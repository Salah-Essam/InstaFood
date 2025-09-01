import 'package:hive/hive.dart';
import 'package:insta_food/core/errors/failures.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

abstract class ItemsLocalDataSource {
  Future<void> cacheItems(List<ItemModel> data);
  Future<List<ItemModel>> getCachedItems();
}

class ProductLocalDataSourceImpl implements ItemsLocalDataSource {
  final Box<ItemModel> box;
  ProductLocalDataSourceImpl({required this.box});

  @override
  Future<void> cacheItems(List<ItemModel> data) async {
    try {
      await box.clear();
      for (final item in data) {
        await box.put(item.itemID, item);
      }
    } catch (e) {
      throw CacheFailure('Failed to cache data: $e');
    }
  }

  @override
  Future<List<ItemModel>> getCachedItems() async {
    try {
      return box.values.toList(growable: false);
    } catch (e) {
      throw CacheFailure('Failed to get cached data: $e');
    }
  }
}
