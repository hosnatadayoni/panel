import 'dart:convert';

import 'package:hive/hive.dart';
part'dataModel.g.dart';

// @HiveType(typeId: 0)
// class Customer {
//
//   @HiveField(0)
//   String? id;
//
//   @HiveField(1)
//   String? userName;
//
//   @HiveField(2)
//   int? mobile;
//
//   @HiveField(3)
//   int? PurchaseCeiling;
//
//
//   Customer({this.id , this.userName , this.mobile ,  this.PurchaseCeiling});
//
//   Customer.fromJson(Map<String, dynamic> json){
//     id = json['id'];
//     userName = json['userName'];
//     mobile = json['mobile'];
//     PurchaseCeiling = json['PurchaseCeiling'];
//   }
//
//
//   Map<String, dynamic> toJson()  {
//     final Map<String, dynamic> data =  <String, dynamic>{};
//     data['id'] = id;
//     data['userName']= userName;
//     data['mobile']= mobile;
//     data['PurchaseCeiling']= PurchaseCeiling;
//     return data;
//   }
// }
@HiveType(typeId: 5)
class DataModel {

  @HiveField(0)
  String? id;

  @HiveField(1)
  Map<String , dynamic> data;


  DataModel({required this.id , required this.data});

  factory DataModel.fromJson(Map<String, dynamic> json){

    return DataModel(
      id : json['id'],
      data : json['data'],
    );

  }


  Map<String, dynamic> toJson()  {
    return {
      'id':id,
      'data':data,

    };
  }
}