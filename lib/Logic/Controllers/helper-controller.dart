import 'package:finance/Logic/Models/db.dart';
import 'package:finance/Logic/Models/order-item.dart';
import 'package:finance/UI/Componenets/page-custom/FormCustom/form-create-orderItem-custom.dart';
import 'package:finance/UI/Componenets/page-custom/FormCustom/form-edit-order-custom.dart';
import 'package:finance/UI/Componenets/page-custom/FormCustom/form-edit-orderItem-custom.dart';
import 'package:finance/UI/Componenets/page-custom/orderItem/oredre-item-create.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finance/Logic/Controllers/validator-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/UI/Componenets/Popups/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../UI/Componenets/page-custom/TableCustom/table-custom-page.dart';
import '../../UI/Componenets/page-custom/order/order-create.dart';
import '../../UI/Componenets/page-custom/order/order-edit.dart';
import '../../UI/Componenets/page-custom/orderItem/oredre-item-edit.dart';
import '../../UI/Views/table-page.dart';
import '../Models/dataModel.dart';
import 'app-controller.dart';
import 'dataController.dart';
import 'main-controller.dart';
import 'package:finance/boxes.dart';

class HelperController extends GetxController {
  //store
  static beforeStore(DataModel newData) {
    return AppController.responceHelper(newData, true);
  }

  static beforeStoreValidation(DataModel newData) {
    return AppController.responceHelper(newData, true);
  }

  static afterStore(String tableName, dataJson, DataModel customData) async {
    if (tableName == 'order') {
      print(' OrderItem.orderItemsList>>>${OrderItem.orderItemsList.length}');
      print(' customData.id>>>${customData.id}');
      if (OrderItem.orderItemsList.length != 0) {
        for (var key in OrderItem.orderItemsList.keys) {
          OrderItem.orderItemsList[key] = {...OrderItem.orderItemsList[key]!, 'سفارش': customData.id};
        }
        for (var list in OrderItem.orderItemsList.values) {
          // list[list.]={'سفارش':customData.id};
          print('list.values>>>${list.values}');
          print('list.values1>>>${list}');
          print('list.values2>>>${list.values.first}');
          await DB('order-items').storeRecord(list);
        }
      }
    }
    return AppController.responceHelper(customData, true);
  }
  //end store

  //update
  static beforeUpdate(DataModel newData) {
    return AppController.responceHelper(newData, true);
  }

  static beforeUpdateValidation(DataModel newData) {
    return AppController.responceHelper(newData, true);
  }

  static afterUpdate(dataJson, DataModel customData) {
    return AppController.responceHelper(customData, true);
  }
  //end update

  //delete
  static beforeDelete(int index) {
    return AppController.responceHelper(null, true);
  }

  static afterDelete(int index, DataModel data) {
    return AppController.responceHelper(data, true);
  }
//end delete

  static createPageFunction() async {
    if(MainController.SubMenuList[MainController.selectedSubItem.value]['table-name']=='order'){
      await Get.to(() => OrderCreatePage());
    }
    if(MainController.SubMenuList[MainController.selectedSubItem.value]['table-name']=='order-items'){
      await Get.to(() => OrderItemCreatePage());
    }
  }

  static tablePageFunction() async {
    if(MainController.SubMenuList[MainController.selectedSubItem.value]['table-name']=='order-items'){
      await Get.to(() => TableCustomPage());
    }
    else
    Get.to(() => TablePage());
  }

  static editPageFunction(DataModel data, int index) async {
    if(MainController.SubMenuList[MainController.selectedSubItem.value]['table-name']=='order'){
      await Get.to(() => OrderEdit(data: data,index: index));
    }
    if(MainController.SubMenuList[MainController.selectedSubItem.value]['table-name']=='order-items'){
      await Get.to(() => OrderItemEdit(data:data,index: index));
    }
  }

}
