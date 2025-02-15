import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ValidatorController extends GetxController {
  static Rx<int> fileSize = 0.obs;

  static bool checkInputValidation(int indexColumn ,Map dataJson){
    var column = MainController.tableInfo['columns'][indexColumn];
    var type = column['type'];
    String name = column['name'];
    if(column['is-show-store'] == true){
      if(dataJson[name] == '' || dataJson[name] == null){
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
    if(column['validators'] != null){
      maxValidator = column['validators'].firstWhere((validator) => validator['type'] == 'max', orElse: () => null);
      minValidator = column['validators'].firstWhere((validator) => validator['type'] == 'min', orElse: () => null);
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
    if (column['type'] == 'file') {
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
    return true;
  }

}