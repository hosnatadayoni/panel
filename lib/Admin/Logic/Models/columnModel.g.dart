
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'columnModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColumnModelAdapter extends TypeAdapter<ColumnModel> {
  @override
  final int typeId = 8;

  @override
  ColumnModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColumnModel(
      id: fields[0] as String?,
      myTable: fields[1] as String?,
      name: fields[2] as String,
      title: fields[3] as String,
      type: fields[4] as String,
      typeField: fields[5] as String,
      defaultValue: fields[6] as dynamic,
      isPictureSelected: fields[7] as dynamic,
      format: fields[8] as dynamic,
      isShowEdit: fields[9] as bool?,
      isShowStore: fields[10] as bool?,
      isShowTable: fields[11] as bool?,
      isShowExcel: fields[12] as bool?,
      sourceItems: fields[13] as String?,
      sourceTable: fields[14] as String?,
      validators: (fields[15] as List).cast<dynamic>(),
      items: (fields[16] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ColumnModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.myTable)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.typeField)
      ..writeByte(6)
      ..write(obj.defaultValue)
      ..writeByte(7)
      ..write(obj.isPictureSelected)
      ..writeByte(8)
      ..write(obj.format)
      ..writeByte(9)
      ..write(obj.isShowEdit)
      ..writeByte(10)
      ..write(obj.isShowStore)
      ..writeByte(11)
      ..write(obj.isShowTable)
      ..writeByte(12)
      ..write(obj.isShowExcel)
      ..writeByte(13)
      ..write(obj.sourceItems)
      ..writeByte(14)
      ..write(obj.sourceTable)
      ..writeByte(15)
      ..write(obj.validators)
      ..writeByte(16)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ColumnModelAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
