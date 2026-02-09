class TableModel {
  final SchemaModel schema;
  final List<ColumnModel> columns;

  TableModel({
    required this.schema,
    required this.columns,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      schema: SchemaModel.fromJson(json['schema']),
      columns: (json['columns'] as List)
          .map((e) => ColumnModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schema': schema.toJson(),
      'columns': columns.map((e) => e.toJson()).toList(),
    };
  }
}
class SchemaModel {
   String? id;
   String? name;
   String? title;
  String? view;
   bool? mainMenu;
   bool? online;
  int countShowRow=10;
   int currentPage=1;
   String? tooltip;
   String? parentTable;
   String? parentId;
  List<dynamic>? relations;
   List<dynamic>? filters;

  SchemaModel({
     this.id,
     this.name,
     this.title,
    this.view,
     this.mainMenu,
     this.online,
    this.parentId,
    this.parentTable,
     this.countShowRow=10,
     this.currentPage=1,
     this.tooltip,
     this.relations,
     this.filters,
  });

  factory SchemaModel.fromJson(Map<String, dynamic> json) {
    return SchemaModel(
      id: json['_id'],
      name: json['name'],
      title: json['title'],
      view: json['view'],
      parentId: json['parent_id']??null,
      parentTable: json['parent_table']??null,
      mainMenu: json['main_menu'] ?? false,
      online: json['online'] ?? false,
      countShowRow: json['countShowRow'] ?? 1,
      currentPage: json['currentPage'] ?? 10,
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
      'main_menu': mainMenu,
      'online': online,
      'countShowRow': countShowRow,
      'currentPage': currentPage,
      'tooltip': tooltip,
      'relations': relations,
      'filters': filters,
    };
  }
}
class ColumnModel {
  final String? id;
  final String? myTable;
  final String name;
  final String title;
  final String type;
  final String typeField;
   bool? isShowEdit;
   bool? isShowStore;
   bool? isShowTable;
   bool? isShowExcel;
  final String? sourceItems;
  final String? sourceTable;
  final List<dynamic> validators;
  final List<dynamic> items;

  ColumnModel({
    this.id,
    this.myTable,
    required this.name,
    required this.title,
    required this.type,
    this.typeField = '',
    this.isShowEdit ,
    this.isShowStore,
    this.isShowTable ,
    this.isShowExcel ,
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
      typeField: json['type_field'],
      isShowEdit: json['is_show_edit'] ,
      isShowStore: json['is_show_store'] ,
      isShowTable: json['is_show_table'] ,
      sourceItems: json['source_items'] ,
      sourceTable: json['source_table'].length!=0?json['source_table']['name']:null ,
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
      'is_show_edit': isShowEdit,
      'is_show_store': isShowStore,
      'is_show_table': isShowTable,
      'source_items': sourceItems,
      'source_table': sourceTable,
      'validators': validators,
      'items': items,
    };
  }
}
