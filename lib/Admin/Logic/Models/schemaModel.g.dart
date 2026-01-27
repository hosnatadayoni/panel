// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemaModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchemaModelAdapter extends TypeAdapter<SchemaModel> {
  @override
  final int typeId = 7;

  @override
  SchemaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchemaModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      title: fields[2] as String?,
      view: fields[3] as String?,
      mainMenu: fields[4] as bool?,
      online: fields[5] as bool?,
      parentId: fields[10] as String?,
      parentTable: fields[9] as String?,
      countShowRow: fields[6] as int,
      currentPage: fields[7] as int,
      tooltip: fields[8] as String?,
      relations: (fields[11] as List?)?.cast<dynamic>(),
      filters: (fields[12] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, SchemaModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.view)
      ..writeByte(4)
      ..write(obj.mainMenu)
      ..writeByte(5)
      ..write(obj.online)
      ..writeByte(6)
      ..write(obj.countShowRow)
      ..writeByte(7)
      ..write(obj.currentPage)
      ..writeByte(8)
      ..write(obj.tooltip)
      ..writeByte(9)
      ..write(obj.parentTable)
      ..writeByte(10)
      ..write(obj.parentId)
      ..writeByte(11)
      ..write(obj.relations)
      ..writeByte(12)
      ..write(obj.filters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchemaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
