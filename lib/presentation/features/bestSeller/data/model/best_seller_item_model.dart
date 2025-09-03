import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:insta_food/presentation/features/filter/data/enum/catagories_enum.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

class BestSellerItem extends ItemModel {
  final String? category;

  BestSellerItem({
    required int itemID,
    required int restaurantID,
    required String imageUrl,
    required double itemPrice,
    required String itemName,
    String? itemDescription,
    required String restaurantName,
    this.category,
  }) : super(
         itemID: itemID,
         restaurantID: restaurantID,
         imageUrl: imageUrl,
         itemPrice: itemPrice,
         itemName: itemName,
         itemDescription: itemDescription,
         restaurantName: restaurantName,
       );
  factory BestSellerItem.fromQuerySnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    {
      final data = doc.data()!;
      return BestSellerItem(
        itemID: int.parse(doc.id),
        itemName: data['name'] ?? '',
        itemDescription: data['description'] ?? '',
        itemPrice: (data['price'] ?? 0.0).toDouble(),
        restaurantName: data['resturant Name'] ?? '',
        category: data['category'],
        imageUrl: data['imageUrl'] ?? '',
        restaurantID: 0,
      );
    }
  }
}
