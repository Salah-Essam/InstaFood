
import 'package:insta_food/core/network/APIs/api_constants.dart';
import 'package:insta_food/core/network/APIs/api_service.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

abstract class MenuRemoteSource {
  Future<List<ItemModel>> fetchMenu(int restaurantId, {String? sortByPrice});
}

class MenuRemoteSourceImpl implements MenuRemoteSource {
  final ApiService apiService;
  MenuRemoteSourceImpl({required this.apiService});

  @override
  Future<List<ItemModel>> fetchMenu(int restaurantId, {String? sortByPrice}) async {
    final path = sortByPrice != null && sortByPrice.isNotEmpty
        ? "${ApiConstants.restaurant}/$restaurantId/menu?sortbyprice=$sortByPrice"
        : "${ApiConstants.restaurant}/$restaurantId/menu";
    final response = await apiService.get(path: path);
    final List<dynamic> jsonList = response.data as List<dynamic>;
    return jsonList.map((json) => ItemModel.fromJson(json)).toList();
  }
}
