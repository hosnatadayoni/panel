import 'package:finance/Logic/Models/db.dart';
import 'package:finance/Logic/Models/order-item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finance/Logic/Controllers/validator-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/UI/Componenets/Popups/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../UI/Views/table-page.dart';
import '../Models/dataModel.dart';
import 'app-controller.dart';
import 'dataController.dart';
import 'main-controller.dart';
import 'package:finance/boxes.dart';

class HelperController extends GetxController {
  //store
  static beforeStore(DataModel newData){
    return AppController.responceHelper(newData,true);
  }
  static beforeStoreValidation(DataModel newData){
    return AppController.responceHelper(newData,true);
  }
  static afterStore(dataJson,DataModel customData) async {
    if(MainController.tableInfo['table-name'] == 'order'){
     for(var list in OrderItem.orderItemsList){
       print('list.values>>>${list.values}');

     }
     await DB('order-item').storeRecord(ViewController.request);

    }
    return AppController.responceHelper(customData,true);
  }
  //end store

  //update
  static beforeUpdate(DataModel newData){
    return AppController.responceHelper(newData,true);
  }
  static beforeUpdateValidation(DataModel newData){
    return AppController.responceHelper(newData,true);
  }
  static afterUpdate(dataJson,DataModel customData){
    return AppController.responceHelper(customData,true);
  }
  //end upfate

  //delete
  static beforeDelete(int index){
    return AppController.responceHelper(null,true);
  }

  static afterDelete(int index,DataModel data){
    return AppController.responceHelper(data,true);
  }
  //end delete


//get records

}