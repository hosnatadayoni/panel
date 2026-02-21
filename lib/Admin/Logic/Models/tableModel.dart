
import 'package:hive/hive.dart';

import 'schemaModel.dart';
import 'columnModel.dart';

part 'tableModel.g.dart';

@HiveType(typeId: 9) // یکتا باشه
class TableModel extends HiveObject {

  @HiveField(0)
   SchemaModel schema;

  @HiveField(1)
   List<ColumnModel> columns;

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
