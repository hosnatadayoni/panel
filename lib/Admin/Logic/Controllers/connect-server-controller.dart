import 'dart:convert';
import 'package:panel/Admin/Logic/Controllers/main-controller.dart';
import 'package:panel/Admin/Logic/Controllers/record-controller.dart';
import 'package:panel/Admin/Logic/Helpers/token-methods.dart';
import 'package:panel/Admin/Logic/Models/ServerModel/project.dart';
import 'package:panel/Admin/Public/api-urls.dart';
import 'package:get/get.dart';
import '../Helpers/api-methods.dart';
import '../Models/db.dart';

class ConncetServerController extends GetxController {
  static Map<String, dynamic> storeRecordRes = {};
  static Map<String, dynamic> updateRecordRes = {};
  static List<Map<String, dynamic>> filterRecordRes = [];
  static List<dynamic> listProjectRes = [];
  static List<dynamic> listSchemaRes = [];
  static List<dynamic> listFieldsRes = [];
  static List<dynamic> listFiltersRes = [];
  static List<dynamic> listValidateRes = [];
  static Map<String,dynamic>stroredSchema={};

  static bool deleteRecordRes = false;
  static List<dynamic> getRecordRes = [];

  static createProject(Map<String, dynamic> json) async {
    var response =
        await RestApi.post(createProjectUrl, body: json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          Project project = Project.fromJson(response!.data['data']);

        },
        printResponse: true);
  }
  static listProject() async {
    String? s ;
    s= await Token.getToken();
    var response = await RestApi.post(listProjectUrl, body: {'api_key': s});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          listProjectRes=response!.data['data'];

        },
        printResponse: true);
  }
  static deleteProject(var apiKey) async {
    var response = await RestApi.post(deleteProjectUrl, body: {'api_key':apiKey},useApiKey: false);
    RestApi.responseHandler(
        response: response, successCallback: () async {}, printResponse: true);
  }
  static createSchema(Map<String, dynamic> json) async {
    var response = await RestApi.post(createSchemaUrl, body: json);
    RestApi.responseHandler(
        response: response, successCallback: () async {
      stroredSchema=response!.data['data'];
    }, printResponse: true);
  }
  static updateSchema(Map<String, dynamic> request,var id) async {
    var body= {
      'id': id,
      'column': json.encode(request).toString(),
    };
    var response = await RestApi.post(updateSchemaUrl, body: body);
    RestApi.responseHandler(
        response: response, successCallback: () async {}, printResponse: true);
  }
  static deleteSchema(Map<String, dynamic> json) async {
    var response = await RestApi.post(deleteSchemaUrl, body: json);
    RestApi.responseHandler(
        response: response, successCallback: () async {}, printResponse: true);
  }
  static listSchema() async {
    var s = await Token.getToken();
    var response = await RestApi.post(listSchemaUrl, body: {'api_key': s});
    RestApi.responseHandler(
        response: response, successCallback: () async {
      listSchemaRes=response!.data['data'];
      // for(var schema in listSchemaRes){
      //   if(schema['relations']!=null && schema['relations'].length!=0){
      //     var rels=[];
      //     for(var rel in schema['relations']){
      //       var index;
      //       index =listSchemaRes.indexWhere((element) => element['_id']==rel);
      //           if(index!=-1){
      //             listSchemaRes[index]['relations'].add( listSchemaRes[index]['name']);
      //
      //           }
      //     }
      //   }
      // }
        }, printResponse: true);
  }

  static createField(Map<String, dynamic> json) async {
    var response = await RestApi.post(createFieldUrl, body: json);
    RestApi.responseHandler(
        response: response, successCallback: () async {

    }, printResponse: true);
  }
  static updateField(Map<String, dynamic> request,var id) async {
    var body= {
      'id': id,
      'field': json.encode(request).toString(),
    };
    var response = await RestApi.post(updateFieldUrl, body: body);
    RestApi.responseHandler(
        response: response, successCallback: () async {

    }, printResponse: true);
  }
  static deleteField(Map<String, dynamic> json) async {
    var response = await RestApi.post(deleteFieldUrl, body: json);
    RestApi.responseHandler(
        response: response, successCallback: () async {

    }, printResponse: true);
  }
  static listField(Map<String, dynamic> json) async {
    var response = await RestApi.post(listFieldUrl, body:json);
    RestApi.responseHandler(
        response: response, successCallback: () async {
        listFieldsRes=response!.data['data'];

        }, printResponse: true);
  }

  static deleteValidate(Map<String, dynamic> json) async {
    var response = await RestApi.post(deleteValidateUrl, body: json);
    RestApi.responseHandler(
        response: response, successCallback: () async {}, printResponse: true);
  }
  static listValidate(Map<String, dynamic> json) async {
    var s = await Token.getToken();
    var response = await RestApi.post(listValidateUrl, body:json);
    RestApi.responseHandler(
        response: response, successCallback: () async {
          print('listValidate a>>>${response!.data['data']}');
      listValidateRes=response!.data['data'];
    }, printResponse: true);
  }
  static createValidate(Map<String, dynamic> json) async {
    var response = await RestApi.post(createValidateFieldsUrl, body: json);
    RestApi.responseHandler(
        response: response, successCallback: () async {

    }, printResponse: true);
  }

  static deleteFilter(Map<String, dynamic> json) async {
    var response = await RestApi.post(deleteFilterUrl, body: json);
    RestApi.responseHandler(
        response: response, successCallback: () async {}, printResponse: true);
  }
  static listFilter(Map<String, dynamic> json) async {
    var response = await RestApi.post(listFiltersUrl, body:json);
    RestApi.responseHandler(
        response: response, successCallback: () async {
      listFiltersRes=response!.data['data'];

    }, printResponse: true);
  }

  static createFilter(Map<String, dynamic> json) async {
    var response = await RestApi.post(createFilterSchemaUrl, body: json);
    RestApi.responseHandler(
        response: response, successCallback: () async {

    }, printResponse: true);
  }





  static storeRecordGeneral(var json) async {
    var response = await RestApi.post(storeRecordUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          storeRecordRes = {};
          storeRecordRes = response!.data['data'];
        },
        printResponse: true);
  }

  static updateRecordGeneral(var json) async {
    var response = await RestApi.post(updateRecordUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          updateRecordRes = {};
          updateRecordRes = response!.data['data'];
        },
        printResponse: true);
  }

  static getRecordGeneral(var tableName) async {
    var info = await MainController.getInfoTable(tableName);

    var perPage = info['countShowRow'];
    var currentPage = info['currentPage'];
    var response = await RestApi.post(getRecordsUrl,
        body: ({
          'table_name': tableName,
          'pageNumber': currentPage.toString(),
          'perPage': perPage.toString()
        }));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getRecordRes = [];
          getRecordRes = response!.data['data']['data'];
          MainController.tableData.value = response.data['data']['data'];
        },
        printResponse: true);
  }

  static createJsonFilter(var wheres, String tableName, String type) {
    List<dynamic> l = [];
    Map<String, dynamic> c = {};
    Map<String, dynamic> body = {};
    body.addAll({
      'table_name': tableName,
      'type': type,
    });
    for (Where item in wheres.values) {
      l.add({
        'column': '${item.fieldName}',
        'operation': "${item.oprator != null ? item.oprator : "\$eq"}",
        'value': "${item.value}"
      });
    }
    body.addAll({
      'filter': json.encode(l),
    });
    return body;
  }

  static filterRecordGeneral(var wheres, String tableName, String type) async {
    var json = createJsonFilter(wheres, tableName, type);
    var response = await RestApi.post(filterRecordsUrl, body: json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          filterRecordRes = response!.data['data'].cast<Map<String, dynamic>>();
        },
        printResponse: true);
  }

  static deleteRecordGeneral(var json) async {
    var response = await RestApi.post(deleteRecordUrl, body: json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          deleteRecordRes = true;
        },
        printResponse: true,
        errorCallback: () => deleteRecordRes = false);
  }

  static addSyncField(Map<dynamic, dynamic> json, bool status) {
    return json.addAll(RecordController.syncFunction(status));
  }

  static setDatabaseme(Map<dynamic, dynamic> json) async {
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
