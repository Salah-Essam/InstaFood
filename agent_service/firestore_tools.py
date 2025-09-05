from typing import Any, Dict, List, Optional
import os
from google.cloud import firestore


def get_db() -> firestore.Client:
    project = os.getenv("FIREBASE_PROJECT_ID", "instafood-1")
    return firestore.Client(project=project)


def add_to_cart(uid: str, item_id: int, item_name: str, image_url: str, restaurant_id: int,
                restaurant_name: str, unit_price: float, quantity: int, size: str) -> None:
    db = get_db()
    cart_item_id = f"{item_id}size{size}"
    data = {
        "cartItemId": cart_item_id,
        "itemId": int(item_id),
        "itemName": item_name,
        "imageUrl": image_url,
        "restaurantId": int(restaurant_id),
        "restaurantName": restaurant_name,
        "unitPrice": float(unit_price),
        "quantity": int(quantity),
        "options": {"size": size},
        "updatedAt": firestore.SERVER_TIMESTAMP,
        "addedAt": firestore.SERVER_TIMESTAMP,
    }
    db.collection("users").document(uid).collection("cart").document(cart_item_id).set(data, merge=True)


def clear_cart(uid: str) -> None:
    db = get_db()
    col = db.collection("users").document(uid).collection("cart")
    for d in col.stream():
        d.reference.delete()


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


def get_best_sellers() -> List[Dict[str, Any]]:
    db = get_db()
    col = db.collection("Best Sellers")
    res = []
    for d in col.stream():
        data = d.to_dict()
        data["id"] = d.id
        res.append(data)
    return res