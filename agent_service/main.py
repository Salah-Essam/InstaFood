import os
from typing import Any, Dict, Optional

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from langchain.tools import tool
from langchain.agents import create_react_agent, AgentExecutor
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_community.llms import HuggingFaceEndpoint, Ollama

from .rag_index import load_project_docs
from .firestore_tools import (
    add_to_cart as fs_add_to_cart,
    place_order as fs_place_order,
    get_orders as fs_get_orders,
    get_best_sellers as fs_get_best_sellers,
    get_db,
)


# Simple retrieval helper
INDEX = load_project_docs()


# Helper to parse JSON payloads from single-string tool inputs
def _parse_json(s: str) -> Dict[str, Any]:
    import json
    try:
        if isinstance(s, (dict, list)):
            return s  # already parsed
        return json.loads(s)
    except Exception:
        return {}


@tool
def rag_search(query: str) -> str:
    """Search project docs to answer questions about InstaFood logic, data flow, and schema."""
    results = INDEX.search(query, k=3)
    return "\n\n".join([f"[{doc.id}] {doc.text}" for doc, _ in results])


@tool
def add_to_cart(payload: str) -> str:
    """Add or update item in cart. Input JSON keys: uid, item_id, item_name, image_url, restaurant_id, restaurant_name, unit_price, quantity, size."""
    d = _parse_json(payload)
    try:
        fs_add_to_cart(
            d.get("uid", ""),
            int(d.get("item_id", 0)),
            str(d.get("item_name", "")),
            str(d.get("image_url", "")),
            int(d.get("restaurant_id", 0)),
            str(d.get("restaurant_name", "")),
            float(d.get("unit_price", 0.0)),
            int(d.get("quantity", 1)),
            str(d.get("size", "regular")),
        )
        return "added"
    except Exception as e:
        return f"error: {e}"


@tool
def place_order(payload: str) -> str:
    """Create an active order from user's cart. Input JSON keys: uid, shipping_address. Returns orderId or 'cart_empty'."""
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
    """Return user's orders. Input JSON: { uid, status? ('active'|'completed'|'cancelled') }"""
    d = _parse_json(payload)
    try:
        return str(fs_get_orders(d.get("uid", ""), d.get("status")))
    except Exception as e:
        return f"error: {e}"


@tool
def best_sellers(payload: str) -> str:
    """Return best seller items from Firestore. Input can be any string (ignored)."""
    try:
        return str(fs_get_best_sellers())
    except Exception as e:
        return f"error: {e}"

@tool
def add_by_item_id(payload: str) -> str:
    """Add by Best Sellers doc id. Input JSON: { uid, item_id, size, quantity? }"""
    d = _parse_json(payload)
    uid = d.get("uid", "")
    item_id = d.get("item_id")
    size = d.get("size", "regular")
    quantity = int(d.get("quantity", 1))
    if item_id is None:
        return "error: missing item_id"
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
def delivery_eta(payload: str) -> str:
    """Get ETA for latest active order or specific one. Input JSON: { uid, order_id? }"""
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


def build_llm():
    # Load .env lazily so local dev can set secrets without exporting system-wide
    try:
        from dotenv import load_dotenv
        load_dotenv()
    except Exception:
        pass

    model = os.getenv("HF_MODEL")
    token = os.getenv("HUGGINGFACEHUB_API_TOKEN")
    if model and token:
        # Use HuggingFaceEndpoint which implements Runnable in LC 0.2+
        return HuggingFaceEndpoint(
            repo_id=model,
            huggingfacehub_api_token=token,
            temperature=0.2,
            max_new_tokens=256,
        )
    # Optional local Llama via Ollama
    ollama_model = os.getenv("OLLAMA_MODEL")
    if ollama_model:
        try:
            return Ollama(model=ollama_model, temperature=0.2)
        except Exception:
            pass
    # No usable LLM configured for the modern agent API
    raise RuntimeError("No LLM configured. Set HF_MODEL and HUGGINGFACEHUB_API_TOKEN or OLLAMA_MODEL.")


TOOLS = [rag_search, add_to_cart, place_order, my_orders, best_sellers, add_by_item_id, delivery_eta]

# Build a ReAct agent using modern API
SYSTEM_INSTRUCTIONS = (
    '''You are an InstaFood assistant.
Use tools by passing a SINGLE JSON STRING as the only argument. Keys must match each tool's docstring.
Examples:
- add_to_cart('{"uid":"<uid>","item_id":1,"item_name":"Burger","image_url":"...","restaurant_id":0,"restaurant_name":"Foo","unit_price":9.9,"quantity":1,"size":"regular"}')
- place_order('{"uid":"<uid>","shipping_address":"Cairo"}')
- my_orders('{"uid":"<uid>","status":"active"}')
- best_sellers('any')
- delivery_eta('{"uid":"<uid>"}')
Use rag_search to recall schema. Keep answers concise.'''
)

PROMPT = ChatPromptTemplate.from_messages([
    ("system", SYSTEM_INSTRUCTIONS),
    ("human", "{input}"),
    MessagesPlaceholder(variable_name="agent_scratchpad"),
])

EXECUTOR = None  # lazy-initialized

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
    EXECUTOR = AgentExecutor(agent=agent, tools=TOOLS, verbose=False)
    return EXECUTOR


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


@app.post("/chat", response_model=ChatRes)
def chat(req: ChatReq) -> Any:
    try:
        executor = get_executor()
        # Pass uid to the agent so it can construct JSON payloads for tools
        user_input = f"uid:{req.userId}\n{req.message}"
        result = executor.invoke({"input": user_input})
        reply = result.get("output", "")
    except Exception as e:
        reply = f"Error: {e}"
    return ChatRes(reply=reply)