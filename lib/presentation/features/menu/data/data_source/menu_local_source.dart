import 'package:hive/hive.dart';
import 'package:insta_food/core/errors/failures.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

abstract class MenuLocalSource {
  Future<void> cacheMenus(List<ItemModel> data);
  Future<List<ItemModel>> getCachedMenus();
}

class MenuLocalDataSourceImpl implements MenuLocalSource {
  final Box<ItemModel> box;
  MenuLocalDataSourceImpl({required this.box});

  @override
  Future<void> cacheMenus(List<ItemModel> data) async {
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
  Future<List<ItemModel>> getCachedMenus() async {
    try {
      return box.values.toList(growable: false);
    } catch (e) {
      throw CacheFailure('Failed to get cached data: $e');
    }
  }
}
