import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

class BestSellerItem extends ItemModel {
  final String? category;

  BestSellerItem({
    required super.itemID,
    required super.restaurantID,
    required super.imageUrl,
    required super.itemPrice,
    required super.itemName,
    super.itemDescription,
    required super.restaurantName,
    this.category,
  });
  factory BestSellerItem.fromQuerySnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    {
      final data = doc.data();
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
