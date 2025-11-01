// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishlistProductAdapter extends TypeAdapter<WishlistProduct> {
  @override
  final int typeId = 1;

  @override
  WishlistProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistProduct(
      id: fields[0] as int,
      name: fields[1] as String,
      price: fields[2] as double,
      image: fields[3] as String,
      userId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WishlistProduct obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
