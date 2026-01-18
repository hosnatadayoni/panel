import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Helpers/utils/extensions.dart';
import 'package:finance/Admin/Logic/Models/ServerModel/tableModel.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/Admin/UI/Views/edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../../UI/Views/create.dart';
import '../../UI/Views/dashboard.dart';
import '../../UI/Views/table-page.dart';
import '../Models/dataModel.dart';
import '../Models/db.dart';
import 'app-controller.dart';
import 'main-controller.dart';

class HelperController extends GetxController {
  //store
  static beforeStore(var newData) {
    return AppController.responceHelper(newData, true);
  }

  static beforeStoreValidation(Map<dynamic, dynamic> newData) {
    return AppController.responceHelper(newData, true);
  }

  static afterStore(String tableName, dataJson, Map<dynamic, dynamic> customData) async {
    return AppController.responceHelper(customData, true);
  }
  //end store

  //update
  static beforeUpdate(Map<dynamic, dynamic> newData) {
    return AppController.responceHelper(newData, true);
  }

  static beforeUpdateValidation(Map<dynamic, dynamic> newData) {
    return AppController.responceHelper(newData, true);
  }

  static afterUpdate(dataJson, Map<dynamic, dynamic> customData) {
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

  static afterDelete(int index, var data) {
    // if(tableName == 'schema'){
    //   ConncetServerController.deleteSchema({'table-name' : 'tableName'});
    // }
    return AppController.responceHelper(data, true);
  }

//end delete
  static backFunction() async {
    // print('HelperController.backFunction>>${ MainController.menuList}');
    var index = MainController.menuList.indexWhere((element) => element.schema.relations!=[]? element.schema.relations!.any((element)
    {
                return element == MainController.tableName.value;
    }):element==[]);
    if (index != -1) {
      print('HelperController.backFunction${MainController.menuList[index]}');

      MainController.selectedSubItem.value = index;
      MainController.tableName.value = MainController.menuList[index].schema.name!;
      var indexNew = MainController.menuList.indexWhere((element) => element.schema.name == MainController.tableName.value);
      var table = MainController.getInfoTable(MainController.tableName.value);
      MainController.infoSchema.value = table;
      print('HelperController.backFunction>>${MainController.tableName.value}>>${MainController.menuList[indexNew]}>>${table}>>${ MainController.infoSchema}>>${MainController.menuList[index]}');
      if (table['view'] == 'custom') {
        MainController.pageInfo[MainController.tableName.value]!.end= 0;
        MainController.pageInfo[MainController.tableName.value]!.start = 0;
      }
      else {
        MainController.dataRecord.value =
        await DB('${MainController.tableName.value}').paginate();
        MainController.allData.value = MainController.dataRecord;
      }
      // Navigator.push(Get.context!, MaterialPageRoute(builder: (context)=>TablePage()));
      // await MainController.goToTablePage(MainController.menuList[index]);
    } else {
      MainController.isClickedItem.value = false;
      MainController.selectedItem.value = -1;
      MainController.selectedSubItem.value = -1;
      Get.to(() => DashboardPage());
    }
  }

  static goToTablePage(TableModel table, {bool loadData = true, var tableFields = null, var tableData = null}) async {
    if (table.schema.view == 'custom') {
        await HelperController.pageInateFunction();
        Navigator.push(Get.context!, MaterialPageRoute(builder: (context) => TablePage()));
    } else {
      if (loadData == true)
        await MainController.loadData(tableData: tableFields, tableDataItems: tableData);
      MainController.infoSchema.value.schema.currentPage = 1;
      MainController.pageInfo[table.schema.name!]?.totalPage = await DB('${MainController.infoSchema.value.schema.name}').infoPage();
      await Get.to(() => TablePage());
    }
  }


  static createPageFunction(String tableName) async {
    var table = MainController.getInfoTable(tableName);
    if (table.schema.view == 'custom') {
    } else {
      await Get.to(() => CreatePage(tableName));
    }
  }

  static createFunction(String tableName,
      {bool loadData = true,
        var tableFields = null,
        var tableData = null}) async {

    var table = MainController.getInfoTable(MainController.tableName.value);
    if (table.schema.view == 'custom') {
      await MainController.loadData(
          tableData: MainController.getInfoTable(''));
    } else {
      var responseStore={};
      Map<String, Map<String,dynamic>> parent = await DB.parentItem;
      if (parent.containsKey('${MainController.infoSchema.value.schema.name}') && parent['${MainController.infoSchema.value.schema.name}']!.length != 0) {
        responseStore= await DB('${MainController.infoSchema.value.schema.name}')
            .parent(parentTable: '${parent[MainController.infoSchema.value.schema.name]!['parent_table']}', parentId: '${parent['${MainController.infoSchema.value.schema.name}']!['parent_id']}').storeRecord(ViewController.request);
      } else {
        responseStore=await DB('${MainController.infoSchema.value.schema.name}').storeRecord(ViewController.request);

      }
      if(responseStore.isNotEmpty){
        showSnackbar(snackTypes.success, 'عملیات با موفقیت انجام شد.');
        ViewController.request={};
        ViewController.storeKey.value=ViewController.storeKey+'store';
      }
      await MainController.loadData(tableData: MainController.getInfoTable('${MainController.infoSchema.value.schema.name}'));
      // if (ViewController.isClickedBtn.value == false) {
      //  goToTablePage(table, loadData: false);
      // }
    }
  }

  static relationFunction({var table = null, var index}) async {
    table = MainController.getInfoTable('${MainController.tableName.value}');
    var tableName = table.schema.name;
    print('HelperController.relationFunction>>>${tableName}');
    if (table.schema.view == 'custom') {
      // pageInateFunction();
      var items = await DB('${table.schema.name}').parent(parentId: MainController.dataRecord[index]['_id'], parentTable: MainController.infoSchema.value.schema.name).getRecords();
      await goToTablePage(table, tableFields: MainController.getInfoTable(table.schema.name), tableData: items);
    } else {
      var items = await DB('${table.schema.name}').parent(parentId: MainController.dataRecord[index]['_id'], parentTable: MainController.infoSchema.value.schema.name).getRecords();
      await goToTablePage(table, tableFields: MainController.getInfoTable(table.schema.name), tableData: items);
    }
  }

  static editFunction (String tableName,
      {var request = null, var id = null}) async {

    var table = MainController.getInfoTable(MainController.tableName.value);
    tableName = table.schema.name;
    if (table.schema.view == 'custom') {
    } else {
      var response={};
      print('HelperController.editFunction>>${request}');
      response= await DB('${MainController.infoSchema.value.schema.name}').where('_id', '\$eq', '${id}').updateRecords(request);
     if(response.isNotEmpty){
       showSnackbar(snackTypes.success, "عملیات با موفقیت انجام شد.");
     }
      // await MainController.loadData(
      //     tableData: MainController.getInfoTable('${MainController.infoSchema.value.schema.name}'));
      // if (ViewController.isClickedBtn.value == false) {
        // await MainController.goToTablePage(
        //     MainController.infoSchema.value.schema.name);
      // }
    }
  }

  static editPageFunction(var data) async {
    var table = MainController.getInfoTable(MainController.tableName.value);
    var tableName = table.schema.name;
    print('HelperController.editPageFunction>>>${table.schema.view}');
    if (table.schema.view == 'custom') {

    }
    else {
      print('HelperController.editPageFunction');
      await Get.to(() => EditPage(data: data));
    }
  }

  static deleteFunction(var id) async {

    var table = MainController.getInfoTable(MainController.tableName.value);
    var tableName = table.schema.name;
    if (table.schema.view == 'custom') {

    } else {
      await DB('${tableName}').where('_id', '\$eq', '${id}').deleteRecord();
      await pageInateFunction();
      // MainController.tableData.value =
      // await DB('${tableName}').paginate();
      MainController.pageInfo[tableName.toString()]!.totalPage = await DB('${tableName}').infoPage();
    }
    Navigator.pop(Get.context!);
  }

  static pageInateFunction() async {
    var table = MainController.getInfoTable(MainController.tableName.value);
    MainController.infoSchema.value = table;
    var tableName = table.schema.name;
    if (table.schema.view == 'custom') {
      MainController.dataRecord.value = await DB('${MainController.tableName.value}').paginate();
      MainController.pageInfo[tableName]!.end = 0;
      MainController.pageInfo[tableName]!.start = 0;
    } else {
      MainController.dataRecord.value = await DB('${tableName}').paginate();
      MainController.allData.value = MainController.dataRecord.value;
    }
  }

  static addColumn(ColumnModel columnModel){
    MainController.infoSchema.value.columns.add(columnModel);
    return MainController.infoSchema.value;
  }

  static addRecord(var index,Map<String,dynamic> records){
    MainController.dataRecord[index].addAll(records);
    return  MainController.dataRecord;
  }

  static filterDate(String dataDate, String searchDate, String opration) {
    Jalali baseDate = searchDate.toJalai();
    Jalali date = dataDate.toJalai();
    if (opration == '>=') {
      if (date.compareTo(baseDate)>=0) {
        return true;
      } else {
        return false;
      }
    } else if (opration == "<=") {
      if (date.compareTo(baseDate)<=0) {
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



}