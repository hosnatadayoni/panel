import 'package:finance/Logic/Controllers/record-controller.dart';
import 'package:finance/Public/api-urls.dart';
import 'package:get/get.dart';

import '../Helpers/api-methods.dart';
import 'app-controller.dart';

class ConncetServerController extends GetxController {

  static setDatabase(Map<dynamic,dynamic> json) async {
    var response = await RestApi.post(categoryStoreUrl, body: {'title':'category title'});
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
        },printResponse: true);
  }

  static addSyncField(Map<dynamic,dynamic> json,bool status){
    return json.addAll(RecordController.syncFunction(status));
  }

  static setDatabaseme(Map<dynamic,dynamic> json) async {
    print('ConncetServerController.setDatabaseme>>${json}');
    var response = await RestApi.post(storeUrl, body: json);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          addSyncField(json, true);
          print('addSyncField >>>${json}');
        },printResponse: true,errorCallback: (){
      addSyncField(json, false);
    });
  }
}