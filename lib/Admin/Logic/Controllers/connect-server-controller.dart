import 'dart:convert';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/record-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/api-urls.dart';
import 'package:get/get.dart';
import '../Helpers/api-methods.dart';
import '../Models/db.dart';
import 'app-controller.dart';

class ConncetServerController extends GetxController {
  static RxList<dynamic> listTableNames=[].obs;
  static Map<String, dynamic> storeRecordRes ={};
  static Map<String, dynamic> updateRecordRes={};
  static List<Map<String, dynamic>>filterRecordRes=[];
  static bool deleteRecordRes=false;
  static RxList<dynamic> getRecordRes=[].obs;
  static RxList<dynamic> getRouteRes=[].obs;
  static RxInt currentPageRoute=1.obs;
  static RxInt countShowRowRoute=10.obs;

  static listSchema() async {
    AppController.finishLoading('list-schema');
    var response = await RestApi.post(listSchemaUrl2,);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
           listTableNames.value = [];
          for (var table in response!.data['data']) {
            listTableNames.add(table['name']);
          }
        },printResponse: true);
    AppController.finishLoading('list-schema');
  }

  static listSchemaByField() async {
    AppController.finishLoading('list-schema');
    var response = await RestApi.post(listSchemaUrl,);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          MainController.SubMenuList.value=[];

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
    storeRecordRes={};
    var response = await RestApi.post(storeRecordUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          storeRecordRes={};
          storeRecordRes=response!.data['data'];
        }
        ,printResponse: true,errorCallback: (){
      storeRecordRes={};
    });
    // AppController.finishLoading('store-record');
    // AppController.finishLoading('get-records');
  }

  static updateRecordGeneral(var json) async {
    var response = await RestApi.post(updateRecordUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          updateRecordRes={};
          updateRecordRes=response!.data['data']!=null &&response.data['data'].length!=0? response.data['data'].first:[];
        },printResponse: true);
    // AppController.finishLoading('update-records');
    // AppController.finishLoading('get-records');
  }

  static getRecordGeneral(var tableName,{var page=null,var perpage=null}) async {
    print('ConncetServerController.getRecordGeneral');
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

  static storeRoute (var json) async {
    var response = await RestApi.post(storeRoutesUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getRouteRes.add(response!.data['data']);
        },printResponse: true);
  }
  static getRoute() async {
    var response = await RestApi.post(listRoutesUrl, body:{'currentPageRoute':currentPageRoute.value.toString(), 'perPage':countShowRowRoute.value.toString()});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getRouteRes.value=[];
          getRouteRes.value=response!.data['data']['data'].length!=0?response.data['data']['data']:[];
          MainController.totalItems.value=response.data['data']['count'];
          int s = (currentPageRoute.value - 1) * countShowRowRoute.value;
          var end = s + countShowRowRoute.value;
          MainController.startIndex.value = s;
          var endBycondition = end >= MainController.totalItems.value ? MainController.totalItems.value : end;
          MainController.endIndex.value = endBycondition;
          ViewController.totalPage.value =(MainController.totalItems.value/countShowRowRoute.value).ceil();
          print('ConncetServerController.getRoute${ MainController.totalPages.value}');
        },printResponse: true);
    // AppController.finishLoading('get-records');
  }
  static updateRoute(var json,var id) async {
    var response = await RestApi.post(updateRouteUrl, body: {'item':(json),'id':id});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          var update=response!.data['data']!=null &&response.data['data'].length!=0? response.data['data']:[];
          var index=getRouteRes.indexWhere((element) => element['_id']==update['_id']);
          if(index!=-1){
            getRouteRes[index]=update;
          }
        },printResponse: true);
  }
  static deleteRoute(var id) async {
    var response = await RestApi.post(deleteRouteUrl, body: {'id':id});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          var index=getRouteRes.indexWhere((element) => element['_id']==id);
          if(index!=-1){
            getRouteRes.removeAt(index);
          }
        },printResponse: true);
    // AppController.finishLoading('update-records');
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
    if(wheres.length!=0)
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
          filterRecordRes=response!.data['data']['data']!=null?response.data['data']['data'].cast<Map<String, dynamic>>():[];
          MainController.totalItems.value=response.data['data']['count'];
          int perPage = int.parse(json["perPage"]);
          ViewController.totalPage.value =(MainController.totalItems.value/perPage).ceil();
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