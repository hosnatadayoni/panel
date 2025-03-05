import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'app-controller.dart';

class ValidatorController extends GetxController {
  static Rx<int> fileSize = 0.obs;

  static Future<bool> checkInputValidation(int indexColumn ,Map dataJson) async {

    var column = MainController.tableInfo['columns'][indexColumn];
    var type = column['type'];
    String name = column['name'];

    if(column['is-show-store'] == true){
      if(column['type']=='multiSelect'){
        if(dataJson[name] != null){
          print('dataJson[name] multi select 123>>>${dataJson[name]}');
          // if(dataJson[name].length == 1 && dataJson[name].contains('آیتم مربوطه یافت نشد')){
          //   dataJson[name]=[];
          // }
          List<dynamic> items = await ViewController.itemsList(
              column);
          if(items.length != 0) {
            if (dataJson[name] != null) {
              for (var id in dataJson[name]) {
                var selectedItem = items.firstWhere(
                      (element) => element['value'] == id,
                  orElse: () => null,
                );
                if(selectedItem == null){
                  if(dataJson[name].length == 1){
                    dataJson[name] = [];
                  }

                }
              }
            }
          }
          if(dataJson[name].length == 0){
            return checkInputRequiredValidator(indexColumn , dataJson);
          }
        }
      }
      if(column['type']=='select' || column['type']=='radiobutton'){
        // if(dataJson[name] == 'آیتم مربوطه یافت نشد'){
        //   dataJson[name] = '';
        // }
        List<dynamic> items = await ViewController.itemsList(
            column);
        if(items.length != 0){
          Map<String, dynamic> selectedItem = items.firstWhere(
                  (element) => element['value'] == dataJson[name],
              orElse: () => {'error': '${AppController.of(Get.context!)!.value('The corresponding item has been deleted')}'});
          if(selectedItem['title'] == null){
            dataJson[name] = '';
          }
        }

      }
      if(dataJson[name] == '' || dataJson[name] == null){
        print('data json is empty');
        print('name data is empty>>>${name}');
        return checkInputRequiredValidator(indexColumn , dataJson);
      }
      else{
        return checkInputRangeValidator(indexColumn , dataJson);
      }
      // if(column['validators'] != null){
      //   var inputRequired = column['validators'].firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
      //   if(inputRequired != null){
      //     if(inputRequired['type'] == 'required'){
      //       return checkInputRequiredValidator(indexColumn , dataJson);
      //     }
      //   }
      //   if(type == 'number' || type == 'file'){
      //     return checkInputRangeValidator(indexColumn , dataJson);
      //   }
      // }
    }
    else{
      return true;
    }
  }
  static bool checkInputRequiredValidator(indexColumn , dataJson){
    var column = MainController.tableInfo['columns'][indexColumn];
    if( column['validators'] != null){
      var inputRequired = column['validators'].firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
      String name = column['name'];
      if(inputRequired != null){
        if(inputRequired['type'] == 'required'){
          return false;
        }
        // if(dataJson[name] == null || dataJson[name] == ''){
        //
        // }
        else{
          return true;
        }
      }
      else{
        return true;
      }
    }
    else{
      return true;
    }
  }

  static bool checkInputRangeValidator(indexColumn , dataJson){
    var column = MainController.tableInfo['columns'][indexColumn];
    String name = column['name'];
    var maxValidator;
    var minValidator;
    var emailValidator;
    if(column['validators'] != null){
      maxValidator = column['validators'].firstWhere((validator) => validator['type'] == 'max', orElse: () => null);
      minValidator = column['validators'].firstWhere((validator) => validator['type'] == 'min', orElse: () => null);
      emailValidator = column['validators'].firstWhere((validator) => validator['type'] == 'email', orElse: () => null);
    }
    if(column['type'] == 'number'){
          var number;
          number = num.tryParse(dataJson[name]);
          if(number != null){
            if(minValidator != null && maxValidator != null){
              if(number < minValidator['value'] || number > maxValidator['value']){
                return false;
              }
              else{
                return true;
              }
            }

        }
      }
    else if (column['type'] == 'file') {
      bool isContains= false;
      if(ViewController.fileSizeList[name]!= null){
        for(var size in ViewController.fileSizeList[name]!){
          if(size > minValidator['value'] && size < maxValidator['value']){
            isContains = true;

          }
          else{
            isContains = false;
          }

        }
        return isContains;
      }

    }
    else if(column['type'] == 'email'){
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      if (!emailRegex.hasMatch(dataJson[name])) {
        return false;
      }
      else{
        return true;
      }
    }
    else if(column['type'] == 'mobile'){
      if(dataJson[name].length > 13 || !dataJson[name].startsWith('9')){
        return false;
      }
      else{
        return true;
      }
    }

    return true;
  }

}