import 'package:insta_food/core/network/APIs/api_constants.dart';
import 'package:insta_food/core/network/APIs/api_service.dart';
import 'package:insta_food/presentation/features/Restaurants/data/model/restaurant_model.dart';


abstract class RestaurantsRemoteDataSource {
  Future<List<Restaurant>> getAllRestaurants();
  Future<List<Restaurant>> getRestaurantsByCategory(String category);
  Future<List<Restaurant>> getRestaurantsByAddressAndName({
    String? address,
    String? name,
  });
  Future<Restaurant> getRestaurantById(int id);
}

/// Implementation using Dio
class RestaurantsRemoteDataSourceImpl implements RestaurantsRemoteDataSource {
  final ApiService apiService;
  RestaurantsRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<Restaurant>> getAllRestaurants() async {
    final response = await apiService.get(path: ApiConstants.restaurant);
    return (response.data as List)
        .map((json) => Restaurant.fromJson(json))
        .toList();
  }

  @override
  Future<List<Restaurant>> getRestaurantsByCategory(String category) async {
    final response = await apiService.get(path: ApiConstants.category + category);
    return (response.data as List)
        .map((json) => Restaurant.fromJson(json))
        .toList();
  }

  @override
  Future<List<Restaurant>> getRestaurantsByAddressAndName({
    String? address,
    String? name,
  }) async {
    final response = await apiService.get(path: ApiConstants.addressandname
        .replaceFirst('{address}', address ?? '')
        .replaceFirst('{name}', name ?? ''));
    return (response.data as List)
        .map((json) => Restaurant.fromJson(json))
        .toList();
  }

  @override
  Future<Restaurant> getRestaurantById(int id) async {
    final response = await apiService.get(path: "${ApiConstants.restaurant}/$id");
    return Restaurant.fromJson(response.data);
  }
}
