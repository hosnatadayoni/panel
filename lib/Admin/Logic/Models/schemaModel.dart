import 'package:hive/hive.dart';

part 'schemaModel.g.dart';

@HiveType(typeId: 7) // حتماً یکتا باشه
class SchemaModel extends HiveObject {

  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? title;

  @HiveField(3)
  String? view;

  @HiveField(4)
  bool? mainMenu;

  @HiveField(5)
  bool? online;

  @HiveField(6)
  int countShowRow;

  @HiveField(7)
  int currentPage;

  @HiveField(8)
  String? tooltip;

  @HiveField(9)
  String? parentTable;

  @HiveField(10)
  String? parentId;

  @HiveField(11)
  List<dynamic>? relations;

  @HiveField(12)
  List<dynamic>? filters;

  @HiveField(13)
  double version;

  SchemaModel({
    this.id,
    this.name,
    this.title,
    this.view,
    this.mainMenu,
    this.online,
    this.parentId,
    this.parentTable,
    this.countShowRow = 10,
    this.currentPage = 1,
    this.tooltip,
    this.relations,
    this.filters,
    this.version=1.0
  });

  factory SchemaModel.fromJson(Map<String, dynamic> json) {
    return SchemaModel(
      id: json['_id'],
      name: json['name'],
      title: json['title'],
      view: json['view'],
      parentId: json['parent_id'],
      parentTable: json['parent_table'],
      mainMenu: json['main_menu'] ?? false,
      online: json['online'] ?? false,
      countShowRow: json['countShowRow'] ?? 10,
      currentPage: json['currentPage'] ?? 1,
      version: (json['version']?.toDouble() ?? 1.0),
      tooltip: json['tooltip'] ?? '',
      relations: json['relations'] ?? [],
      filters: json['filters'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'title': title,
      'view': view,
      'parent_id': parentId,
      'parent_table': parentTable,
      'main_menu': mainMenu,
      'online': online,
      'countShowRow': countShowRow,
      'currentPage': currentPage,
      'tooltip': tooltip,
      'relations': relations,
      'filters': filters,
      'version': version,
    };
  }
}
