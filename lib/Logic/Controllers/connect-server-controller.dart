import 'dart:convert';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/record-controller.dart';
import 'package:finance/Logic/Helpers/token-methods.dart';
import 'package:finance/Logic/Models/ServerModel/project.dart';
import 'package:finance/Public/api-urls.dart';
import 'package:get/get.dart';
import '../Helpers/api-methods.dart';
import '../Models/db.dart';

class ConncetServerController extends GetxController {

  static Map<String, dynamic>storeRecordRes={};
  static Map<String, dynamic>updateRecordRes={};
  static List<Map<String, dynamic>>filterRecordRes=[];
  static bool deleteRecordRes=false;
  static List<dynamic>getRecordRes=[];
  static createProject() async {
    var response = await RestApi.post(createProjectUrl, body: {'name':'panel'});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          Project project=Project.fromJson(response!.data['data']);
          Token.setToken(project.apiKey!);
        },printResponse: true);
  }

  static createSchema(Map<String,dynamic> json) async {
    var response = await RestApi.post(createSchemaUrl, body:json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
        },printResponse: true);
  }

  static deleteSchema(Map<String,dynamic> json) async {
    var response = await RestApi.post(deleteSchemaUrl, body:json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
        },printResponse: true);
  }

  static listSchema() async {
    var s=await Token.getToken();
    var response = await RestApi.post(listSchemaUrl, body:{'api_key':s});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
        },printResponse: true);
  }

  static storeRecordGeneral(var json) async {
    var response = await RestApi.post(storeRecordUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          storeRecordRes={};
          storeRecordRes=response!.data['data'];
        },printResponse: true);
  }

  static getRecordGeneral(String? tableName) async {
    var response = await RestApi.post(getRecordsUrl, body: {'table_name':tableName});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getRecordRes=[];
          getRecordRes=response!.data['data'];
          MainController.tableData.value=response!.data['data'];
          print('ConncetServerController.getRecordGeneral>>>${MainController.tableData.value}');
          // print('ConncetServerController.getRecordGeneral>>>${response!.data['data'].first.keys}');
          // MainController.tableInfo=
        },printResponse: true);
  }
  static updateRecordGeneral(var json) async {
    var response = await RestApi.post(updateRecordUrl, body: json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          updateRecordRes={};
          updateRecordRes=response!.data['data'];
          // print('ConncetServerController.getRecordGeneral>>>${response!.data['data'].first.keys}');
          // MainController.tableInfo=
        },printResponse: true);
  }
  static createJsonFilter(var wheres,String tableName){
    Map<String,dynamic>filter={};
    List<dynamic>l=[];
    Map<String,dynamic> c={};
         Map<String,dynamic> body ={};
    body.addAll({
        'table_name':tableName,
      });
      for(Where item in wheres.values){
        c.addAll({'${item.fieldName}': {"${item.oprator!=null?item.oprator:"\$eq"}": "${item.value}"}
        });
      }
    body.addAll({
        'filter':(json.encode(c)).toString(),
      });
      print('MainController.createJsonSchemaApi>>>>${body}');
      // ConncetServerController.createSchema(list);

    return body;
  }
  static filterRecordGeneral(var wheres,String tableName) async {
    var json=createJsonFilter(wheres, tableName);
    var response = await RestApi.post(filterRecordsUrl, body: json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          filterRecordRes=response!.data['data'].cast<Map<String, dynamic>>();
          // updateRecordRes={};
          // updateRecordRes=response!.data['data'];
          // print('ConncetServerController.getRecordGeneral>>>${response!.data['data'].first.keys}');
          // MainController.tableInfo=
        },printResponse: true);
  }
  static deleteRecordGeneral(var json) async {
    var response = await RestApi.post(deleteRecordUrl, body: json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          deleteRecordRes=true;
          // print('ConncetServerController.getRecordGeneral>>>${response!.data['data'].first.keys}');
          // MainController.tableInfo=
        },printResponse: true,errorCallback:()=> deleteRecordRes=false);
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