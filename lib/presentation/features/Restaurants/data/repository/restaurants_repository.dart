
import 'package:insta_food/presentation/features/Restaurants/data/data_source/local_data.dart';
import 'package:insta_food/presentation/features/Restaurants/data/data_source/remote_data.dart';
import 'package:insta_food/presentation/features/Restaurants/data/model/restaurant_model.dart';
import 'package:insta_food/core/network/network_info.dart';

class RestaurantsRepository {
  final RestaurantsLocalDataSource local;
  final RestaurantsRemoteDataSource remote;
  final NetworkInfo networkInfo;

  RestaurantsRepository({required this.local, required this.remote, required this.networkInfo});

  Future<List<Restaurant>> fetchAll() async {
    if (await networkInfo.isConnected) {
      final list = await remote.getAllRestaurants();
      await local.cacheRestaurants(list);
      return list;
    }
    return local.getCachedRestaurants();
  }

  Future<List<Restaurant>> filterByName(String name) async {
    if (await networkInfo.isConnected) {
      final list = await remote.getRestaurantsByAddressAndName(name: name);
      await local.cacheRestaurants(list);
      return list;
    }
    final cached = await local.getCachedRestaurants();
    return cached.where((r) => r.restaurantName.toLowerCase().contains(name.toLowerCase())).toList();
  }

  Future<List<Restaurant>> filterByAddress(String address) async {
    if (await networkInfo.isConnected) {
      final list = await remote.getRestaurantsByAddressAndName(address: address);
      await local.cacheRestaurants(list);
      return list;
    }
    final cached = await local.getCachedRestaurants();
    return cached.where((r) => r.address.toLowerCase().contains(address.toLowerCase())).toList();
  }

  Future<List<Restaurant>> filterByCuisine(String cuisine) async {
    if (await networkInfo.isConnected) {
      final list = await remote.getRestaurantsByCategory(cuisine);
      await local.cacheRestaurants(list);
      return list;
    }
    final cached = await local.getCachedRestaurants();
    return cached.where((r) => r.type.toLowerCase().contains(cuisine.toLowerCase())).toList();
  }

  Future<void> cacheRestaurants(List<Restaurant> restaurants) => local.cacheRestaurants(restaurants);
  Future<List<Restaurant>> getCachedRestaurants() => local.getCachedRestaurants();
}
