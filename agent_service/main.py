import os
import concurrent.futures as cf
import threading
from typing import Any, Dict, Optional

from fastapi import FastAPI, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from langchain.tools import tool
from langchain.agents import create_react_agent, AgentExecutor
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_google_genai import ChatGoogleGenerativeAI
import difflib
import time

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
    import json
    if isinstance(s, (dict, list)):
        return s  # already parsed
    try:
        return json.loads(s)
    except Exception:
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
        # Load all items then apply fuzzy selection locally (mirrors Flutter filtering-on-list approach)
        all_items = list_items() or []

        def score(item_name: str) -> float:
            nm = (item_name or "").strip().lower()
            if not nm:
                return 0.0
            if query == nm:
                return 1.0
            if query in nm:
                return 0.95
            base = difflib.SequenceMatcher(None, query, nm).ratio()
            qtokens = set(query.split())
            ntokens = set(nm.split())
            overlap = len(qtokens & ntokens) / max(1, len(qtokens))
            return max(base, 0.7 * base + 0.3 * overlap)

        scored = []
        for it in all_items:
            name = str(it.get("itemName") or it.get("name") or "")
            s = score(name)
            if s >= 0.55:
                it2 = dict(it)
                it2["_score"] = round(s, 3)
                scored.append(it2)
        scored.sort(key=lambda x: x.get("_score", 0.0), reverse=True)
        out = []
        for it in scored[:5]:
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
    """Filter items (via Items API) by optional category and/or max_price. Input keys: max_price, category, query.
    Returns a compact list of objects: [{id, name, price}].
    """
    d = _parse_json(payload)
    try:
        import re
        items = list_items() or []
        def _parse_price(v) -> float:
            try:
                if isinstance(v, (int, float)):
                    return float(v)
                s = str(v)
                m = re.findall(r"[\d]+(?:\.[\d]+)?", s)
                return float(m[0]) if m else 0.0
            except Exception:
                return 0.0

        max_price = d.get("max_price")
        try:
            max_price = float(max_price) if max_price is not None else None
        except Exception:
            max_price = None

        raw_category = (d.get("category") or "").strip().lower()
        q = (d.get("query") or "").strip().lower()
        cat_syn = {
            "drink": [
                "drink", "drinks", "beverage", "beverages", "soft drink", "soft drinks",
                "juice", "juices", "mocktail", "shake", "lassi", "soda",
                "مشروب", "مشروبات", "عصير", "مشروبات غازية"
            ],
            "dessert": ["dessert", "desserts", "sweet", "sweets", "حلو", "حلويات"],
            "burger": ["burger", "burgers", "برجر"],
            "pizza": ["pizza", "بيتزا"],
        }
        def _cat_match(name: str) -> bool:
            if not raw_category:
                return True
            nm = (name or "").lower()
            if raw_category in nm:
                return True
            for k, vals in cat_syn.items():
                if raw_category == k or raw_category in vals:
                    if any(v in nm for v in vals):
                        return True
            return False

        out = []
        for it in items:
            name = str(it.get("itemName") or it.get("name") or "")
            price = _parse_price(it.get("itemPrice", 0.0))
            item_id = it.get("itemID") or it.get("id")
            if max_price is not None and price > max_price:
                continue
            if not _cat_match(name):
                continue
            if q and q not in name.lower():
                continue
            out.append({"id": item_id, "name": name, "price": price})
        out.sort(key=lambda x: x.get("price", 0.0))
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
        max_retries = int(os.getenv("GEMINI_MAX_RETRIES", "0"))
    except Exception:
        max_retries = 0

    try:
        return ChatGoogleGenerativeAI(
            model=model_name,
            google_api_key=api_key,
            temperature=0.2,
            max_tokens=max_toks,
            convert_system_message_to_human=True,
            max_retries=max_retries,
        )
    except TypeError:
        # Older versions may not support max_retries; fall back gracefully
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
FASTPATH_ENV_KEY = "AGENT_FASTPATH"

# Simple in-memory cache for quick fast-paths
_CACHE = {
    "best_sellers_names": (0.0, []),  # (ts, [names])
}

def _fastpath_enabled() -> bool:
    v = os.getenv(FASTPATH_ENV_KEY, "false").strip().lower()
    return v in ("1", "true", "yes", "on")

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


def _try_fastpath(uid: str, msg: str) -> Optional[str]:
    """Ultra-fast handling for common intents: greetings, best sellers, cart, orders, ETA."""
    m = (msg or "").strip().lower()
    # Helper: run a callable with a small timeout
    def _with_timeout(fn, seconds: float, default=None):
        try:
            with cf.ThreadPoolExecutor(max_workers=1) as ex:
                return ex.submit(fn).result(timeout=seconds)
        except Exception:
            return default
    try:
        # Greetings
        if any(k in m for k in ["hi", "hello", "hey", "salam", "مرحبا", "hola", "السلام", "اهلا"]):
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

        # Cart overview
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
                    pool.submit(_run).result(timeout=10.0)
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


@app.post("/chat", response_model=ChatRes)
async def chat(req: ChatReq, background_tasks: BackgroundTasks) -> Any:
    global EXECUTOR
    msg = req.message.strip().lower()

    if _fastpath_enabled():
        quick = _try_fastpath(req.userId, msg)
        if quick:
            # Log to Firestore in background so we don't block the response
            background_tasks.add_task(fs_add_chat_message, req.userId, "user", req.message)
            background_tasks.add_task(fs_add_chat_message, req.userId, "assistant", quick)
            return ChatRes(reply=quick)

    try:
        executor = get_executor()
        user_input = f"uid:{req.userId}\n{req.message}"
        def _invoke():
            return executor.invoke({"input": user_input})
        with cf.ThreadPoolExecutor(max_workers=1) as ex:
            result = ex.submit(_invoke).result(timeout=25.0)
        reply = result.get("output", "")
        
        background_tasks.add_task(fs_add_chat_message, req.userId, "user", req.message)
        background_tasks.add_task(fs_add_chat_message, req.userId, "assistant", reply)
    except cf.TimeoutError:
        reply = "The assistant timed out. Please try again."
    except Exception as e:
        err_text = str(e)
        if ("429" in err_text) or ("rate_limit" in err_text.lower()) or ("rate limit" in err_text.lower()):
            try:
                if "cart" in msg:
                    data = fs_get_cart(req.userId)
                    items = [f"- {(it.get('itemName') or it.get('name') or '')} x{it.get('quantity',1)}" for it in (data or []) if (it.get('itemName') or it.get('name'))]
                    return ChatRes(reply=("\n".join(items) or "Your cart is empty."))
                if ("order" in msg) or ("history" in msg):
                    data = fs_get_orders(req.userId, None)
                    return ChatRes(reply=str(data))
                if any(k in msg for k in ["best seller", "bestseller"]):
                    items = fs_get_best_sellers() or []
                    names = [str(it.get("name", "")) for it in items]
                    top = ", ".join(filter(None, names[:3]))
                    return ChatRes(reply=f"Here are some hits today: {top}.")
            except Exception:
                return ChatRes(reply="The AI hit a temporary rate limit. I can still help with your cart or orders.")
            return ChatRes(reply="The AI hit a temporary rate limit. Please try again in a few minutes.")
        
        reply = f"Error: {e}"
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