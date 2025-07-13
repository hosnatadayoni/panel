import 'dart:convert';

import 'package:finance/Admin/Logic/Controllers/connect-server-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Logic/Models/order-item.dart';
import 'package:finance/Admin/UI/Views/edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../UI/Views/create.dart';
import '../../UI/Views/table-page.dart';
import '../Helpers/token-methods.dart';
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
    print('customData.id4>>>${customData.id}');
    if (tableName == 'order3') {
      if (OrderItem.orderItemsList.length != 0) {
        // for (var key in OrderItem.orderItemsList.keys) {
        //   OrderItem.orderItemsList[key] = {...OrderItem.orderItemsList[key]!, 'سفارش': customData.id};
        // }
        for (var list in OrderItem.orderItemsList.values) {
          // await DB('order-itemss').parent(parentTable: 'order',parentId: customData.id!).storeRecord(list);
          await DB('itemsOrder2')
              .parent(parentTable: 'order3', parentId: customData.id!)
              .storeRecord(list);
        }
      }
    }
    if (tableName == 'itemsOrder') {
      // await DB('itemsOrder').parent(parentTable: 'order3',parentId: customData.id!).storeRecord(list);
    }

    // if (tableName == 'fields') {
    //   Map<String, dynamic> parent = await DB.parentItem;
    //   await ConncetServerController.createField({
    //     'table': '${parent['parent_id']}',
    //     'name': '${customData.data['name']}',
    //     'title': '${customData.data['title']}',
    //     'typeField': '${customData.data['type_filed']}',
    //     'sourceItems': '${customData.data['sourceItems']}',
    //     'sourceTable': '${customData.data['sourceTable']}'
    //   });
    // }
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
    // if (dataJson == 'schema') {
    //   ConncetServerController.updateSchema({'table-name': dataJson});
    // }

    return AppController.responceHelper(customData, true);
  }
  //end update

  //delete
  static beforeDelete(int index) {
    return AppController.responceHelper(null, true);
  }

  static afterDelete(int index, DataModel data) {
    // if(tableName == 'schema'){
    //   ConncetServerController.deleteSchema({'table-name' : 'tableName'});
    // }
    return AppController.responceHelper(data, true);
  }
//end delete

  static createPageFunction(String tableName) async {
    var table =MainController.getInfoTable(tableName);
    print('HelperController.createPageFunction>>${table}');
    if (table['view'] == 'custom') {

    } else {
      await Get.to(() => CreatePage(tableName));
    }
  }

  static createFunction(String tableName,{bool loadData = true, var tableFields = null, var tableData = null}) async {
    var table =MainController.getInfoTable(MainController.tableName.value);
    print('HelperController.createFunction>>>${ MainController.tableName.value}');
    if (table['view'] == 'custom') {


    }
    else {
      Map<String, dynamic> parent = await DB.parentItem;
      if (parent.length == 0) {
        await DB('${MainController.tableInfo['name']}').storeRecord(ViewController.request);
      } else {
        await DB('${MainController.tableInfo['table-name']}')
            .parent(
                parentTable: '${parent['parent_table']}',
                parentId: '${parent['parent_id']}')
            .storeRecord(ViewController.request);
      }
      if (ViewController.isClickedBtn.value == false) {
        MainController.goToTablePage(table,loadData: false);
      }
    }
  }

  static relationFunction({var table = null, var index}) async {
    table = MainController.getInfoTable('${MainController.tableName.value}');
    var tableName=table['table-name'];
    print('HelperController.relationFunction>>>${ MainController.tableName.value}');
    if (table['view'] == 'custom') {
      if (tableName == 'schema') {
        await Token.removeToken();
        Token.setToken(MainController.tableData.value[index]['api_key']);
      }
      if (tableName == 'fields') {
        DB.parentItem={
          'parent_id':MainController.tableData.value[index]['_id'],
          'parent_table':MainController.tableData.value[index]['name']
        };
      }
      pageInateFunction();
      // await Token.removeName();
      // await Token.setName(MainController.tableData.value[index]['name'].toString());
      // print('table>>1>>${table['table-name']}');
      // await MainController.goToTablePage(table,loadData: false);
    } else {
      var items = await DB('${table['table-name']}').parent(parentId: MainController.tableData.value[index]['_id'], parentTable: MainController.tableInfo['table-name']).getRecords();
      DB.parentItem = {
        'parent_id': MainController.tableData.value[index]['_id'],
        'parent_table': MainController.tableInfo['table-name']
      };
      await MainController.goToTablePage(table, tableFields: MainController.getInfoTable(table['table-name']), tableData: items);
    }
  }

  static tablePageFunction({var table=null}) async {
    print('HelperController.tablePageFunction>>${MainController.tableName.value}');
    var tabeleInfo=MainController.getInfoTable(MainController.tableName.value);
    // String tableName =  tabeleInfo['table-name'];
    await pageInateFunction();
    // if (tableName == 'project') {
    //   await ConncetServerController.listProject();
    //   MainController.tableData.value = ConncetServerController.listProjectRes;
    //   MainController.allData.value=MainController.tableData.value;
    //
    // }
    // if (tableName == 'schema') {
    //   print('table>>3>>${table}');
    //   await ConncetServerController.listSchema();
    //   MainController.tableData.value = ConncetServerController.listSchemaRes;
    //   MainController.allData.value=MainController.tableData.value;
    //   MainController.tableInfo=tabeleInfo;
    //   print('HelperController.tablePageFunction>>>${tabeleInfo}');
    // }
    // if (tableName == 'fields') {
    //   Map<String, dynamic> parent = await DB.parentItem;
    //   if (parent.length != 0) {
    //     await ConncetServerController.listField({'name':parent['parent_table']});
    //   }
    //   MainController.tableData.value = ConncetServerController.listFieldsRes;
    //   MainController.allData.value=MainController.tableData.value;
    //   MainController.tableInfo=tabeleInfo;
    // }
    Navigator.push(Get.context!, MaterialPageRoute(builder: (context)=>TablePage()));
  }

  static editFunction(String tableName,{ var request = null, var id = null}) async {
    var table =MainController.getInfoTable(MainController.tableName.value);
    tableName=table['table-name'];
    if(table['view']=='custom'){

    }
    else{
      await DB('${MainController.tableInfo['table-name']}').where('_id', '\$eq', '${id}').updateRecord(request);
      if (ViewController.isClickedBtn.value == false) {
        await MainController.goToTablePage(MainController.tableInfo['table-name']);
      }
    }

  }

  static editPageFunction(var data) async {
    OrderItem.orderItemsList = {};

      await Get.to(() => EditPage(data: data));

  }

  static deleteFunction(var id) async {
    var table =MainController.getInfoTable(MainController.tableName.value);
    var tableName=table['table-name'];
    if(table['view']=='custom'){

    }else {
      DB('${tableName}').where('_id', '\$eq', '${id}').deleteRecord();
      pageInateFunction();
      // MainController.tableData.value =
      // await DB('${tableName}').paginate();
      ViewController.totalPage.value =
      await DB('${tableName}').infoPage();
    }
    Navigator.pop(Get.context!);
  }

  static pageInateFunction() async {
    var table =MainController.getInfoTable(MainController.tableName.value);
    MainController.tableInfo=table;
    var tableName=table['table-name'];
    if(table['view']=='custom'){
      MainController.endIndex.value = 0;
      MainController.startIndex.value = 0;

    }else {
      MainController.tableData.value= await DB('${MainController.tableName.value}').paginate();
    MainController.allData.value= MainController.tableData.value;
    }
  }
  static pageInateItems({var perPage = 10,var currentPage=1,List<dynamic>? listItems}) async {
    var totalItems=listItems!.length;
    int s = (currentPage - 1) * perPage;
    var end = s + perPage;
    MainController.startIndex.value = s;
    var endByCondition = end >= totalItems ? totalItems : end;
    MainController.endIndex.value = int.parse(endByCondition.toString());
    List<dynamic> list= listItems.skip(s).take(perPage).toList();
    print('HelperController.pageInateItems>>${totalItems}>>${end}>${s}>>${perPage}');
    MainController.tableData.value= list;
    MainController.allData.value= list;
  }

  static filterDate(String dataDate, String searchDate, String opration) {
    Jalali baseDate = convertJalaliStringToDate(searchDate);
    Jalali date = convertJalaliStringToDate(dataDate);
    if (opration == '>=') {
      if (date.isAfter(baseDate)) {
        return true;
      } else {
        return false;
      }
    } else if (opration == "<=") {
      if (date.isBefore(baseDate)) {
        return true;
      } else {
        return false;
      }
    } else if (opration == "==") {
      if (date == baseDate) {
        return true;
      } else {
        return false;
      }
    }
  }

  static filterTime(String dataTime, String searchTime, String opration) {
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

    if (opration == '>=') {
      if (itemDataTime.hour >= itemSearchTime.hour &&
          itemDataTime.minute >= itemSearchTime.minute) {
        return true;
      } else {
        return false;
      }
    } else if (opration == "<=") {
      if (itemDataTime.hour <= itemSearchTime.hour &&
          itemDataTime.minute <= itemSearchTime.minute) {
        return true;
      } else {
        return false;
      }
    } else if (opration == "==") {
      if (itemDataTime.hour == itemSearchTime.hour &&
          itemDataTime.minute == itemSearchTime.minute) {
        return true;
      } else {
        return false;
      }
    } else if (opration == "!=") {
      if (itemDataTime.hour != itemSearchTime.hour &&
          itemDataTime.minute != itemSearchTime.minute) {
        return true;
      } else {
        return false;
      }
    } else if (opration == ">") {
      if (itemDataTime.hour > itemSearchTime.hour &&
          itemDataTime.minute > itemSearchTime.minute) {
        return true;
      } else {
        return false;
      }
    } else if (opration == "<") {
      if (itemDataTime.hour < itemSearchTime.hour &&
          itemDataTime.minute < itemSearchTime.minute) {
        return true;
      } else {
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
