import 'package:dio/dio.dart';
import 'package:insta_food/core/errors/failures.dart';
import 'package:insta_food/core/remote/api_service.dart';
import 'package:insta_food/core/remote/constant/api_constants.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

abstract class ItemsRemoteDataSource {
  Future<dynamic> fetchItems();
  Future<dynamic> itemSearch(String name);
}

class ItemsRemoteDataSourceImpl implements ItemsRemoteDataSource {
  final ApiService apiService;
  ItemsRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<ItemModel>> fetchItems() async {
    try {
      final response = await apiService.get(path: ApiConstants.items);
      final List<dynamic> jsonList = response.data as List<dynamic>;
      return jsonList.map((json) => ItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Server error');
    }
  }

  @override
  Future<List<ItemModel>> itemSearch(String name) async {
    try {
      final response = await apiService.get(
        path: ApiConstants.itemsearch + name,
      );
      final List<dynamic> jsonList = response.data as List<dynamic>;
      return jsonList.map((json) => ItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Server error');
    }
  }
}
