import 'package:finance/Logic/Controllers/helper-controller.dart';
import 'package:finance/Logic/Controllers/validator-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/UI/Componenets/Popups/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../UI/Views/table-page.dart';
import '../Models/dataModel.dart';
import 'dataController.dart';
import 'main-controller.dart';
import 'package:finance/boxes.dart';

class RecordController extends GetxController {
  static bool validate(Map<String , dynamic> dataJson,DataModel newData) {
    bool isValidator;
    List<bool> isValidatorList=[];
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      isValidator = ValidatorController.checkInputValidation(j,newData.data);
      isValidatorList.add(isValidator);
    }
    bool isExsistsValidation = isValidatorList.contains(false);
    if(isExsistsValidation){
      isValidatorList=[];
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
    ViewController.isClickedCreateBtn.value = true;
    var Id =Uuid().v4();
    DataModel newData = DataModel(
        id: '${Id}',
        data: ViewController.request
    );
    var beforValidate=HelperController.beforeStoreValidation(newData);
    if(beforValidate['status']==false){
      showSnackbar(snackTypes.error, beforValidate['message']);
    }
    else{
      if(validate(dataJson, newData)==false){
       var before= await HelperController.beforeStore(newData);
        if(before['status']==false){
          showSnackbar(snackTypes.error, before['message']);
        }
        else{
          var customData=await HelperController.beforeStore (newData)['data'];
          await box.add(customData);
          dataController.allData.value.add(customData);
          await MainController.loadData();
          MainController.renderPagination();
          var afterData=await HelperController.afterStore(dataJson,customData);
          if(afterData['status']==false){
            showSnackbar(snackTypes.error, afterData['message']);
          }
          Get.to(() => TablePage());
        }

      }
    }

  }



  static updateRecord( DataModel data,int index) async {
    final record = DataModel(
      id: data.id,
      data: ViewController.request,
    );
    var beforeValidate=await HelperController.beforeUpdateValidation(record);
    if(beforeValidate['status']==false){
      showSnackbar(snackTypes.error, beforeValidate['message']);
    }
    else{
      print('validate>>>${validate(record.data, record)}');
      if(validate(record.data, record)==false){
       var before= await HelperController.beforeUpdate(record);
        if(before['status']==false){
          showSnackbar(snackTypes.error, before['messsage']);
        }else{
          var customUpdate=await HelperController.beforeUpdate(record)['data'];
          dataController.allData.value[index] =  customUpdate;
          MainController.tableData.value[index] = customUpdate;
          await box.putAt(index,customUpdate);
          MainController.isClickedItem.value = true;
          var after=await HelperController.afterStore(data,customUpdate);
          if(after['status']==false){
            showSnackbar(snackTypes.error,after['message'] );
          }
          Get.to(() => TablePage());
        }
      }

    }


  }



  static deleteRecord(int index) async {
    var data=MainController.tableData.value[index];
    var before=await HelperController. beforeDelete(index);
    if(before['status']==false){
      showSnackbar(snackTypes.error,before['message'] );
    }
    else{
      box.deleteAt(index);
      MainController.tableData.value.removeAt(index);
      await MainController.loadData();
      MainController.renderPagination();
      var after=HelperController.afterDelete(index, data);
      if(after['status']==false){
        showSnackbar(snackTypes.error,after['message'] );
      }
      Navigator.pop(Get.context!);
    }

  }

}