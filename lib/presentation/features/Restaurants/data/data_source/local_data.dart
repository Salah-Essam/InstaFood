import 'package:hive/hive.dart';
import 'package:insta_food/core/errors/failures.dart';
import 'package:insta_food/presentation/features/Restaurants/data/model/restaurant_model.dart';

abstract class RestaurantsLocalDataSource {
  Future<void> cacheRestaurants(List<Restaurant> restaurants);
  Future<List<Restaurant>> getCachedRestaurants();
}

class RestaurantsLocalDataSourceImpl implements RestaurantsLocalDataSource {
  final Box<Restaurant> box;

  RestaurantsLocalDataSourceImpl({required this.box});

  @override
  Future<void> cacheRestaurants(List<Restaurant> restaurants) async {
    try {
      // Clear existing then write new entries keyed by restaurantID
      await box.clear();
      for (final r in restaurants) {
        await box.put(r.restaurantID, r);
      }
    } catch (e) {
      throw CacheFailure('Failed to cache data');
    }
  }

  @override
  Future<List<Restaurant>> getCachedRestaurants() async {
    try {
  return box.values.whereType<Restaurant>().toList();
    } catch (e) {
      throw CacheFailure('Failed to get cached data');
    }
  }
}

