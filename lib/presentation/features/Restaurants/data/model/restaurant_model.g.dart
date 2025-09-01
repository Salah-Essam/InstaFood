// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantAdapter extends TypeAdapter<Restaurant> {
  @override
  final int typeId = 1;

  @override
  Restaurant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Restaurant(
      restaurantID: fields[0] as int,
      restaurantName: fields[1] as String,
      address: fields[2] as String,
      type: fields[3] as String,
      parkingLot: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Restaurant obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.restaurantID)
      ..writeByte(1)
      ..write(obj.restaurantName)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.parkingLot);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
