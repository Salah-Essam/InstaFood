
class Restaurant {
  final int restaurantID;
  final String restaurantName;
  final String address;
  final String type;
  final bool parkingLot;

  Restaurant({
    required this.restaurantID,
    required this.restaurantName,
    required this.address,
    required this.type,
    required this.parkingLot,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      restaurantID: json['restaurantID'] as int,
      restaurantName: json['restaurantName'] as String,
      address: json['address'] as String,
      type: json['type'] as String,
      parkingLot: json['parkingLot'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        "restaurantID": restaurantID,
        "restaurantName": restaurantName,
        "address": address,
        "type": type,
        "parkingLot": parkingLot,
      };
}
