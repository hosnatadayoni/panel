import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:get/get.dart';

import '../../Public/api-urls.dart';
import '../Helpers/api-methods.dart';
import 'main-controller.dart';

class AdminController extends GetxController {
  static RxList<dynamic> getAccessRes=[].obs;
  static RxInt currentPageAccess=1.obs;
  static RxInt countShowRowAccess=10.obs;

  static RxList<dynamic> getRoleRes=[].obs;
  static RxInt currentPageRole=1.obs;
  static RxInt countShowRowRole=10.obs;

  static storeAccess (var json) async {
    var response = await RestApi.post(storeAccessUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getAccessRes.add(response!.data['data']);
        },printResponse: true);
  }
  static getAccess() async {
    var response = await RestApi.post(listAccessesUrl, body:{'pageNumber':currentPageAccess.value.toString(), 'perPage':countShowRowAccess.value.toString()});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getAccessRes.value=[];
          getAccessRes.value=response!.data['data']['data'].length!=0?response.data['data']['data']:[];
          MainController.totalItems.value=response.data['data']['count'];
          int s = (currentPageAccess.value - 1) * countShowRowAccess.value;
          var end = s + countShowRowAccess.value;
          MainController.startIndex.value = s;
          var endBycondition = end >= MainController.totalItems.value ? MainController.totalItems.value : end;
          MainController.endIndex.value = endBycondition;
          ViewController.totalPage.value =(MainController.totalItems.value/countShowRowAccess.value).ceil();
        },printResponse: true);
  }
  static updateAccess(var json,var id) async {
    var response = await RestApi.post(updateAccessUrl, body: {'item':(json),'id':id});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          var update=response!.data['data']!=null &&response.data['data'].length!=0? response.data['data']:[];
          var index=getAccessRes.indexWhere((element) => element['_id']==update['_id']);
          if(index!=-1){
            getAccessRes[index]=update;
          }
        },printResponse: true);
  }
  static deleteAccess(var id) async {
    var response = await RestApi.post(deleteAccessUrl, body: {'id':id});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          var index=getAccessRes.indexWhere((element) => element['_id']==id);
          if(index!=-1){
            getAccessRes.removeAt(index);
          }
        },printResponse: true);
    // AppController.finishLoading('update-records');
    // AppController.finishLoading('get-records');
  }


  static storeRole (var json) async {
    var response = await RestApi.post(storeRoleUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getRoleRes.add(response!.data['data']);
        },printResponse: true);
  }
  static getRoles() async {
    var response = await RestApi.post(listRolesUrl, body:{'pageNumber':currentPageRole.value.toString(), 'perPage':countShowRowRole.value.toString()});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getRoleRes.value=[];
          getRoleRes.value=response!.data['data']['data'].length!=0?response.data['data']['data']:[];
          MainController.totalItems.value=response.data['data']['count'];
          int s = (currentPageRole.value - 1) * countShowRowRole.value;
          var end = s + countShowRowRole.value;
          MainController.startIndex.value = s;
          var endBycondition = end >= MainController.totalItems.value ? MainController.totalItems.value : end;
          MainController.endIndex.value = endBycondition;
          ViewController.totalPage.value =(MainController.totalItems.value/countShowRowRole.value).ceil();
        },printResponse: true);
  }
  static updateRole(var json,var id) async {
    var response = await RestApi.post(updateRoleUrl, body: {'item':(json),'id':id});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          var update=response!.data['data']!=null &&response.data['data'].length!=0? response.data['data']:[];
          var index=getRoleRes.indexWhere((element) => element['_id']==update['_id']);
          if(index!=-1){
            getRoleRes[index]=update;
          }
        },printResponse: true);
  }
  static deleteRole(var id) async {
    var response = await RestApi.post(deleteAccessUrl, body: {'id':id});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          var index=getRoleRes.indexWhere((element) => element['_id']==id);
          if(index!=-1){
            getRoleRes.removeAt(index);
          }
        },printResponse: true);
    // AppController.finishLoading('update-records');
    // AppController.finishLoading('get-records');
  }
}