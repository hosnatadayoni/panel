import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


enum fontTypes{
  heading1,
  heading2,
  heading3,
  heading4,
  heading5,
  text1,
  text2,
  text3,
  text4,
  text5,
  text6,
  text7,
  text8,
  text9,
  text10,
  text11,
  text12,
  text13,
}



class AppController extends GetxController {

  static RxBool isLoading=false.obs;
  static RxList<String> loadingList=<String>[].obs;


  static late Locale locale;
  static Map<dynamic, dynamic> _localizedValues = new Map();

  static startLoading(String loadingTag){
    if(loadingTag!='' && loadingTag!=null)
      loadingList.add(loadingTag);
  }

  static finishLoading(String loadingTag){
    loadingList.remove(loadingTag);
  }

  static hasLoading(loadingTag){
    if(loadingList.contains(loadingTag))
      return true;
    else
      return false;
  }
  static hasLoadingList(List<String> loadingTag){
    for (var i = 0; i < loadingTag.length; i++){
      if(loadingList.contains(loadingTag[i]))
        return true;
    }
    return false;
  }

  static fontStyle(fontTypes fontType,Color itemColor){
    switch(fontType){
      case fontTypes.heading1:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w600,fontSize: 33,);
      case fontTypes.heading2:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w600,fontSize: 23,);
      case fontTypes.heading3:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w500,fontSize: 19);
      case fontTypes.heading4:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w500,fontSize: 16);
      case fontTypes.heading5:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w400,fontSize: 15);
      case fontTypes.text1:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w400,fontSize: 12);
      case fontTypes.text2:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w700,fontSize: 16);
      case fontTypes.text3:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w500,fontSize: 14);
      case fontTypes.text4:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w700,fontSize: 20);
      case fontTypes.text5:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w400,fontSize: 14);
      case fontTypes.text6:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w600,fontSize: 10);
      case fontTypes.text7:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w700,fontSize: 12);
      case fontTypes.text8:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w700,fontSize: 25);
      case fontTypes.text9:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w300,fontSize: 12);
      case fontTypes.text10:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w700,fontSize: 14);
      case fontTypes.text11:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w700,fontSize: 18);
      case fontTypes.text12:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w400,fontSize: 10);
      case fontTypes.text13:
        return TextStyle(color: itemColor,fontWeight: FontWeight.w400,fontSize: 16);

    }



  }

  static priceFormat(int value){
    NumberFormat myFormat = NumberFormat.decimalPattern();
    return myFormat.format(value);
  }
  static priceFormatDouble(double value){
    NumberFormat myFormat = NumberFormat.decimalPattern();
    return myFormat.format(value);
  }

  AppController(Locale locale) {
    locale = locale;
    _localizedValues = new Map();
  }

  static AppController? of(BuildContext context) {
    return Localizations.of<AppController>(context, AppController);
  }

  String value(String key) {
    return _localizedValues[key] ?? '** $key not found';
  }

  static Future<AppController> load(Locale locale) async {
    AppController translations = new AppController(locale);
    String jsonContent =
    await rootBundle.loadString("assets/locales/${locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);
    return translations;
  }
  get currentLanguage => locale.languageCode;


  static getAlertSuccess(){
    return AppController.of(Get.context!)!.value('The operation accomplished.');
  }
  static getAlertError(){
    return AppController.of(Get.context!)!.value('The operation encountered an error!');
  }
  static responceHelper(var data,bool status){
    Map<String,dynamic> result=<String,dynamic>{};
    if(status==false){
      result['status']=false;
      result['message']=AppController.getAlertError();
      result['data']=null;
    }
    else{
      result['status']=true;
      result['message']=AppController.getAlertSuccess();
      result['data']=data;
    }

    return result;
  }
}

