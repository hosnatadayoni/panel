import 'dart:convert';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/record-controller.dart';
import 'package:finance/Admin/Public/api-urls.dart';
import 'package:get/get.dart';
import '../Helpers/api-methods.dart';
import '../Models/db.dart';
import 'app-controller.dart';

class ConncetServerController extends GetxController {

  static Map<String, dynamic>storeRecordRes={};
  static Map<String, dynamic> updateRecordRes={};
  static List<Map<String, dynamic>>filterRecordRes=[];
  static bool deleteRecordRes=false;
  static RxList<dynamic> getRecordRes=[].obs;

  static listSchemaByField() async {
    AppController.finishLoading('list-schema');
    var response = await RestApi.post(listSchemaUrl,);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {

          MainController.SubMenuList.value=response!.data['data'];
          for (var name in MainController.tableNames()) {
            MainController.addsyncField('${name}');

            MainController.setRelations('${name}');

            MainController.addParentForRelations('${name}');
          }
          // storeRecordRes={};
          // storeRecordRes=response!.data['data'];
        },printResponse: true);
    AppController.finishLoading('list-schema');
  }

  static listField(var json) async {
    var response = await RestApi.post(listFieldUrl, body: json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          // storeRecordRes={};
          // storeRecordRes=response!.data['data'];
        },printResponse: true);
  }

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
          updateRecordRes=response!.data['data']!=null &&response!.data['data'].length!=0? response!.data['data'].first:[];
        },printResponse: true);
    // AppController.finishLoading('update-records');
    // AppController.finishLoading('get-records');
  }

  static getRecordGeneral(var tableName,{var page=null,var perpage=null}) async {
    var info=await MainController.getInfoTable(tableName);
    var perPage=perpage??info['schema']['countShowRow'];
    var currentPage=page??info['schema']['currentPage'];
    var response = await RestApi.post(getRecordsUrl, body:( {'table_name':tableName,
      'pageNumber':currentPage.toString(),
      'perPage':perPage.toString()})
    );
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getRecordRes.value=[];
          getRecordRes.value=response!.data['data']['data']!=null?response.data['data']['data']:[];
          MainController.totalItems.value=response.data['data']['count'];

        },printResponse: true);
    // AppController.finishLoading('get-records');
  }

  static createJsonFilter(var wheres,String tableName,String type,{var page=null,var perpage=null}) async {
    List<dynamic>l=[];
    Map<String,dynamic> c={};
    Map<String,dynamic> body ={};
    var info=await MainController.getInfoTable(tableName);
    var perPage=perpage??info['schema']['countShowRow'];
    var currentPage=page??info['schema']['currentPage'];
    body.addAll({
        'table_name':tableName,
        'type':type,
      'pageNumber':currentPage.toString(),
      'perPage':perPage.toString()
      });
    for(Where item in wheres.values){
      l.add({'column':'${item.fieldName}','operation': "${item.operator!=null?item.operator:"\$eq"}",'value': "${item.value}"});
      }

    body.addAll({
        'filter':json.encode(l),

      });
    return body;
  }

  static filterRecordGeneral(var wheres,String tableName,String type) async {
    var json=await createJsonFilter(wheres, tableName,type);
    var response = await RestApi.post(filterRecordsUrl, body: json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          filterRecordRes=response!.data['data']['data']!=null?response!.data['data']['data'].cast<Map<String, dynamic>>():[];
          MainController.totalItems.value=response.data['data']['count'];
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