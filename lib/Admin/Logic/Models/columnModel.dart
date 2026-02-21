import 'package:hive/hive.dart';

part 'columnModel.g.dart';

@HiveType(typeId: 8) // typeId یکتا باشه
class ColumnModel extends HiveObject {

  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? myTable;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final String typeField;

  @HiveField(6)
  dynamic defaultValue;

  @HiveField(7)
  dynamic isPictureSelected;

  @HiveField(8)
  dynamic format;

  @HiveField(9)
  bool? isShowEdit;

  @HiveField(10)
  bool? isShowStore;

  @HiveField(11)
  bool? isShowTable;

  @HiveField(12)
  bool? isShowExcel;

  @HiveField(13)
  final String? sourceItems;

  @HiveField(14)
  final String? sourceTable;

  @HiveField(15)
  final List<dynamic> validators;

  @HiveField(16)
  final List<dynamic> items;

  ColumnModel({
    this.id,
    this.myTable,
    required this.name,
    required this.title,
    required this.type,
    this.typeField = '',
    this.defaultValue,
    this.isPictureSelected,
    this.format,
    this.isShowEdit,
    this.isShowStore,
    this.isShowTable,
    this.isShowExcel,
    this.sourceItems,
    this.sourceTable,
    this.validators = const [],
    this.items = const [],
  });

  factory ColumnModel.fromJson(Map<String, dynamic> json) {
    return ColumnModel(
      id: json['_id'],
      myTable: json['my_table'],
      name: json['name'],
      title: json['title'],
      type: json['type'],
      defaultValue: json['default_value'],
      typeField: json['type_field'] ?? '',
      isShowEdit: json['is_show_edit'],
      isShowStore: json['is_show_store'],
      isShowTable: json['is_show_table'],
      isShowExcel: json['is_show_excel'],
      sourceItems: json['source_items'],
      sourceTable: json['source_table'] != null &&
          json['source_table'].length != 0
          ? json['source_table']['name']
          : null,
      validators: json['validators'] ?? [],
      items: json['items'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'my_table': myTable,
      'name': name,
      'title': title,
      'type': type,
      'type_field': typeField,
      'default_value': defaultValue,
      'is_show_edit': isShowEdit,
      'is_show_store': isShowStore,
      'is_show_table': isShowTable,
      'is_show_excel': isShowExcel,
      'source_items': sourceItems,
      'source_table': sourceTable,
      'validators': validators,
      'items': items,
    };
  }
}