import 'package:finance/Logic/Models/db.dart';
import 'package:finance/UI/Componenets/Popups/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../Controllers/main-controller.dart';
import 'dataModel.dart';

class Records{
  static getRecords(String tableName,
      {bool condition=false, String? fieldName, String? oprator, var value}) async {
    var lo=DB('category').where('y','!=',456).where('y','>=',400).getRecords();
    // var t=MainController.getTypeOfField('category','y');
    // print('typeis>>$t');
  }

}