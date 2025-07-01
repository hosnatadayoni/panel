import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Logic/Models/order-item.dart';
import 'package:finance/Admin/UI/Componenets/page-custom/orderItem/order-item-create.dart';
import 'package:finance/Admin/UI/Views/edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../UI/Componenets/page-custom/order/order-create.dart';
import '../../UI/Componenets/page-custom/order/order-edit.dart';
import '../../UI/Views/table-page.dart';
import '../Models/dataModel.dart';
import 'app-controller.dart';
import 'main-controller.dart';

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
      if (OrderItem.orderItemsList.length != 0) {
        // for (var key in OrderItem.orderItemsList.keys) {
        //   OrderItem.orderItemsList[key] = {...OrderItem.orderItemsList[key]!, 'سفارش': customData.id};
        // }
        for (var list in OrderItem.orderItemsList.values) {
          await DB('order-itemss').parent(parentTable: 'order',parentId: customData.id!).storeRecord(list);
        }
      }
    }
    if(tableName=='itemsOrder'){
      // await DB('itemsOrder').parent(parentTable: 'order2',parentId: customData.id!).storeRecord(list);

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

      // ViewController.request=data;
      await Get.to(() => EditPage(data: data));
    }
  }

   static filterDate(String dataDate,String searchDate,String opration) {
      Jalali baseDate = convertJalaliStringToDate(searchDate);
      Jalali date = convertJalaliStringToDate(dataDate);
      if(opration=='>='){
        if(date.isAfter(baseDate))
        {
          return true;
        }else{
          return false;
        }
      }
      else if(opration=="<="){
      if(date.isBefore(baseDate))
        {
          return true;
        }else{
          return false;
        }
      }
      else if(opration=="=="){
        if(date==baseDate)
        {
          return true;
        }else{
          return false;
        }
      }
  }

   static filterTime(String dataTime,String searchTime,String opration) {
     final timeSearchParts = searchTime.split(':');
     final itemSearchTime = TimeOfDay(
       hour: int.parse(timeSearchParts[0]),
       minute: int.parse(timeSearchParts[1]),
     );
     final timeDataParts = dataTime.split(':');
     final itemDataTime = TimeOfDay(
       hour: int.parse(timeDataParts[0]),
       minute: int.parse(timeDataParts[1]),
     );

      if(opration=='>='){
        if(itemDataTime.hour>=itemSearchTime.hour && itemDataTime.minute>=itemSearchTime.minute)
        {
          return true;
        }else{
          return false;
        }
      }
      else if(opration=="<="){
      if(itemDataTime.hour<=itemSearchTime.hour && itemDataTime.minute<=itemSearchTime.minute)
        {
          return true;
        }else{
          return false;
        }
      }
      else if(opration=="=="){
        if(itemDataTime.hour == itemSearchTime.hour && itemDataTime.minute == itemSearchTime.minute)
        {
          return true;
        }else{
          return false;
        }
      }
      else if(opration=="!="){
        if(itemDataTime.hour != itemSearchTime.hour && itemDataTime.minute != itemSearchTime.minute)
        {
          return true;
        }else{
          return false;
        }
      }
      else if(opration==">"){
        if(itemDataTime.hour > itemSearchTime.hour && itemDataTime.minute > itemSearchTime.minute)
        {
          return true;
        }else{
          return false;
        }
      }
      else if(opration=="<"){
        if(itemDataTime.hour < itemSearchTime.hour && itemDataTime.minute < itemSearchTime.minute)
        {
          return true;
        }else{
          return false;
        }
      }
  }

// تابع کمکی: تبدیل رشته تاریخ جلالی به Jalali
  static Jalali convertJalaliStringToDate(String jalaliStr) {
    List<String> parts = jalaliStr.split('/');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);
    return Jalali(year, month, day);
  }
}
