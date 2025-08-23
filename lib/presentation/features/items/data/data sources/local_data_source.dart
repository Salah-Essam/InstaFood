import 'package:hive/hive.dart';
import 'package:insta_food/core/errors/failures.dart';
import 'package:insta_food/core/hive/hive_setup.dart';

abstract class ItemsLocalDataSource {
  Future<void> cacheItems(dynamic data);
  Future<dynamic> getCachedItems();
}

class ProductLocalDataSourceImpl implements ItemsLocalDataSource {
  final Box box;

  ProductLocalDataSourceImpl({required this.box});

  @override
  Future<void> cacheItems(dynamic data) async {
    try {
      await box.put(cacheItemsKey, data);
    } catch (e) {
      throw CacheFailure('Failed to cache data');
    }
  }

  @override
  Future<dynamic> getCachedItems() async {
    try {
      return box.get(cacheItemsKey);
    } catch (e) {
      throw CacheFailure('Failed to get cached data');
    }
  }
}
