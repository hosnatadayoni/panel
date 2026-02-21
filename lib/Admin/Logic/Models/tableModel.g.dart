// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tableModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TableModelAdapter extends TypeAdapter<TableModel> {
  @override
  final int typeId = 9;

  @override
  TableModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TableModel(
      schema: fields[0] as SchemaModel,
      columns: (fields[1] as List).cast<ColumnModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, TableModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.schema)
      ..writeByte(1)
      ..write(obj.columns);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TableModelAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}