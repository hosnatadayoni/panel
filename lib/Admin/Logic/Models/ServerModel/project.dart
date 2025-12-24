class Schema {
  String? name;
  String? id;
  Schema.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
  }
}
class Field{
  String? id;
  String? name;
  String? title;
  String? type;
  String? typeField;
  String? sourceItem;
  String? sourceTable;
  String? parentSlug;
  String? parentId;
  List<String>items=['title'];
  List<dynamic>filters=[];
  Field.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    title = json['title'];
    type = json['type'];
    typeField = json['type_field'];
    sourceItem = json['source_items'];
    sourceTable = json['source_table'];
    items = json['items'];
    filters = json['filters'];
  }
}
