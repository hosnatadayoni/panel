import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionController extends GetxController {

  static ConnectivityResult? connectivityResult;
  static RxBool checkConnection=false.obs;
  static StreamSubscription? subscription;

  static checkConnectivity() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi) {
      print('Connected to a wifi network');
      checkConnection.value=true;
      print("checkConnection1 ${checkConnection}");

    } else if (result == ConnectivityResult.mobile) {
      print('Connected to a mobile network');
      checkConnection.value=true;
      print("checkConnection2 ${checkConnection}");
    }else if (result == ConnectivityResult.ethernet) {
      print('Connected to a mobile network');
      checkConnection.value=true;
      print("checkConnection2 ${checkConnection}");
    } else {
      checkConnection.value=false;
      print("checkConnection3 ${checkConnection}");
      // Navigator.push(Get.context!, MaterialPageRoute(builder: (context) =>  ConnectionError()));
    }
    connectivityResult = result;
    subscription=Connectivity().onConnectivityChanged.listen((result){
       result=result;
        print("result${result}");
    });
  }

  void checkConnectivityRetry() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();



    if (result == ConnectivityResult.wifi) {
     Navigator.pop(Get.context!);

    } else if (result == ConnectivityResult.mobile) {
      Navigator.pop(Get.context!);
      //Navigator.pushNamed(Get.context!, '/signIn');

    } else {

      // Navigator.push(Get.context!, MaterialPageRoute(builder: (context) =>  ConnectionError()));
    }
    connectivityResult = result;
    subscription=Connectivity().onConnectivityChanged.listen((result){
       result=result;
        print("result${result}");
     update();

    });
    update();
  }
}