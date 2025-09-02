import 'package:insta_food/presentation/features/favorites/domain/favorites_repository.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

/// Simple in-memory favorites repository (cleared when app restarts)
class FavoritesRepositoryMemory implements FavoritesRepository {
  final Map<int, ItemModel> _favorites = {};

  @override
  Map<int, ItemModel> get favoritesMap => _favorites;

  @override
  List<ItemModel> get favorites => _favorites.values.toList(growable: false);

  @override
  bool isFavorite(int itemId) => _favorites.containsKey(itemId);

  @override
  void add(ItemModel item) {
    _favorites[item.itemID] = item;
  }

  @override
  void remove(int itemId) {
    _favorites.remove(itemId);
  }

  @override
  void toggle(ItemModel item) {
    if (isFavorite(item.itemID)) {
      remove(item.itemID);
    } else {
      add(item);
    }
  }

  @override
  void clear() => _favorites.clear();
}
