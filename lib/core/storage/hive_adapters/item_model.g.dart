// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../presentation/features/items/data/model/item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemModelAdapter extends TypeAdapter<ItemModel> {
  @override
  final int typeId = 0;

  @override
  ItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemModel(
      itemID: fields[0] as int,
      restaurantID: fields[6] as int,
      imageUrl: fields[5] as String,
      itemPrice: fields[3] as double,
      itemName: fields[1] as String,
      itemDescription: fields[2] as String?,
      restaurantName: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ItemModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.itemID)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.itemDescription)
      ..writeByte(3)
      ..write(obj.itemPrice)
      ..writeByte(4)
      ..write(obj.restaurantName)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.restaurantID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
