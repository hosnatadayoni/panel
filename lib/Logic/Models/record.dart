import 'package:finance/Logic/Models/db.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../Controllers/main-controller.dart';
import 'dataModel.dart';

class Records{
  static getRecords(String tableName,
      {bool condition=false, String? fieldName, String? oprator, var value}) async {
    var lo=DB('dd').where('','','').where(fieldName, oprator, value).where(fieldName, oprator, value);
    print('lo>>>${lo.list?.length}');
    Box box;
    List<dynamic>dataItems=[];
    int index=MainController.SubMenuList.indexWhere((element) => element['table-name']=='$tableName');
    var tableInfo = MainController.SubMenuList[index];
    box = await Hive.openBox<DataModel>('${tableInfo['table-name']}');
    List<dynamic>data=box.values.toList();
    for(var d in data){
      print('data items>>${d.data}');
      print('data items>>${d.data['y']=='456'}');
     // dataItems.add(d.data);
     if(condition){
       if(oprator=='=='){
         if(d.data['$fieldName']==value){
           dataItems.add(d.data);
           print('data items>>${d.data}');

         }

       }
     }
    }
    print('data items>>${dataItems.length}');
    // return dataItems;
  }
}