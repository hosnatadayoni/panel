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
  static Future<bool> validate(String tableName, DataModel newData,var dataTable) async {
    print('new data7>>${newData.data}');

    bool isValidator;
    List<bool> isValidatorList = [];
    var columns = ViewController.getColumnList(tableName);
    print('new data8>>${newData.data}');

    for (var j = 0; j < columns.length; j++) {
      isValidator = await ValidatorController.checkInputValidation(j, newData.data,tableData: dataTable);
      isValidatorList.add(isValidator);
    }
    print('isValidatorList is>>>${ newData.data}');
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
    // dataController.allData.value[recordIndex] = existingData;
  }

  static storeRecordByEcel(var excelJson) async {
    var id = Uuid().v4();
    excelJson.remove('id');
    DataModel newData = DataModel(
      id: '${id}',
      data: excelJson,
    );
    await box.add(newData);
    // dataController.allData.value.add(newData);
    await MainController.loadData();
    MainController.renderPagination();
  }
}
