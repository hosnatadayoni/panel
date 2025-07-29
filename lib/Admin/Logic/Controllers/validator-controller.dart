import 'dart:ffi';

import 'package:file_picker/file_picker.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/general.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'app-controller.dart';

class ValidatorController extends GetxController {
  static Future<bool> checkInputValidation(int indexColumn, Map dataJson,
      {var tableData}) async {
    var column;
    if (tableData == null) {
      column = MainController.tableInfo['columns'][indexColumn];
    } else {
      column = tableData['columns'][indexColumn];
    }
    var type = column['type'];
    String name = column['name'];

    if (column['is_show_store'] == true) {
      if (column['type'] == 'multiSelect') {
        if (dataJson[name] != null) {
          // List<dynamic> items = await ViewController.itemsList(column);
          // if(items.length != 0) {
          //   if (dataJson[name] != null) {
          //     for (var id in dataJson[name]) {
          //       var selectedItem = items.firstWhere(
          //             (element) => element['value'] == id,
          //         orElse: () => null,
          //       );
          //       if(selectedItem == null){
          //         if(dataJson[name].length == 1){
          //           dataJson[name] = [];
          //         }
          //
          //       }
          //     }
          //   }
          // }
          if (dataJson[name].length == 0) {
            return checkInputRequiredValidator(indexColumn, dataJson,
                tableData: tableData);
          }
        }
      }
      if (column['type'] == 'select' || column['type'] == 'radiobutton') {
        // if(dataJson[name] == 'آیتم مربوطه یافت نشد'){
        //   dataJson[name] = '';
        // }
        // List<dynamic> items = await ViewController.itemsList(
        //     column);
        // if(items.length != 0){
        //   Map<String, dynamic> selectedItem = items.firstWhere(
        //           (element) => element['value'] == dataJson[name],
        //       orElse: () => {'error': '${AppController.of(Get.context!)!.value('The corresponding item has been deleted')}'});
        //   if(selectedItem['title'] == null){
        //     dataJson[name] = '';
        //   }
        // }
        if (dataJson[name] == '' || dataJson[name] == null) {
          return checkInputRequiredValidator(indexColumn, dataJson,
              tableData: tableData);
        }
      }
      if (dataJson[name] == '' || dataJson[name] == null) {
        return checkInputRequiredValidator(indexColumn, dataJson,
            tableData: tableData);
      } else {
        return checkInputRangeValidator(indexColumn, dataJson,
            tableData: tableData);
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
    } else {
      return true;
    }
  }

  static Future<bool> checkInputRequiredValidator(indexColumn, dataJson,
      {var tableData}) async {
    var column;
    if (tableData == null) {
      column = MainController.tableInfo['columns'][indexColumn];
    } else {
      column = tableData['columns'][indexColumn];
    }

    if (column['validators'] != null) {
      var inputRequired = column['validators'].firstWhere(
          (validator) => validator['type'] == 'required',
          orElse: () => null);
      String name = column['name'];
      if (inputRequired != null) {
        if (inputRequired['type'] == 'required') {
          if (column['type'] == 'multiSelect' ||
              column['type'] == 'select' ||
              column['type'] == 'radiobutton') {
            List<dynamic> items = await ViewController.itemsList(column);
            if (items.length == 0) {
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        }
        // if(dataJson[name] == null || dataJson[name] == ''){
        //
        // }
        else {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  static Future<bool> checkInputRangeValidator(indexColumn, dataJson,
      {tableData}) async {
    var column;
    String tableName = '';
    if (tableData == null) {
      column = MainController.tableInfo['columns'][indexColumn];
      tableName = MainController.tableInfo['schema']['name'];
    } else {
      column = tableData['columns'][indexColumn];
      tableName = tableData['schema']['name'];
    }

    String name = column['name'];
    var maxValidator;
    var minValidator;
    var emailValidator;
    if (column['validators'] != null) {
      maxValidator = column['validators'].firstWhere(
          (validator) => validator['type'] == 'max',
          orElse: () => null);
      minValidator = column['validators'].firstWhere(
          (validator) => validator['type'] == 'min',
          orElse: () => null);
      emailValidator = column['validators'].firstWhere(
          (validator) => validator['type'] == 'email',
          orElse: () => null);
    }
    if (column['type'] == 'Number double' || column['type'] == 'Number int') {
      var number;
      if (dataJson[name] != null) {
        number = dataJson[name];
        if (column['type'] == 'Number double') {
          if (!(number is double)) {
            return false;
          }
        } else {
          if (!(number is int)) {
            return false;
          }
        }

        number = await General(tableName)
            .withFormat(column['type'], number, column['name']);
        if (minValidator != null && maxValidator != null) {
          if (number < minValidator['value'] ||
              number > maxValidator['value']) {
            return false;
          } else {
            return true;
          }
        }
      }
    } else if (column['type'] == 'file') {
      bool isContains = false;
      if (ViewController.fileSizeList[name] != null) {
        for (var size in ViewController.fileSizeList[name]!) {
          if (minValidator != null || maxValidator != null) {
            if (size > minValidator['value'] && size < maxValidator['value']) {
              isContains = true;
            } else {
              isContains = false;
            }
          } else {
            return true;
          }
        }
        return isContains;
      }
    } else if (column['type'] == 'email') {
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      if (!emailRegex.hasMatch(dataJson[name])) {
        return false;
      } else {
        return true;
      }
    } else if (column['type'] == 'mobile') {
      if (dataJson[name].length > 13 || !dataJson[name].startsWith('9')) {
        return false;
      } else {
        return true;
      }
    }

    return true;
  }

  static validateByType(Map<String, dynamic> request, String tableName) {
    var columns = MainController.getColumnsTable(tableName);
    for (var key in request.keys) {
      if (key != '_id') {
        if (request[key] != null) {
          for (var column in columns) {
            if (column['name'] == key) {
              if (column['type'] == 'Number int') {
                print(
                    'ValidatorController.validateByType>>${request[key]}>>${request[key] is int}');
                if (request[key] is int == false) {
                  return false;
                }
              }
              if (column['type'] == 'Number double') {
                if (request[key] is double == false) {
                  return false;
                }
              }
              if (column['type'] == 'multiSelect') {
                if (request[key] is List == false) {
                  return false;
                }
              }
              if (column['type'] == 'select' ||
                  column['type'] == 'radioButton') {
                if (request[key] is String == false) {
                  return false;
                }
              }
              if (column['type'] == 'checkBox') {
                if (request[key] is Bool == false) {
                  return false;
                }
              }
            }
          }
        }
      }
    }
    return true;
  }

  static List<String> imageFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'tiff',
    'tif',
    'bmp',
    'webp',
    'raw',
    'heif',
    'heic',
    'svg',
    'psd',
    'eps',
    'pdf',
    'ico',
  ];
  static List<String> excelFormats = [
    'xls',
    'xlsx',
  ];
  static List<String> wordFormats = [
    'doc',
    'docx',
  ];
  static validationFile(var column, PlatformFile? file) {
    if(file!=null) {
      if (column['validators'] != null) {
        for (int i = 0; i < column['validators'].length; i++) {
          if (column['validators'][i]['type'] == 'image') {
              if (imageFormats.contains(file.extension!.toLowerCase())) {
                return [true, ''];
              } else {
                return [false, column['validators'][i]['message']];
              }
          } else if (column['validators'][i]['type'] == 'pdf') {
              if (file.extension!.toLowerCase() == 'pdf') {
                return [true, ''];
              } else {
                return [false, column['validators'][i]['message']];
              }
          }
          if (column['validators'][i]['type'] == 'xlsx') {
              if (excelFormats.contains(file.extension!.toLowerCase())) {
                return [true, ''];
              } else {
                return [false, column['validators'][i]['message']];
              }
          }
          if (column['validators'][i]['type'] == 'word') {
              if (wordFormats.contains(file.extension!.toLowerCase())) {
                return [true, ''];
              } else {
                return [false, column['validators'][i]['message']];
              }
          }  if (column['validators'][i]['type'] == 'max') {
              if (file.size <= column['validators'][i]['size']) {
                return [true, ''];
              } else {
                return [false, column['validators'][i]['message']];
              }
          }  if (column['validators'][i]['type'] == 'min') {
              if (file.size >= column['validators'][i]['size']) {
                return [true, ''];
              } else {
                return [false, column['validators'][i]['message']];
              }
          }
        }
      }
      return [true,''];;
    }
    return [true,''];
  }
}
