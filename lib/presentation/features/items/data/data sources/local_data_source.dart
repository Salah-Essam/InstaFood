import 'package:hive/hive.dart';
import 'package:insta_food/core/errors/failures.dart';
import 'package:insta_food/core/storage/hive_service.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

abstract class ItemsLocalDataSource {
  Future<void> cacheItems(List<ItemModel> data);
  Future<dynamic> getCachedItems();
}

class ProductLocalDataSourceImpl implements ItemsLocalDataSource {
  final Box box;

  ProductLocalDataSourceImpl({required this.box});

  @override
  Future<void> cacheItems(List<ItemModel> data) async {
    try {
      await box.put(cacheItemsKey, data);
    } catch (e) {
      throw CacheFailure('Failed to cache data');
    }
  }

  @override
  Future<List<ItemModel>> getCachedItems() async {
    try {
      final dynamic cachedData = box.get(cacheItemsKey);

      // Explicitly cast to List<ItemModel>
      if (cachedData is List<dynamic>) {
        return cachedData.cast<ItemModel>();
      }
      return [];
    } catch (e) {
      throw CacheFailure('Failed to get cached data');
    }
  }
}
