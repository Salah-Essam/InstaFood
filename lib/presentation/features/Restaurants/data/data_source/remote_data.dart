import 'package:dio/dio.dart';
import 'package:insta_food/core/network/APIs/api_constants.dart';
import 'package:insta_food/presentation/features/Restaurants/data/model/Restaurant_model.dart';
import 'package:insta_food/presentation/features/Restaurants/data/model/menu_model.dart';


/// Abstract class for contract
abstract class RestaurantRemoteDataSource {
  Future<List<Restaurant>> getAllRestaurants();
  Future<List<Restaurant>> getRestaurantsByCategory(String category);
  Future<List<Restaurant>> getRestaurantsByAddressAndName({
    String? address,
    String? name,
  });
  Future<Restaurant> getRestaurantById(int id);
  Future<List<MenuItem>> getRestaurantMenu(int restaurantId);
  Future<List<MenuItem>> getRestaurantMenuSortedByPrice(
      int restaurantId, String order);
}

/// Implementation using Dio
class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final Dio dio;
  static const String baseUrl = ApiConstants.baseUrl;

  RestaurantRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Restaurant>> getAllRestaurants() async {
    final response = await dio.get(baseUrl);
    return (response.data as List)
        .map((json) => Restaurant.fromJson(json))
        .toList();
  }

  @override
  Future<List<Restaurant>> getRestaurantsByCategory(String category) async {
    final response = await dio.get(baseUrl, queryParameters: {
      "category": category,
    });
    return (response.data as List)
        .map((json) => Restaurant.fromJson(json))
        .toList();
  }

  @override
  Future<List<Restaurant>> getRestaurantsByAddressAndName({
    String? address,
    String? name,
  }) async {
    final response = await dio.get(baseUrl, queryParameters: {
      if (address != null) "address": address,
      if (name != null) "name": name,
    });
    return (response.data as List)
        .map((json) => Restaurant.fromJson(json))
        .toList();
  }

  @override
  Future<Restaurant> getRestaurantById(int id) async {
    final response = await dio.get("$baseUrl/$id");
    return Restaurant.fromJson(response.data);
  }

  @override
  Future<List<MenuItem>> getRestaurantMenu(int restaurantId) async {
    final response = await dio.get("$baseUrl/$restaurantId/menu");
    return (response.data as List)
        .map((json) => MenuItem.fromJson(json))
        .toList();
  }

  @override
  Future<List<MenuItem>> getRestaurantMenuSortedByPrice(
      int restaurantId, String order) async {
    final response = await dio.get(
      "$baseUrl/$restaurantId/menu",
      queryParameters: {"sortbyprice": order}, // asc or desc
    );
    return (response.data as List)
        .map((json) => MenuItem.fromJson(json))
        .toList();
  }
}
