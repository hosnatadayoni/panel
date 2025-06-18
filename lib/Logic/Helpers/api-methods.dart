import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:finance/Logic/Helpers/token-methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as Get;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../UI/Componenets/Popups/snackbar.dart';

// enum requestTypes{
//   get,post,put,delete
// }
// class RestApi {
//
//   static bool isConnected=true;
//
//
//   static Future<Response?> request(url,{Map<String,dynamic>? data=null, useToken = true,}) async {
//
//     if(await Connectivity().checkConnectivity()==ConnectivityResult.none){
//       isConnected=false;
//       return null;
//     }
//     isConnected=true;
//
//     try {
//       Dio dio = new Dio();
//
//       var mytoken = null;
//       if (useToken) {
//         mytoken = await Token.getToken();
//         if (mytoken != null) dio.options.headers["authorization"] = mytoken;
//       }
//       dio.options.headers["Access-Control-Allow-Origin"]=true;
//       dio.options.contentType="multipart/form-data";
//       var formData = null;
//       if(data!=null){
//         formData=FormData.fromMap(data);
//       }
//       var response;
//
//       switch(formData){
//         case requestTypes.get:
//           response = await dio.get(url,queryParameters: data,);
//           break;
//         case requestTypes.post:
//           response = await dio.post(url,data: formData,);
//           break;
//         case requestTypes.put:
//           response = await dio.put(url,data: formData,);
//           break;
//         case requestTypes.delete:
//           response = await dio.delete(url,data: formData,);
//           break;
//       }
//
//       return response;
//     } catch (e) {
//       if (e is DioError && e.response != null) {
//         return e.response;
//       }else if(e is DioError && e.type==DioErrorType.connectionTimeout) {
//         isConnected=false;
//         return null;
//       } else {
//         print('apiError>>>${e.toString()}');
//         return null;
//       }
//     }
//   }
//
//
//
//
//   static responseHandler({Response? response,Function? successCallback,Function? errorCallback,printResponse=false,popupMessage=true})async{
//     if(response==null){
//       if(isConnected)
//         showSnackbar(snackTypes.error, 'Server Error');
//       else
//         showSnackbar(snackTypes.error, 'اتصال اینترنت را بررسی کنید.');
//         // if(ModalRoute.of(Get.Get.context!)!.settings.name!='/networkError')
//         // Navigator.of(Get.Get.context!).pushNamedAndRemoveUntil('/networkError', (route) => false);
//     }
//
//     else if(response.statusCode==200 ){
//       if(printResponse)
//       if(successCallback!=null)
//         await successCallback();
//     }
//     else{
//       if(popupMessage && response.data!=null && response.data['message']!=null)
//         showSnackbar(snackTypes.error,'${response.data['message']??''}');
//       if(errorCallback!=null)
//         await errorCallback();
//     }
//
//
//   }
//
//
//   static Future<Response?> get(url, {query, useToken = true}) async {
//
//     if(await Connectivity().checkConnectivity()==ConnectivityResult.none){
//       isConnected=false;
//       return null;
//     }
//     isConnected=true;
//     try {
//
//       Dio dio = new Dio();
//       var mytoken;
//       if (useToken) {
//         mytoken = await Token.getToken();
//         if (mytoken != null) dio.options.headers["authorization"] = mytoken;
//       }
//       var response =
//       await dio.get(url, queryParameters: query,);
//       return response;
//     }catch (e) {
//       if (e is DioError && e.response != null) {
//         return e.response;
//       }
//       else if(e is DioError && e.type==DioErrorType.connectionTimeout) {
//         isConnected=false;
//         return null;
//       }
//       else {
//         print('apiError>>>${e.toString()}');
//         return null;
//       }
//     }
//   }
//
//   static Future<Response?> post(url, {body=null, useToken = true}) async {
//     if(await Connectivity().checkConnectivity()==ConnectivityResult.none){
//       isConnected=false;
//       return null;
//     }
//     isConnected=true;
//
//     try {
//
//       Dio dio = new Dio();
//
//       var mytoken = null;
//       if (useToken) {
//         if (mytoken != null) dio.options.headers["authorization"] = mytoken;
//       }
//       dio.options.headers["Access-Control-Allow-Origin"]=true;
//       // dio.options.contentType="multipart/form-data";
//       dio.options.contentType="application/json";
//       body.addAll({
//         'api_key': await Token.getToken()
//       });
//       // body=json.encode(body).toString();
//       var formData = null;
//       if(body!=null)
//         formData=FormData.fromMap(body);
//       var response = await dio.post(url, data: formData,);
//       return response;
//     } catch (e) {
//       if (e is DioError && e.response != null) {
//         return e.response;
//       }else if(e is DioError && e.type==DioErrorType.connectionTimeout) {
//         isConnected=false;
//         return null;
//       } else {
//         return null;
//       }
//     }
//   }
//
//
//
//   static Future<Response?> put(url, {body=null, useToken = true}) async {
//
//     if(await Connectivity().checkConnectivity()==ConnectivityResult.none){
//       isConnected=false;
//       return null;
//     }
//     isConnected=true;
//
//
//     try {
//
//       Dio dio = new Dio();
//       var mytoken;
//       if (useToken) {
//         mytoken = await Token.getToken();
//         if (mytoken != null) dio.options.headers["authorization"] = mytoken;
//       }
//       dio.options.contentType="multipart/form-data";
//       var formData = null;
//       if(body!=null)
//         formData=FormData.fromMap(body);
//       var response = await dio.put(url, data: formData,);
//       return response;
//     } catch (e) {
//       if (e is DioError && e.response != null) {
//         return e.response;
//       }else if(e is DioError && e.type==DioErrorType.connectionTimeout) {
//         isConnected=false;
//         return null;
//       } else {
//         print('apiError>>>${e.toString()}');
//         return null;
//       }
//     }
//   }
//
//
//   static Future<Response?> delete(url, {body=null, useToken = true}) async {
//
//     if(await Connectivity().checkConnectivity()==ConnectivityResult.none){
//       isConnected=false;
//       return null;
//     }
//     isConnected=true;
//
//     try {
//
//       var mytoken;
//       Dio dio = new Dio();
//
//       if (useToken) {
//         mytoken = await Token.getToken();
//         if (mytoken != null) dio.options.headers["authorization"] = mytoken;
//       }
//
//       var formData = null;
//       if(body!=null)
//         formData=FormData.fromMap(body);
//       var response = await dio.delete(url, data: formData);
//       return response;
//     } catch (e) {
//       if (e is DioError && e.response != null) {
//         return e.response;
//       }else if(e is DioError && e.type==DioErrorType.connectionTimeout) {
//         isConnected=false;
//         return null;
//       } else {
//         print('apiError>>>${e.toString()}');
//         return null;
//       }
//     }
//   }
//
//
//   static Future<bool> download(url, savePath,{useToken = true, options = null}) async {
//
//     if(await Connectivity().checkConnectivity()==ConnectivityResult.none){
//       isConnected=false;
//       return false;
//     }
//     isConnected=true;
//
//     try {
//       Dio dio = Dio();
//       var mytoken;
//       if (useToken) {
//         mytoken = await Token.getToken();
//         if (mytoken != null) dio.options.headers["authorization"] = mytoken;
//       }
//
//       await dio.download(url, savePath, options: options, onReceiveProgress: (rec, total) {
//       });
//       return true;
//     } catch (e) {
//       if(e is DioError && e.response != null){
//       }
//       else{
//         print(e.toString());
//       }
//     }
//     return false;
//   }
// }