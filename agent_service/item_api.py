import os
from typing import Any, Dict, List, Optional
import httpx

API_BASE_URL = os.getenv("API_BASE_URL", "https://fakerestaurantapi.runasp.net/api")


def _client(timeout: float = 8.0) -> httpx.Client:
    return httpx.Client(base_url=API_BASE_URL, timeout=timeout)


def list_items(limit: Optional[int] = None) -> List[Dict[str, Any]]:
    with _client() as c:
        r = c.get("/Restaurant/items")
        r.raise_for_status()
        items = r.json()
        if isinstance(items, list) and limit:
            return items[: int(limit)]
        return items if isinstance(items, list) else []


def search_items(name: str) -> List[Dict[str, Any]]:
    name = (name or "").strip()
    if not name:
        return []
    with _client() as c:
        r = c.get(f"/Restaurant/items", params={"ItemName": name})
        r.raise_for_status()
        data = r.json()
        return data if isinstance(data, list) else []


def get_item_by_id(item_id: int) -> Optional[Dict[str, Any]]:
    # No direct id endpoint; fetch all and filter locally (API is small)
    try:
        items = list_items()
    except Exception:
        items = []
    for it in items or []:
        try:
            if int(it.get("itemID")) == int(item_id):
                return it
        except Exception:
            continue
    return None


def price_with_size(base_price: float, size_name: str) -> float:
    size = (size_name or "").strip().lower()
    modifiers = {
        "small": 0.0,
        "medium": 2.0,
        "large": 4.0,
        "xlarge": 6.0,
    }
    return float(base_price) + float(modifiers.get(size, 0.0))
