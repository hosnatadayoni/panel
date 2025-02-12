import 'package:finance/Logic/Controllers/validator-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/UI/Componenets/Popups/snackbar.dart';
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
    var beforValidate=beforeStoreValidation(newData);
    if(beforValidate['status']==false){
      showSnackbar(snackTypes.error, beforValidate['message']);
    }
    else{
      if(validate(dataJson, newData)==false){
        await beforeStore(newData);
        if(beforeStore (newData)['status']==false){
          showSnackbar(snackTypes.error, beforeStore (newData)['message']);
        }
        else{
          var customData=beforeStore (newData)['data'];

          await box.add(customData);
          dataController.allData.value.add(customData);
          await MainController.loadData();
          MainController.renderPagination();
          var afterData=afterStore(dataJson,customData);
          if(afterData['status']==false){
            showSnackbar(snackTypes.error, afterData['message']);
          }
          Get.to(() => TablePage());
        }

      }
    }

  }
  static beforeStore(DataModel newData){
    newData.data['y']='123';
    print('responceHelper>>>${AppController.responceHelper(newData,true)}');
    return AppController.responceHelper(newData,true);
  }
  static beforeStoreValidation(DataModel newData){
    return AppController.responceHelper(newData,true);
  }
  static afterStore(dataJson,DataModel customData){
    return AppController.responceHelper(customData,true);
  }

  static updateRecord( DataModel data,int index) async {
    final record = DataModel(
      id: data.id,
      data: data.data,
    );
    var beforeValidate=beforeUpdateValidation(record);
    if(beforeValidate['status']==false){
      showSnackbar(snackTypes.error, beforeValidate['message']);
    }
    else{
      print('validate>>>${validate(record.data, record)}');
      if(validate(record.data, record)==false){
        await beforeUpdate(record);
        if(beforeUpdate(record)['status']==false){
          showSnackbar(snackTypes.error, beforeUpdate(record)['messsage']);
        }else{
          var customUpdate=beforeUpdate(record)['data'];
          dataController.allData.value[index] =  customUpdate;
          await box.putAt(index,customUpdate);
          MainController.isClickedItem.value = true;
          var after=afterStore(data,customUpdate);
          if(after['status']==false){
            showSnackbar(snackTypes.error,after['message'] );
          }
          Get.to(() => TablePage());
        }
      }

    }


  }
  static beforeUpdate(DataModel newData){
    return AppController.responceHelper(newData,true);
  }
  static beforeUpdateValidation(DataModel newData){
    return AppController.responceHelper(newData,true);
  }
  static afterUpdate(dataJson,DataModel customData){
    return AppController.responceHelper(customData,true);

  }

  static deleteRecord(int index) async {
    var data=MainController.tableData.value[index];
    var before= beforeDelete(index);
    if(before['status']==false){
      showSnackbar(snackTypes.error,before['message'] );
    }
    else{
      box.deleteAt(index);
      MainController.tableData.value.removeAt(index);
      await MainController.loadData();
      MainController.renderPagination();
      var after=afterDelete(index, data);
      if(after['status']==false){
        showSnackbar(snackTypes.error,after['message'] );
      }
      Navigator.pop(Get.context!);
    }

  }
  static beforeDelete(int index){
    return AppController.responceHelper(null,true);

  }  static afterDelete(int index,DataModel data){
    return AppController.responceHelper(data,true);
  }
}