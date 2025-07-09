import 'dart:convert';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/record-controller.dart';
import 'package:finance/Admin/Public/api-urls.dart';
import 'package:get/get.dart';
import '../Helpers/api-methods.dart';
import '../Models/db.dart';

class ConncetServerController extends GetxController {

  static Map<String, dynamic>storeRecordRes={};
  static Map<String, dynamic>updateRecordRes={};
  static List<Map<String, dynamic>>filterRecordRes=[];
  static bool deleteRecordRes=false;
  static List<dynamic>getRecordRes=[];



  static storeRecordGeneral (var json) async {
    var response = await RestApi.post(storeRecordUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          storeRecordRes={};
          storeRecordRes=response!.data['data'];
        },printResponse: true);
    // AppController.finishLoading('store-record');
    // AppController.finishLoading('get-records');
  }

  static updateRecordGeneral(var json) async {
    var response = await RestApi.post(updateRecordUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          updateRecordRes={};
          updateRecordRes=response!.data['data'];
        },printResponse: true);
    // AppController.finishLoading('update-records');
    // AppController.finishLoading('get-records');
  }

  static getRecordGeneral(var tableName) async {
    var info=await MainController.getInfoTable(tableName);

    var perPage=info['countShowRow'];
    var currentPage=info['currentPage'];
    var response = await RestApi.post(getRecordsUrl, body:( {'table_name':tableName,
      'pageNumber':currentPage.toString(),
      'perPage':perPage.toString()})
    );
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getRecordRes=[];
          getRecordRes=response!.data['data']['data'];
          MainController.tableData.value=response.data['data']['data'];
          print('ConncetServerController.getRecordGeneral>>${MainController.tableData.value}');
        },printResponse: true);
    // AppController.finishLoading('get-records');
  }

  static createJsonFilter(var wheres,String tableName,String type){
    List<dynamic>l=[];
    Map<String,dynamic> c={};
    Map<String,dynamic> body ={};
    body.addAll({
        'table_name':tableName,
        'type':type,
      });
    for(Where item in wheres.values){
      l.add({'column':'${item.fieldName}','operation': "${item.oprator!=null?item.oprator:"\$eq"}",'value': "${item.value}"});
      }
    body.addAll({
        'filter':json.encode(l),
      });
    return body;
  }

  static filterRecordGeneral(var wheres,String tableName,String type) async {
    var json=createJsonFilter(wheres, tableName,type);
    var response = await RestApi.post(filterRecordsUrl, body: json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          filterRecordRes=response!.data['data'].cast<Map<String, dynamic>>();
        },printResponse: true);
  }

  static deleteRecordGeneral(var json) async {
    var response = await RestApi.post(deleteRecordUrl, body: json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          deleteRecordRes=true;
        },printResponse: true,errorCallback:()=> deleteRecordRes=false);
    // AppController.finishLoading('delete-record');
    // AppController.finishLoading('get-records');
  }

  static addSyncField(Map<dynamic,dynamic> json,bool status){
    return json.addAll(RecordController.syncFunction(status));
  }

  static setDatabaseme(Map<dynamic,dynamic> json) async {
    // print('ConncetServerController.setDatabaseme>>${json}');
    // var response = await RestApi.post(storeUrl, body: json);
    // RestApi.responseHandler(
    //     response: response,
    //     successCallback: () async {
    //       addSyncField(json, true);
    //       print('addSyncField >>>${json}');
    //     },printResponse: true,errorCallback: (){
    //   addSyncField(json, false);
    // });
  }
}