import 'package:hive_flutter/hive_flutter.dart';

part 'restaurant_model.g.dart';

@HiveType(typeId: 1)  
class Restaurant {
  @HiveField(0)
  final int restaurantID;
  @HiveField(1)
  final String restaurantName;
  @HiveField(2)
  final String address;
  @HiveField(3)
  final String type;
  @HiveField(4)
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
