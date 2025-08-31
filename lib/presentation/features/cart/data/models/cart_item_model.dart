import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/items/data/model/item_size.dart';

class CartItemModel extends Equatable {
  final String cartItemId; // {itemId}_{variantHash}
  final int itemId;
  final String itemName;
  final String imageUrl;
  final int restaurantId;
  final String restaurantName;
  final double unitPrice; // snapshot price at add time (base + size mods)
  final int quantity;
  final Map<String, dynamic> options; // {size: ..., extras: ...}
  final DateTime? addedAt;
  final DateTime? updatedAt;

  const CartItemModel({
    required this.cartItemId,
    required this.itemId,
    required this.itemName,
    required this.imageUrl,
    required this.restaurantId,
    required this.restaurantName,
    required this.unitPrice,
    required this.quantity,
    required this.options,
    this.addedAt,
    this.updatedAt,
  });

  double get totalPrice => unitPrice * quantity;

  factory CartItemModel.fromFirestore(Map<String, dynamic> map) {
    return CartItemModel(
      cartItemId: map['cartItemId'] as String,
      itemId: (map['itemId'] as num).toInt(),
      itemName: map['itemName'] as String,
      imageUrl: map['imageUrl'] as String,
      restaurantId: (map['restaurantId'] as num).toInt(),
      restaurantName: map['restaurantName'] as String,
      unitPrice: (map['unitPrice'] as num).toDouble(),
      quantity: (map['quantity'] as num).toInt(),
      options: Map<String, dynamic>.from(map['options'] as Map? ?? {}),
      addedAt: (map['addedAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'cartItemId': cartItemId,
        'itemId': itemId,
        'itemName': itemName,
        'imageUrl': imageUrl,
        'restaurantId': restaurantId,
        'restaurantName': restaurantName,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'options': options,
        'addedAt': addedAt,
        'updatedAt': updatedAt,
      }..removeWhere((k, v) => v == null);

  static String buildCartItemId({required int itemId, required ItemSize size}) {
    final variantHash = 'size_${size.name}';
    return '${itemId}_$variantHash';
  }

  factory CartItemModel.fromItem({
    required ItemModel item,
    required ItemSize size,
    required int quantity,
  }) {
    final id = buildCartItemId(itemId: item.itemID, size: size);
    final price = item.itemPrice + size.priceModifier;
    return CartItemModel(
      cartItemId: id,
      itemId: item.itemID,
      itemName: item.itemName,
      imageUrl: item.imageUrl,
      restaurantId: item.restaurantID,
      restaurantName: item.restaurantName,
      unitPrice: price,
      quantity: quantity,
      options: {
        'size': size.name,
      },
    );
  }

  CartItemModel copyWith({int? quantity}) => CartItemModel(
        cartItemId: cartItemId,
        itemId: itemId,
        itemName: itemName,
        imageUrl: imageUrl,
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        unitPrice: unitPrice,
        quantity: quantity ?? this.quantity,
        options: options,
        addedAt: addedAt,
        updatedAt: updatedAt,
      );

  @override
  List<Object?> get props => [cartItemId, quantity, unitPrice];
}
