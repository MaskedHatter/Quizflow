// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FolderAdapter extends TypeAdapter<Folder> {
  @override
  final int typeId = 2;

  @override
  Folder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Folder(
      title: fields[0] as String,
      folderLevel: fields[1] as double,
      subItemsRaw: (fields[4] as List).cast<CollectionTypes>(),
      pathList: (fields[5] as List).cast<String>(),
      parent: fields[2] as Folder?,
      folderColor: (fields[7] as List?)?.cast<int>(),
      boxId: fields[9] as String?,
    )
      ..subItems = (fields[3] as HiveList?)?.castHiveList()
      ..isExpanded = fields[6] as bool
      ..i = fields[8] as int;
  }

  @override
  void write(BinaryWriter writer, Folder obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.folderLevel)
      ..writeByte(2)
      ..write(obj.parent)
      ..writeByte(3)
      ..write(obj.subItems)
      ..writeByte(4)
      ..write(obj.subItemsRaw)
      ..writeByte(5)
      ..write(obj.pathList)
      ..writeByte(6)
      ..write(obj.isExpanded)
      ..writeByte(7)
      ..write(obj.folderColor)
      ..writeByte(8)
      ..write(obj.i)
      ..writeByte(9)
      ..write(obj.boxId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
