import 'dart:convert';
import 'package:finance/Admin/Logic/Models/ServerModel/user.dart';
import 'package:finance/Admin/Logic/Models/paginate.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/Admin/UI/Views/set-token-page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../Public/api-urls.dart';
import '../../UI/Views/dashboard.dart';
import '../Helpers/api-methods.dart';
import '../Helpers/token-methods.dart';
import '../Models/tableModel.dart';
import 'main-controller.dart';

class AdminController extends GetxController {
  static RxList<dynamic> getAccessRes = [].obs;
  static RxList<dynamic> getNameAccessRes = [].obs;
  static RxInt currentPageAccess = 1.obs;
  static RxInt countShowRowAccess = 10.obs;

  static RxList<dynamic> getRoleRes = [].obs;
  static RxMap<String, dynamic> accessRoles = <String, dynamic>{}.obs;
  static RxInt currentPageRole = 1.obs;
  static RxInt countShowRowRole = 10.obs;

  static RxList<dynamic> getAdminRes = [].obs;
  static RxInt currentPageAdmin = 1.obs;
  static RxInt countShowRowAdmin = 10.obs;

  static Rx<UserModel> userModel=UserModel().obs;

  static Rx<bool> isVisibility = true.obs;

  static login() async {
    var response = await RestApi.post(loginUrl,
        body: {'username': userModel.value.username, 'password': userModel.value.password,'api_key': MainController.apiKey.value},useToken: false);
    RestApi.responseHandler(
      response: response,

      successCallback: () async {
        var user = response!.data['data'];

        if (user != null) {
           await Token.setToken( '${response.data['data']['token']}');
           var t=await Token.getToken();
         print('AdminController.login>>${t}');
          Get.to(DashboardPage());
        }
      },
      printResponse: true,);
  }
  static storeAccess(var json) async {
    var response = await RestApi.post(storeAccessUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getAccessRes.add(response!.data['data']);
        },
        printResponse: true);
  }

  static getNameAccess() async {
    var response = await RestApi.post(listNameAccessUrl);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          print('AdminController.getNameAccess>>>${response!.data['data']}');
          getNameAccessRes.value = [];
          getNameAccessRes.value =
              response.data['data'].length != 0 ? response.data['data'] : [];
        },
        printResponse: true);
  }

  static getAccess() async {
    var response = await RestApi.post(listAccessesUrl, body: {
      'pageNumber': currentPageAccess.value.toString(),
      'perPage': countShowRowAccess.value.toString()
    });
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getAccessRes.value = [];
          getAccessRes.value = response!.data['data']['data'].length != 0
              ? response.data['data']['data']
              : [];
          String name='access_'+MainController.apiKey.value;

          var tRec = int.parse(response.data['data']['count'].toString());
          int s = (currentPageAccess.value - 1) * countShowRowAccess.value;
          var end = s + countShowRowAccess.value;
          var endBycondition = end >= tRec ? tRec : end;
          int tPage =(tRec/ countShowRowAccess.value).ceil();
          MainController.pageInfo[name]=PageInfo(start: s,end:endBycondition,totalPage:tPage,totalRecords: tRec  );
        },
        printResponse: true, errorCallback: () {
      getAccessRes.value = [];
    });
  }

  static updateAccess(var json, var id) async {
    var response =
        await RestApi.post(updateAccessUrl, body: {'item': (json), 'id': id});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          var update = response!.data['data'] != null &&
                  response.data['data'].length != 0
              ? response.data['data']
              : [];
          var index = getAccessRes
              .indexWhere((element) => element['_id'] == update['_id']);
          if (index != -1) {
            getAccessRes[index] = update;
          }
        },
        printResponse: true);
  }

  static deleteAccess(var id) async {
    var response = await RestApi.post(deleteAccessUrl, body: {'id': id});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          var index =
              getAccessRes.indexWhere((element) => element['_id'] == id);
          if (index != -1) {
            getAccessRes.removeAt(index);
          }
        },
        printResponse: true);
    // AppController.finishLoading('update-records');
    // AppController.finishLoading('get-records');
  }

  static storeRole(var json) async {
    var response = await RestApi.post(storeRoleUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getRoleRes.add(response!.data['data']);
          // accessRoles.add(response!.data['data'][1]);
        },
        printResponse: true);
  }

  static getRoles({int? pageNumber, int? perPage}) async {
    var response = await RestApi.post(listRolesUrl, body: {
      'pageNumber': pageNumber ?? currentPageRole.value.toString(),
      'perPage': pageNumber ?? countShowRowRole.value.toString()
    });
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getRoleRes.value = [];
          getRoleRes.value = response!.data['data']['data'].length != 0
              ? response.data['data']['data']
              : [];
          String name='role_'+MainController.apiKey.value;

         int tRc = int.parse(response.data['data']['count'].toString());
          int s = (currentPageRole.value - 1) * countShowRowRole.value;
          var end = s + countShowRowRole.value;
          var endBycondition = end >= tRc ? tRc : end;
          int totalPages= (tRc / countShowRowRole.value).ceil();
          MainController.pageInfo[name]=PageInfo(start: s,end: endBycondition,totalRecords: tRc,totalPage: totalPages);
        },
        printResponse: true, errorCallback: () {
      getRoleRes.value = [];
    });
  }

  static updateRole(var json, var id) async {
    var response =
        await RestApi.post(updateRoleUrl, body: {'item': (json), 'id': id});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          var update = response!.data['data'] != null &&
                  response.data['data'].length != 0
              ? response.data['data']
              : [];
          var index = getRoleRes
              .indexWhere((element) => element['_id'] == update['_id']);
          if (index != -1) {
            getRoleRes[index] = update;
          }
        },
        printResponse: true);
  }

  static deleteRole(var id) async {
    var response = await RestApi.post(deleteAccessUrl, body: {'id': id});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          var index = getRoleRes.indexWhere((element) => element['_id'] == id);
          if (index != -1) {
            getRoleRes.removeAt(index);
          }
        },
        printResponse: true);
    // AppController.finishLoading('update-records');
    // AppController.finishLoading('get-records');
  }

  static getAccessRole(var id) async {
    var response = await RestApi.post(listRoleAccesssUrl,
        body: {'id': id, 'pageNumber': 0, 'perPage': 0});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          accessRoles.value = {};
          if (response!.data['data']['data'].length != 0) {
            for (var data in response.data['data']['data']) {
              accessRoles[data['access_id']] = data;
            }
          } else {
            accessRoles.value = {};
          }
          String name='access_role_'+MainController.apiKey.value;
          int tRec= int.parse(response.data['data']['count'].toString());
          int s = (currentPageRole.value - 1) * countShowRowRole.value;
          var end = s + countShowRowRole.value;
          var endBycondition = end >= tRec ? tRec : end;
          int tPage = (tRec / countShowRowRole.value).ceil();
          MainController.pageInfo[name]=PageInfo(start: s,end: endBycondition,totalPage: tPage,totalRecords: tRec);
        },
        printResponse: true, errorCallback: () {
      accessRoles.value = {};

    });
  }

  static storeRoleAccesss(var json) async {
    var response = await RestApi.post(storeRoleAccesssUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          accessRoles[response!.data['data']['access_id']] =
              response.data['data'];
        },
        printResponse: true);
  }

  static storeAdmin(var json) async {
    var response = await RestApi.post(storeAdminUrl, body: (json));
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getAdminRes.add(response!.data['data']);
        },
        printResponse: true);
  }

  static getAdmins() async {
    var response = await RestApi.post(listAdminsUrl, body: {
      'pageNumber': currentPageAdmin.value.toString(),
      'perPage': countShowRowAdmin.value.toString()
    });
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          getAdminRes.value = [];
          getAdminRes.value = response!.data['data'] != null &&
                  response.data['data']['data'].length != 0
              ? response.data['data']['data']
              : [];
          String name='admin_'+MainController.apiKey.value;

          int tRec= int.parse(response.data['data']['count'].toString());
          int s = (currentPageAdmin.value - 1) * countShowRowAdmin.value;
          var end = s + countShowRowAdmin.value;
          var endBycondition = end >= tRec ? tRec : end;
          int tPage = (tRec / countShowRowAdmin.value).ceil();
          MainController.pageInfo[name]=PageInfo(start: s,end: endBycondition,totalPage: tPage,totalRecords: tRec);
        },
        printResponse: true,
        errorCallback: () {
          getAdminRes.value = [];
        });
  }

  static getAdmin() async {
    var response = await RestApi.post(getAdminUrl);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          userModel.value = UserModel.fromJson(response!.data['data']['data']);
          MainController.apiKey.value=response.data['data']['api_key'];
          Navigator.push(Get.context!, MaterialPageRoute(builder: (context) =>  DashboardPage()));
        },
        printResponse: true,
        errorCallback: () {
          print('AdminController.getAdmin');
          getAdminRes.value = [];
          Navigator.push(Get.context!, MaterialPageRoute(builder: (context) =>  SetTokenPage()));
        });
  }

  static updateAdmin(var json, var id) async {
    var response =
        await RestApi.post(updateAdminUrl, body: {'item': (json), 'id': id});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          var update = response!.data['data'] != null &&
                  response.data['data'].length != 0
              ? response.data['data']
              : [];
          var index = getAdminRes
              .indexWhere((element) => element['_id'] == update['_id']);
          if (index != -1) {
            getAdminRes[index] = update;
          }
        },
        printResponse: true);
  }

  static updateProfileAdmin() async {
    var response =
        await RestApi.post(updateProfileAdminUrl, body: {'item': jsonEncode(userModel.toJson())});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          userModel.value = UserModel.fromJson(response!.data['data']);
          showSnackbar(snackTypes.success, 'عملیات با موفقیت انجام شد');
        },

        printResponse: true);
  }
  static changePass() async {
    var response =
        await RestApi.post(updatePasswordUrl, body: {'item': jsonEncode(userModel.toJson())});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {

          showSnackbar(snackTypes.success, 'عملیات با موفقیت انجام شد');
        },

        printResponse: true);
  }

  static logout() async {
    await Token.removeToken();
    MainController.menuList.value = [];

    getRoleRes.value = [];
    getAdminRes.value = [];
    final box = await Hive.openBox<TableModel>('menuBox');
    await box.clear();
  }
}
