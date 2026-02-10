import 'package:finance/Admin/Logic/Controllers/connect-server-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/UI/Views/edit.dart';
import 'package:finance/Custom/Logic/controller.dart';
import 'package:finance/Custom/UI/View/Order/create.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../Custom/UI/View/Order/detail-create.dart';
import '../../../Custom/UI/View/Order/edit.dart';
import '../../UI/Views/create.dart';
import '../../UI/Views/dashboard.dart';
import '../../UI/Views/table-page.dart';
import '../Models/dataModel.dart';
import '../Models/db.dart';
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
    // if(tableName == 'schema'){
    //   ConncetServerController.deleteSchema({'table-name' : 'tableName'});
    // }
    return AppController.responceHelper(data, true);
  }

//end delete
  static backFunction() async {
    var index = MainController.SubMenuList.indexWhere(
        (element) => element['schema']['relations'] != null
            ? element['schema']['relations'].any((element) {
                return element == MainController.tableName.value;
              })
            : element == null);
    if (index != -1) {
      print('HelperController.backFunction${MainController.SubMenuList[index]}');
      MainController.selectedSubItem.value = index;
      MainController.tableName.value =
          MainController.SubMenuList[index]['schema']['name'];
      var indexNew = MainController.SubMenuList.indexWhere((element) =>
          element['schema']['name'] == MainController.tableName.value);
      var table = MainController.getInfoTable(MainController.tableName.value);
      MainController.tableInfo.value = table;
      if (table['schema']['view'] == 'custom') {
        var a = await DB('${MainController.tableName.value}')
            .where('_id', '\$eq', DB.parentItem.values.first['parent_id'])
            .getRecords();
        var b = await DB('${MainController.tableName.value}')
            .parent(
                parentTable: a.first['parent_table'],
                parentId: a.first['parent_id'])
            .getRecords();
        await goToTablePage(MainController.SubMenuList[index], tableData: b);

        MainController.endIndex.value = 0;
        MainController.startIndex.value = 0;
      } else {
        MainController.tableData.value =
            await DB('${MainController.tableName.value}').paginate();
        MainController.allData.value = MainController.tableData;
      }
      // Navigator.push(Get.context!, MaterialPageRoute(builder: (context)=>TablePage()));
      // Navigator.push(Get.context!, MaterialPageRoute(builder: (context)=>TablePage()));
      // await goToTablePage(MainController.SubMenuList[index]);
    } else {
      MainController.isClickedItem.value = false;
      MainController.selectedItem.value = -1;
      MainController.selectedSubItem.value = -1;
      Get.to(() => DashboardPage());
    }
  }

  static createPageFunction(String tableName) async {
    var table = MainController.getInfoTable(tableName);
    if (table['schema']['view'] == 'custom') {
      if (tableName == "order") {
        var users = await DB("user").getRecords();
        var products = await DB("product").getRecords();
        print('HelperController.createPageFunction>>${users}');
        CustomController.orderRequest.value = {};
        CustomController.orderDetailRequest.value = {};
        Get.to(() => OrderCreate(users: users, products: products));
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
    if (table['schema']['view'] == 'custom') {
      if (table['schema']['name'] == 'order') {
        print(
            'HelperController.createFunction>>${CustomController.orderRequest}');
        var orderId;
        await DB('order')
            .parent(
                parentTable: 'user',
                parentId: CustomController.orderRequest['customer'])
            .storeRecord(CustomController.orderRequest);
        orderId = ConncetServerController.storeRecordRes['_id'];
        print('HelperController.createFunction order id>>${orderId}');
        if (CustomController.orderDetailRequest.isNotEmpty) {
          for (var detail in CustomController.orderDetailRequest.keys) {
            await DB('order_detail')
                .parent(parentTable: 'order', parentId: orderId)
                .storeRecord(CustomController.orderDetailRequest[detail]);
          }
        }
      }
      // await MainController.loadData(
      //     tableData: MainController.getInfoTable(''));
    } else {
      Map<String, Map<String, dynamic>> parent = await DB.parentItem;
      if (parent.containsKey('${MainController.tableInfo['schema']['name']}') &&
          parent['${MainController.tableInfo['schema']['name']}']!.length !=
              0) {
        await DB('${MainController.tableInfo['schema']['name']}')
            .parent(
                parentTable:
                    '${parent[MainController.tableInfo['schema']['name']]!['parent_table']}',
                parentId:
                    '${parent['${MainController.tableInfo['schema']['name']}']!['parent_id']}')
            .storeRecord(ViewController.request);
      } else {
        await DB('${MainController.tableInfo['schema']['name']}')
            .storeRecord(ViewController.request);
      }
      await MainController.loadData(
          tableData: MainController.getInfoTable(
              '${MainController.tableInfo['schema']['name']}'));
      if (ViewController.isClickedBtn.value == false) {
        goToTablePage(table, loadData: false);
      }
    }
  }

  static relationFunction({var table = null, var index}) async {
    table = MainController.getInfoTable('${MainController.tableName.value}');
    var tableName = table['schema']['name'];
    if (table['schema']['view'] == 'custom') {
      var items = await DB('${table['schema']['name']}')
          .parent(
              parentId: MainController.tableData[index]['_id'],
              parentTable: MainController.tableInfo['schema']['name'])
          .getRecords();

      await goToTablePage(table,
          tableFields: MainController.getInfoTable(table['schema']['name']),
          tableData: items);
    } else {
      print('HelperController.relationFunction');
      var items = await DB('${table['schema']['name']}')
          .parent(
              parentId: MainController.tableData[index]['_id'],
              parentTable: MainController.tableInfo['schema']['name'])
          .getRecords();

      await goToTablePage(table,
          tableFields: MainController.getInfoTable(table['schema']['name']),
          tableData: items);
    }
  }

  static tablePageFunction({var table = null}) async {
    var tabeleInfo =
        MainController.getInfoTable(MainController.tableName.value);
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
    Navigator.push(
        Get.context!, MaterialPageRoute(builder: (context) => TablePage()));
  }

  static editFunction(String tableName,
      {var request = null, var id = null}) async {
    var table = MainController.getInfoTable(MainController.tableName.value);
    tableName = table['schema']['name'];
    if (table['schema']['view'] == 'custom') {
      if (tableName == 'order') {
        if(CustomController.orderRequest['image']!=null)
          CustomController.orderRequest['image']=CustomController.orderRequest['image'].contains('/') ? CustomController.orderRequest['image'].split('/').last : CustomController.orderRequest['image'];
        await DB('order').where('_id', '\$eq', '${id}').updateRecords(CustomController.orderRequest);
        if (CustomController.orderDetailRequest.length != 0)
          for (String key in CustomController.orderDetailRequest.keys) {
            if (CustomController.orderDetailRequest[key]!.containsKey('_id')) {
              print('HelperController.editFunction orderDetailRequest>>${CustomController.orderDetailRequest[key]}');
              await DB('order_detail').where('_id', '\$eq', '${CustomController.orderDetailRequest[key]!['_id']}').updateRecords(CustomController.orderDetailRequest[key]);
            } else {
              await DB('order_detail').parent(parentTable: 'order', parentId: id.toString()).storeRecord(CustomController.orderDetailRequest[key]);
            }
          }
      }
    } else {
      print('HelperController.editFunction>>${request}');
      await DB('${MainController.tableInfo['schema']['name']}')
          .where('_id', '\$eq', '${id}')
          .updateRecords(request);
      // await MainController.loadData(
      //     tableData: MainController.getInfoTable('${MainController.tableInfo['schema']['name']}'));
      // if (ViewController.isClickedBtn.value == false) {
      // await goToTablePage(
      //     MainController.tableInfo['schema']['name']);
      // }
    }
  }

  static editPageFunction(var data) async {
    var table = MainController.getInfoTable(MainController.tableName.value);
    var tableName = table['schema']['name'];
    if (table['schema']['view'] == 'custom') {
      if (tableName == 'order') {
        CustomController.orderRequest.value = {};
        CustomController.orderDetailRequest.value = {};
        var users = await DB("user").getRecords();
        var products = await DB("product").getRecords();
        var details = await DB('order_detail').parent(parentTable: "order", parentId: "${data['_id']}").getRecords();
        print('HelperController.createPageFunction details>>${details}');
        CustomController.orderRequest.value = data;
        if (details.length != 0) {
          for (var detail in details) {
            var uuid = Uuid();
            String ky = uuid.v4();
            CustomController.orderDetailRequest[ky] = detail;
            ;
          }
        }
        print(
            'HelperController.editPageFunction>>${CustomController.orderDetailRequest.length}');
        await Get.to(() => OrderEdit(
              products: products,
              users: users,
            ));
      }
    } else {
      await Get.to(() => EditPage(data: data));
    }
  }

  static deleteFunction(var id) async {
    var table = MainController.getInfoTable(MainController.tableName.value);
    var tableName = table['schema']['name'];
    if (table['schema']['view'] == 'custom') {
      if(tableName=='order'){
       await DB('order_detail').parent(parentTable: 'order',parentId: id.toString()).deleteRecord();
        DB('order').where('_id', '\$eq', '${id}').deleteRecord();
      }


    } else {
      DB('${tableName}').where('_id', '\$eq', '${id}').deleteRecord();
      pageInateFunction();
      // MainController.tableData.value =
      // await DB('${tableName}').paginate();
      ViewController.totalPage.value = await DB('${tableName}').infoPage();
    }
    Navigator.pop(Get.context!);
  }

  static goToTablePage(var table, {bool loadData = true, var tableFields = null, var tableData = null}) async {
    if (table['schema']['view'] == 'custom') {
      if (table['schema']['name'] == 'order') {
        await HelperController.pageInateFunction();
        if (tableData != null) MainController.tableData.value = tableData;

        await CustomController.addColumnOrderTable();
        Navigator.push(
            Get.context!, MaterialPageRoute(builder: (context) => TablePage()));
      } else {
        HelperController.pageInateFunction();
        Navigator.push(
            Get.context!, MaterialPageRoute(builder: (context) => TablePage()));
      }
    } else {
      if (loadData == true)
        await MainController.loadData(
            tableData: tableFields, tableDataItems: tableData);
      MainController.tableInfo['schema']['currentPage'] = 1;
      ViewController.totalPage.value =
          await DB('${MainController.tableInfo['schema']['name']}').infoPage();
      await Get.to(() => TablePage());
    }
  }

  static pageInateFunction() async {
    var table = MainController.getInfoTable(MainController.tableName.value);
    MainController.tableInfo.value = table;
    var tableName = table['schema']['name'];
    if (table['schema']['view'] == 'custom') {
      MainController.tableData.value =
          await DB('${MainController.tableName.value}').paginate();
      MainController.endIndex.value = 0;
      MainController.startIndex.value = 0;
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
}
