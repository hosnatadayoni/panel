import 'package:hive/hive.dart';
part'package:finance/Admin/Logic/Models/dataModel.g.dart';

@HiveType(typeId: 5)
class DataModel {

  @HiveField(0)
  String? id;

  @HiveField(1)
  Map<dynamic , dynamic> data;


  DataModel({this.id , required this.data});

  factory DataModel.fromJson(Map<String, dynamic> json){
    return DataModel(
      id : json['id'],
      data: json['data']
    );
  }


  Map<String, dynamic> toJson()  {
    return {
      '_id':id,
      'data':data,

    };
  }
}
