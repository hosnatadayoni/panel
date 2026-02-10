import 'package:finance/Admin/Logic/Controllers/record-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Helpers/utils/extensions.dart';
import 'package:finance/Admin/Logic/Models/tableModel.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/Admin/UI/Views/edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../Custom/Logic/Controllers/view-custom-controller.dart';
import '../../../Custom/Logic/Models/order-item.dart';
import '../../../Custom/UI/Components/Views/table-page-custom.dart';
import '../../../Custom/UI/Components/page-custom/order/order-create.dart';
import '../../../Custom/UI/Components/page-custom/order/order-edit.dart';
import '../../UI/Views/create.dart';
import '../../UI/Views/dashboard.dart';
import '../../UI/Views/table-page.dart';
import '../Models/columnModel.dart';
import '../Models/dataModel.dart';
import '../Models/db.dart';
import 'app-controller.dart';
import 'connect-server-controller.dart';
import 'connection-controller.dart';
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
  static beforeDelete( Map<dynamic, dynamic> data) {
    return AppController.responceHelper(data, true);
  }

  static afterDelete( Map<dynamic, dynamic> data) {
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
      TableModel table = MainController.getInfoTable(MainController.tableName.value);
      MainController.infoSchema.value = table;
      print('HelperController.backFunction>>${MainController.tableName.value}>>${MainController.menuList[indexNew]}>>${table}>>${ MainController.infoSchema}>>${MainController.menuList[index]}');
      if (table.schema.view == 'custom') {
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
  static getListSchema() async {
    bool connectivity = await ConnectionController.checkConnectivity();
    if(connectivity){
      await ConncetServerController.listSchemaByField();
    }
    else {
      final box = await Hive.openBox<TableModel>('menuBox');
      if (box.isNotEmpty) {
        MainController.menuList.assignAll(box.values.toList());
      }
    }
      // else{
      //     await ConncetServerController.listSchemaByField();
      // }
  }
  static goToTablePage(String tableName, {bool loadData = true, var tableFields = null, var tableData = null}) async {
    TableModel table=MainController.getInfoTable(tableName);
    if (table.schema.view == 'custom') {
      await HelperController.pageInateFunction();
      if (table.schema.name == 'order') {
        Navigator.push(Get.context!, MaterialPageRoute(builder: (context) => TablePageCustom()));
      }
      else if (table.schema.name == 'Order_Details') {
        Navigator.push(Get.context!, MaterialPageRoute(builder: (context) => TablePage()));
      }
      else
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
    TableModel table = MainController.getInfoTable(tableName);
    if (table.schema.view == 'custom') {
      print('HelperController.createPageFunction>>${table.schema.name}');
      if (table.schema.name== 'order') {
        List<dynamic> customerItems = await DB('user').getRecords();
        List<dynamic> productItems = await DB('product').getRecords();
        ViewCustomController.containers = <String, Widget>{}.obs;
        await Get.to(() => OrderCreatePage(tableName, customerItems, productItems));
      }
    } else {
      await Get.to(() => CreatePage(tableName));
    }
  }

  static createFunction(String tableName, {bool loadData = true, var tableFields = null, var tableData = null}) async {
    TableModel table = MainController.getInfoTable(MainController.tableName.value);
    if (table.schema.view == 'custom') {
      if (table.schema.name == 'order') {
        if (ViewCustomController.order['date'] == null) {
          ViewCustomController.order['Date'] =
              ViewCustomController.getDate(Jalali.now());
        }
        if (ViewCustomController.order['type'] == null) {
          ViewCustomController.order['Type'] =
          MainController.getDetailsOfField('order', 'Type')['items']
              .first['value'];
        }
        if (ViewCustomController.order['customer'] == null) {
          List<dynamic> customerItems = await DB('user').getRecords();
          ViewCustomController.order['customer'] = customerItems.first['_id'];
        }

        var Id = Uuid().v4();
        DataModel newData =
        DataModel(id: '${Id}', data: ViewCustomController.order);
        bool validate = await RecordController.validate(
            'order', newData, MainController.getInfoTable('order'));
        if (validate == false) {
          var Id = Uuid().v4();
          List<bool> validatorOrderDetailList = [];
          for (var i = 0;
          i < OrderItem.orderItemsList.values.toList().length;
          i++) {
            var orderItem = OrderItem.orderItemsList.values.toList()[i];
            if (orderItem['Cut_Pattern'] == null) {
              orderItem['Cut_Pattern'] = MainController.getDetailsOfField(
                  'Order_Details', 'Cut_Pattern')['items']
                  .first['value'];
            }
            if (orderItem['Manufacturing_Difficulty'] == null) {
              orderItem['Manufacturing_Difficulty'] =
              MainController.getDetailsOfField(
                  'Order_Details', 'Manufacturing_Difficulty')['items']
                  .first['value'];
            }
            if (orderItem['Product_Name'] == null) {
              List<dynamic> productItems = await DB('product').getRecords();
              orderItem['Product_Name'] = ViewCustomController
                  .order['customer'] = productItems.first['_id'];
            }
            print('orderItem>>>${orderItem}');
            DataModel newDataOrderItem =
            DataModel(id: '${Id}', data: orderItem);

            bool validateOrderDetail = await RecordController.validate(
                'Order_Details',
                newDataOrderItem,
                MainController.getInfoTable('Order_Details'));
            validatorOrderDetailList.add(validateOrderDetail);
          }
          if (validatorOrderDetailList.length != 0) {
            if (validatorOrderDetailList.every((e) => !e)) {
              await DB('${tableName}')
                  .parent(
                  parentId: '${ViewCustomController.order['customer']}',
                  parentTable: 'user')
                  .storeRecord(ViewCustomController.order);
              var orderId = ConncetServerController.storeRecordRes['_id'];
              for (var orderItem in OrderItem.orderItemsList.values.toList()) {
                await DB('Order_Details')
                    .parent(parentId: '${orderId}', parentTable: '${tableName}')
                    .storeRecord(orderItem);
              }
            }
          } else {
            showSnackbar(snackTypes.error, 'لطفا جزئیات سفارش را وارد کنید...');
          }
        }

        await MainController.loadData(
            tableData: MainController.getInfoTable('order'));
      }
      else {
        await MainController.loadData(
            tableData: MainController.getInfoTable(''));
      }
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
      var orderList = [];
      if (tableName == 'order') {
        print(
            'MainController.tableData relation orders>>>${MainController.dataRecord}');
        orderList = await DB('${table['schema']['name']}')
            .parent(
            parentId: MainController.dataRecord[index]['_id'],
            parentTable: MainController.infoSchema.value.schema.name)
            .getRecords();

        print('order list>>>${orderList}');
      }
      if (tableName == 'Order_Details') {
        print(
            'MainController.tableData relation order_detail>>>${MainController.dataRecord}');
        print(
            'c1300>>>${await DB('Order_Details').parent(parentId: MainController.dataRecord[index]['_id'], parentTable: 'order').getRecords()}');
        var orderDetailsList = await DB('Order_Details')
            .parent(
            parentId: MainController.dataRecord[index]['_id'],
            parentTable: 'order')
            .getRecords();
        print('orderDetailsList>>>${orderDetailsList}');
      }
      await HelperController.goToTablePage(
        table,
        tableFields: MainController.getInfoTable(table['schema']['name']),
      );
      pageInateFunction();
      // var items = await DB('${table.schema.name}').parent(parentId: MainController.dataRecord[index]['_id'], parentTable: MainController.infoSchema.value.schema.name).getRecords();
      // await goToTablePage(table, tableFields: MainController.getInfoTable(table.schema.name), tableData: items);
    } else {
      print('HelperController.relationFunction>>${MainController.dataRecord[index]['_id']}');
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
      var response=[];
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
    TableModel table = MainController.getInfoTable(MainController.tableName.value);
    var tableName = table.schema.name;
    print('HelperController.editPageFunction>>>${table.schema.view}');
    if (table.schema.view == 'custom') {
      if (tableName== 'order') {
        List<dynamic> customerItems = await DB('user')
            .parent(parentTable: null, parentId: null)
            .getRecords();
        List<dynamic> productItems = await DB('product')
            .parent(parentTable: null, parentId: null)
            .getRecords();
        await Get.to(() => OrderEditPge(data: data, customerItems, productItems));
      }
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
      if (tableName == 'order') {
        await DB('${tableName}').where('_id', '\$eq', '${id}').deleteRecord();
        print('orderssssss delete ${id}');
      }
    } else {
      print('HelperController.deleteFunction>>$id');
      await DB('${tableName}').where('_id', '\$eq', '${id}').deleteRecord();
      // await pageInateFunction();
      // MainController.pageInfo[tableName.toString()]!.totalPage = await DB('${tableName}').infoPage();
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
      // MainController.allData.value = MainController.dataRecord.value;
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