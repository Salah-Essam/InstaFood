import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

/// Contract for managing session-scoped favorites.
abstract class FavoritesRepository {
  Map<int, ItemModel> get favoritesMap;
  List<ItemModel> get favorites;
  bool isFavorite(int itemId);
  void add(ItemModel item);
  void remove(int itemId);
  void toggle(ItemModel item);
  void clear();
}
