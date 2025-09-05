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
    ]
    docs = [Doc(id=i, text=t) for i, t in texts]
    return SimpleBM25Index(docs)