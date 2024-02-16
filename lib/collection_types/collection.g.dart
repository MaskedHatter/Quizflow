// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollectionTypesAdapter extends TypeAdapter<CollectionTypes> {
  @override
  final int typeId = 4;

  @override
  CollectionTypes read(BinaryReader reader) {
    return CollectionTypes();
  }

  @override
  void write(BinaryWriter writer, CollectionTypes obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionTypesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
