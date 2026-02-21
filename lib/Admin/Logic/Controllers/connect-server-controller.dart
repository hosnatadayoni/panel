import 'dart:convert';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/record-controller.dart';
import 'package:finance/Admin/Logic/Models/paginate.dart';
import 'package:finance/Admin/Public/api-urls.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../Helpers/api-methods.dart';
import '../Models/tableModel.dart';
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

  static listSchemaByField() async {
    AppController.finishLoading('list-schema');
    var response = await RestApi.post(listSchemaUrl,);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          MainController.menuList.value=[];
          MainController.menuList.value = (response!.data["data"] as List).map((item) => TableModel.fromJson(item)).toList();
          for (var name in MainController.tableNames()) {
            MainController.addsyncField('${name}');

            MainController.setRelations('${name}');

            MainController.addParentForRelations('${name}');
            final box = await Hive.openBox<TableModel>('menuBox');
            await box.clear();
            await box.addAll(MainController.menuList.value);
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

  static Future<Map<String, dynamic>> storeRecordGeneral (var json) async {
    storeRecordRes={};
    Map<String, dynamic> responseStore={};
    var response = await RestApi.post(storeRecordUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          storeRecordRes={};
          storeRecordRes=response!.data['data'];
          responseStore={};
          responseStore=response.data['data'];
          print('ConncetServerController.storeRecordGeneral>>${responseStore}');
          return responseStore;
        }
        ,printResponse: true,errorCallback: (){
      responseStore={};
    });
    return responseStore;
    // AppController.finishLoading('store-record');
    // AppController.finishLoading('get-records');
  }

  static Future<List<Map<String, dynamic>>>  updateRecordsGeneral(var json) async {
    List<Map<String, dynamic>>responseUpdate=[];
    var response = await RestApi.post(updateRecordUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          // updateRecordRes={};
          // updateRecordRes=response!.data['data']!=null &&response.data['data'].length!=0? response.data['data'].first:[];
          responseUpdate=response!.data['data']!=null &&response.data['data'].length!=0? List<Map<String,dynamic>>.from(response.data['data']):[];
        },printResponse: true,errorCallback: (){
    }
    );
    return responseUpdate;
    // AppController.finishLoading('update-records');
    // AppController.finishLoading('get-records');
  }

  static Future<Map<String, dynamic>>  findAndUpdateRecordGeneral(var json) async {
    Map<String, dynamic>responseUpdate={};
    var response = await RestApi.post(findAndUpdateRecordUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          responseUpdate=response!.data['data']!=null &&response.data['data'].length!=0? Map<String,dynamic>.from(response.data['data'].first):{};
        },printResponse: true,errorCallback: (){
    }
    );
    return responseUpdate;
    // AppController.finishLoading('update-records');
    // AppController.finishLoading('get-records');
  }

  static getRecordGeneral(var tableName,{var page=null,var perpage=null}) async {
    print('ConncetServerController.getRecordGeneral');
    var info=await MainController.getInfoTable(tableName);
    var perPage=perpage??info.schema.countShowRow;
    var currentPage=page??info.schema.currentPage;
    var response = await RestApi.post(getRecordsUrl, body:( {'table_name':tableName,
      'pageNumber':currentPage.toString(),
      'perPage':perPage.toString()})
    );
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getRecordRes.value=[];
          getRecordRes.value=response!.data['data']['data']!=null?response.data['data']['data']:[];
          int tRec=int.parse(response.data['data']['count'].toString());
          MainController.pageInfo[tableName]=PageInfo(totalRecords: tRec);
          return getRecordRes;
        },printResponse: true);
    return getRecordRes;

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
          String name='route_'+MainController.apiKey.value;
          int tRec= int.parse(response.data['data']['count'].toString());
          int s = (currentPageRoute.value - 1) * countShowRowRoute.value;
          var end = s + countShowRowRoute.value;
          var endBycondition = end >= tRec ? tRec : end;
          int tPage = (tRec / countShowRowRoute.value).ceil();
          MainController.pageInfo[name]=PageInfo(start: s,end: endBycondition,totalPage: tPage,totalRecords: tRec);
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
    Map<String,dynamic> body ={};
    var info=await MainController.getInfoTable(tableName);
    var perPage=perpage??info.schema.countShowRow;
    var currentPage=page??info.schema.currentPage;
    body.addAll({
      'table_name':tableName,
      'type':type,
      'pageNumber':currentPage.toString(),
      'perPage':perPage.toString()
    });
    if(wheres.length!=0) {
      for (Where item in wheres.values) {
        l.add({
          'column': '${item.fieldName}',
          'operation': "${item.operator != null ? item.operator : "\$eq"}",
          'value': "${item.value}"
        });
      }
    }

    body.addAll({
      'filter':json.encode(l),

    });
    return body;
  }

  static  Future<List<Map<String, dynamic>>>  filterRecordGeneral(var wheres,String tableName,String type) async {
    var json=await createJsonFilter(wheres, tableName,type);
    filterRecordRes=[];
    List<Map<String, dynamic>> responseUpdate=[];
    var response = await RestApi.post(filterRecordsUrl, body: json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          // MainController.pageInfo.value={};
          filterRecordRes=response!.data['data']!=null?response.data['data'].cast<Map<String, dynamic>>():[];
          responseUpdate=response.data['data']!=null?response.data['data'].cast<Map<String, dynamic>>():[];
          int tRec=response.data['pagination']['total'];
          int perPage = int.parse(json["perPage"]);
          int tPage=(tRec/perPage).ceil();
          MainController.pageInfo[tableName]=PageInfo(start:1,end:0,totalRecords: tRec,totalPage: tPage);
          print('ConncetServerController.filterRecordGeneral>>>${tableName}>>>${MainController.pageInfo[tableName]}');
        },printResponse: true);
    return responseUpdate;
  }

  static Future<List<Map<String, dynamic>>> deleteRecordsGeneral(var json) async {
    List<Map<String, dynamic>> responseDelete =[];
    var response = await RestApi.post(deleteRecordUrl, body: json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          print('ConncetServerController.deleteRecordsGeneral>>>${response!.data['data']}');

          responseDelete= response.data['data']!=null && response.data['data'].length!=0? List<Map<String,dynamic>>.from(response.data['data']) : [];

          deleteRecordRes=true;
          var info=await MainController.getInfoTable(json['table_name']);
          var perPage=info.schema.countShowRow;
          int tRec=MainController.pageInfo[json['table_name']]!.totalRecords;
          int tPage=(tRec/perPage).ceil();
          MainController.pageInfo[json['table_name']]=PageInfo(totalPage: tPage);
          return responseDelete;
        },printResponse: true,errorCallback:() {
      deleteRecordRes = false;
    });
    return responseDelete;
    // AppController.finishLoading('delete-record');
    // AppController.finishLoading('get-records');
  }
  static Future<Map<String, dynamic>> findByIdAndDelete(var json) async {
    Map<String, dynamic> responseDelete ={};
    var response = await RestApi.post(findAndDeleteRecordUrl, body: json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          responseDelete= response!.data['data']!=null && response.data['data'].length!=0? Map<String,dynamic>.from(response.data['data']) : {};
          deleteRecordRes=true;
          var info=await MainController.getInfoTable(json['table_name']);
          var perPage=info.schema.countShowRow;
          int tRec=MainController.pageInfo[json['table_name']]!.totalRecords;
          int tPage=(tRec/perPage).ceil();
          MainController.pageInfo[json['table_name']]=PageInfo(totalPage: tPage);
          return responseDelete;
        },printResponse: true,errorCallback:() {
      deleteRecordRes = false;
    });
    return responseDelete;
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
// import 'dart:convert';
// import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
// import 'package:finance/Admin/Logic/Controllers/record-controller.dart';
// import 'package:finance/Admin/Logic/Models/paginate.dart';
// import 'package:finance/Admin/Public/api-urls.dart';
// import 'package:get/get.dart';
// import '../Helpers/api-methods.dart';
// import '../Models/ServerModel/tableModel.dart';
// import '../Models/db.dart';
// import 'app-controller.dart';
//
// class ConncetServerController extends GetxController {
//   static RxList<dynamic> listTableNames=[].obs;
//   static Map<String, dynamic> storeRecordRes ={};
//   static Map<String, dynamic> updateRecordRes={};
//   static List<Map<String, dynamic>>filterRecordRes=[];
//   static bool deleteRecordRes=false;
//   static RxList<dynamic> getRecordRes=[].obs;
//   static RxList<dynamic> getRouteRes=[].obs;
//   static RxInt currentPageRoute=1.obs;
//   static RxInt countShowRowRoute=10.obs;
//
//   static listSchema() async {
//     AppController.finishLoading('list-schema');
//     var response = await RestApi.post(listSchemaUrl2,);
//     RestApi.responseHandler(
//         response: response,
//         successCallback: () async {
//            listTableNames.value = [];
//           for (var table in response!.data['data']) {
//             listTableNames.add(table['name']);
//           }
//         },printResponse: true);
//     AppController.finishLoading('list-schema');
//   }
//
//   static listSchemaByField() async {
//     AppController.finishLoading('list-schema');
//     var response = await RestApi.post(listSchemaUrl,);
//     RestApi.responseHandler(
//         response: response,
//         successCallback: () async {
//           MainController.menuList.value=[];
//           MainController.menuList.value = (response!.data["data"] as List)
//               .map((item) => TableModel.fromJson(item))
//               .toList();
//           for (var name in MainController.tableNames()) {
//             MainController.addsyncField('${name}');
//
//             MainController.setRelations('${name}');
//
//             MainController.addParentForRelations('${name}');
//           }
//           // storeRecordRes={};
//           // storeRecordRes=response!.data['data'];
//         },printResponse: true);
//     AppController.finishLoading('list-schema');
//   }
//
//   static listField(var json) async {
//     var response = await RestApi.post(listFieldUrl, body: json);
//     RestApi.responseHandler(
//         response: response,
//         successCallback: () async {
//           // storeRecordRes={};
//           // storeRecordRes=response!.data['data'];
//         },printResponse: true);
//   }
//
//   static Future<Map<String, dynamic>> storeRecordGeneral (var json) async {
//     storeRecordRes={};
//     Map<String, dynamic> responseStore={};
//     var response = await RestApi.post(storeRecordUrl, body: (json));
//     RestApi.responseHandler(
//         response: response,
//         successCallback: () async {
//           storeRecordRes={};
//           storeRecordRes=response!.data['data'];
//           responseStore={};
//           responseStore=response.data['data'];
//           print('ConncetServerController.storeRecordGeneral>>${responseStore}');
//           return responseStore;
//         }
//         ,printResponse: true,errorCallback: (){
//       responseStore={};
//     });
//     return responseStore;
//     // AppController.finishLoading('store-record');
//     // AppController.finishLoading('get-records');
//   }
//
//   static Future<Map<String, dynamic>>  updateRecordGeneral(var json) async {
//     Map<String, dynamic> responseUpdate={};
//     var response = await RestApi.post(updateRecordUrl, body: (json));
//     RestApi.responseHandler(
//         response: response,
//         successCallback: () async {
//           updateRecordRes={};
//           updateRecordRes=response!.data['data']!=null &&response.data['data'].length!=0? response.data['data'].first:[];
//           responseUpdate=response.data['data']!=null &&response.data['data'].length!=0? response.data['data'].first:[];
//         },printResponse: true,errorCallback: (){
//     }
//     );
//     return responseUpdate;
//     // AppController.finishLoading('update-records');
//     // AppController.finishLoading('get-records');
//   }
//
//   static getRecordGeneral(var tableName,{var page=null,var perpage=null}) async {
//     print('ConncetServerController.getRecordGeneral');
//     var info=await MainController.getInfoTable(tableName);
//     var perPage=perpage??info['schema']['countShowRow'];
//     var currentPage=page??info['schema'].currentPage;
//     var response = await RestApi.post(getRecordsUrl, body:( {'table_name':tableName,
//       'pageNumber':currentPage.toString(),
//       'perPage':perPage.toString()})
//     );
//     RestApi.responseHandler(
//         response: response,
//         successCallback: () async {
//           getRecordRes.value=[];
//           getRecordRes.value=response!.data['data']['data']!=null?response.data['data']['data']:[];
//           int tRec=int.parse(response.data['data']['count'].toString());
//           MainController.pageInfo[tableName]=PageInfo(totalRecords: tRec);
//
//         },printResponse: true);
//     // AppController.finishLoading('get-records');
//   }
//
//   static storeRoute (var json) async {
//     var response = await RestApi.post(storeRoutesUrl, body: (json));
//     RestApi.responseHandler(
//         response: response,
//         successCallback: () async {
//           getRouteRes.add(response!.data['data']);
//         },printResponse: true);
//   }
//   static getRoute() async {
//     var response = await RestApi.post(listRoutesUrl, body:{'currentPageRoute':currentPageRoute.value.toString(), 'perPage':countShowRowRoute.value.toString()});
//     RestApi.responseHandler(
//         response: response,
//         successCallback: () async {
//           getRouteRes.value=[];
//           getRouteRes.value=response!.data['data']['data'].length!=0?response.data['data']['data']:[];
//           String name='route_'+MainController.apiKey.value;
//           int tRec= int.parse(response.data['data']['count'].toString());
//           int s = (currentPageRoute.value - 1) * countShowRowRoute.value;
//           var end = s + countShowRowRoute.value;
//           var endBycondition = end >= tRec ? tRec : end;
//           int tPage = (tRec / countShowRowRoute.value).ceil();
//           MainController.pageInfo[name]=PageInfo(start: s,end: endBycondition,totalPage: tPage,totalRecords: tRec);
//         },printResponse: true);
//     // AppController.finishLoading('get-records');
//   }
//   static updateRoute(var json,var id) async {
//     var response = await RestApi.post(updateRouteUrl, body: {'item':(json),'id':id});
//     RestApi.responseHandler(
//         response: response,
//         successCallback: () async {
//           var update=response!.data['data']!=null &&response.data['data'].length!=0? response.data['data']:[];
//           var index=getRouteRes.indexWhere((element) => element['_id']==update['_id']);
//           if(index!=-1){
//             getRouteRes[index]=update;
//           }
//         },printResponse: true);
//   }
//   static deleteRoute(var id) async {
//     var response = await RestApi.post(deleteRouteUrl, body: {'id':id});
//     RestApi.responseHandler(
//         response: response,
//         successCallback: () async {
//           var index=getRouteRes.indexWhere((element) => element['_id']==id);
//           if(index!=-1){
//             getRouteRes.removeAt(index);
//           }
//         },printResponse: true);
//     // AppController.finishLoading('update-records');
//     // AppController.finishLoading('get-records');
//   }
//
//   static createJsonFilter(var wheres,String tableName,String type,{var page=null,var perpage=null}) async {
//     List<dynamic>l=[];
//     Map<String,dynamic> c={};
//     Map<String,dynamic> body ={};
//     var info=await MainController.getInfoTable(tableName);
//     var perPage=perpage??info.schema.countShowRow;
//     var currentPage=page??info.schema.currentPage;
//     body.addAll({
//         'table_name':tableName,
//         'type':type,
//       'pageNumber':currentPage.toString(),
//       'perPage':perPage.toString()
//       });
//     if(wheres.length!=0) {
//       for (Where item in wheres.values) {
//         l.add({
//           'column': '${item.fieldName}',
//           'operation': "${item.operator != null ? item.operator : "\$eq"}",
//           'value': "${item.value}"
//         });
//       }
//     }
//
//     body.addAll({
//         'filter':json.encode(l),
//
//       });
//     return body;
//   }
//
//   static  Future<List<Map<String, dynamic>>>  filterRecordGeneral(var wheres,String tableName,String type) async {
//     var json=await createJsonFilter(wheres, tableName,type);
//     filterRecordRes=[];
//     List<Map<String, dynamic>> responseUpdate=[];
//     var response = await RestApi.post(filterRecordsUrl, body: json);
//     RestApi.responseHandler(
//         response: response,
//         successCallback: () async {
//           // MainController.pageInfo.value={};
//           filterRecordRes=response!.data['data']!=null?response.data['data'].cast<Map<String, dynamic>>():[];
//           responseUpdate=response.data['data']!=null?response.data['data'].cast<Map<String, dynamic>>():[];
//           int tRec=response.data['pagination']['total'];
//           int perPage = int.parse(json["perPage"]);
//           int tPage=(tRec/perPage).ceil();
//           MainController.pageInfo[tableName]=PageInfo(start:1,end:0,totalRecords: tRec,totalPage: tPage);
//         },printResponse: true);
//     return responseUpdate;
//   }
//
//   static Future<bool> deleteRecordGeneral(var json) async {
//     var response = await RestApi.post(deleteRecordUrl, body: json);
//     RestApi.responseHandler(
//         response: response,
//         successCallback: () async {
//           deleteRecordRes=true;
//           var info=await MainController.getInfoTable(json['table_name']);
//           var perPage=info.schema.countShowRow;
//           // MainController.totalRecords.value--;
//
//           int tRec=MainController.pageInfo[json['table_name']]!.totalRecords;
//           int tPage=(tRec/perPage).ceil();
//           MainController.pageInfo[json['table_name']]=PageInfo(totalPage: tPage);
//
//         },printResponse: true,errorCallback:() {
//       deleteRecordRes = false;
//     });
//     return deleteRecordRes;
//
//     // AppController.finishLoading('delete-record');
//     // AppController.finishLoading('get-records');
//   }
//
//   static addSyncField(Map<dynamic,dynamic> json,bool status){
//     return json.addAll(RecordController.syncFunction(status));
//   }
//
//   static setDatabaseme(Map<dynamic,dynamic> json) async {
//     // print('ConncetServerController.setDatabaseme>>${json}');
//     // var response = await RestApi.post(storeUrl, body: json);
//     // RestApi.responseHandler(
//     //     response: response,
//     //     successCallback: () async {
//     //       addSyncField(json, true);
//     //       print('addSyncField >>>${json}');
//     //     },printResponse: true,errorCallback: (){
//     //   addSyncField(json, false);
//     // });
//   }
// }