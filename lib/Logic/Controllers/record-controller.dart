import 'package:finance/Logic/Controllers/helper-controller.dart';
import 'package:finance/Logic/Controllers/validator-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/UI/Views/create.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../UI/Views/table-page.dart';
import '../Models/dataModel.dart';
import 'dataController.dart';
import 'main-controller.dart';
import 'package:finance/boxes.dart';

class RecordController extends GetxController {
  static Future<bool> validate(String tableName, DataModel newData) async {
    bool isValidator;
    List<bool> isValidatorList = [];
    var columns = ViewController.getColumnList(tableName);
    for (var j = 0; j < columns.length; j++) {
      // var column= MainController.tableInfo['columns'][j];
      // String name = column['name'];
      // dataJson[name] == '' || dataJson[name] == null
      // print('columns validate>>>${name}>>${newData.data[name]}');
      isValidator = await ValidatorController.checkInputValidation(j, newData.data);
      isValidatorList.add(isValidator);
    }
    print('isValidatorList>>>${ newData.data}');
    bool isExsistsValidation = isValidatorList.contains(false);
    if (isExsistsValidation) {
      isValidatorList = [];
      return true;
    } else {
      return false;
    }
  }

  static updateRecordByEcel(
      var excelJson, var recordIndex, var primeColumn) async {
    DataModel existingData = MainController.tableData.value[recordIndex];
    existingData.data = excelJson;
    await box.putAt(recordIndex, existingData);
    dataController.allData.value[recordIndex] = existingData;
  }

  static storeRecordByEcel(var excelJson) async {
    var id = Uuid().v4();
    excelJson.remove('id');
    DataModel newData = DataModel(
      id: '${id}',
      data: excelJson,
    );
    await box.add(newData);
    dataController.allData.value.add(newData);
    await MainController.loadData();
    MainController.renderPagination();
  }

  // static storeRecord(String tableName, Map<String, dynamic> request) async {
  //   print('store record>>>${request}');
  //   Box box = await Hive.openBox<DataModel>('${tableName}');
  //
  //   ViewController.isClickedBtn.value = true;
  //   var Id = Uuid().v4();
  //   DataModel newData = DataModel(id: '${Id}', data: request);
  //   var beforValidate = HelperController.beforeStoreValidation(newData);
  //   if (beforValidate['status'] == false) {
  //     showSnackbar(snackTypes.error, beforValidate['message']);
  //   } else {
  //     print('validate record>>>${await validate(tableName, newData)}');
  //
  //     if (await validate(tableName, newData) == false) {
  //       var before = await HelperController.beforeStore(newData);
  //       if (before['status'] == false) {
  //         showSnackbar(snackTypes.error, before['message']);
  //       } else {
  //         var customData = await HelperController.beforeStore(newData)['data'];
  //         await box.add(customData);
  //         dataController.allData.value.add(customData);
  //         await MainController.loadData();
  //         MainController.renderPagination();
  //         var afterData =
  //             await HelperController.afterStore(request, customData);
  //         if (afterData['status'] == false) {
  //           showSnackbar(snackTypes.error, afterData['message']);
  //         }
  //         ViewController.isClickedBtn.value = false;
  //         request = {};
  //         Get.to(() => CreatePage( ));
  //
  //       }
  //     }
  //   }
  // }

  // static updateRecord( Map<String, dynamic> request,
  //     DataModel data, int index) async {
  //   final record = DataModel(
  //     id: data.id,
  //     data:request,
  //   );
  //   var beforeValidate = await HelperController.beforeUpdateValidation(record);
  //   if (beforeValidate['status'] == false) {
  //     showSnackbar(snackTypes.error, beforeValidate['message']);
  //   } else {
  //     if (await validate(tableName,record) == false) {
  //       var before = await HelperController.beforeUpdate(record);
  //       if (before['status'] == false) {
  //         showSnackbar(snackTypes.error, before['messsage']);
  //       } else {
  //         var customUpdate =
  //             await HelperController.beforeUpdate(record)['data'];
  //         dataController.allData.value[index] = customUpdate;
  //         MainController.tableData.value[index] = customUpdate;
  //         await box.putAt(index, customUpdate);
  //         MainController.isClickedItem.value = true;
  //         var after = await HelperController.afterStore(data, customUpdate);
  //         if (after['status'] == false) {
  //           showSnackbar(snackTypes.error, after['message']);
  //         }
  //         Get.to(() => TablePage());
  //       }
  //     }
  //   }
  // }

  static deleteRecord(int index) async {
    var data = MainController.tableData.value[index];
    var before = await HelperController.beforeDelete(index);
    if (before['status'] == false) {
      showSnackbar(snackTypes.error, before['message']);
    } else {
      box.deleteAt(index);
      MainController.tableData.value.removeAt(index);
      await MainController.loadData();
      MainController.renderPagination();
      var after = HelperController.afterDelete(index, data);
      if (after['status'] == false) {
        showSnackbar(snackTypes.error, after['message']);
      }
      Navigator.pop(Get.context!);
    }
  }
}
