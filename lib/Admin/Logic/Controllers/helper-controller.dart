import 'dart:convert';
import 'package:panel/Admin/Logic/Controllers/connect-server-controller.dart';
import 'package:panel/Admin/Logic/Controllers/record-controller.dart';
import 'package:panel/Admin/Logic/Controllers/view-controller.dart';
import 'package:panel/Admin/Logic/Controllers/view-custom-controller.dart';
import 'package:panel/Admin/Logic/Models/db.dart';
import 'package:panel/Admin/Logic/Models/order-item.dart';
import 'package:panel/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:panel/Admin/UI/Views/dashboard.dart';
import 'package:panel/Admin/UI/Views/edit.dart';
import 'package:panel/Admin/boxes.dart';
import 'package:panel/AdminCustom/UI/Views/creteField.dart';
import 'package:panel/AdminCustom/UI/Views/editField.dart';
import 'package:panel/AdminCustom/UI/Views/editSchema.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
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
    return AppController.responceHelper(data, true);
  }

//end delete

  static createPageFunction(String tableName) async {
    var table = MainController.getInfoTable(tableName);
    print('HelperController.createPageFunction>>${table}');
    if (table['view'] == 'custom') {
      if (table['table-name'] == 'project' || table['table-name'] == 'validators') {
        await Get.to(() => CreatePage(tableName));
      }
      if( table['table-name'] == 'schema'){
        await ConncetServerController.listSchema();
        MainController.tableInfo['columns'][6]['items'] = [];
        var index =MainController.SubMenuList.indexWhere((element) => element['table-name']=='schema');
        if(index!=-1){
          for(var field in ConncetServerController.listSchemaRes) {
            print('HelperController.createPageFunction222${ MainController.tableInfo['columns']}');
            MainController.tableInfo['columns'][6]['items']
                .add({"title": field['name'], "value": field['name']});
          }
          print('HelperController.createPageFunction>>>${  MainController.tableInfo['columns'][6]}');
        }
        await Get.to(() => CreatePage(tableName));

      }
      if( table['table-name'] == 'filters'){
        Map<String, dynamic> parent = await DB.parentItem;
        print('HelperController.createPageFunction>>>${parent}');
        if (parent.length != 0) {
          await ConncetServerController.listField({'name':parent['parent_table']});
        }
        var index =MainController.SubMenuList.indexWhere((element) => element['table-name']=='filters');
        if(index!=-1){
          for(var field in ConncetServerController.listFieldsRes) {
            print('HelperController.createPageFunction222${field['name']}');
            MainController.tableInfo['columns'][0]['items']
                .add({"title": field['name'], "value": field['name']});
          }
          print('HelperController.createPageFunction>>>${ MainController.tableInfo}');
        }
        await Get.to(() => CreatePage(tableName));
      }
      else if(table['table-name'] == 'fields'){
        await Get.to(() => CretePageField(tableName));
      }

    } else {
      await Get.to(() => CreatePage(tableName));
    }
  }

  static createFunction(String tableName,
      {bool loadData = true,
      var tableFields = null,
      var tableData = null}) async {
    var table = MainController.getInfoTable(MainController.tableName.value);
    if (table['view'] == 'custom') {
      if (table['table-name'] == 'project') {
        if(ViewController.request['name'] != null){
          ViewController.request['name'] = ViewController.request['name'].trim().replaceAll(' ', '_');
        }
        var Id = Uuid().v4();
        DataModel newData = DataModel(id: '${Id}', data: ViewController.request);
        if (await RecordController.validate(table['table-name'], newData,
            ViewCustomController.getDataTable(table['table-name'])) ==
            false) {
          await ConncetServerController.createProject(ViewController.request);
          MainController.goToTablePage(table, loadData: false);
        }
        else {
          showSnackbar(snackTypes.error, "${AppController.of(Get.context!)!.value('error')}");
        }
        ViewController.isClickedBtn.value=true;
      }

      if (table['table-name'] == 'schema') {
        if(ViewController.request['name'] != null){
          ViewController.request['name'] = ViewController.request['name'].trim().replaceAll(' ', '_');
        }
        var Id = Uuid().v4();
        DataModel newData = DataModel(id: '${Id}', data: ViewController.request);
        if (await RecordController.validate(table['table-name'], newData,
            ViewCustomController.getDataTable(table['table-name'])) ==
            false) {
          await ConncetServerController.createSchema(ViewController.request);
          MainController.goToTablePage(table, loadData: false);
        }
        else {
          showSnackbar(snackTypes.error, "${AppController.of(Get.context!)!.value('error')}");
        }
        ViewController.isClickedBtn.value=true;
      }

      if (table['table-name'] == 'fields') {
        Map<String, dynamic> parent = await DB.parentItem;
        print('await DB.parentItem>>>${await DB.parentItem}');
        if (parent.length != 0) {
          ViewController.request.addAll({'table': parent['parent_id']});
        }
        if(ViewController.request['name'] != null){
          ViewController.request['name'] = ViewController.request['name'].trim().replaceAll(' ', '_');
        }
        var Id = Uuid().v4();
        DataModel newData = DataModel(id: '${Id}', data: ViewController.request);
        if (await RecordController.validate(table['table-name'], newData,
            ViewCustomController.getDataTable(table['table-name'])) ==
            false) {
          await ConncetServerController.createField(ViewController.request);
          MainController.goToTablePage(table, loadData: false);
        }
        else {

          showSnackbar(snackTypes.error, "${AppController.of(Get.context!)!.value('error')}");
        }
        ViewController.isClickedBtn.value=true;
      }

      if (table['table-name'] == 'filters') {
        Map<String, dynamic> parent = await DB.parentItem;
        if (parent.length != 0) {
          ViewController.request.addAll({
            'table': parent['parent_id']
          });
        }
        await ConncetServerController.createFilter(ViewController.request);
        MainController.goToTablePage(table,loadData: false);
      }
      if (table['table-name'] == 'validators') {
        Map<String, dynamic> parent = await DB.parentItem;
        if (parent.length != 0) {
          ViewController.request.addAll({
            'field': parent['parent_id']
          });
        }
        await ConncetServerController.createValidate(ViewController.request);
        MainController.goToTablePage(table,loadData: false);
      }
    } else {
      Map<String, dynamic> parent = await DB.parentItem;
      if (parent.length == 0) {
        await DB('${MainController.tableInfo['table-name']}')
            .storeRecord(ViewController.request);
      } else {
        await DB('${MainController.tableInfo['table-name']}')
            .parent(
                parentTable: '${parent['parent_table']}',
                parentId: '${parent['parent_id']}')
            .storeRecord(ViewController.request);
      }
      if (ViewController.isClickedBtn.value == false) {
        MainController.goToTablePage(table, loadData: false);
      }
    }
  }

  static relationFunction({var table = null, var index}) async {
    table = MainController.getInfoTable('${MainController.tableName.value}');
    var tableName = table['table-name'];
    if (table['view'] == 'custom') {
      if (tableName == 'schema') {
        await Token.removeToken();
        Token.setToken(MainController.tableData.value[index]['api_key']);
      }
      if (tableName == 'fields') {
        DB.parentItem = {
          'parent_id': MainController.tableData.value[index]['_id'],
          'parent_table': MainController.tableData.value[index]['name']
        };
      }
      if (tableName == 'filters') {
        DB.parentItem={
          'parent_id':MainController.tableData.value[index]['_id'],
          'parent_table':MainController.tableData.value[index]['name']
        };
      }
      if (tableName == 'validators') {
        print('HelperController.relationFunction>>>${MainController.tableData.value[index]}');
        DB.parentItem={
          'parent_id':MainController.tableData.value[index]['_id'],
          'parent_table':MainController.tableData.value[index]['name']
        };
      }
      pageInateFunction();
    } else {
      var items = await DB('${table['table-name']}')
          .parent(
              parentId: MainController.tableData.value[index]['_id'],
              parentTable: MainController.tableInfo['table-name'])
          .getRecords();
      DB.parentItem = {
        'parent_id': MainController.tableData.value[index]['_id'],
        'parent_table': MainController.tableInfo['table-name']
      };
      await MainController.goToTablePage(table,
          tableFields: MainController.getInfoTable(table['table-name']),
          tableData: items);
    }
  }

  static tablePageFunction({var table = null}) async {
    await pageInateFunction();
    Navigator.push(
        Get.context!, MaterialPageRoute(builder: (context) => TablePage()));
  }

  static editFunction(String tableName,
      {var request = null, var id = null}) async {
    var table = MainController.getInfoTable(MainController.tableName.value);
    tableName = table['table-name'];
    if (table['view'] == 'custom') {
      if (tableName == 'schema') {
        request.addAll({'id': id});
        if(request['name'] != null){
          request['name'] = request['name'].trim().replaceAll(' ', '_');
        }
        final record = DataModel(id: request['_id'], data: request);
        var validate = await RecordController.validate(tableName, record,
            ViewCustomController.getDataTable(tableName));
        if (validate == false){
          await ConncetServerController.updateSchema(request,id);
          await MainController.goToTablePage(table);
        }
        else {
          showSnackbar(snackTypes.error,
              '${AppController.of(Get.context!)!.value('The operation encountered an error.')}');
        }
        print('request schema page>>>${request}');
      }
      if (tableName == 'fields') {
        // var req = {
        //   'id': id,
        //   'field': json.encode(request).toString(),
        // };
        // await ConncetServerController.updateField(req);
        print('HelperController.editFunction request>>$request');
        await ConncetServerController.updateField(request,id);
        print('req field page>>>${request}');
        await MainController.goToTablePage(table);
      }
    } else {
      await DB('${MainController.tableInfo['table-name']}')
          .where('_id', '\$eq', '${id}')
          .updateRecord(request);
      if (ViewController.isClickedBtn.value == false) {
        await MainController.goToTablePage(
            MainController.tableInfo['table-name']);
      }
    }
  }

  static editPageFunction(var data) async {
    OrderItem.orderItemsList = {};
    var table = MainController.getInfoTable(MainController.tableName.value);
    if (table['view'] == 'custom') {
      if (table['table-name'] == 'project') {
        await Get.to(() => EditPage(data: data));
      }
       if(table['table-name'] == 'fields'){
        await Get.to(() => EditFieldPage(data: data));
      }
      if( table['table-name'] == 'schema') {
        // await ConncetServerController.listSchema();
        // var index = MainController.SubMenuList.indexWhere((
        //     element) => element['table-name'] == 'schema');
        // if (index != -1) {
        //   for (var field in ConncetServerController.listSchemaRes) {
        //     print('HelperController.createPageFunction222${ MainController
        //         .tableInfo['columns']}');
        //     MainController.tableInfo['columns'][6]['items']
        //         .add({"title": field['name'], "value": field['_id']});
        //   }
        //   print('HelperController.createPageFunction>>>${ MainController
        //       .tableInfo['columns'][6]}');
        // }
        await ConncetServerController.listSchema();
        MainController.tableInfo['columns'][6]['items'] = [];
        var index = MainController.SubMenuList.indexWhere((
            element) => element['table-name'] == 'schema');
        if (index != -1) {
          for (var field in ConncetServerController.listSchemaRes) {
            print('HelperController.createPageFunction222${ MainController
                .tableInfo['columns']}');
            MainController.tableInfo['columns'][6]['items'].add({"title": field['name'], "value": field['name']});
            }
          }
        await Get.to(() => EditSchemaPage(data: data));
      }

      } else {
      await Get.to(() => EditPage(data: data));
    }

  }
  // static editPageFunction(var data) async {
  //   var table =MainController.getInfoTable(MainController.tableName.value);
  //   var tableName=table['table-name'];
  //   if(table['view']=='custom'){
  //     if(tableName!='filters' && tableName!='validators' ){
  //       await Get.to(() => EditPage(data: data));
  //     }
  //   }else{
  //     await Get.to(() => EditPage(data: data));
  //   }
  // }

  static deleteFunction(var item) async {
    var table = MainController.getInfoTable(MainController.tableName.value);
    var tableName = table['table-name'];
    if (table['view'] == 'custom') {
      if(tableName=='fields'){
        var index=ConncetServerController.listFiltersRes.indexWhere((element) => element['column']==item['name']);

        print('HelperController.deleteFunction>>${index}>>${ConncetServerController.listFiltersRes}>>');
        if(index!=-1){
          await ConncetServerController.deleteFilter({'id':ConncetServerController.listFiltersRes[index]['_id']});
        }
        await ConncetServerController.deleteField({'id':item['_id']});

      }
      if (tableName == 'project') {
        await ConncetServerController.deleteProject(item['api_key']);
      }
      if(tableName=='schema'){
        await ConncetServerController.deleteSchema({'name':item['name']});
      }
      pageInateFunction();
    } else {
      DB('${tableName}').where('_id', '\$eq', '${item['_id']}').deleteRecord();
      pageInateFunction();
      ViewController.totalPage.value = await DB('${tableName}').infoPage();
    }
    Navigator.pop(Get.context!);
  }

  static pageInateFunction() async {
    var table = MainController.getInfoTable(MainController.tableName.value);
    MainController.tableInfo = table;
    var tableName = table['table-name'];
    if (table['view'] == 'custom') {
      MainController.endIndex.value = 0;
      MainController.startIndex.value = 0;
      if (tableName == 'project') {
        await ConncetServerController.listProject();

        await pageInateItems(
            perPage: table['countShowRow'],
            currentPage: table['currentPage'],
            listItems: ConncetServerController.listProjectRes);
      }
      if (tableName == 'schema') {
        await ConncetServerController.listSchema();

        await pageInateItems(
            perPage: table['countShowRow'],
            currentPage: table['currentPage'],
            listItems: ConncetServerController.listSchemaRes);
      }
      if (tableName == 'fields') {
        Map<String, dynamic> parent = await DB.parentItem;
        if (parent.length != 0) {
          await ConncetServerController.listField(
              {'name': parent['parent_table']});
        }
        await pageInateItems(
            perPage: table['countShowRow'],
            currentPage: table['currentPage'],
            listItems: ConncetServerController.listFieldsRes);
      }
      if(tableName=='filters'){

        Map<String, dynamic> parent = await DB.parentItem;
        print('HelperController.pageInateFunction>>>${parent}');
        if (parent.length != 0) {
          await ConncetServerController.listFilter({'my_table':parent['parent_id']});
        }
        await pageInateItems( perPage : table['countShowRow'], currentPage:table['currentPage'], listItems:ConncetServerController.listFiltersRes );
      }
      if(tableName=='validators'){
        Map<String, dynamic> parent = await DB.parentItem;
        if (parent.length != 0) {
          await ConncetServerController.listValidate({'my_field':parent['parent_id']});
        }
        await pageInateItems( perPage : table['countShowRow'], currentPage:table['currentPage'], listItems:ConncetServerController.listValidateRes );
      }
    } else {
      MainController.tableData.value =
          await DB('${MainController.tableName.value}').paginate();
      MainController.allData.value = MainController.tableData.value;
    }
  }

  static pageInateItems(
      {var perPage = 10, var currentPage = 1, List<dynamic>? listItems}) async {
    var totalItems = listItems!.length;
    int s = (currentPage - 1) * perPage;
    var end = s + perPage;
    MainController.startIndex.value = s;
    var endByCondition = end >= totalItems ? totalItems : end;
    MainController.endIndex.value = int.parse(endByCondition.toString());
    List<dynamic> list = listItems.skip(s).take(perPage).toList();
    print(
        'HelperController.pageInateItems>>${totalItems}>>${end}>${s}>>${perPage}');
    MainController.tableData.value = list;
    MainController.allData.value = list;
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

  static Future<List> itemsListFunction(
      String tableName) async {
    print('items list function');
    var table = MainController.getInfoTable(tableName);
    if (table['view'] == 'custom') {
      if (table['table-name'] == 'schema') {
        int index = ConncetServerController.listSchemaRes
            .indexWhere((s) => s['name'] == DB.parentItem['parent_table']);
        print('index a>>>${index}');
        if (index != -1) {
          ConncetServerController.listSchemaRes
              .remove(ConncetServerController.listSchemaRes[index]);
        }
        return ConncetServerController.listSchemaRes;
      }
    } else {
      return await DB('${tableName}').getRecords();
    }
    return [];
  }

  static backFunction() async {
    var index=MainController.SubMenuList.indexWhere((element) => element['relations'].any((element) => element['table-name']==MainController.tableName.value));
    print('HelperController.backFunction>>$index');
    if(index!=-1){
      MainController.selectedSubItem.value = index;
      // DB.parentItem={};
      MainController.tableName.value=MainController.SubMenuList[index]['table-name'];
      await MainController.goToTablePage(MainController.SubMenuList[index]);


    }else{
      MainController.isClickedItem.value = false;
      MainController.selectedItem.value = -1;
      MainController.selectedSubItem.value = -1;
      Get.to(() => DashboardPage());
    }
  }

  static checkboxFunctuin(String name , int indexRow , var text) async {
    var table = MainController.getInfoTable(MainController.tableName.value);
    if(table['view'] == 'custom'){
      if(table['table-name'] == 'schema'){
          // MainController.tableData.value[indexRow][name] =  !MainController.tableData.value[indexRow][name];
          // await ConncetServerController.updateSchema({"${name}" : text});
        await ConncetServerController.updateSchema({"${name}" : text},MainController.tableData[indexRow]['_id']);
      }
      if(table['table-name'] == 'fields'){
          // MainController.tableData.value[indexRow][name] =  !MainController.tableData.value[indexRow][name];
          // print("field>>>>checkbox>>>${MainController.tableData.value[indexRow]}");
          // await ConncetServerController.updateField({"${name}" : text});
        await ConncetServerController.updateField({"${name}" : text},MainController.tableData[indexRow]['_id']);
      }

    }
    else{
      // await DB('${MainController.tableInfo['table-name']}').
      // where('_id', '\$eq', '${MainController.tableData.value[indexRow]['_id']}')
      // .updateRecords({'${name}':'${text}'});
      await DB('${MainController.tableInfo['table-name']}').
      where('_id', '\$eq', '${MainController.tableData[indexRow]['_id']}')
          .updateRecords({'${name}':'${text}'});
    }
  }
}
