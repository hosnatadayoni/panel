import 'package:finance/Logic/Controllers/validator-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../UI/Views/table-page.dart';
import '../Models/dataModel.dart';
import 'app-controller.dart';
import 'dataController.dart';
import 'main-controller.dart';
import 'package:finance/boxes.dart';

class RecordController extends GetxController {
  static bool validate(Map<String , dynamic> dataJson,DataModel newData) {
    bool isValidator;
    List<bool> isValidatorList = [];
    List<String> isRequiredList = [];
    List<String> isRangeList = [];
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      isValidator = ValidatorController.checkInputValidation(j, newData.data);
      isValidatorList.add(isValidator);

      var column = MainController.tableInfo['columns'][j];
      if (column['validators'] != null) {
        var inputRequired = column['validators'].firstWhere((
            validator) => validator['type'] == 'required', orElse: () => null);
        var maxValidator = column['validators'].firstWhere((
            validator) => validator['type'] == 'max', orElse: () => null);
        var minValidator = column['validators'].firstWhere((
            validator) => validator['type'] == 'min', orElse: () => null);
        if (inputRequired != null) {
          if (inputRequired['type'] == 'required') {
            print('dataJson[column[name]]>>>>${dataJson[column['name']]}');
            if (dataJson[column['name']] == null ||
                dataJson[column['name']] == '') {
              isRequiredList.add('${column['name']}');
            }
          }
        }
        if (maxValidator != null && minValidator != null) {
          if (column['type'] == 'number') {
            var number;
            if (dataJson[column['name']] != null) {
              number = num.tryParse(dataJson[column['name']]);
            }
            if (number != null) {
              if (number < minValidator['value'] ||
                  number > maxValidator['value']) {
                isRangeList.add('${column['name']}');
              }
            }
          }
          else if (column['type'] == 'file') {}
        }
      }
    }
    bool isExsistsValidation = isValidatorList.contains(false);
    if (isExsistsValidation) {
      String requiredMessage = isRequiredList.isNotEmpty
          ? '${AppController.of(Get.context!)!.value(
          'Enter the fields')} ${isRequiredList.join(', ')} ${AppController.of(
          Get.context!)!.value('It is mandatory')} '
          : '';
      String rangeMessage = isRangeList.isNotEmpty
          ? '${AppController.of(Get.context!)!.value('fields')} ${isRangeList
          .join(', ')} ${AppController.of(Get.context!)!.value('is wrong')} '
          : '';
      isValidatorList = [];
      isRequiredList = [];
      isRangeList = [];
      return true;
    }
    else{
      return false;
    }
  }
  static updateRecordByEcel(var excelJson, var recordIndex, var primeColumn) async {
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

  static storeRecord(Map<String , dynamic> dataJson) async {
    ViewController.isShowMessage.value = true;
    var Id =Uuid().v4();
    DataModel newData = DataModel(
      id: '${Id}',
      data: dataJson,
    );
    beforeStoreValidation(newData);
    if(validate(dataJson, newData)==false){
      DataModel customData= beforeStore(newData);

      await box.add(customData);
      dataController.allData.value.add(customData);
      await MainController.loadData();
      MainController.renderPagination();
      afterStore(dataJson,customData);
      Get.to(() => TablePage());
    }
  }
  static beforeStore(DataModel newData){
    // Map<String,dynamic> result=<String,dynamic>{};
    // result['status']=true;
    // result['data']=newData;
    return newData;
  }
  static beforeStoreValidation(DataModel newData){
    return newData;
  }
  static afterStore(dataJson,DataModel customData){
    return customData;
  }

  static updateRecord( DataModel data,int index) async {
    final record = DataModel(
      id: data.id,
      data: data.data,
    );
    beforeUpdateValidation(record);
    print('validate>>>${validate(record.data, record)}');
    if(validate(record.data, record)==false){
      DataModel customUpdate=beforeUpdate(record);
      dataController.allData.value[index] =  customUpdate;
      await box.putAt(index,customUpdate);
      MainController.isClickedItem.value = true;
      afterStore(data,customUpdate);
      Get.to(() => TablePage());
    }

  }
  static beforeUpdate(DataModel newData){
    // Map<String,dynamic> result=<String,dynamic>{};
    // result['status']=true;
    // result['data']=newData;
    return newData;
  }
  static beforeUpdateValidation(DataModel newData){
    return newData;
  }
  static afterUpdate(dataJson,DataModel customData){
    return customData;
  }

  static deleteRecord(int index) async {
    var data=MainController.tableData.value[index];
    beforeDelete(index);
    box.deleteAt(index);
    MainController.tableData.value.removeAt(index);
    await MainController.loadData();
    MainController.renderPagination();
    afterDelete(index, data);
    Navigator.pop(Get.context!);
  }
  static beforeDelete(int index){
    return null;
  }  static afterDelete(int index,DataModel data){
    return data;
  }
}