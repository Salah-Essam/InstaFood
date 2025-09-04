import 'package:hive/hive.dart';
import 'package:insta_food/core/errors/failures.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

abstract class MenuLocalSource {
  /// Cache (replace) the menu for a single restaurant without touching other restaurants' menus.
  Future<void> cacheMenusForRestaurant(int restaurantId, List<ItemModel> data);

  /// Get cached menu items for a specific restaurant.
  Future<List<ItemModel>> getCachedMenuForRestaurant(int restaurantId);

  // Deprecated (kept for backward compatibility if anything else still calls them)
  @Deprecated('Use cacheMenusForRestaurant instead')
  Future<void> cacheMenus(List<ItemModel> data);
  @Deprecated('Use getCachedMenuForRestaurant instead')
  Future<List<ItemModel>> getCachedMenus();
}

class MenuLocalDataSourceImpl implements MenuLocalSource {
  final Box<ItemModel> box;
  MenuLocalDataSourceImpl({required this.box});

  /// Remove existing cached items for [restaurantId] then insert new ones.
  @override
  Future<void> cacheMenusForRestaurant(int restaurantId, List<ItemModel> data) async {
    try {
      // Collect keys belonging to this restaurant.
      final keysToDelete = <dynamic>[];
      for (final key in box.keys) {
        final value = box.get(key);
        if (value != null && value.restaurantID == restaurantId) {
          keysToDelete.add(key);
        }
      }
      if (keysToDelete.isNotEmpty) {
        await box.deleteAll(keysToDelete);
      }
      // Insert new items (using itemID as key keeps existing convention)
      for (final item in data) {
        await box.put(item.itemID, item);
      }
    } catch (e) {
      throw CacheFailure('Failed to cache data: $e');
    }
  }

  @override
  Future<List<ItemModel>> getCachedMenuForRestaurant(int restaurantId) async {
    try {
      return box.values.where((i) => i.restaurantID == restaurantId).toList(growable: false);
    } catch (e) {
      throw CacheFailure('Failed to get cached data: $e');
    }
  }

  // Deprecated legacy methods (no restaurant scoping) kept so older calls won't crash.
  @override
  Future<void> cacheMenus(List<ItemModel> data) async {
    if (data.isEmpty) return; // best effort: if items belong to same restaurant, infer id
    final restaurantId = data.first.restaurantID;
    await cacheMenusForRestaurant(restaurantId, data);
  }

  @override
  Future<List<ItemModel>> getCachedMenus() async {
    try {
      return box.values.toList(growable: false);
    } catch (e) {
      throw CacheFailure('Failed to get cached data: $e');
    }
  }
}
