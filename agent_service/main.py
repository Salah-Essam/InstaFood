import os
import concurrent.futures as cf
from typing import Any, Dict, Optional

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from langchain.tools import tool
from langchain.agents import create_react_agent, AgentExecutor
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_community.llms import HuggingFaceEndpoint, Ollama
try:
    from langchain_groq import ChatGroq
except Exception:  # optional dependency
    ChatGroq = None  # type: ignore

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
)

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
    """Add by Best Sellers doc id. Input keys: uid, item_id, size, quantity, confirm. Rules: confirm must be true.
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
    db = get_db()
    doc = db.collection("Best Sellers").document(str(item_id)).get()
    if not doc.exists:
        return "item_not_found"
    data = doc.to_dict() or {}
    name = data.get("name", "")
    image = data.get("imageUrl", "")
    price = float(data.get("price", 0.0))
    rest_name = data.get("resturant Name", "")
    try:
        fs_add_to_cart(uid, int(item_id), name, image, 0, rest_name, price, int(quantity), size)
        return "added"
    except Exception as e:
        return f"error: {e}"

@tool
def filter_items(payload: str) -> str:
    """Filter Best Sellers by optional category and/or max_price. Input keys: max_price, category, query.
    Returns a compact list of objects: [{id, name, price}].
    """
    d = _parse_json(payload)
    try:
        import re
        items = fs_get_best_sellers() or []
        # Robust price parsing: accept numbers embedded in strings (e.g., "₹150", "Rs 150")
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

        # Category normalization + synonyms
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
        def _cat_match(item_cat: str, name: str) -> bool:
            if not raw_category:
                return True
            ic = (item_cat or "").lower()
            nm = (name or "").lower()
            # direct substring
            if raw_category in ic:
                return True
            # synonyms
            for k, vals in cat_syn.items():
                if raw_category == k or raw_category in vals:
                    if any(v in ic for v in vals) or any(v in nm for v in vals):
                        return True
            return False

        out = []
        for it in items:
            name = str(it.get("name", ""))
            price = _parse_price(it.get("price", 0.0))
            cat = str(it.get("category", it.get("Category", "")))
            item_id = it.get("id") or it.get("item_id") or it.get("docId")
            if max_price is not None and price > max_price:
                continue
            if not _cat_match(cat, name):
                continue
            if q and q not in name.lower():
                continue
            out.append({"id": item_id, "name": name, "price": price})
        # Sort ascending by price for budget-friendly display
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
    base_eta = 30  # minutes typical
    if hasattr(created, 'timestamp'):
        try:
            # Firestore Timestamp -> datetime
            if hasattr(created, 'to_datetime'):
                created_dt = created.to_datetime()
            else:
                created_dt = created
            elapsed = (now - created_dt).total_seconds() / 60.0
            remaining = max(5, base_eta - int(elapsed))
            eta_at = now + timedelta(minutes=remaining)
            # Use %I (12-hour) which is Windows-safe (no leading zero stripping)
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
    # Load .env lazily so local dev can set secrets without exporting system-wide
    try:
        from dotenv import load_dotenv
        load_dotenv()
    except Exception:
        pass

    # Prefer Groq if configured (fast, reliable API)
    groq_key = os.getenv("GROQ_API_KEY")
    groq_model = os.getenv("GROQ_MODEL") or "meta-llama/llama-3.1-8b-instant"
    if groq_key and ChatGroq is not None:
        try:
            # ChatGroq may not support a timeout kwarg; keep it minimal
            return ChatGroq(api_key=groq_key, model=groq_model, temperature=0.2, max_tokens=256)
        except Exception:
            pass

    # Prefer local Ollama if configured (avoids HF 404/gated models)
    ollama_model = os.getenv("OLLAMA_MODEL")
    if ollama_model:
        try:
            return Ollama(model=ollama_model, temperature=0.2)
        except Exception:
            pass
    # Hugging Face Inference API
    model = os.getenv("HF_MODEL")
    token = os.getenv("HUGGINGFACEHUB_API_TOKEN")
    if model and token:
        return HuggingFaceEndpoint(
            repo_id=model,
            huggingfacehub_api_token=token,
            temperature=0.2,
            max_new_tokens=256,
            timeout=90,
        )
    # No usable LLM configured for the modern agent API
    raise RuntimeError("No LLM configured. Set GROQ_API_KEY+GROQ_MODEL or HF_MODEL+HUGGINGFACEHUB_API_TOKEN, or OLLAMA_MODEL.")


def build_llm_for_model(model_id: str):
    """Build an LLM client for a specific HF model id using the same settings."""
    token = os.getenv("HUGGINGFACEHUB_API_TOKEN")
    if not (model_id and token):
        raise RuntimeError("Missing model id or HF token")
    return HuggingFaceEndpoint(
        repo_id=model_id,
        huggingfacehub_api_token=token,
        temperature=0.2,
        max_new_tokens=256,
        timeout=90,
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
    """Remove a specific cart item. Input keys: uid, cart_item_id (e.g., 123sizeLarge)."""
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

# Build a ReAct agent using modern API
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

EXECUTOR = None  # lazy-initialized
FASTPATH_ENV_KEY = "AGENT_FASTPATH"

def _fastpath_enabled() -> bool:
    v = os.getenv(FASTPATH_ENV_KEY, "false").strip().lower()
    return v in ("1", "true", "yes", "on")

def get_executor():
    global EXECUTOR
    if EXECUTOR is not None:
        return EXECUTOR
    # Ensure we load env from both root .env and agent_service/.env
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


def build_executor_with_model(model_id: str) -> AgentExecutor:
    """Build a fresh AgentExecutor bound to a specific HF model id."""
    llm = build_llm_for_model(model_id)
    agent = create_react_agent(llm, TOOLS, PROMPT)
    return AgentExecutor(agent=agent, tools=TOOLS, verbose=False)


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
    # Build executor once to avoid cold-start on first user call
    try:
        _ = get_executor()
    except Exception:
        pass

@app.get("/health")
def health() -> Dict[str, str]:
    return {"status": "ok"}


@app.get("/debug/auth")
def debug_auth() -> Dict[str, Any]:
    """Debug endpoint to verify ADC visibility and Firestore connectivity (no secrets exposed)."""
    path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
    proj = os.getenv("FIREBASE_PROJECT_ID")
    emulator = os.getenv("FIRESTORE_EMULATOR_HOST")
    exists = bool(path and os.path.isfile(path))
    firestore_ok = False
    error: Optional[str] = None
    try:
        def _probe():
            db = get_db()
            # Try a harmless read to force credentials/emulator usage
            return list(db.collection("Best Sellers").limit(1).stream())
        with cf.ThreadPoolExecutor(max_workers=1) as ex:
            _ = ex.submit(_probe).result(timeout=3.0)
            firestore_ok = True
    except Exception as e:
        error = str(e)[:300]
    return {
        "GOOGLE_APPLICATION_CREDENTIALS": path,
        "path_exists": exists,
        "FIREBASE_PROJECT_ID": proj,
        "FIRESTORE_EMULATOR_HOST": emulator,
        "HF_MODEL": os.getenv("HF_MODEL"),
        "HF_MODEL_FALLBACK": os.getenv("HF_MODEL_FALLBACK"),
        "OLLAMA_MODEL": os.getenv("OLLAMA_MODEL"),
        "GROQ_MODEL": os.getenv("GROQ_MODEL"),
        "GROQ_API_KEY_present": bool(os.getenv("GROQ_API_KEY")),
        "HUGGINGFACEHUB_API_TOKEN_present": bool(os.getenv("HUGGINGFACEHUB_API_TOKEN")),
        "firestore_ok": firestore_ok,
        "error": error,
    }


@app.get("/debug/llm")
def debug_llm() -> Dict[str, Any]:
    """Quick check that the configured LLM (and optional fallback) responds via HF Inference API.
    Returns ok flags and any trimmed error messages for easier diagnosis of 404/gated models.
    """
    model = os.getenv("HF_MODEL")
    fallback = os.getenv("HF_MODEL_FALLBACK")
    out: Dict[str, Any] = {
        "HF_MODEL": model,
        "HF_MODEL_FALLBACK": fallback,
        "GROQ_MODEL": os.getenv("GROQ_MODEL"),
    }

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
                            # Collect raw message strings for debugging
                            msgs = getattr(prompt, "messages", [])
                            info["prompt_msgs"] = [getattr(m, "prompt", getattr(m, "content", "")) for m in msgs]
                        except Exception:
                            pass
            except Exception:
                pass
            def _run():
                # Minimal invoke; agent will just respond to small input
                return executor.invoke({"input": "ping"})
            with cf.ThreadPoolExecutor(max_workers=1) as ex:
                _ = ex.submit(_run).result(timeout=20.0)
            info.update({"ok": True})
            return info
        except Exception as e:
            info = info if 'info' in locals() else {}
            info.update({"ok": False, "error": str(e)[:400]})
            return info

    # Primary
    try:
        ex1 = get_executor()
        out.update({"primary": _probe_exec(ex1)})
    except Exception as e:
        out.update({"primary": {"ok": False, "error": str(e)[:400]}})

    # Fallback (HF only)
    if fallback:
        try:
            ex2 = build_executor_with_model(fallback)
            out.update({"fallback": _probe_exec(ex2)})
        except Exception as e:
            out.update({"fallback": {"ok": False, "error": str(e)[:400]}})
    return out


@app.post("/chat", response_model=ChatRes)
def chat(req: ChatReq) -> Any:
    global EXECUTOR
    # Fast-path: handle a few simple intents without LLM to avoid cold-start latency
    msg = req.message.strip().lower()
    # Small-talk greeting (only when fast-path is enabled)
    if _fastpath_enabled() and any(k in msg for k in ["hi", "hello", "hey", "salam", "مرحبا", "hola"]):
        reply = "Hey there! Craving something tasty today? I can recommend popular picks or add items to your cart."
        try:
            fs_add_chat_message(req.userId, "user", req.message)
            fs_add_chat_message(req.userId, "assistant", reply)
        except Exception:
            pass
        return ChatRes(reply=reply)

    # Simple recommendation fast-path (when enabled)
    if _fastpath_enabled() and any(k in msg for k in ["recommend", "suggest", "hungry", "today", "something good"]):
        try:
            items = fs_get_best_sellers() or []
            names = [str(it.get("name", "")) for it in items]
            top = ", ".join(filter(None, names[:3]))
            reply = f"Here are some hits today: {top}. Want me to add one to your cart?"
            fs_add_chat_message(req.userId, "user", req.message)
            fs_add_chat_message(req.userId, "assistant", reply)
            return ChatRes(reply=reply)
        except Exception:
            # Fall through to LLM path
            pass

    # Budget/category fast-path: "under 370" or "drinks under 370"
    if _fastpath_enabled() and ("under " in msg or "below " in msg):
        import re
        try:
            m = re.search(r"(under|below)\s*(\d+)", msg)
            cap = None
            if m:
                cap = float(m.group(2))
            category = None
            if "drink" in msg or "drinks" in msg:
                category = "drink"
            items = fs_get_best_sellers() or []
            filt = []
            for it in items:
                price = float(it.get("price", 0.0))
                name = str(it.get("name", ""))
                cat = str(it.get("category", it.get("Category", ""))).lower()
                if cap is not None and price > cap:
                    continue
                if category and category not in cat:
                    continue
                filt.append(f"{name} (₹{int(price)})")
            reply = "Here are some options: " + ", ".join(filt[:5]) + ". Want me to add one? Which size and quantity?"
            fs_add_chat_message(req.userId, "user", req.message)
            fs_add_chat_message(req.userId, "assistant", reply)
            return ChatRes(reply=reply)
        except Exception:
            pass
    if _fastpath_enabled() and any(k in msg for k in ["best seller", "best sellers", "bestseller", "bestsellers"]):
        # Wrap Firestore call in a short timeout to avoid long stalls when ADC/auth is cold
        try:
            def _bs():
                return fs_get_best_sellers()
                # Some prompt templates expect an extra 'query' variable; pass it defensively.
                return executor.invoke({"input": "ping", "query": "ping"})
                data = ex.submit(_bs).result(timeout=5.0)
            names = [str(it.get("name", "")) for it in (data or [])]
            reply = "\n".join(f"- {n}" for n in names if n)
            # persist messages
            fs_add_chat_message(req.userId, "user", req.message)
            fs_add_chat_message(req.userId, "assistant", reply or "No best sellers found.")
            return ChatRes(reply=reply or "No best sellers found.")
        except cf.TimeoutError:
            return ChatRes(reply="Best sellers are warming up; please try again in a few seconds.")
        except Exception as e:
            return ChatRes(reply=f"Error: {e}")
    if _fastpath_enabled() and ("order" in msg or "history" in msg):
        status = None
        if "active" in msg:
            status = "active"
        elif "complete" in msg or "completed" in msg:
            status = "completed"
        try:
            def _orders():
                return fs_get_orders(req.userId, status)
            with cf.ThreadPoolExecutor(max_workers=1) as ex:
                data = ex.submit(_orders).result(timeout=5.0)
            fs_add_chat_message(req.userId, "user", req.message)
            resp = str(data)
            fs_add_chat_message(req.userId, "assistant", resp)
            return ChatRes(reply=resp)
        except cf.TimeoutError:
            return ChatRes(reply="Fetching orders is taking longer than usual; please retry shortly.")
        except Exception as e:
            return ChatRes(reply=f"Error: {e}")
    if _fastpath_enabled() and "cart" in msg:
        try:
            def _cart():
                return fs_get_cart(req.userId)
            with cf.ThreadPoolExecutor(max_workers=1) as ex:
                data = ex.submit(_cart).result(timeout=5.0)
            items = []
            for it in (data or []):
                name = it.get("itemName") or it.get("name") or ""
                qty = it.get("quantity", 1)
                if name:
                    items.append(f"- {name} x{qty}")
            fs_add_chat_message(req.userId, "user", req.message)
            resp = ("\n".join(items) or "Your cart is empty.")
            fs_add_chat_message(req.userId, "assistant", resp)
            return ChatRes(reply=resp)
        except cf.TimeoutError:
            return ChatRes(reply="Fetching cart is taking longer than usual; please retry shortly.")
        except Exception as e:
            return ChatRes(reply=f"Error: {e}")

    try:
        executor = get_executor()
        user_input = f"uid:{req.userId}\n{req.message}"
        def _invoke():
            return executor.invoke({"input": user_input})
        with cf.ThreadPoolExecutor(max_workers=1) as ex:
            result = ex.submit(_invoke).result(timeout=45.0)
        reply = result.get("output", "")
        # Persist chat history, but never fail the request if Firestore is unavailable
        try:
            fs_add_chat_message(req.userId, "user", req.message)
            fs_add_chat_message(req.userId, "assistant", reply)
        except Exception:
            pass
    except cf.TimeoutError:
        # Fallback to selective fast-paths if enabled by timeout policy
        if any(k in msg for k in ["best seller", "best sellers", "bestseller", "bestsellers"]):
            try:
                fs_add_chat_message(req.userId, "user", req.message)
                resp = "Best sellers are warming up; please try again in a few seconds."
                fs_add_chat_message(req.userId, "assistant", resp)
                return ChatRes(reply=resp)
            except Exception:
                pass
        if "cart" in msg:
            try:
                data = fs_get_cart(req.userId)
                items = [f"- {(it.get('itemName') or it.get('name') or '')} x{it.get('quantity',1)}" for it in (data or []) if (it.get('itemName') or it.get('name'))]
                fs_add_chat_message(req.userId, "user", req.message)
                resp = ("\n".join(items) or "Your cart is empty.")
                fs_add_chat_message(req.userId, "assistant", resp)
                return ChatRes(reply=resp)
            except Exception:
                pass
        if "order" in msg or "history" in msg:
            try:
                fs_add_chat_message(req.userId, "user", req.message)
                resp = str(fs_get_orders(req.userId, None))
                fs_add_chat_message(req.userId, "assistant", resp)
                return ChatRes(reply=resp)
            except Exception:
                pass
        reply = "The assistant timed out. Please try again."
    except Exception as e:
        # Try a fallback model if configured and the error looks like an HF 404/availability
        err_text = str(e)
        fb = os.getenv("HF_MODEL_FALLBACK")
        # Handle Groq/LLM rate limit errors gracefully
        if ("429" in err_text) or ("rate_limit" in err_text.lower()) or ("rate limit" in err_text.lower()):
            # On rate limit: try to fulfill common intents without LLM
            try:
                low = msg
                if "cart" in low:
                    data = fs_get_cart(req.userId)
                    items = [f"- {(it.get('itemName') or it.get('name') or '')} x{it.get('quantity',1)}" for it in (data or []) if (it.get('itemName') or it.get('name'))]
                    return ChatRes(reply=("\n".join(items) or "Your cart is empty."))
                if ("order" in low) or ("history" in low):
                    data = fs_get_orders(req.userId, None)
                    return ChatRes(reply=str(data))
                # Budget/category quick path: "under 300", "less than 300", with optional drinks
                import re
                cap = None
                m = re.search(r"(under|below|less than)\s*(\d+)", low)
                if m:
                    try:
                        cap = float(m.group(2))
                    except Exception:
                        cap = None
                is_drink = any(k in low for k in ["drink", "drinks", "beverage", "juice", "lassi", "مشروب", "مشروبات", "عصير"])  # quick synonyms
                if cap is not None:
                    items = fs_get_best_sellers() or []
                    def _price(v):
                        try:
                            if isinstance(v, (int, float)):
                                return float(v)
                            import re as _re
                            ms = _re.findall(r"[\d]+(?:\.[\d]+)?", str(v))
                            return float(ms[0]) if ms else 0.0
                        except Exception:
                            return 0.0
                    def _cat(it):
                        return str(it.get("category", it.get("Category", "")).lower())
                    filt = []
                    for it in items:
                        p = _price(it.get("price", 0.0))
                        if p > cap:
                            continue
                        if is_drink and not any(x in (_cat(it) + " " + str(it.get("name",""))).lower() for x in ["drink","drinks","beverage","juice","lassi","مشروب","مشروبات","عصير","soda","shake","mocktail"]):
                            continue
                        filt.append((str(it.get("name","")), int(p)))
                    filt.sort(key=lambda x: x[1])
                    reply = (
                        ("Here are some options: " + ", ".join(f"{n} (₹{pr})" for n, pr in filt[:5]) + ". Want me to add one? Which size and quantity?")
                        if filt else "No matching items found under your budget."
                    )
                    return ChatRes(reply=reply)
            except Exception:
                # If any of the direct paths fail, continue with fallback handling below
                pass
            # Try HF fallback first if available
            if fb:
                try:
                    alt_executor = build_executor_with_model(fb)
                    def _invoke_alt():
                        return alt_executor.invoke({"input": user_input})
                    with cf.ThreadPoolExecutor(max_workers=1) as ex:
                        result = ex.submit(_invoke_alt).result(timeout=45.0)
                    EXECUTOR = alt_executor
                    reply = result.get("output", "")
                    return ChatRes(reply=reply)
                except Exception:
                    pass
            # No fallback: provide a friendly message and a quick suggestion
            try:
                items = fs_get_best_sellers() or []
                names = [str(it.get("name", "")) for it in items]
                top = ", ".join(filter(None, names[:3]))
                reply = (
                    "The AI reached its daily limit and will be available again soon. "
                    + (f"Meanwhile, popular picks: {top}. Want one?" if top else "Meanwhile, I can still fetch your cart or orders.")
                )
                fs_add_chat_message(req.userId, "user", req.message)
                fs_add_chat_message(req.userId, "assistant", reply)
                return ChatRes(reply=reply)
            except Exception:
                return ChatRes(reply="The AI hit a temporary rate limit. Please try again in a few minutes.")
        if fb and ("404" in err_text or "Not Found" in err_text or "Model" in err_text):
            try:
                alt_executor = build_executor_with_model(fb)
                def _invoke_alt():
                    return alt_executor.invoke({"input": user_input})
                with cf.ThreadPoolExecutor(max_workers=1) as ex:
                    result = ex.submit(_invoke_alt).result(timeout=90.0)
                # swap global executor to fallback so next calls are faster
                EXECUTOR = alt_executor
                reply = result.get("output", "")
                return ChatRes(reply=reply)
            except Exception:
                pass
        # As a safety net, attempt fast-paths on generic errors too
        if any(k in msg for k in ["best seller", "best sellers", "bestseller", "bestsellers"]):
            try:
                data = fs_get_best_sellers()
                names = [str(it.get("name", "")) for it in (data or [])]
                return ChatRes(reply=("\n".join(f"- {n}" for n in names if n) or "No best sellers found."))
            except Exception:
                pass
        if "cart" in msg:
            try:
                data = fs_get_cart(req.userId)
                items = [f"- {(it.get('itemName') or it.get('name') or '')} x{it.get('quantity',1)}" for it in (data or []) if (it.get('itemName') or it.get('name'))]
                return ChatRes(reply=("\n".join(items) or "Your cart is empty."))
            except Exception:
                pass
        if "order" in msg or "history" in msg:
            try:
                return ChatRes(reply=str(fs_get_orders(req.userId, None)))
            except Exception:
                pass
        reply = f"Error: {e}"
        try:
            fs_add_chat_message(req.userId, "user", req.message)
            fs_add_chat_message(req.userId, "assistant", reply)
        except Exception:
            pass
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