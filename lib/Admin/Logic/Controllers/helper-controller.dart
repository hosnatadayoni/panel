import 'package:finance/Admin/Logic/Controllers/connect-server-controller.dart';
import 'package:finance/Admin/Logic/Controllers/record-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/Admin/UI/Views/edit.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/UI/Components/Views/table-page-custom.dart';
import 'package:finance/custom/UI/Components/page-custom/order/order-create.dart';
import 'package:finance/custom/UI/Components/page-custom/order/order-edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import '../../UI/Views/create.dart';
import '../../UI/Views/dashboard.dart';
import '../../UI/Views/table-page.dart';
import '../Models/dataModel.dart';
import '../Models/db.dart';
import 'app-controller.dart';
import 'main-controller.dart';
import 'package:finance/custom/Logic/Models/order-item.dart';

class HelperController extends GetxController {
  //store
  static beforeStore(DataModel newData) {
    return AppController.responceHelper(newData, true);
  }

  static beforeStoreValidation(DataModel newData) {
    return AppController.responceHelper(newData, true);
  }

  static afterStore(String tableName, dataJson, DataModel customData) async {
    if (tableName == 'Order') {
      if (OrderItem.orderItemsList.length != 0) {
        // for (var key in OrderItem.orderItemsList.keys) {
        //   OrderItem.orderItemsList[key] = {...OrderItem.orderItemsList[key]!, 'سفارش': customData.id};
        // }
        for (var list in OrderItem.orderItemsList.values) {
          // await DB('order-itemss').parent(parentTable: 'order',parentId: customData.id!).storeRecord(list);
          await DB('Order_Details')
              .parent(parentTable: 'Order', parentId: customData.id!)
              .storeRecord(list);
        }
      }
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
  static backFunction() async {
    // print('HelperController.backFunction>>${ MainController.SubMenuList}');
    var index = MainController.SubMenuList.indexWhere((element) => element['schema']['relations']!=null?element['schema']['relations'].any((element)
    {
                return element == MainController.tableName.value;
    }):element==null);
    if (index != -1) {

      MainController.selectedSubItem.value = index;
      MainController.tableName.value = MainController.SubMenuList[index]['schema']['name'];
      var indexNew = MainController.SubMenuList.indexWhere((element) => element['schema']['name'] == MainController.tableName.value);
      var table = MainController.getInfoTable(MainController.tableName.value);
      MainController.tableInfo.value = table;
      if (table['view'] == 'custom') {
        MainController.endIndex.value = 0;
        MainController.startIndex.value = 0;
      }
      else {
        MainController.tableData.value =
        await DB('${MainController.tableName.value}').paginate();
        MainController.allData.value = MainController.tableData;
        await Get.to(() => TablePage());

      }
      // Navigator.push(Get.context!, MaterialPageRoute(builder: (context)=>TablePage()));
      // await MainController.goToTablePage(MainController.SubMenuList[index]);
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
      if(table['schema']['name'] =='Orders'){
        List<dynamic> customerItems= await DB('Customer').getRecords();
        List<dynamic> productItems= await DB('Product').getRecords();
        ViewCustomController.containers.value = <String, Widget>{}.obs;
        OrderItem.orderItemsList.value = <String, Map<String, dynamic>>{}.obs;
        await Get.to(() => OrderCreatePage(tableName , customerItems , productItems));
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
      if(tableName == 'Orders') {

        if (ViewCustomController.order['Date'] == null) {
          ViewCustomController.order['Date'] = ViewCustomController.getDate(Jalali.now());
        }
        if(ViewCustomController.order['Type'] == null){
          ViewCustomController.order['Type'] = MainController.getDetailsOfField('Orders' , 'Type')['items'].first['value'];
        }
        if(ViewCustomController.order['Customer'] == null){
          List<dynamic> customerItems= await DB('Customer').getRecords();
          ViewCustomController.order['Customer'] = customerItems.first['_id'];
        }

        var Id = Uuid().v4();
        DataModel newData = DataModel(
            id: '${Id}',
            data: ViewCustomController.order);
        bool validate = await RecordController.validate('Orders', newData , MainController.getInfoTable('Orders'));
        if(validate == false){

          List<bool> validatorOrderDetailList=[];
          for (var i = 0; i < OrderItem.orderItemsList.values.toList().length; i++) {
            var orderItem = OrderItem.orderItemsList.values.toList()[i];

            if (orderItem['First_Dimension'] != null) {
              orderItem['First_Dimension'] =
                  (orderItem['First_Dimension'] as num).toDouble();
            }
            if (orderItem['Second_Dimension'] != null) {
              orderItem['Second_Dimension'] =
                  (orderItem['Second_Dimension'] as num).toDouble();
            }
            if(orderItem['Cut_Pattern'] == null){
              orderItem['Cut_Pattern'] = MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern')['items'].first['value'];
            }
            if(orderItem['Manufacturing_Difficulty'] == null){
              orderItem['Manufacturing_Difficulty'] = MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty')['items'].first['value'];
            }
            if(orderItem['Product_Name'] == null){
              List<dynamic> productItems= await DB('Product').getRecords();
              orderItem['Product_Name'] = productItems.first['_id'];
            }
            var Id = Uuid().v4();
            DataModel newDataOrderItem = DataModel(
                id: '${Id}',
                data: orderItem);

            bool validateOrderDetail = await RecordController.validate('Order_Details', newDataOrderItem, MainController.getInfoTable('Order_Details'));
            validatorOrderDetailList.add(validateOrderDetail);
          }
          if(validatorOrderDetailList.length != 0){
            if(validatorOrderDetailList.every((e) => !e)){
              await DB('${tableName}').parent(parentId: '${ViewCustomController.order['Customer']}',
                  parentTable: 'Customer').storeRecord(ViewCustomController.order);
              var orderId = ConncetServerController.storeRecordRes['_id'];
              for (var orderItem in OrderItem.orderItemsList.values.toList()) {
                await DB('Order_Details').parent(
                    parentId: '${orderId}',
                    parentTable: '${tableName}').storeRecord(orderItem);
              }
            }
          }
          else{
            showSnackbar(snackTypes.error, 'لطفا جزئیات سفارش را وارد کنید...');
          }
        }

          await MainController.loadData(
              tableData: MainController.getInfoTable('Orders'));
      }

    } else {
      Map<String, dynamic> parent = await DB.parentItem;
      if (parent.containsKey(MainController.tableInfo['schema']['name'])&&parent[MainController.tableInfo['schema']['name']].length == 0) {
        await DB('${MainController.tableInfo['schema']['name']}')
            .storeRecord(ViewController.request);
      } else {
        await DB('${MainController.tableInfo['schema']['name']}')
            .parent(
            parentTable: '${parent['parent_table']}',
            parentId: '${parent['parent_id']}')
            .storeRecord(ViewController.request);
      }
      await MainController.loadData(
          tableData: MainController.getInfoTable('${MainController.tableInfo['schema']['name']}'));
      if (ViewController.isClickedBtn.value == false) {
        MainController.goToTablePage(table, loadData: false);
      }
    }
  }

  static relationFunction({var table = null, var index}) async {
    table = MainController.getInfoTable('${MainController.tableName.value}');
    var tableName = table['schema']['name'];
    if (table['schema']['view'] == 'custom') {
      var orderList=[];
      if(tableName == 'Orders'){
        orderList = await DB('${table['schema']['name']}')
            .parent(
            parentId: MainController.tableData[index]['_id'],
            parentTable: MainController.tableInfo['schema']['name'])
            .getRecords();

      }
      if(tableName == 'Order_Details'){
        var orderDetailsList = await ViewCustomController.getDataOrderDetailList(MainController.tableData[index]['_id']);
      }
      await MainController.goToTablePage(table,
          tableFields: MainController.getInfoTable(table['schema']['name']),);
      pageInateFunction();
    } else {
      // DB.parentItem = {
      //   'parent_id': MainController.tableData[index]['_id'],
      //   'parent_table': MainController.tableInfo['schema']['name']
      // };
      var items = await DB('${table['schema']['name']}')
          .parent(
          parentId: MainController.tableData[index]['_id'],
          parentTable: MainController.tableInfo['schema']['name'])
          .getRecords();


      await MainController.goToTablePage(table,
          tableFields: MainController.getInfoTable(table['schema']['name']),
          tableData: items);
    }
  }

  static tablePageFunction({var table = null}) async {
    var tabeleInfo =
    MainController.getInfoTable(MainController.tableName.value);
    await pageInateFunction();
    RxMap<String, int> totalQuantities = <String, int>{}.obs;
    if(table['schema']['name'] == 'Orders'){
      Navigator.push(
          Get.context!, MaterialPageRoute(builder: (context) => TablePageCustom()));
    }
    if(table['schema']['name'] == 'Order_Details'){
      Navigator.push(
          Get.context!, MaterialPageRoute(builder: (context) => TablePage()));
    }

  }

  static editFunction (String tableName,
      {var request = null, var id = null}) async {

    var table = MainController.getInfoTable(MainController.tableName.value);
    tableName = table['schema']['name'];

    if (table['schema']['view'] == 'custom') {
      if(tableName == 'Orders') {

        if (request['Date'] == null) {
          request['Date'] = ViewCustomController.getDate(Jalali.now());
        }
        if(request['Type'] == null){
          request['Type'] = MainController.getDetailsOfField('Orders' , 'Type')['items'].first['value'];
        }
        if(request['Customer'] == null){
          List<dynamic> customerItems= await DB('Customer').getRecords();
          request['Customer'] = customerItems.first['_id'];
        }
        Map<String, dynamic> result = {};
        result.addAll(OrderItem.orderItemsList);
        result.addAll(OrderItem.orderItemsList2);

        var Id = Uuid().v4();
        DataModel newData = DataModel(
            id: '${Id}',
            data: request);
        bool validate = await RecordController.validate('Orders', newData , MainController.getInfoTable('Orders'));
        if(validate == false){
          var Id = Uuid().v4();
          List<bool> validatorOrderDetailList=[];
          for (var i = 0; i < result.values.toList().length; i++) {
            var orderItem = result.values.toList()[i];
            if(orderItem['Cut_Pattern'] == null){
              orderItem['Cut_Pattern'] = MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern')['items'].first['value'];
            }
            if(orderItem['Manufacturing_Difficulty'] == null){
              orderItem['Manufacturing_Difficulty'] = MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty')['items'].first['value'];
            }
            if(orderItem['Product_Name'] == null){
              List<dynamic> productItems= await DB('Product').getRecords();
              orderItem['Product_Name'] = productItems.first['_id'];
            }
            DataModel newDataOrderItem = DataModel(
                id: '${Id}',
                data: orderItem);

            bool validateOrderDetail = await RecordController.validate('Order_Details', newDataOrderItem, MainController.getInfoTable('Order_Details'));
            print('validateOrderDetail>>>${validateOrderDetail}');
            validatorOrderDetailList.add(validateOrderDetail);
          }
          if(validatorOrderDetailList.length != 0){
            if(validatorOrderDetailList.every((e) => !e)){
              request['parent_id'] = request['Customer']['_id'];
              await DB('${tableName}').where('_id', '\$eq', '${request['_id']}').updateRecords(request);
              var orderId = request['_id'];
              for (var orderItem in result.values.toList()) {
                if(orderItem['_id'] == null){
                  await DB('Order_Details').parent(parentId: '${orderId}', parentTable: '${tableName}').storeRecord(orderItem);
                }
                else{
                  await DB('Order_Details').where('_id', '\$eq', '${orderItem['_id']}').updateRecords(orderItem);
                }

              }
              MainController.goToTablePage(table);
              ViewController.isClickedEditBtn.value = false;
            }

          }
          else{
            showSnackbar(snackTypes.error, 'لطفا جزئیات سفارش را وارد کنید...');
          }
        }

        // await MainController.loadData(
        //     tableData: MainController.getInfoTable('Orders'));
      }

    } else {
      await DB('${MainController.tableInfo['schema']['name']}')
          .where('_id', '\$eq', '${id}').updateRecords(request);
      // await MainController.loadData(
      //     tableData: MainController.getInfoTable('${MainController.tableInfo['schema']['name']}'));
      // if (ViewController.isClickedBtn.value == false) {
        // await MainController.goToTablePage(
        //     MainController.tableInfo['schema']['name']);
      // }
    }
  }

  static editPageFunction(var data) async {
    var table = MainController.getInfoTable(MainController.tableName.value);
    if (table['schema']['view'] == 'custom') {
      if(table['schema']['name'] =='Orders'){
        List<dynamic> customerItems= await DB('Customer').parent().getRecords();
        List<dynamic> productItems= await DB('Product').parent().getRecords();
        List orderDetailItems = await ViewCustomController.getDataOrderDetailList('${data['_id']}');
        ViewCustomController.editContainers.value =<String, Widget>{}.obs;
        await Get.to(() => OrderEditPge(data: data ,  customerItems, productItems));
      }

    } else {
      await Get.to(() => EditPage(data: data));
    }
  }

  static deleteFunction(var id) async {

    var table = MainController.getInfoTable(MainController.tableName.value);
    var tableName = table['schema']['name'];
    if (table['schema']['view'] == 'custom') {
      if(tableName == 'Orders'){
        await DB('${tableName}').where('_id', '\$eq', '${id}').deleteRecord();
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

  // static pageInateFunction() async {
  //   var table = MainController.getInfoTable(MainController.tableName.value);
  //   MainController.tableInfo = table;
  //   var tableName = table['schema']['name'];
  //   if (table['schema']['view'] == 'custom') {
  //     MainController.endIndex.value = 0;
  //     MainController.startIndex.value = 0;
  //
  //     //add
  //     if(table['view']=='custom'){
  //       MainController.endIndex.value = 0;
  //       MainController.startIndex.value = 0;
  //
  //
  //     }
  //     //end add
  //
  //   } else {
  //     MainController.tableData.value =
  //     await DB('${MainController.tableName.value}').paginate();
  //     MainController.allData.value = MainController.tableData.value;
  //   }
  // }

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
