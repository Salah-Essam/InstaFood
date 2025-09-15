import os
import json
import concurrent.futures as cf
import threading
import re
import ast
import difflib
import time
from typing import Any, Dict, List, Optional

from fastapi import FastAPI, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from langchain.tools import tool
from langchain.agents import create_react_agent, AgentExecutor
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_google_genai import ChatGoogleGenerativeAI

from .rag_index import load_project_docs
from .firestore_tools import (
    add_to_cart as fs_add_to_cart,
    place_order as fs_place_order,
    get_orders as fs_get_orders,
    get_best_sellers as fs_get_best_sellers,
    get_cart as fs_get_cart,
    add_favorite as fs_add_favorite,
    remove_favorite as fs_remove_favorite,
    get_favorites as fs_get_favorites,
    add_chat_message as fs_add_chat_message,
    remove_from_cart as fs_remove_from_cart,
    cancel_order as fs_cancel_order,
    get_chat_history as fs_get_chat_history,
    get_db,
    warm_firestore,
)
from .item_api import search_items, get_item_by_id, price_with_size, list_items

# Load .env early so fast-path Firestore calls see env vars
try:
    from dotenv import load_dotenv, find_dotenv
    load_dotenv(find_dotenv(usecwd=True))
    load_dotenv(os.path.join(os.path.dirname(__file__), ".env"), override=True)
except Exception:
    pass

# Simple retrieval helper
INDEX = load_project_docs()

# Helper to parse JSON payloads from single-string tool inputs
def _parse_json(s: Any) -> Any:
    if isinstance(s, (dict, list)):
        return s  # already parsed
    try:
        return json.loads(s)
    except Exception:
        # Fallback: try Python literal eval (for inputs mistakenly passed as str(dict))
        try:
            val = ast.literal_eval(s)
            if isinstance(val, (dict, list)):
                return val
        except Exception:
            pass
        return {}


@tool
def rag_search(payload: str) -> str:
    """Search project docs for InstaFood logic, data flow, and schema. Input accepts a JSON string with key 'query' or a plain string."""
    d = _parse_json(payload)
    query = d.get("query") if isinstance(d, dict) else None
    q = str(query or payload or "")
    results = INDEX.search(q, k=3)
    return "\n\n".join([f"[{doc.id}] {doc.text}" for doc, _ in results])


@tool
def find_product(payload: str) -> str:
    """Find a product by (possibly fuzzy) name using the same approach as Flutter: load items and fuzzy-match locally.
    Returns a list of matching products with fields: id,name,imageUrl,price,restaurantName,_score."""
    try:
        query = (payload or "").strip().lower()
        if not query:
            return "[]"
        items = _get_items_cached(ttl=60.0) or []
        ranked = _fuzzy_find_all(query, items)
        if not ranked:
            # Remote fallback to API search if cache-based fuzzy has no results
            try:
                remote = search_items(query) or []
            except Exception:
                remote = []
            ranked = _fuzzy_find_all(query, remote)
        out = []
        for it in ranked[:5]:
            out.append({
                "id": it.get("itemID") or it.get("id") or it.get("docId"),
                "name": it.get("itemName") or it.get("name"),
                "imageUrl": it.get("imageUrl"),
                "price": it.get("itemPrice") or it.get("price"),
                "restaurantName": it.get("restaurantName"),
                "_score": it.get("_score"),
            })
        return str(out)
    except Exception as e:
        return f"error: {e}"


@tool
def add_to_cart(payload: str) -> str:
    """Add or update item in cart. Strict input JSON keys: uid, item_id, item_name, image_url, restaurant_id, restaurant_name, unit_price, quantity, size, confirm.
    Rules: confirm must be true, and both size and quantity must be provided.
    """
    d = _parse_json(payload)
    try:
        if not bool(d.get("confirm")):
            return "error: confirmation_required"
        size = d.get("size")
        if not size:
            return "error: missing_size"
        try:
            qty = int(d.get("quantity"))
        except Exception:
            return "error: missing_quantity"
        if qty <= 0:
            return "error: missing_quantity"
        fs_add_to_cart(
            d.get("uid", ""),
            int(d.get("item_id", 0)),
            str(d.get("item_name", "")),
            str(d.get("image_url", "")),
            int(d.get("restaurant_id", 0)),
            str(d.get("restaurant_name", "")),
            float(d.get("unit_price", 0.0)),
            int(qty),
            str(size),
        )
        return "added"
    except Exception as e:
        return f"error: {e}"


@tool
def place_order(payload: str) -> str:
    """Create an active order from user's cart. Input keys: uid, shipping_address. Returns orderId or 'cart_empty'."""
    d = _parse_json(payload)
    uid = d.get("uid", "")
    addr = d.get("shipping_address", "")
    try:
        order_id = fs_place_order(uid, addr)
        return order_id or "cart_empty"
    except Exception as e:
        return f"error: {e}"


@tool
def my_orders(payload: str) -> str:
    """Return user's orders. Input fields: uid, optional status ('active'|'completed'|'cancelled')."""
    d = _parse_json(payload)
    try:
        return str(fs_get_orders(d.get("uid", ""), d.get("status")))
    except Exception as e:
        return f"error: {e}"


@tool
def best_sellers(payload: str) -> str:
    """Return best seller items from Firestore. Input can be any string (ignored)."""
    try:
        data = fs_get_best_sellers()
        return str(data)
    except Exception as e:
        return f"error: {e}"

@tool
def add_by_item_id(payload: str) -> str:
    """Add by item id (from app Items API). Input keys: uid, item_id, size, quantity, confirm. Rules: confirm must be true.
    """
    d = _parse_json(payload)
    uid = d.get("uid", "")
    item_id = d.get("item_id")
    if item_id is None:
        return "error: missing item_id"
    if not bool(d.get("confirm")):
        return "error: confirmation_required"
    size = d.get("size")
    if not size:
        return "error: missing_size"
    try:
        quantity = int(d.get("quantity"))
    except Exception:
        return "error: missing_quantity"
    if quantity <= 0:
        return "error: missing_quantity"
    # Align with app: fetch item details from API
    item = get_item_by_id(int(item_id))
    if not item:
        return "item_not_found"
    name = str(item.get("itemName", ""))
    image = str(item.get("imageUrl", ""))
    base_price = float(item.get("itemPrice", 0.0))
    price = float(price_with_size(base_price, str(size)))
    rest_name = str(item.get("restaurantName", ""))
    try:
        fs_add_to_cart(uid, int(item_id), name, image, int(item.get("restaurantID", 0)), rest_name, price, int(quantity), str(size))
        return "added"
    except Exception as e:
        return f"error: {e}"

@tool
def filter_items(payload: str) -> str:
    """Filter and search items similar to Flutter's ListFilter, with extra options.
    Input keys:
      - category: snacks|meals|vegan|desserts|drinks
      - sub_category: string contained in description
      - max_price: number
      - exclude_terms: list[str]
      - restaurant_name: optional string to restrict to a restaurant (substring, case-insensitive)
      - query: optional free-text fuzzy search over name+description (misspellings allowed)
    Returns: list of {id, name, price, restaurantName} sorted by relevance then price.
    """
    d = _parse_json(payload)
    try:
        items = list_items() or []

        # Mirror Flutter FoodCategory keywords and exclusionKeywords
        CATEGORIES = {
            "snacks": {
                "keywords": [
                    "fried", "fritter", "in a bun", "wrapped", "street food", "skewers", "tandoor",
                ],
                "exclude": [],
            },
            "meals": {
                "keywords": ["curry", "biryani", "grilled", "cooked", "seafood"],
                "exclude": [],
            },
            "vegan": {
                "keywords": ["mango", "vegetables", "pizza", "green"],
                "exclude": [
                    "meat", "chicken", "mutton", "fish", "prawn", "cream", "butter", "yogurt", "milk", "prawn", "lamb",
                ],
            },
            "desserts": {
                "keywords": ["sweet", "syrup", "sugar", "pudding", "vermicelli", "mango", "fruits"],
                "exclude": ["sweet churma", "drink"],
            },
            "drinks": {
                "keywords": ["drink", "brewed", "coffee", "beer"],
                "exclude": ["coffee-soaked"],
            },
        }

        def norm(s: str) -> str:
            return (str(s or "").lower())

        category = norm(d.get("category")) or None
        sub_category = norm(d.get("sub_category")) or None
        max_price_raw = d.get("max_price")
        try:
            max_price = float(max_price_raw) if max_price_raw is not None else None
        except Exception:
            max_price = None

        exclude_terms = [
            str(x).lower() for x in (d.get("exclude_terms") or []) if str(x).strip()
        ]
        restaurant_name = norm(d.get("restaurant_name")) or None
        query_text = norm(d.get("query")) or None

        # Optional restaurant filter first (cheap)
        if restaurant_name:
            items = [it for it in items if restaurant_name in norm(it.get("restaurantName") or "")]

        # Optional fuzzy search over name+description to narrow candidates (algorithmic, no hard-coded synonyms)
        ranked_map = None
        if query_text:
            ranked = _fuzzy_find_all(query_text, items)
            if ranked:
                ids = {it.get("itemID") or it.get("id") or it.get("docId") for it in ranked}
                score_by_id = {
                    (it.get("itemID") or it.get("id") or it.get("docId")): it.get("_score", 0.0)
                    for it in ranked
                }
                items = [it for it in items if (it.get("itemID") or it.get("id") or it.get("docId")) in ids]
                ranked_map = score_by_id

        def include_item(it: dict) -> bool:
            desc = norm(it.get("itemDescription") or it.get("description"))
            price = float(it.get("itemPrice", 0.0))

            # Price filter
            if max_price is not None and price > max_price:
                return False

            # Category/subcategory filter
            if category:
                cfg = CATEGORIES.get(category)
                if not cfg:
                    return True  # unknown category -> don't block
                kws = cfg.get("keywords", [])
                exs = cfg.get("exclude", [])
                has_excl = any(e in desc for e in exs)
                # Add runtime excludes (e.g., soft drinks)
                if exclude_terms:
                    if any(e in desc for e in exclude_terms):
                        return False
                if sub_category is None:
                    has_kw = any(k in desc for k in kws)
                    if not has_kw or has_excl:
                        return False
                else:
                    has_kw = (sub_category in desc)
                    if not has_kw or has_excl:
                        return False
            return True

        out = []
        for it in items:
            if not include_item(it):
                continue
            oid = it.get("itemID") or it.get("id")
            out.append({
                "id": it.get("itemID") or it.get("id"),
                "name": it.get("itemName") or it.get("name"),
                "price": float(it.get("itemPrice", 0.0)),
                "restaurantName": it.get("restaurantName") or "",
                "_score": (ranked_map.get(oid, 0.0) if ranked_map else 0.0),
            })
        # Sort by score desc then price asc for stability
        out.sort(key=lambda x: (-x.get("_score", 0.0), x.get("price", 0.0)))
        return str(out)
    except Exception as e:
        return f"error: {e}"

@tool
def delivery_eta(payload: str) -> str:
    """Get ETA for latest active order or a specific one. Input keys: uid, optional order_id."""
    from datetime import datetime, timezone, timedelta
    from google.cloud import firestore as _fs
    db = get_db()
    d = _parse_json(payload)
    uid = d.get("uid", "")
    order_id = d.get("order_id")
    col = db.collection("users").document(uid).collection("orders")
    if order_id:
        doc = col.document(order_id).get()
        if not doc.exists:
            return "order_not_found"
        data = doc.to_dict() or {}
    else:
        q = col.where("status", "==", "active").order_by("createdAt", direction=_fs.Query.DESCENDING).limit(1)
        docs = list(q.stream())
        if not docs:
            return "no_active_orders"
        data = docs[0].to_dict() or {}
    created = data.get("createdAt")
    now = datetime.now(timezone.utc)
    base_eta = 30
    if hasattr(created, 'timestamp'):
        try:
            if hasattr(created, 'to_datetime'):
                created_dt = created.to_datetime()
            else:
                created_dt = created
            elapsed = (now - created_dt).total_seconds() / 60.0
            remaining = max(5, base_eta - int(elapsed))
            eta_at = now + timedelta(minutes=remaining)
            return f"Estimated delivery in ~{remaining} minutes (by {eta_at.astimezone().strftime('%I:%M %p')})."
        except Exception:
            pass
    return "Estimated delivery window: 20–40 minutes."


@tool
def my_cart(payload: str) -> str:
    """Return user's cart items. Input key: uid."""
    d = _parse_json(payload)
    try:
        return str(fs_get_cart(d.get("uid", "")))
    except Exception as e:
        return f"error: {e}"


def build_llm():
    try:
        from dotenv import load_dotenv
        load_dotenv()
    except Exception:
        pass

    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        raise RuntimeError("GEMINI_API_KEY not found in .env file. Please set the environment variable.")

    # Get the model name from the environment, with a default value
    model_name = os.getenv("GEMINI_MODEL", "gemini-1.5-flash")
    # Allow increasing generation length (default higher than 256)
    try:
        max_toks = int(os.getenv("GEMINI_MAX_TOKENS", "1024"))
    except Exception:
        max_toks = 1024

    # Allow tuning retries to avoid long backoffs on 429 (free tier limits)
    try:
        max_retries = int(os.getenv("GEMINI_MAX_RETRIES", "1"))
    except Exception:
        max_retries = 1

    # Prefer no convert_system_message_to_human (newer versions deprecate this), with fallbacks
    try:
        return ChatGoogleGenerativeAI(
            model=model_name,
            google_api_key=api_key,
            temperature=0.2,
            max_tokens=max_toks,
            max_retries=max_retries,
        )
    except TypeError:
        try:
            # Older versions may not support max_retries
            return ChatGoogleGenerativeAI(
                model=model_name,
                google_api_key=api_key,
                temperature=0.2,
                max_tokens=max_toks,
            )
        except TypeError:
            # Very old versions needed convert_system_message_to_human
            return ChatGoogleGenerativeAI(
                model=model_name,
                google_api_key=api_key,
                temperature=0.2,
                max_tokens=max_toks,
                convert_system_message_to_human=True,
            )


@tool
def add_to_favorites(payload: str) -> str:
    """Add an item to favorites. Input keys: uid, item_id, name, image_url, restaurant_name, price."""
    d = _parse_json(payload)
    try:
        fs_add_favorite(d.get("uid", ""), int(d.get("item_id", 0)), str(d.get("name", "")), str(d.get("image_url", "")), str(d.get("restaurant_name", "")), float(d.get("price", 0.0)))
        return "added"
    except Exception as e:
        return f"error: {e}"


@tool
def remove_from_favorites(payload: str) -> str:
    """Remove an item from favorites. Input keys: uid, item_id."""
    d = _parse_json(payload)
    try:
        fs_remove_favorite(d.get("uid", ""), int(d.get("item_id", 0)))
        return "removed"
    except Exception as e:
        return f"error: {e}"


@tool
def my_favorites(payload: str) -> str:
    """Return user's favorites. Input key: uid."""
    d = _parse_json(payload)
    try:
        return str(fs_get_favorites(d.get("uid", "")))
    except Exception as e:
        return f"error: {e}"


@tool
def remove_cart_item(payload: str) -> str:
    """Remove a specific cart item. Input keys: uid, cart_item_id (format: "{itemId}_size_{size}", e.g., "123_size_large")."""
    d = _parse_json(payload)
    try:
        fs_remove_from_cart(d.get("uid", ""), str(d.get("cart_item_id", "")))
        return "removed"
    except Exception as e:
        return f"error: {e}"


@tool
def cancel_order(payload: str) -> str:
    """Cancel an existing order. Input keys: uid, order_id."""
    d = _parse_json(payload)
    try:
        fs_cancel_order(d.get("uid", ""), str(d.get("order_id", "")))
        return "cancelled"
    except Exception as e:
        return f"error: {e}"


TOOLS = [
    rag_search,
    find_product,
    add_to_cart,
    place_order,
    my_orders,
    best_sellers,
    add_by_item_id,
    filter_items,
    delivery_eta,
    my_cart,
    add_to_favorites,
    remove_from_favorites,
    my_favorites,
    remove_cart_item,
    cancel_order,
]

SYSTEM_INSTRUCTIONS = (
    """
You are an InstaFood assistant.

You have access to tools: {tool_names}
Descriptions:\n{tools}

Follow this ReAct format strictly:
Thought: consider what to do
Action: call a tool by name
Action Input: a SINGLE JSON STRING with the required keys
Observation: result of the action
... (you can repeat Thought/Action/Action Input/Observation)
Final Answer: the final, helpful answer to the user

Rules:
- Always include the user's uid in tool inputs when required (we prepend it in the message as "uid:<uid>").
- For rag_search, pass a JSON string with key "query" and the search text.
- If a user asks to add an item with a name that is not clear, first use `find_product` (fuzzy friendly) to shortlist.
    If you find a likely match, ask the user to confirm: e.g., "Did you mean Sashi Taki?" After confirmation, ask for size and quantity if missing,
    then add using `add_by_item_id` (preferred) or `add_to_cart` with image_url and correct name. Always include size and quantity.
    Always source product details (name, price, image) from the Items API (not Best Sellers), unless the user explicitly asks for best sellers.
- If a request isn't possible, say so briefly and suggest available options.
- Keep answers concise and in the scope of InstaFood.
- Never add to cart without explicit consent. First propose options, then ask: "Add X? What size and quantity?" Only after the user confirms, call add_to_cart/add_by_item_id with confirm:true, size, and quantity.
- Ask for any missing details before calling tools (e.g., size, quantity, restaurant). Use a short clarifying question, then call the tool once you have enough info.
- For budget/category requests (e.g., "drinks under 370"), first use filter_items with max_price and category to shortlist, then present 2–5 options with names and prices.
- Never claim you've added/removed anything unless the tool Observation explicitly returns a success like 'added' or 'removed'. If you see errors like 'confirmation_required' or 'missing_size', ask the user and retry.
 - LLM-first: reason over the user's intent and prior context before choosing tools. Only use tools when they can fulfill the intent.
 - If the user's request is related to InstaFood but there is no tool to do it, explain how to achieve it in the app (navigation or steps) instead of calling tools.
 - If the request is clearly out-of-scope (not related to InstaFood), politely say so and offer helpful InstaFood options.
 - Mirror the user's language (Arabic/English/etc.) when replying and asking clarifying questions.
"""
)

PROMPT = ChatPromptTemplate.from_messages([
    ("system", SYSTEM_INSTRUCTIONS),
    ("human", "{input}"),
    ("ai", "{agent_scratchpad}"),
])

EXECUTOR = None
_LLM_POOL: Optional[cf.ThreadPoolExecutor] = None
FASTPATH_ENV_KEY = "AGENT_FASTPATH"
# Global cooldown marker for LLM attempts (set when we hit timeout/429 in /chat)
_LLM_BACKOFF_UNTIL: float = 0.0

# Simple in-memory cache for quick fast-paths
_CACHE = {
    "best_sellers_names": (0.0, []),  # (ts, [names])
}

# Items list cache to reduce API calls and enable offline fuzzy matching under LLM rate limits
_ITEMS_CACHE = {
    "items": (0.0, []),  # (timestamp, items)
}

# Memory of last item suggestions per user (for "option 2" / "from <restaurant>")
LAST_SUGGESTIONS: Dict[str, List[dict]] = {}

# Light per-user LLM rate guard to avoid bursts that trigger provider 429s
_LLM_LAST_CALL: Dict[str, float] = {}
_LLM_RECENT_CALLS: Dict[str, List[float]] = {}

# No hard-coded synonyms; rely on algorithmic fuzzy matching

_DEF_SIZES = ["small", "medium", "large", "xlarge"]


def _fastpath_enabled() -> bool:
    try:
        v = os.environ.get(FASTPATH_ENV_KEY, "true").strip().lower()
        return v in ("1", "true", "yes", "on")
    except Exception:
        return True


def _get_items_cached(ttl: float = 60.0) -> list:
    now = time.time()
    ts, items = _ITEMS_CACHE.get("items", (0.0, []))
    if (now - ts) < ttl and items:
        return items
    try:
        from .item_api import list_items as _li  # local import to avoid cycles
        data = _li() or []
        _ITEMS_CACHE["items"] = (now, data)
        return data
    except Exception:
        return items or []


def _norm(s: str) -> str:
    s = (s or "").lower().strip()
    s = re.sub(r"[^a-z0-9\s]", " ", s)
    s = re.sub(r"\s+", " ", s)
    return s


def _score_name(q: str, name: str) -> float:
    qn = _norm(q)
    nm = _norm(name)
    if not qn or not nm:
        return 0.0
    if qn == nm:
        return 1.0
    if qn in nm:
        return 0.96
    base = difflib.SequenceMatcher(None, qn, nm).ratio()
    qtok = set(qn.split())
    ntok = set(nm.split())
    overlap = len(qtok & ntok) / max(1, len(qtok))
    return max(base, 0.7 * base + 0.3 * overlap)


def _expand_query(query: str) -> List[str]:
    # Algorithmic expansion: include original, singular/plural variants, and common spacing variations
    q = _norm(query)
    if not q:
        return []
    alts = {q}
    # pluralization simplistic toggle (s/es); helps kebab/kebabs, drink/drinks
    if q.endswith("s"):
        alts.add(q[:-1])
    else:
        alts.add(q + "s")
        if not q.endswith("es"):
            alts.add(q + "es")
    # remove/insert spaces (e.g., "icecream" vs "ice cream") for short tokens
    if " " in q:
        alts.add(q.replace(" ", ""))
    else:
        # insert space between two words if camel-ish or long
        if len(q) > 6:
            mid = len(q)//2
            alts.add(q[:mid] + " " + q[mid:])
    return list(alts)


# Improve find_product by using synonyms and lower threshold; cache assumed available in existing code
try:
    from .item_api import list_items  # type: ignore
except Exception:
    list_items = None  # fallback if not present for safety


def _rf_ratio(a: str, b: str) -> float:
    """Compute a robust fuzzy ratio.
    Lazily attempts to use rapidfuzz if available; otherwise falls back to difflib.
    Returns a score in [0,100].
    """
    try:
        import importlib
        rf = importlib.import_module("rapidfuzz.fuzz")
        return max(
            getattr(rf, "token_set_ratio")(a, b),
            getattr(rf, "partial_ratio")(a, b),
            getattr(rf, "token_sort_ratio")(a, b),
        )
    except Exception:
        return difflib.SequenceMatcher(None, a, b).ratio() * 100


def _fuzzy_find_all(query: str, items: List[dict]) -> List[dict]:
    q = _norm(query)
    if not q:
        return []
    candidates: List[dict] = []
    for it in items or []:
        name = str(it.get("itemName") or it.get("name") or "")
        desc = str(it.get("itemDescription") or it.get("description") or "")
        text = (name + " " + desc).strip().lower()
        score = _rf_ratio(q, text)
        # Threshold tuned for misspellings while avoiding noise
        if score >= 58:
            it2 = dict(it)
            it2["_score"] = round(score / 100.0, 3)
            candidates.append(it2)
    candidates.sort(key=lambda x: x.get("_score", 0.0), reverse=True)
    return candidates


def _norm_words(s: str) -> str:
    s = (s or "").lower()
    s = re.sub(r"[^a-z0-9\s]+", " ", s)
    s = re.sub(r"\s+", " ", s).strip()
    return s


def _choose_best_match(query: str, ranked: List[dict]) -> dict:
    """Prefer exact/phrase matches over generic fuzzy top.
    Rules:
    1) Exact normalized equality match on item name wins.
    2) Whole-phrase containment (item contains full query) beats others.
    3) Token coverage: prefer items covering all query tokens with minimal extras.
    4) Fallback to first ranked.
    """
    qn = _norm_words(query)
    qtok = set(qn.split())
    best = None
    best_score = -1.0
    # Precompute normalized names
    norms = []
    for it in ranked:
        nm = str(it.get("itemName") or it.get("name") or "")
        nn = _norm_words(nm)
        norms.append((it, nm, nn))
    # 1) Exact normalized equality
    for it, _, nn in norms:
        if nn == qn and nn:
            return it
    # 2) Whole-phrase containment
    for it, _, nn in norms:
        if nn and qn and (qn in nn):
            return it
    # 3) Token coverage heuristic
    for it, _, nn in norms:
        ntok = set(nn.split())
        if qtok and qtok.issubset(ntok):
            # higher score for fewer extra tokens and higher fuzzy score if present
            extra = max(0, len(ntok) - len(qtok))
            fuzzy = float(it.get("_score", 0.0))
            score = 1.0 - 0.05 * extra + 0.01 * fuzzy
            if score > best_score:
                best = it
                best_score = score
    return best or (ranked[0] if ranked else {})


def _remember_suggestions(uid: str, items: List[dict]) -> None:
    LAST_SUGGESTIONS[uid] = [
        {
            "id": it.get("itemID") or it.get("id") or it.get("docId"),
            "name": it.get("itemName") or it.get("name"),
            "restaurantName": it.get("restaurantName"),
            "price": it.get("itemPrice") or it.get("price"),
            "_score": it.get("_score"),
        }
        for it in items[:5]
    ]


def _remember_suggestions_from_text(uid: str, text: str) -> None:
    """Extract item names from LLM free-text replies and map them to real items.
    Supports bullet styles: '1. Name — ...', '* Name (..)', '- Name — ...'.
    """
    try:
        if not text:
            return
        pattern = re.compile(r"^\s*(?:\d+\.|\*|-)\s*([^\n\(—\-]{2,})", re.MULTILINE)
        names = [m.group(1).strip() for m in pattern.finditer(text)]
        if not names:
            return
        items = _get_items_cached(ttl=60.0)
        ranked: List[dict] = []
        seen_ids = set()
        for nm in names:
            r = _fuzzy_find_all(nm, items)
            if not r:
                continue
            top = r[0]
            iid = top.get("itemID") or top.get("id") or top.get("docId")
            if iid in seen_ids:
                continue
            seen_ids.add(iid)
            ranked.append(top)
        if ranked:
            _remember_suggestions(uid, ranked)
    except Exception:
        # Don't block on heuristic memory
        pass


def _pick_from_memory(uid: str, msg: str) -> Optional[dict]:
    opts = LAST_SUGGESTIONS.get(uid) or []
    if not opts:
        return None
    m = re.search(r"\boption\s*(\d+)\b", msg, flags=re.I)
    if m:
        idx = int(m.group(1)) - 1
        if 0 <= idx < len(opts):
            return opts[idx]
    # Match by restaurant name if present
    for it in opts:
        r = (it.get("restaurantName") or "").lower()
        if r and r in msg.lower():
            return it
    # Prefer exact/phrase match on item name
    qn = _norm_words(msg)
    # exact equality
    for it in opts:
        nm = _norm_words(it.get("name") or "")
        if nm and nm == qn:
            return it
    # phrase containment
    for it in opts:
        nm = _norm_words(it.get("name") or "")
        if nm and qn and qn in nm:
            return it
    # token overlap fallback
    qtok = set(qn.split())
    for it in opts:
        nm = _norm_words(it.get("name") or "")
        if nm:
            ntok = set(nm.split())
            if qtok and qtok.issubset(ntok):
                return it
    return None


# Hook into chat flow: deterministic pre-parser before LLM
try:
    from fastapi import BackgroundTasks
    from pydantic import BaseModel

    class ChatReq(BaseModel):
        userId: str
        message: str

    class ChatRes(BaseModel):
        reply: str
        meta: Optional[dict] = None
except Exception:
    pass


from typing import Tuple


def _parse_size_qty(msg: str) -> Tuple[Optional[str], Optional[int]]:
    size = None
    qty = None
    text = msg or ""
    # Tolerant size aliases (no single-letter forms to avoid false positives)
    SIZE_ALIASES: List[tuple[str, List[str]]] = [
        ("xlarge", [r"\bx[-\s]?large\b", r"\bextra[-\s]?large\b", r"\bxl\b", r"\bxlarge\b"]),
        ("large", [r"\blarge\b", r"\blarg\b", r"\blrg\b", r"\blg\b"]),
        ("medium", [r"\bmedium\b", r"\bmedu?i?um\b", r"\bmed\b", r"\bmd\b"]),
        ("small", [r"\bsmall\b", r"\bsm\b"]),
    ]
    for canonical, pats in SIZE_ALIASES:
        for p in pats:
            if re.search(p, text, flags=re.I):
                size = canonical
                break
        if size:
            break
    # quantity
    mq = re.search(r"\b(\d{1,2})\b", text)
    if mq:
        try:
            qty = int(mq.group(1))
        except Exception:
            qty = None
    return size, qty


def prehandle_message(req) -> Optional["ChatRes"]:
    uid = getattr(req, "userId", "")
    msg = getattr(req, "message", "")
    if not uid or not msg:
        return None
    low = msg.lower().strip()

    # Resolve pronoun adds like "add it/that/this" using last suggestions
    if re.search(r"\b(?:add|order|buy|put)\s+(?:it|that|this)\b", low):
        chosen = _pick_from_memory(uid, low) or (LAST_SUGGESTIONS.get(uid) or [None])[0]
        if chosen:
            size, qty = _parse_size_qty(low)
            size = size or "small"
            qty = qty or 1
            payload = {
                "uid": uid,
                "item_id": int(chosen.get("id")),
                "size": size,
                "quantity": qty,
                "confirm": True,
            }
            try:
                res = add_by_item_id(json.dumps(payload))  # type: ignore
                if str(res).strip().lower() == "added":
                    return ChatRes(reply=f"Added {chosen.get('name')} ({size}) x{qty} to your cart.")
                else:
                    return ChatRes(reply=f"Couldn't add {chosen.get('name')}: {res}")
            except Exception as e:
                return ChatRes(reply=f"Sorry, couldn't add it right now: {e}")
        # If nothing in memory, ask for a name
        return ChatRes(reply="Tell me the item name, e.g., 'add vada pav small 1'.")

    # Option selection / refer back to previous suggestions
    chosen = _pick_from_memory(uid, low)
    if chosen:
        size, qty = _parse_size_qty(low)
        if size and qty:
            payload = {
                "uid": uid,
                "item_id": int(chosen.get("id")),
                "size": size,
                "quantity": qty,
                "confirm": True,
            }
            try:
                res = add_by_item_id(json.dumps(payload))  # type: ignore
                if str(res).strip().lower() == "added":
                    return ChatRes(reply=f"Added {chosen.get('name')} ({size}) x{qty} to your cart.")
                else:
                    return ChatRes(reply=f"Couldn't add {chosen.get('name')}: {res}")
            except Exception as e:
                return ChatRes(reply=f"Sorry, couldn't add it right now: {e}")
        # Ask for the missing details explicitly
        return ChatRes(reply=f"Got it: {chosen.get('name')}. What size and quantity would you like?")

    def _ranked_matches(name_part: str, restaurant_filter: Optional[str] = None) -> List[dict]:
        # Try local cache first (fast, mirrors Flutter)
        items_local = _get_items_cached(ttl=60.0)
        if restaurant_filter:
            rnorm = _norm(restaurant_filter)
            items_local = [it for it in items_local if rnorm in _norm(str(it.get("restaurantName") or ""))]
        ranked = _fuzzy_find_all(name_part, items_local)
        if ranked:
            return ranked
        # Fallback: query API search endpoint with synonyms if local fuzzy found nothing
        ranked_remote: List[dict] = []
        try:
            alts = _expand_query(name_part)
            seen_ids = set()
            for q in alts:
                try:
                    remote = search_items(q) or []
                except Exception:
                    remote = []
                for it in remote:
                    # Normalize shape to local structure
                    iid = it.get("itemID") or it.get("id") or it.get("docId")
                    if iid in seen_ids:
                        continue
                    seen_ids.add(iid)
                    it2 = dict(it)
                    it2["_score"] = round(_score_name(name_part, str(it.get("itemName") or it.get("name") or "")), 3)
                    ranked_remote.append(it2)
        except Exception:
            pass
        ranked_remote.sort(key=lambda x: x.get("_score", 0.0), reverse=True)
        return ranked_remote

    # Direct add intent by name
    if any(k in low for k in ["add", "order", "buy", "put", "أضف", "اضف", "اطلب"]):
        # Extract candidate name after the verb
        m = re.search(r"(?:add|order|buy|put|أضف|اضف|اطلب)\s+(.+)", low)
        if m:
            name_part = m.group(1)
        else:
            name_part = low
        # Pattern: "<item> from <restaurant>"
        mfrom = re.search(r"(.+?)\s+from\s+([a-z0-9\s]+)$", name_part)
        rest_filter = None
        if mfrom:
            name_part = mfrom.group(1).strip()
            rest_filter = mfrom.group(2).strip()
        # Ranked search with local+remote fallback
        ranked = _ranked_matches(name_part, rest_filter)
        if ranked:
            _remember_suggestions(uid, ranked)
            top = _choose_best_match(name_part, ranked)
            size, qty = _parse_size_qty(low)
            if size and qty:
                payload = {
                    "uid": uid,
                    "item_id": int(top.get("itemID") or top.get("id")),
                    "size": size,
                    "quantity": qty,
                    "confirm": True,
                }
                try:
                    res = add_by_item_id(json.dumps(payload))  # type: ignore
                    if str(res).strip().lower() == "added":
                        return ChatRes(reply=f"Added {top.get('itemName') or top.get('name')} ({size}) x{qty}.")
                    else:
                        return ChatRes(reply=f"Couldn't add: {res}")
                except Exception as e:
                    return ChatRes(reply=f"Sorry, couldn't add it right now: {e}")
            else:
                # Ask for size/qty and show top 3 options
                lines = []
                for i, it in enumerate(ranked[:3], start=1):
                    nm = (it.get('itemName') or it.get('name') or '')
                    rn = (it.get('restaurantName') or '')
                    pr = it.get('itemPrice') or it.get('price')
                    lines.append(f"{i}. {nm} — {rn} — {pr}")
                return ChatRes(
                    reply=(
                        "I found these matches:\n" + "\n".join(lines) +
                        "\nReply like: 'option 1 small 1' or 'add <name> medium 2' or 'from <restaurant> large 1'"
                    )
                )
        else:
            # No matches at all – suggest trying close spellings
            return ChatRes(reply="I couldn't find that yet. Try a close spelling or tell me the restaurant, e.g., 'kebab from Peter Cat'.")

    # Delete intent made more robust: try cart fuzzy match
    if any(w in low for w in ["delete", "remove", "cancel item"]):
        try:
            cart = fs_get_cart(uid)  # type: ignore
            if cart:
                target = None
                best = 0.0
                for it in cart:
                    nm = str(it.get("itemName") or it.get("name") or "")
                    s = _score_name(low, nm)
                    if s > best:
                        best = s
                        target = it
                if target and best >= 0.55:
                    item_id = target.get("itemID") or target.get("id") or target.get("docId")
                    size = (target.get("size") or (target.get("options") or {}).get("size") or "").lower()
                    key = f"{item_id}_size_{size}" if item_id and size else str(item_id)
                    payload = {"uid": uid, "cart_item_id": key}
                    _ = remove_cart_item(json.dumps(payload))  # type: ignore
                    return ChatRes(reply=f"{target.get('itemName') or target.get('name')} removed from your cart.")
        except Exception:
            pass
        # Fall back to default flow if not handled
        return None

    # Natural language filter intent: e.g., "drinks under 200", "show desserts below 150"
    try:
        # Quick exclusion intent like: "no soft drinks", "no soda", "no cola"
        no_soft = bool(re.search(r"\bno\s+(soft\s+drinks?|sodas?|cola|pepsi|coke)\b", low))

        # Category with max price
        m = re.search(r"\b(?P<cat>drinks?|desserts?|snacks?|meals?|vegan)\b(?:[^0-9]{0,30})?(?:under|below|less than)\s*\$?\s*(?P<price>\d{1,4})", low)
        if m:
            cat_raw = m.group("cat")
            price = float(m.group("price"))
            cat_map = {
                "drink": "drinks", "drinks": "drinks",
                "dessert": "desserts", "desserts": "desserts",
                "snack": "snacks", "snacks": "snacks",
                "meal": "meals", "meals": "meals",
                "vegan": "vegan",
            }
            cat = cat_map.get(cat_raw.rstrip('s'), cat_map.get(cat_raw, cat_raw))
            payload = {"category": cat, "max_price": price}
            if no_soft and cat == "drinks":
                payload["exclude_terms"] = ["soft drink", "soda", "cola", "pepsi", "coke"]
            raw = filter_items(json.dumps(payload))  # type: ignore
            items_list = []
            try:
                items_list = ast.literal_eval(str(raw))
            except Exception:
                items_list = []
            if isinstance(items_list, list) and items_list:
                lines = []
                for it in items_list[:5]:
                    nm = str(it.get("name", ""))
                    rn = str(it.get("restaurantName", ""))
                    pr = it.get("price")
                    lines.append(f"- {nm} — {rn} — {pr}")
                return ChatRes(reply=f"Top {cat} under {int(price)}:\n" + "\n".join(lines) + "\nReply like: 'add <name> <size> <qty>' or 'option 1 small 1'.")
            else:
                return ChatRes(reply=f"I couldn't find {cat} under {int(price)} right now.")

        # Category only (no price): "show me drinks" / "any desserts?"
        m2 = re.search(r"\b(show|any|list|recommend|عرض|قائمة)?\s*(?P<cat>drinks?|desserts?|snacks?|meals?|vegan)\b", low)
        if m2:
            cat_raw = m2.group("cat")
            cat_map = {
                "drink": "drinks", "drinks": "drinks",
                "dessert": "desserts", "desserts": "desserts",
                "snack": "snacks", "snacks": "snacks",
                "meal": "meals", "meals": "meals",
                "vegan": "vegan",
            }
            cat = cat_map.get(cat_raw.rstrip('s'), cat_map.get(cat_raw, cat_raw))
            payload = {"category": cat}
            raw = filter_items(json.dumps(payload))  # type: ignore
            items_list = []
            try:
                items_list = ast.literal_eval(str(raw))
            except Exception:
                items_list = []
            if isinstance(items_list, list) and items_list:
                lines = []
                for it in items_list[:5]:
                    nm = str(it.get("name", ""))
                    rn = str(it.get("restaurantName", ""))
                    pr = it.get("price")
                    lines.append(f"- {nm} — {rn} — {pr}")
                return ChatRes(reply=f"Here are some {cat} options:\n" + "\n".join(lines) + "\nReply like: 'add <name> <size> <qty>' or 'option 1 small 1'.")
    except Exception:
        pass

    # Bare name query (e.g., "butter chicken") – shortlist and ask for size/qty
    try:
        tokens = low.split()
        if 1 <= len(tokens) <= 5 and not any(w in low for w in ["cart", "order status", "orders", "history", "help"]):
            ranked = _ranked_matches(low)
            if ranked:
                _remember_suggestions(uid, ranked)
                lines = []
                for i, it in enumerate(ranked[:3], start=1):
                    nm = (it.get('itemName') or it.get('name') or '')
                    rn = (it.get('restaurantName') or '')
                    pr = it.get('itemPrice') or it.get('price')
                    lines.append(f"{i}. {nm} — {rn} — {pr}")
                return ChatRes(
                    reply=(
                        "I found these matches:\n" + "\n".join(lines) +
                        "\nReply like: 'option 1 small 1' or 'add <name> medium 2'."
                    )
                )
    except Exception:
        pass

    return None

# ...existing code...
def get_executor():
    global EXECUTOR
    if EXECUTOR is not None:
        return EXECUTOR
    try:
        from dotenv import load_dotenv, find_dotenv
        load_dotenv(find_dotenv(usecwd=True))
        load_dotenv(os.path.join(os.path.dirname(__file__), ".env"), override=True)
    except Exception:
        pass
    llm = build_llm()
    agent = create_react_agent(llm, TOOLS, PROMPT)
    EXECUTOR = AgentExecutor(agent=agent, tools=TOOLS, verbose=False, handle_parsing_errors=True)
    return EXECUTOR

def get_llm_pool() -> cf.ThreadPoolExecutor:
    global _LLM_POOL
    if _LLM_POOL is None:
        _LLM_POOL = cf.ThreadPoolExecutor(max_workers=4, thread_name_prefix="llm")
    return _LLM_POOL


def _try_fastpath(uid: str, msg: str) -> Optional[str]:
    """Ultra-fast handling for common intents: greetings, best sellers, cart, orders, ETA."""
    m = (msg or "").strip().lower()
    # If the user is clearly trying to add/order/buy something, skip fastpath entirely
    if any(k in m for k in ["add", "order", "buy", "put", "أضف", "اضف", "اطلب"]):
        return None
    # Helper: run a callable with a small timeout
    def _with_timeout(fn, seconds: float, default=None):
        try:
            with cf.ThreadPoolExecutor(max_workers=1) as ex:
                return ex.submit(fn).result(timeout=seconds)
        except Exception:
            return default
    try:
        # Greetings (word-boundary only to avoid matching 'hi' inside 'chicken')
        if re.search(r"^(hi|hello|hey|salam|مرحبا|hola|السلام|اهلا)\b", m):
            return "Hey there! Craving something tasty today? I can recommend popular picks or add items to your cart."

        # Popular / recommendations
        if any(k in m for k in ["best seller", "bestseller", "best sellers", "recommend", "recommendation", "today", "مشهور", "الأشهر"]):
            # Try to warm Firestore briefly to reduce first-call latency
            try:
                warm_firestore(timeout_s=0.6)
            except Exception:
                pass
            # 60s cached to avoid Firestore latency
            ts, cached = _CACHE.get("best_sellers_names", (0.0, []))
            now = time.time()
            names: list[str]
            if now - ts < 60 and cached:
                names = cached
            else:
                def _load():
                    data = fs_get_best_sellers() or []
                    return [str(it.get("name", "")) for it in data]
                names = _with_timeout(_load, 1.2, default=[])
                _CACHE["best_sellers_names"] = (now, names)
            top = ", ".join([n for n in (names or [])[:5] if n])
            if top:
                return f"Some popular picks: {top}. Say a name and I can add it to your cart (size and quantity)."
            return "I couldn't fetch best sellers right now. You can still tell me what you're craving."

        # Cart overview (instant)
        CART_KEYS = [
            "cart", "my cart", "basket", "bag", "what's in my cart", "what in my cart",
            "سلة", "سله", "عربة", "العربة", "عربة التسوق"
        ]
        if any(k in m for k in CART_KEYS):
            try:
                warm_firestore(timeout_s=0.6)
            except Exception:
                pass
            def _load_cart():
                return fs_get_cart(uid) or []
            data = _with_timeout(_load_cart, 1.2, default=None)
            if data is None:
                return "Your cart is loading. Try again in a moment."
            if not data:
                return "Your cart is empty. Want me to add something from the best sellers?"
            lines = [f"- {(it.get('itemName') or it.get('name') or '')} x{it.get('quantity',1)} (size: {((it.get('options') or {}).get('size') or 'N/A')})" for it in data]
            return "Your cart:\n" + "\n".join(lines)

        # Orders overview
        if "order" in m and any(k in m for k in ["my", "history", "orders", "طلباتي", "طلب"]):
            try:
                warm_firestore(timeout_s=0.6)
            except Exception:
                pass
            def _load_orders():
                return fs_get_orders(uid, None)
            data = _with_timeout(_load_orders, 1.5, default=None)
            return (str(data) if data is not None else "Orders are loading. Try again shortly.")

        # Delivery ETA
        if any(k in m for k in ["when", "arrive", "delivery", "eta", "time", "متى", "وقت"]) and "order" in m:
            try:
                warm_firestore(timeout_s=0.6)
            except Exception:
                pass
            return delivery_eta(str({"uid": uid}))
    except Exception:
        return None
    return None


class ChatReq(BaseModel):
    userId: str
    message: str


class ChatRes(BaseModel):
    reply: str


app = FastAPI(title="InstaFood Agent")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
def _warm_start():
    # Optionally prepare the executor; avoid pinging LLM unless enabled
    try:
        _ = get_executor()
    except Exception:
        pass
    # Warm Firestore quickly (uses its own short timeout inside)
    try:
        warm_firestore(timeout_s=2.0)
    except Exception:
        pass
    # LLM warm ping is disabled by default to avoid consuming quota; enable with AGENT_WARM_LLM=true
    warm_llm = os.getenv("AGENT_WARM_LLM", "false").strip().lower() in ("1", "true", "yes", "on")
    if warm_llm:
        def _llm_probe_bg():
            try:
                ex = get_executor()
                def _run():
                    return ex.invoke({"input": "ping"})
                with cf.ThreadPoolExecutor(max_workers=1) as pool:
                    _ = pool.submit(_run).result(timeout=10.0)
            except Exception:
                pass
        try:
            threading.Thread(target=_llm_probe_bg, daemon=True).start()
        except Exception:
            pass

@app.get("/health")
def health() -> Dict[str, str]:
    return {"status": "ok"}


@app.get("/debug/auth")
def debug_auth(quick: bool = False) -> Dict[str, Any]:
    path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
    proj = os.getenv("FIREBASE_PROJECT_ID")
    emulator = os.getenv("FIRESTORE_EMULATOR_HOST")
    exists = bool(path and os.path.isfile(path))
    firestore_ok = False
    error: Optional[str] = None
    if not quick:
        try:
            # Attempt to warm before probing to avoid cold-start latency
            try:
                warm_firestore(timeout_s=1.2)
            except Exception:
                pass
            def _probe():
                db = get_db()
                return list(db.collection("Best Sellers").limit(1).stream())
            with cf.ThreadPoolExecutor(max_workers=1) as ex:
                _ = ex.submit(_probe).result(timeout=1.5)
                firestore_ok = True
        except Exception as e:
            emsg = str(e)
            error = (emsg if emsg else repr(e))[:300]
    return {
        "GOOGLE_APPLICATION_CREDENTIALS": path,
        "path_exists": exists,
        "FIREBASE_PROJECT_ID": proj,
        "FIRESTORE_EMULATOR_HOST": emulator,
        "firestore_ok": firestore_ok,
        "error": error,
    }


@app.get("/debug/llm")
def debug_llm(probe: bool = False) -> Dict[str, Any]:
    out: Dict[str, Any] = {}

    def _probe_exec(executor: AgentExecutor) -> Dict[str, Any]:
        try:
            info: Dict[str, Any] = {}
            try:
                ag = getattr(executor, "agent", None)
                if ag is not None:
                    prompt = getattr(ag, "prompt", None)
                    if prompt is not None:
                        info["prompt_vars"] = list(getattr(prompt, "input_variables", []))
                        try:
                            msgs = getattr(prompt, "messages", [])
                            info["prompt_msgs"] = [getattr(m, "prompt", getattr(m, "content", "")) for m in msgs]
                        except Exception:
                            pass
            except Exception:
                pass
            if probe:
                def _run():
                    return executor.invoke({"input": "ping"})
                with cf.ThreadPoolExecutor(max_workers=1) as ex:
                    _ = ex.submit(_run).result(timeout=20.0)
                info.update({"ok": True, "probed": True})
            else:
                info.update({"ok": True, "probed": False})
            return info
        except Exception as e:
            info = info if 'info' in locals() else {}
            info.update({"ok": False, "error": str(e)[:400]})
            return info

    try:
        ex1 = get_executor()
        out.update({"primary": _probe_exec(ex1)})
    except Exception as e:
        out.update({"primary": {"ok": False, "error": str(e)[:400]}})

    return out


@app.get("/debug/llm_status")
def debug_llm_status() -> Dict[str, Any]:
    """Expose whether LLM is currently in cooldown and for how long.
    Useful for showing a client banner like: 'AI in fast mode (pre-parser only)'.
    """
    try:
        quick_timeout_s = float(os.getenv("AGENT_LLM_QUICK_TIMEOUT", "10.0"))
    except Exception:
        quick_timeout_s = 10.0
    try:
        cooldown_window_s = float(os.getenv("AGENT_LLM_429_BACKOFF_SECONDS", "300"))
    except Exception:
        cooldown_window_s = 300.0
    now = time.time()
    remaining = max(0.0, _LLM_BACKOFF_UNTIL - now)
    in_cooldown = remaining > 0
    mode = "fast-mode" if in_cooldown else "llm-first"
    return {
        "is_in_cooldown": in_cooldown,
        "remaining_seconds": int(round(remaining)),
        "mode": mode,
        "llm_quick_timeout_seconds": quick_timeout_s,
        "cooldown_window_seconds": int(round(cooldown_window_s)),
        "preparser_enabled": True,
        "fastpath_enabled": _fastpath_enabled(),
    }


@app.post("/chat", response_model=ChatRes)
async def chat(req: ChatReq, background_tasks: BackgroundTasks) -> Any:
    global EXECUTOR
    msg = req.message.strip().lower()

    # Always try fastpath first for instant replies (greetings, cart, orders, ETA), regardless of env flags
    quick = _try_fastpath(req.userId, msg)
    if quick:
        # Log to Firestore in background so we don't block the response
        background_tasks.add_task(fs_add_chat_message, req.userId, "user", req.message)
        background_tasks.add_task(fs_add_chat_message, req.userId, "assistant", quick)
        return ChatRes(reply=quick)

    # We no longer short-circuit common flows before LLM to avoid duplicate side effects.
    # Fastpath remains first; for all other intents, we try a short LLM attempt and then pre-parser fallback.

    # LLM-first (quick) for smart reasoning; deterministic pre-parser as fast fallback
    # Use a 10s window by default so we bail out fast on throttling but still let quick answers through
    quick_timeout_s = 10.0
    try:
        quick_timeout_s = float(os.getenv("AGENT_LLM_QUICK_TIMEOUT", "10.0"))
    except Exception:
        pass

    # If we recently hit a 429, skip LLM for a cooldown window to avoid slow backoffs
    global _LLM_BACKOFF_UNTIL
    try:
        _ = _LLM_BACKOFF_UNTIL
    except NameError:
        _LLM_BACKOFF_UNTIL = 0.0
    now_ts = time.time()
    llm_cooldown_s = float(os.getenv("AGENT_LLM_429_BACKOFF_SECONDS", "300"))
    skip_llm_due_to_429 = now_ts < _LLM_BACKOFF_UNTIL
    entered_cooldown = False

    # Optional lightweight per-user rate limiter to avoid burst 429s
    soft_skip_llm = False
    try:
        max_calls = int(os.getenv("AGENT_LLM_RATELIMIT_COUNT", "3"))
        window_s = float(os.getenv("AGENT_LLM_RATELIMIT_WINDOW", "10"))
        if max_calls > 0 and window_s > 0:
            now = time.time()
            hist = _LLM_RECENT_CALLS.get(req.userId, [])
            hist = [t for t in hist if now - t < window_s]
            if len(hist) >= max_calls:
                soft_skip_llm = True
            else:
                hist.append(now)
                _LLM_RECENT_CALLS[req.userId] = hist
    except Exception:
        pass

    # Try LLM with a short timeout
    if not skip_llm_due_to_429 and not soft_skip_llm:
        try:
            executor = get_executor()
            # Build brief conversation context (last 5 messages) and light parsing hints
            hist_lines: List[str] = []
            try:
                hist = fs_get_chat_history(req.userId, 5) or []
                for h in hist:
                    role = str(h.get("role") or h.get("sender") or "").lower()
                    text = str(h.get("text") or h.get("message") or h.get("content") or "")
                    if role in ("user", "assistant") and text:
                        hist_lines.append(f"- {role}: {text}")
            except Exception:
                pass
            # Light hint extraction without side effects
            size_hint, qty_hint = _parse_size_qty(msg)
            r_hint = None
            mfrom = re.search(r"(.+?)\s+from\s+([a-z0-9\s]+)$", msg)
            if mfrom:
                r_hint = mfrom.group(2).strip()
            hints: List[str] = []
            if size_hint:
                hints.append(f"size={size_hint}")
            if qty_hint:
                hints.append(f"qty={qty_hint}")
            if r_hint:
                hints.append(f"restaurant={r_hint}")
            hints_text = ("; ".join(hints)) if hints else ""
            hist_text = ("\n".join(hist_lines)) if hist_lines else ""
            user_input = (
                f"uid:{req.userId}\n"
                f"last_messages:\n{hist_text}\n\n"
                f"hints:{(' ' + hints_text) if hints_text else ''}\n\n"
                f"message:\n{req.message}"
            )
            def _invoke():
                return executor.invoke({"input": user_input})
            pool = get_llm_pool()
            fut = pool.submit(_invoke)
            result = fut.result(timeout=quick_timeout_s)
            reply = result.get("output", "")
            # Learn suggestions (so user can say 'kofta' / 'option 1' next)
            try:
                _remember_suggestions_from_text(req.userId, reply)
            except Exception:
                pass
            background_tasks.add_task(fs_add_chat_message, req.userId, "user", req.message)
            background_tasks.add_task(fs_add_chat_message, req.userId, "assistant", reply)
            return ChatRes(reply=reply)
        except cf.TimeoutError:
            try:
                fut.cancel()
            except Exception:
                pass
            # Enter cooldown for a while to avoid repeated slow attempts
            try:
                _LLM_BACKOFF_UNTIL = time.time() + llm_cooldown_s
                entered_cooldown = True
            except Exception:
                pass
        except Exception as e:
            # On rate limits or other LLM errors, proceed to pre-parser
            err_text = str(e)
            if ("429" in err_text) or ("rate_limit" in err_text.lower()) or ("rate limit" in err_text.lower()):
                try:
                    _LLM_BACKOFF_UNTIL = time.time() + llm_cooldown_s
                    entered_cooldown = True
                except Exception:
                    pass
            
    # Deterministic pre-parser: handle option selection and add/remove by name
    try:
        pre = prehandle_message(req)
    except Exception:
        pre = None
    if pre:
        # If we just entered cooldown, prepend a short notice for the user
        reply_text = pre.reply
        if soft_skip_llm and not entered_cooldown:
            reply_text = (
                "Note: Using fast mode briefly to keep things responsive. I'll try the AI model again in a few seconds.\n\n"
                + reply_text
            )
        if entered_cooldown:
            mins = int(llm_cooldown_s // 60)
            reply_text = (
                f"Note: The AI model hit a temporary limit. I’ll switch to fast mode for about {mins} minutes, then try the model again.\n\n"
                + reply_text
            )
        background_tasks.add_task(fs_add_chat_message, req.userId, "user", req.message)
        background_tasks.add_task(fs_add_chat_message, req.userId, "assistant", reply_text)
        return ChatRes(reply=reply_text)

    # No pre-parser match. If we entered cooldown or are in cooldown, inform the user and provide guidance.
    if entered_cooldown or skip_llm_due_to_429:
        mins = int(llm_cooldown_s // 60)
        reply = (
            f"Note: The AI model hit a temporary limit. I’ll switch to fast mode for about {mins} minutes, then try the model again.\n\n"
            "You can still ask me to: show best sellers, find items (e.g., 'butter chicken'), add by name ('add mango lassi small 1'),"
            " or check 'what's in my cart'."
        )
        background_tasks.add_task(fs_add_chat_message, req.userId, "user", req.message)
        background_tasks.add_task(fs_add_chat_message, req.userId, "assistant", reply)
        return ChatRes(reply=reply)

    # Final guidance when neither LLM nor pre-parser produced a direct answer
    reply = "Please tell me what you’d like to do: ‘find <item>’, ‘add <name> <size> <qty>’, ‘best sellers’, or ‘what’s in my cart’."
    background_tasks.add_task(fs_add_chat_message, req.userId, "user", req.message)
    background_tasks.add_task(fs_add_chat_message, req.userId, "assistant", reply)
    return ChatRes(reply=reply)


class HistoryReq(BaseModel):
    userId: str
    limit: Optional[int] = 50


@app.post("/chat/history")
def chat_history(req: HistoryReq) -> Any:
    try:
        data = fs_get_chat_history(req.userId, req.limit or 50)
        return {"messages": data}
    except Exception as e:
        return {"messages": [], "error": str(e)}