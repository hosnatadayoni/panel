import 'package:finance/Logic/Models/db.dart';
import 'package:finance/Logic/Models/order-item.dart';
import 'package:finance/UI/Componenets/page-custom/orderItem/order-item-create.dart';
import 'package:finance/UI/Views/edit.dart';
import 'package:get/get.dart';
import '../../UI/Componenets/page-custom/order/order-create.dart';
import '../../UI/Componenets/page-custom/order/order-edit.dart';
import '../../UI/Componenets/page-custom/orderItem/order-item-edit.dart';
import '../../UI/Views/table-page.dart';
import '../Models/dataModel.dart';
import 'app-controller.dart';
import 'main-controller.dart';

class HelperController extends GetxController {
  //store
  static beforeStore(DataModel newData) {
    print('new data5>>${newData.data}');
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
        // for (var key in OrderItem.orderItemsList.keys) {
        //   OrderItem.orderItemsList[key] = {...OrderItem.orderItemsList[key]!, 'سفارش': customData.id};
        // }
        for (var list in OrderItem.orderItemsList.values) {
          print('list.values>>>${list.values}');
          print('list.values1>>>${list}');
          print('list.values2>>>${list.values.first}');
          await DB('order-itemss').parent(parentTable: 'order',parentId: customData.id!).storeRecord(list);
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
    OrderItem.orderItemsList = {};
    if(MainController.SubMenuList[MainController.selectedSubItem.value]['table-name']=='order'){
      await Get.to(() => OrderCreatePage());
    }
    if(MainController.SubMenuList[MainController.selectedSubItem.value]['table-name']=='order-itemss'){
      await Get.to(() => OrderItemCreatePage());
    }
  }

  static tablePageFunction() async {
    // if(MainController.SubMenuList[MainController.selectedSubItem.value]['table-name']=='order-items'){
    //   await Get.to(() => TablePage());
    // }
    // else
    Get.to(() => TablePage());
  }

  static editPageFunction(var data) async {
    OrderItem.orderItemsList = {};
    if(MainController.SubMenuList[MainController.selectedSubItem.value]['table-name']=='order'){
      await Get.to(() => OrderEdit(data: data));
    }
    else{

      await Get.to(() => EditPage(data: data));
    }
  }

}
