import 'package:insta_food/core/remote/api_keys.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'item_model.g.dart';

@HiveType(typeId: 0)
class ItemModel {
  @HiveField(0)
  final int itemID;
  @HiveField(1)
  final String itemName;
  @HiveField(2)
  final String? itemDescription;
  @HiveField(3)
  final double itemPrice;
  @HiveField(4)
  final String restaurantName;
  @HiveField(5)
  final String imageUrl;
  @HiveField(6)
  final int restaurantID;
  ItemModel({
    required this.itemID,
    required this.restaurantID,
    required this.imageUrl,
    required this.itemPrice,
    required this.itemName,
    this.itemDescription,
    required this.restaurantName,
  });
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      itemID: json[ApiKeys.itemID],
      itemName: json[ApiKeys.itemName],
      itemDescription: json[ApiKeys.itemDescription],
      itemPrice: json[ApiKeys.itemPrice],
      restaurantName: json[ApiKeys.restaurantName],
      restaurantID: json[ApiKeys.restaurantID],
      imageUrl: json[ApiKeys.imageUrl],
    );
  }
}
