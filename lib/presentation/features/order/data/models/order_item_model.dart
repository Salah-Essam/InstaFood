class OrderItemModel {
  final String itemId;
  final String itemName;
  final String imageUrl;
  final String restaurantId;
  final String restaurantName;
  final double unitPrice;
  final int quantity;

  const OrderItemModel({
    required this.itemId,
    required this.itemName,
    required this.imageUrl,
    required this.restaurantId,
    required this.restaurantName,
    required this.unitPrice,
    required this.quantity,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      itemId: (map['itemId'] ?? '').toString(),
      itemName: (map['itemName'] ?? '').toString(),
      imageUrl: (map['imageUrl'] ?? '').toString(),
      restaurantId: (map['restaurantId'] ?? '').toString(),
      restaurantName: (map['restaurantName'] ?? '').toString(),
      unitPrice: (map['unitPrice'] is num) ? (map['unitPrice'] as num).toDouble() : 0.0,
      quantity: (map['quantity'] is int) ? map['quantity'] as int : int.tryParse(map['quantity']?.toString() ?? '0') ?? 0,
    );
  }
}
