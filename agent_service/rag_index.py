from dataclasses import dataclass
from typing import List, Tuple

from rank_bm25 import BM25Okapi


@dataclass
class Doc:
    id: str
    text: str


class SimpleBM25Index:
    def __init__(self, docs: List[Doc]):
        self.docs = docs
        self.tokenized = [d.text.lower().split() for d in docs]
        self.bm25 = BM25Okapi(self.tokenized)

    def search(self, query: str, k: int = 5) -> List[Tuple[Doc, float]]:
        tokens = query.lower().split()
        scores = self.bm25.get_scores(tokens)
        pairs = list(zip(self.docs, scores))
        pairs.sort(key=lambda x: x[1], reverse=True)
        return pairs[:k]


def load_project_docs() -> SimpleBM25Index:
    # Minimal embedded knowledge about InstaFood data flow
    texts = [
        (
            "orders",
            "Firestore structure: users/{uid}/orders/{orderId} with fields: status, items, subtotal, tax, deliveryFee, total, shippingAddress, payment, delivery, createdAt, updatedAt. Status can be active, completed, cancelled.",
        ),
        (
            "cart",
            "Cart structure: users/{uid}/cart/{cartItemId} fields: cartItemId, itemId, itemName, imageUrl, restaurantId, restaurantName, unitPrice, quantity, options(size,...), addedAt, updatedAt.",
        ),
        (
            "best_sellers",
            "Best sellers collection: Firestore collection 'Best Sellers' with docs containing name, description, price, resturant Name, category, imageUrl. BestSellerItem maps to ItemModel.",
        ),
        (
            "business_logic",
            "Place order flow: build payload from current cart (CartCubit -> CartRepository -> Firestore), create active order, mark payment paid/completed, clear cart, show ETA. Delivery estimate ~10 min prep + distance/0.5 km per minute.",
        ),
        (
            "tools_json",
            "Agent tools and required JSON keys: add_to_cart {uid,item_id,item_name,image_url,restaurant_id,restaurant_name,unit_price,quantity,size}; place_order {uid,shipping_address}; my_orders {uid,status?}; best_sellers {}; add_by_item_id {uid,item_id,size,quantity?}; delivery_eta {uid,order_id?}; my_cart {uid}; add_to_favorites {uid,item_id,name,image_url,restaurant_name,price}; remove_from_favorites {uid,item_id}; my_favorites {uid}. Always include uid from chat context.",
        ),
        (
            "ids_and_keys",
            "Cart item identity: cartItemId is f\"{itemId}size{size}\" so adding same itemId with same size merges quantity. Best Sellers docs use field 'resturant Name' (typo intentional). Best seller document id is used as item_id when adding by id.",
        ),
        (
            "eta_logic",
            "ETA: Use latest active order (status=='active'), base window ~20–40 minutes. If createdAt is known, subtract elapsed from ~30 minutes, minimum 5 minutes remaining. Present as 'Estimated delivery in ~X minutes (by HH:MM AM/PM)'.",
        ),
        (
            "flutter_client",
            "Flutter chat calls POST /chat with {userId,message}. Dio receiveTimeout is ~90s. Backend should bind 0.0.0.0 and use LAN IP for phone testing. Keep app foregrounded to avoid socket aborts.",
        ),
        (
            "env_and_auth",
            "Backend uses Firestore via ADC with FIREBASE_PROJECT_ID and GOOGLE_APPLICATION_CREDENTIALS. Optional FIRESTORE_EMULATOR_HOST supported. /debug/auth endpoint verifies 'firestore_ok'.",
        ),
        (
            "payments",
            "Payment flow: order starts with payment.status='pending'; when paid, set payment.status='paid' and possibly status='completed'. mark_order_paid(uid,order_id) updates payment status.",
        ),
    ]
    docs = [Doc(id=i, text=t) for i, t in texts]
    return SimpleBM25Index(docs)