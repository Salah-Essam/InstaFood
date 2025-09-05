import os
from typing import Any, Dict, Optional

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from langchain.tools import tool
from langchain.agents import AgentType, initialize_agent
from langchain_community.llms.huggingface_hub import HuggingFaceHub
from langchain_community.llms import Ollama

from rag_index import load_project_docs
from firestore_tools import (
    add_to_cart as fs_add_to_cart,
    place_order as fs_place_order,
    get_orders as fs_get_orders,
    get_best_sellers as fs_get_best_sellers,
    get_db,
)


# Simple retrieval helper
INDEX = load_project_docs()


@tool
def rag_search(query: str) -> str:
    """Search project docs to answer questions about InstaFood logic, data flow, and schema."""
    results = INDEX.search(query, k=3)
    return "\n\n".join([f"[{doc.id}] {doc.text}" for doc, _ in results])


@tool
def add_to_cart(uid: str, item_id: int, item_name: str, image_url: str, restaurant_id: int,
                restaurant_name: str, unit_price: float, quantity: int, size: str) -> str:
    """Add or update an item in a user's cart in Firestore. Quantity replaces existing quantity for same item/size."""
    fs_add_to_cart(uid, item_id, item_name, image_url, restaurant_id, restaurant_name, unit_price, quantity, size)
    return "added"


@tool
def place_order(uid: str, shipping_address: str) -> str:
    """Create an active order from the user's cart and return the orderId."""
    order_id = fs_place_order(uid, shipping_address)
    return order_id or "cart_empty"


@tool
def my_orders(uid: str, status: Optional[str] = None) -> str:
    """Return user's orders; status can be 'active', 'completed', or 'cancelled'."""
    return str(fs_get_orders(uid, status))


@tool
def best_sellers() -> str:
    """Return list of best seller items from Firestore."""
    return str(fs_get_best_sellers())

@tool
def add_by_item_id(uid: str, item_id: int, size: str, quantity: int = 1) -> str:
    """Convenience: look up item details by Best Sellers doc id (numeric string) and add to cart."""
    db = get_db()
    doc = db.collection("Best Sellers").document(str(item_id)).get()
    if not doc.exists:
        return "item_not_found"
    d = doc.to_dict() or {}
    name = d.get("name", "")
    image = d.get("imageUrl", "")
    price = float(d.get("price", 0.0))
    rest_name = d.get("resturant Name", "")
    # No restaurant id in this collection; set 0
    fs_add_to_cart(uid, int(item_id), name, image, 0, rest_name, price, int(quantity), size)
    return "added"

@tool
def delivery_eta(uid: str, order_id: Optional[str] = None) -> str:
    """Rough ETA for a user's latest active order (or a specific order). Returns human text."""
    from datetime import datetime, timezone, timedelta
    db = get_db()
    col = db.collection("users").document(uid).collection("orders")
    if order_id:
        doc = col.document(order_id).get()
        if not doc.exists:
            return "order_not_found"
        data = doc.to_dict() or {}
    else:
        q = col.where("status", "==", "active").order_by("createdAt", direction=_import_('google.cloud.firestore').Query.DESCENDING).limit(1)
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
            return f"Estimated delivery in ~{remaining} minutes (by {eta_at.astimezone().strftime('%-I:%M %p')})."
        except Exception:
            pass
    return "Estimated delivery window: 20–40 minutes."


def build_llm():
    model = os.getenv("HF_MODEL")
    token = os.getenv("HUGGINGFACEHUB_API_TOKEN")
    if model and token:
        return HuggingFaceHub(repo_id=model, model_kwargs={"temperature": 0.2, "max_new_tokens": 256})
    # Optional local Llama via Ollama
    ollama_model = os.getenv("OLLAMA_MODEL")
    if ollama_model:
        try:
            return Ollama(model=ollama_model, temperature=0.2)
        except Exception:
            pass
    # Fallback: a tiny echo-style baseline to support tool calls; encourages tool-first answers.
    class DummyLLM:
        def _call_(self, prompt: str) -> str:
            return "Use tools to answer. If user asks to do something, call the appropriate tool with reasonable defaults."
    return DummyLLM()


TOOLS = [rag_search, add_to_cart, place_order, my_orders, best_sellers, add_by_item_id, delivery_eta]
LLM = build_llm()
AGENT = initialize_agent(
    tools=TOOLS,
    llm=LLM,
    agent=AgentType.ZERO_SHOT_REACT_DESCRIPTION,
    verbose=False,
)


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
    system = (
        "You are an InstaFood assistant. \n"
        "When user asks for: \n"
        "- add to cart -> call add_to_cart(uid, item_id, item_name, image_url, restaurant_id, restaurant_name, unit_price, quantity, size).\n"
        "- place order -> call place_order(uid, shipping_address).\n"
        "- my orders/history or delivery status -> call my_orders(uid, status?).\n"
        "- best seller -> call best_sellers.\n"
        "Use rag_search to recall schema.\n"
        "Keep answers short."
    )
    prompt = system + "\nUser: " + req.message
    try:
        reply = AGENT.run(prompt)
    except Exception as e:
        reply = f"Error: {e}"
    return ChatRes(reply=reply)