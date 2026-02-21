import 'package:finance/Admin/Logic/Controllers/connect-server-controller.dart';
import 'package:finance/Admin/Logic/Controllers/record-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Helpers/utils/extensions.dart';
import 'package:finance/Admin/Logic/Models/columnModel.dart';
import 'package:finance/Admin/Logic/Models/tableModel.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/Admin/UI/Views/edit.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/Logic/Models/order-item.dart';
import 'package:finance/custom/UI/Components/Views/order-detail-page-custom/table-order-detail-page-custom.dart';
import 'package:finance/custom/UI/Components/Views/order-page-custom/table-page-custom.dart';
import 'package:finance/custom/UI/Components/Views/output-order-page-custom/table-output-order-page-custom.dart';
import 'package:finance/custom/UI/Components/page-custom/order/order-edit-info.dart';
import 'package:finance/custom/UI/Components/page-custom/order/order-edit.dart';
import 'package:finance/custom/UI/Components/page-custom/order/order-info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shamsi_date/shamsi_date.dart';
import 'package:uuid/uuid.dart';
import '../../../custom/UI/Components/page-custom/order/order-create.dart';
import '../../UI/Views/create.dart';
import '../../UI/Views/dashboard.dart';
import '../../UI/Views/table-page.dart';
import '../Models/dataModel.dart';
import '../Models/db.dart';
import 'app-controller.dart';
import 'main-controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';


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



  static createPageFunction(String tableName) async {
    var table = MainController.getInfoTable(tableName);
    if (table.schema.view == 'custom') {
      if(table.schema.name =='Orders'){
        await ViewCustomController.getAllReocord('Customer');
        await ViewCustomController.getAllReocord('Product');
        List<dynamic> customerItems= await DB('Customer').getRecords();
        List<dynamic> productItems= await DB('Product').getRecords();
        ViewCustomController.containers.value = <String, Widget >{}.obs;
        OrderItem.orderItemsList.value = <String, Map<String, dynamic>>{}.obs;
        ViewCustomController.order = {};
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
    if (table.schema.view == 'custom') {
      if(tableName == 'Orders') {
        if (ViewCustomController.order['Date'] == null) {
          ViewCustomController.order['Date'] = ViewCustomController.getDate(Jalali.now());
        }
        if(ViewCustomController.order['Input_Code'] == null){
          ViewCustomController.order['Input_Code'] = await ViewCustomController.saveOrderCode(Jalali.now());
        }
        if(ViewCustomController.order['Drawing_Number'] == null){
          ViewCustomController.order['Drawing_Number'] = await ViewCustomController.generateDrawingNumber();
        }
        if(ViewCustomController.order['Type'] == null){
          ViewCustomController.order['Type'] = MainController.getDetailsOfField('Orders' , 'Type').items.first['value'];
        }
        bool validate = await RecordController.validate('Orders', ViewCustomController.order , MainController.getInfoTable('Orders'));
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
              orderItem['Cut_Pattern'] = MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern').items.first['value'];
            }
            if(orderItem['Manufacturing_Difficulty'] == null){
              orderItem['Manufacturing_Difficulty'] = MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty').items.first['value'];
            }
            if(orderItem['Quantity'] == null){
              orderItem['Quantity'] = 1;
            }
            bool validateOrderDetail = await RecordController.validate('Order_Details', orderItem, MainController.getInfoTable('Order_Details'));
            validatorOrderDetailList.add(validateOrderDetail);
          }
          if(validatorOrderDetailList.length != 0){
            if(ViewCustomController.isShowAlert.value == false){
              if(validatorOrderDetailList.every((e) => !e)){
                await DB('${tableName}').parent(parentId: '${ViewCustomController.order['Customer']}',
                    parentTable: 'Customer').storeRecord(ViewCustomController.order);
                var orderId = ConncetServerController.storeRecordRes['_id'];
                for (var orderItem in OrderItem.orderItemsList.values.toList()) {
                  await DB('Order_Details').parent(
                      parentId: '${orderId}',
                      parentTable: '${tableName}').storeRecord(orderItem);
                }
                showSnackbar(snackTypes.success, 'عملیات با موفقیت انجام شد.');
                await Get.to(() => OrderInfo(table: table));
                // if(MainController.infoSchema.value.schema.name == 'Customer'){
                //   for (var i = 0; i < MainController.dataRecord.length; i++){
                //     ViewCustomController.goTableCustom(table: MainController.tableName.value,index: i);
                //   }
                // }
                // else if(MainController.infoSchema.value.schema.name == 'Orders'){
                //   HelperController.goToTablePage(table);
                // }
                // ViewController.isClickedBtn.value = false;
              }
            }
          }
          else{
            showSnackbar(snackTypes.error, '${AppController.of(Get.context!)!.value('Please enter the order details')}');
          }
        }

        await MainController.loadData(
            tableData: MainController.getInfoTable('Orders'));
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

      // await MainController.loadData(tableData: MainController.getInfoTable('${MainController.infoSchema.value.schema.name}'));
      // if (ViewController.isClickedBtn.value == false) {
      //  goToTablePage(table, loadData: false);
      // }
      if (ViewController.isClickedBtn.value == false) {
        HelperController.goToTablePage(table, loadData: false);
      }
    }

  }

  static relationFunction({var table = null, var index}) async {
    table = MainController.getInfoTable('${MainController.tableName.value}');
    var tableName = table.schema.name;
    print('HelperController.relationFunction>>>${tableName}');
    if (table.schema.view == 'custom') {
      // pageInateFunction();
      ViewCustomController.customerId.value = MainController.dataRecord.value[index]['_id'];
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
      if(tableName == 'Orders') {
        if (request['Date'] == null) {
          request['Date'] = ViewCustomController.getDate(Jalali.now());
        }
        if(request['Type'] == null){
          request['Type'] = MainController.getDetailsOfField('Orders' , 'Type').items.first['value'];
        }
        Map<String, dynamic> result = {};
        print('OrderItem.orderItemsList.value for result>>>${OrderItem.orderItemsList.value}');
        print('OrderItem.orderItemsList2.value for result>>>${OrderItem.orderItemsList2.value}');
        result.addAll(OrderItem.orderItemsList.value);
        result.addAll(OrderItem.orderItemsList2.value);
        print('result of order item>>>${result}');
        bool validate = await RecordController.validate('Orders', request , MainController.getInfoTable('Orders'));
        if(validate == false){
          List<bool> validatorOrderDetailList=[];
          for (var i = 0; i < result.values.toList().length; i++) {
            var orderItem = result.values.toList()[i];
            if(orderItem['Cut_Pattern'] == null){
              orderItem['Cut_Pattern'] = MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern').items.first['value'];
            }
            if(orderItem['Manufacturing_Difficulty'] == null){
              orderItem['Manufacturing_Difficulty'] = MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty').items.first['value'];
            }
            if(orderItem['Quantity'] == null){
              orderItem['Quantity'] = 1;
            }
            bool validateOrderDetail = await RecordController.validate('Order_Details', orderItem, MainController.getInfoTable('Order_Details'));
            validatorOrderDetailList.add(validateOrderDetail);
          }
          if(validatorOrderDetailList.length != 0){
            if(ViewCustomController.isShowAlert.value == false){
              if(validatorOrderDetailList.every((e) => !e)){
                request['parent_id'] = request['Customer']['_id'];
                await DB('${tableName}').where('_id', '\$eq', '${request['_id']}').updateRecords(request);
                var orderId = request['_id'];
                List<dynamic> orderDetailItems = await ViewCustomController.getDataOrderDetailList('${orderId}');
                final formIds = result.values
                    .where((e) => e['_id'] != null)
                    .map((e) => e['_id'])
                    .toSet();
                for (var orderDetail in orderDetailItems) {
                  if (!formIds.contains(orderDetail['_id'])) {
                    await DB('Order_Details').where('_id', '\$eq', '${orderDetail['_id']}').deleteRecord();
                  }
                }
                for (var orderItem in result.values.toList()) {
                  if(orderItem['_id'] == null){
                    await DB('Order_Details').parent(parentId: '${orderId}', parentTable: '${tableName}').storeRecord(orderItem);
                  }
                  else{
                    await DB('Order_Details').where('_id', '\$eq', '${orderItem['_id']}').updateRecords(orderItem);
                  }
                }
                await Get.to(() => OrderEditInfo(table: table , data: request, ));
                // if(MainController.infoSchema.value.schema.name == 'Customer'){
                //   for (var i = 0; i < MainController.dataRecord.length; i++){
                //     ViewCustomController.goTableCustom(table: MainController.tableName.value,index: i);
                //   }
                // }
                // else if(MainController.infoSchema.value.schema.name == 'Orders'){
                //   HelperController.goToTablePage(table);
                // }
                // ViewController.isClickedEditBtn.value = false;
              }
            }
          }
          else{
            showSnackbar(snackTypes.error, '${AppController.of(Get.context!)!.value('Please enter the order details')}');
          }

        }
        await MainController.loadData(
            tableData: MainController.getInfoTable('Orders'));

      }
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
      await MainController.loadData(
          tableData: MainController.getInfoTable('${MainController.infoSchema.value.schema.name}'));
      if (ViewController.isClickedEditBtn.value == false) {
      await HelperController.goToTablePage(table);
      }
    }
  }

  static editPageFunction(var data) async {
    var table = MainController.getInfoTable(MainController.tableName.value);
    var tableName = table.schema.name;
    print('HelperController.editPageFunction>>>${table.schema.view}');
    if (table.schema.view == 'custom') {
      if(tableName =='Orders'){
        await ViewCustomController.getAllReocord('Customer');
        await ViewCustomController.getAllReocord('Product');
        List<dynamic> customerItems= await DB('Customer').parent().getRecords();
        List<dynamic> productItems= await DB('Product').parent().getRecords();
        ViewCustomController.editContainers.value =<String, Widget>{}.obs;
        OrderItem.orderItemsList.value = <String, Map<String, dynamic>>{}.obs;
        OrderItem.orderItemsList2.value = <String, Map<String, dynamic>>{}.obs;
        await Get.to(() => OrderEditPge(data: data ,  customerItems, productItems));
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
      if(tableName == 'Orders'){
        await DB('${tableName}').where('_id', '\$eq', '${id}').deleteRecord();
        await pageInateFunction();
      }
    } else {
      print('HelperController.deleteFunction>>$id');
      await DB('${tableName}').where('_id', '\$eq', '${id}').deleteRecord();
      await pageInateFunction();
      // MainController.pageInfo[tableName.toString()]!.totalPage = await DB('${tableName}').infoPage();
    }
    Navigator.pop(Get.context!);
  }
  //
  // static deleteFunction(var id) async {
  //
  //   var table = MainController.getInfoTable(MainController.tableName.value);
  //   var tableName = table.schema.name;
  //   if (table.schema.view == 'custom') {
  //     if(tableName == 'Orders'){
  //       await DB('${tableName}').where('_id', '\$eq', '${id}').deleteRecord();
  //     }
  //   } else {
  //     await DB('${tableName}').where('_id', '\$eq', '${id}').deleteRecord();
  //     await pageInateFunction();
  //     // MainController.tableData.value =
  //     // await DB('${tableName}').paginate();
  //     MainController.pageInfo[tableName.toString()]!.totalPage = await DB('${tableName}').infoPage();
  //   }
  //   Navigator.pop(Get.context!);
  // }
  static goToTablePage(TableModel table, {bool loadData = true, var tableFields = null, var tableData = null}) async {
    String tableName = table.schema.name!;
    if (table.schema.view == 'custom'){
      if(tableName == 'Orders'){
        await MainController.loadData(
            tableData: MainController.getInfoTable('Orders'),
        );
        for (var row in MainController.dataRecord){
          String id = row['_id'];
          ViewCustomController.quantities[id] = await ViewCustomController.calculateTotalQuantity(id);
          ViewCustomController.areas[id] = await ViewCustomController.calculateTotalArea(id);
        }
        await Navigator.push(
            Get.context!, MaterialPageRoute(builder: (context) => TablePageOrderCustom(table)));
        await HelperController.pageInateFunction();
      }
      if(tableName == 'Order_Details'){
        await HelperController.pageInateFunction();
        MainController.dataRecord.value = tableData;

        Navigator.push(
            Get.context!, MaterialPageRoute(builder: (context) =>  TablePageOrderDetailCustom(table)));

      }
      if(tableName == 'Order_Output'){
        ViewCustomController.orderDetailsSelected.value ={};
        ViewCustomController.ordersSelected.value={};
        ViewCustomController.allOrdersSelected.value = [];
        MainController.infoSchema.value.schema.currentPage = 1;
        ViewCustomController.isClickedBtnRegister.value = false;
        List<dynamic> ordersList = await DB('Orders').getRecords();
        await ViewCustomController.getStatusOutPutOrders(ordersList);
        await MainController.loadData(tableData: MainController.getInfoTable('Orders'));
        MainController.pageInfo[table.schema.name!]?.totalPage = await DB('Orders').infoPage();
        Navigator.push(Get.context!, MaterialPageRoute(builder: (context) => TablePageOutPutOrderCustom()));
      }
    }
    else {
      if (loadData == true)
        await MainController.loadData(tableData: tableFields, tableDataItems: tableData);
      MainController.infoSchema.value.schema.currentPage = 1;
      MainController.pageInfo[table.schema.name!]?.totalPage = await DB('${MainController.infoSchema.value.schema.name}').infoPage();
      await Get.to(() => TablePage());
    }
    print('MainController.pageInfo>>>${MainController.pageInfo}');
  }

  static pageInateFunction() async {
    var table = MainController.getInfoTable(MainController.tableName.value);
    MainController.infoSchema.value = table;
    var tableName = table.schema.name;
    if (table.schema.view == 'custom') {
      if(tableName == 'Orders'){
        if(MainController.menuList[MainController.selectedSubItem.value].schema.name! == 'Customer'){
          MainController.dataRecord.value = await DB('${tableName}').parent(parentId: '${ViewCustomController.customerId.value}', parentTable: 'Customer').getRecords();
        }
        else{
          MainController.dataRecord.value = await DB('${tableName}').getRecords();
        }
        MainController.allData.value = MainController.dataRecord.value;
        for (var row in MainController.dataRecord){
          String id = row['_id'];
          ViewCustomController.quantities[id] = await ViewCustomController.calculateTotalQuantity(id);
          ViewCustomController.areas[id] = await ViewCustomController.calculateTotalArea(id);
        }
      }
      else if(tableName == 'Order_Details'){
      }
      if(tableName == 'Order_Output'){
        // print('_TableFooterState.box currentPage>>>>${ MainController.infoSchema.value.schema.name}>>${ MainController.infoSchema.value.schema.currentPage}');
        // print('ViewCustomController.ordersSelected.length>>>${ViewCustomController.ordersSelected.length}');
        if(ViewCustomController.ordersSelected.length != 0 && ViewCustomController.isClickedBtnRegister.value == true){
          MainController.dataRecord.value = [].obs;
          for(var orderDetail in ViewCustomController.getOrderDetailsOrderSelectedList()){
            MainController.dataRecord.add(orderDetail);
          }
          ViewCustomController.updatePagenationInOutPutOrderItems();



          // MainController.dataRecord.value = await DB('${tableName}').paginate();
        }
        else{
          List<dynamic> ordersList = await DB('Orders').getRecords();
          await ViewCustomController.getStatusOutPutOrders(ordersList);
          MainController.dataRecord.value = await DB('Orders').paginate();
          MainController.allData.value = MainController.dataRecord.value;
        }
      }
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
    Jalali baseDate = searchDate.toJalai() as Jalali;
    Jalali date = dataDate.toJalai() as Jalali;
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