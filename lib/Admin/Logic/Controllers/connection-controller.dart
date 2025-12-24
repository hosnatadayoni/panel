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
      checkConnection.value=true;

    } else if (result == ConnectivityResult.mobile) {
      checkConnection.value=true;
    }else if (result == ConnectivityResult.ethernet) {
      checkConnection.value=true;
    } else {
      checkConnection.value=false;
      // Navigator.push(Get.context!, MaterialPageRoute(builder: (context) =>  ConnectionError()));
    }
    connectivityResult = result;
    subscription=Connectivity().onConnectivityChanged.listen((result){
       result=result;
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
     update();

    });
    update();
  }
}
