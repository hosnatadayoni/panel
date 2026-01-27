import 'package:finance/Admin/Logic/Models/tableModel.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part'projectModel.g.dart';

@HiveType(typeId: 6)
class ProjectModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  List<TableModel> tables;

  ProjectModel({required this.id, required this.tables});
}