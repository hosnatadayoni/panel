import 'package:finance/Logic/Controllers/record-controller.dart';
import 'package:finance/Logic/Helpers/token-methods.dart';
import 'package:finance/Logic/Models/ServerModel/project.dart';
import 'package:finance/Public/api-urls.dart';
import 'package:get/get.dart';
import '../Helpers/api-methods.dart';


class ConncetServerController extends GetxController {

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
  // static createSchema(Map<dynamic,dynamic> json) async {
  //   var response = await RestApi.post(createSchemaUrl, body: {'title':'category title'});
  //   RestApi.responseHandler(
  //       response: response,
  //       successCallback: () async {
  //       },printResponse: true);
  // }

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