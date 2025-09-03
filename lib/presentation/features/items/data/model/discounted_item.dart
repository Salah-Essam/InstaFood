import 'dart:math';

import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

class DiscountedItem extends ItemModel {
  final int discountPercentage;
  final double discountedPrice;

  DiscountedItem._({
    required int itemID,
    required int restaurantID,
    required String imageUrl,
    required double itemPrice,
    required String itemName,
    String? itemDescription,
    required String restaurantName,
    required this.discountPercentage,
    required this.discountedPrice,
  }) : super(
         itemID: itemID,
         restaurantID: restaurantID,
         imageUrl: imageUrl,
         itemPrice: itemPrice,
         itemName: itemName,
         itemDescription: itemDescription,
         restaurantName: restaurantName,
       );
  static int _generateRandomDiscount([double min = 10.0, double max = 70.0]) {
    final random = Random();
    // Generate multiples of 5 within the range
    final minMultiple = (min / 5).ceil() * 5;
    final maxMultiple = (max / 5).floor() * 5;

    // Calculate how many steps of 5 we have
    final steps = ((maxMultiple - minMultiple) / 5).toInt() + 1;

    // Randomly select a multiple of 5
    return minMultiple + (random.nextInt(steps) * 5).toInt();
  }

  static double _calculateDiscountedPrice(
    double originalPrice,
    int discountPercentage,
  ) {
    return originalPrice * (1 - discountPercentage / 100);
  }

  factory DiscountedItem({
    required int itemID,
    required int restaurantID,
    required String imageUrl,
    required double itemPrice,
    required String itemName,
    String? itemDescription,
    required String restaurantName,
    double minDiscount = 10.0,
    double maxDiscount = 50.0,
  }) {
    final discountPercentage = _generateRandomDiscount(
      minDiscount,
      maxDiscount,
    );
    final discountedPrice = _calculateDiscountedPrice(
      itemPrice,
      discountPercentage,
    );

    return DiscountedItem._(
      itemID: itemID,
      restaurantID: restaurantID,
      imageUrl: imageUrl,
      itemPrice: itemPrice,
      itemName: itemName,
      itemDescription: itemDescription,
      restaurantName: restaurantName,
      discountPercentage: discountPercentage,
      discountedPrice: discountedPrice,
    );
  }
}
