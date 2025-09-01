class MenuItem {
  final int itemID;
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final String restaurantName;
  final int restaurantID;
  final String imageUrl;

  MenuItem({
    required this.itemID,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.restaurantName,
    required this.restaurantID,
    required this.imageUrl,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      itemID: json['itemID'] as int,
      itemName: json['itemName'] as String,
      itemDescription: json['itemDescription'] as String,
      itemPrice: (json['itemPrice'] as num).toDouble(),
      restaurantName: json['restaurantName'] as String,
      restaurantID: json['restaurantID'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "itemID": itemID,
        "itemName": itemName,
        "itemDescription": itemDescription,
        "itemPrice": itemPrice,
        "restaurantName": restaurantName,
        "restaurantID": restaurantID,
        "imageUrl": imageUrl,
      };
}
