from typing import Any, Dict, List, Optional
import os
import threading
import concurrent.futures as cf
from google.cloud import firestore


_DB: Optional[firestore.Client] = None
_DB_LOCK = threading.Lock()


def get_db() -> firestore.Client:
    global _DB
    if _DB is not None:
        return _DB
    with _DB_LOCK:
        if _DB is None:
            project = os.getenv("FIREBASE_PROJECT_ID", "instafood-1")
            _DB = firestore.Client(project=project)
    return _DB


def warm_firestore(timeout_s: float = 2.0) -> bool:
    """Attempt a tiny read to warm up credentials, TLS, and gRPC channel.
    Returns True if warm succeeded within timeout.

    Important: Do not block on worker shutdown if the probe exceeds timeout,
    to avoid hanging app startup. We cancel futures and return quickly.
    """
    def _probe():
        db = get_db()
        # Touch a lightweight collection if available; ignore result
        _ = list(db.collection("Best Sellers").limit(1).stream())
        return True
    ex: Optional[cf.ThreadPoolExecutor] = None
    try:
        ex = cf.ThreadPoolExecutor(max_workers=1)
        fut = ex.submit(_probe)
        return bool(fut.result(timeout=max(0.2, float(timeout_s))))
    except Exception:
        return False
    finally:
        if ex is not None:
            # Don't wait for long-running probe; cancel if possible
            try:
                ex.shutdown(wait=False, cancel_futures=True)  # type: ignore[arg-type]
            except Exception:
                try:
                    ex.shutdown(wait=False)
                except Exception:
                    pass


def add_to_cart(uid: str, item_id: int, item_name: str, image_url: str, restaurant_id: int,
                restaurant_name: str, unit_price: float, quantity: int, size: str) -> None:
    """Upsert a cart item matching Flutter structure.
    - cartItemId: "{itemId}_size_{sizeName}" where sizeName in [small, medium, large, xlarge]
    - options.size: the size enum name (lowercase)
    """
    db = get_db()
    size_name = str(size or "").strip().lower()
    # Normalize common forms (Large -> large, L -> large, etc.)
    alias = {"s": "small", "sm": "small", "small": "small",
             "m": "medium", "md": "medium", "medium": "medium",
             "l": "large", "lg": "large", "large": "large",
             "xl": "xlarge", "x-large": "xlarge", "x_l": "xlarge", "xlarge": "xlarge"}
    size_name = alias.get(size_name, size_name)
    cart_item_id = f"{int(item_id)}_size_{size_name}"
    data = {
        "cartItemId": cart_item_id,
        "itemId": int(item_id),
        "itemName": item_name,
        "imageUrl": image_url,
        "restaurantId": int(restaurant_id),
        "restaurantName": restaurant_name,
        "unitPrice": float(unit_price),
        "quantity": int(quantity),
        "options": {"size": size_name},
        "updatedAt": firestore.SERVER_TIMESTAMP,
        "addedAt": firestore.SERVER_TIMESTAMP,
    }
    db.collection("users").document(uid).collection("cart").document(cart_item_id).set(data, merge=True)


def clear_cart(uid: str) -> None:
    db = get_db()
    col = db.collection("users").document(uid).collection("cart")
    for d in col.stream():
        d.reference.delete()


def remove_from_cart(uid: str, cart_item_id: str) -> None:
    db = get_db()
    db.collection("users").document(uid).collection("cart").document(str(cart_item_id)).delete()


def get_cart(uid: str) -> List[Dict[str, Any]]:
    db = get_db()
    col = db.collection("users").document(uid).collection("cart").order_by("addedAt")
    return [doc.to_dict() for doc in col.stream()]


def place_order(uid: str, shipping_address: str) -> Optional[str]:
    db = get_db()
    items = get_cart(uid)
    if not items:
        return None
    subtotal = sum((it.get("unitPrice", 0.0) * it.get("quantity", 1)) for it in items)
    tax = 1.0
    delivery = 2.0
    total = subtotal + tax + delivery
    payload = {
        "status": "active",
        "items": items,
        "subtotal": subtotal,
        "tax": tax,
        "deliveryFee": delivery,
        "total": total,
        "shippingAddress": shipping_address,
        "payment": {"status": "pending"},
        "createdAt": firestore.SERVER_TIMESTAMP,
        "updatedAt": firestore.SERVER_TIMESTAMP,
    }
    ref = db.collection("users").document(uid).collection("orders").add(payload)[1]
    return ref.id


def get_orders(uid: str, status: Optional[str] = None) -> List[Dict[str, Any]]:
    db = get_db()
    q = db.collection("users").document(uid).collection("orders")
    if status:
        q = q.where("status", "==", status)
    q = q.order_by("createdAt", direction=firestore.Query.DESCENDING)
    return [doc.to_dict() | {"id": doc.id} for doc in q.stream()]


def mark_order_paid(uid: str, order_id: str) -> None:
    db = get_db()
    db.collection("users").document(uid).collection("orders").document(order_id).update({
        "payment.status": "paid",
        "updatedAt": firestore.SERVER_TIMESTAMP,
    })


def cancel_order(uid: str, order_id: str) -> None:
    db = get_db()
    db.collection("users").document(uid).collection("orders").document(order_id).update({
        "status": "cancelled",
        "updatedAt": firestore.SERVER_TIMESTAMP,
    })


def get_best_sellers() -> List[Dict[str, Any]]:
    db = get_db()
    col = db.collection("Best Sellers")
    res = []
    for d in col.stream():
        data = d.to_dict()
        data["id"] = d.id
        res.append(data)
    return res


# Favorites helpers (assumes users/{uid}/favorites/{itemId})
def add_favorite(uid: str, item_id: int, name: str, image_url: str, restaurant_name: str, price: float) -> None:
    db = get_db()
    doc_id = str(item_id)
    data = {
        "itemId": int(item_id),
        "name": name,
        "imageUrl": image_url,
        "restaurantName": restaurant_name,
        "price": float(price),
        "addedAt": firestore.SERVER_TIMESTAMP,
    }
    db.collection("users").document(uid).collection("favorites").document(doc_id).set(data, merge=True)


def remove_favorite(uid: str, item_id: int) -> None:
    db = get_db()
    db.collection("users").document(uid).collection("favorites").document(str(item_id)).delete()


def get_favorites(uid: str) -> List[Dict[str, Any]]:
    db = get_db()
    col = db.collection("users").document(uid).collection("favorites").order_by("addedAt", direction=firestore.Query.DESCENDING)
    return [doc.to_dict() | {"id": doc.id} for doc in col.stream()]


# Chat history helpers: users/{uid}/chat/{autoId}
def add_chat_message(uid: str, role: str, content: str) -> None:
    db = get_db()
    data = {
        "role": role,  # "user" | "assistant" | "system"
        "content": content,
        "createdAt": firestore.SERVER_TIMESTAMP,
    }
    db.collection("users").document(uid).collection("chat").add(data)


def get_chat_history(uid: str, limit: int = 50) -> List[Dict[str, Any]]:
    db = get_db()
    q = (
        db.collection("users").document(uid).collection("chat")
        .order_by("createdAt", direction=firestore.Query.DESCENDING)
        .limit(max(1, int(limit)))
    )
    items = [doc.to_dict() | {"id": doc.id} for doc in q.stream()]
    # return ascending by time for UI
    return list(reversed(items))