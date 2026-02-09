import 'package:file_picker/file_picker.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/ServerModel/tableModel.dart';
import 'package:finance/Admin/Logic/Models/general.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'app-controller.dart';

class ValidatorController extends GetxController {
  static Future<bool> checkInputValidation(int indexColumn, Map dataJson,
      {var tableData}) async {
    ColumnModel column;
    if (tableData == null) {
      column = MainController.infoSchema.value.columns[indexColumn];
    } else {
      column = tableData.columns[indexColumn];
    }
    var type = column.type;
    String name = column.name;

    if (column.isShowStore == true) {
      if (column.type== 'multiSelect') {
        if (dataJson[name] != null) {
          if (dataJson[name].length == 0) {
            return checkInputRequiredValidator(indexColumn, dataJson,
                tableData: tableData);
          }
        }
      }
      if (column.type == 'select' || column.type == 'radiobutton') {
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
    } else {
      return true;
    }
  }

  static Future<bool> checkInputRequiredValidator(indexColumn, dataJson,
      {var tableData}) async {
    ColumnModel column;
    if (tableData == null) {
      column = MainController.infoSchema.value.columns[indexColumn];
    } else {
      column = tableData.columns[indexColumn];
    }

    if (column.validators != []) {
      var inputRequired = column.validators.firstWhere(
              (validator) => validator['type'] == 'required',
          orElse: () => null);
      String name = column.name;
      if (inputRequired != null) {
        if (inputRequired['type'] == 'required') {
          if (column.type == 'multiSelect' ||
              column.type  == 'select' ||
              column.type  == 'radiobutton') {
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
      column = MainController.infoSchema.value.columns[indexColumn];
      tableName = MainController.infoSchema.value.schema.name!;
    } else {
      column = tableData.columns[indexColumn];
      tableName = tableData.schema.name;
    }

    String name = column.name;
    var maxValidator;
    var minValidator;
    var maxCountValidator;
    var minCountValidator;
    var onlyCountValidator;
    var emailValidator;
    if (column.validators != []) {
      print('ValidatorController.checkInputRangeValidator>>${column.name}>>${column.validators}');
      maxValidator = column.validators.firstWhere(
              (validator) => validator['type'] == 'max',
          orElse: () => null);
      minValidator = column.validators.firstWhere(
              (validator) => validator['type'] == 'min',
          orElse: () => null);
      maxCountValidator = column.validators.firstWhere(
              (validator) => validator['type'] == 'max_count',
          orElse: () => null);
      minCountValidator = column.validators.firstWhere(
              (validator) => validator['type'] == 'min_count',
          orElse: () => null);
      onlyCountValidator = column.validators.firstWhere(
              (validator) => validator['type'] == 'only_count',
          orElse: () => null);
      emailValidator = column.validators.firstWhere(
              (validator) => validator['type'] == 'email',
          orElse: () => null);
    }
    if (
    // column['type'] == 'Number double' ||
    column.type == 'Number int') {
      print('ValidatorController.checkInputRangeValidator>>${ column}');
      var number;
      if (dataJson[name] != null) {
        number = dataJson[name];
        // if (column['type'] == 'Number double') {
        //   if (!(number is double)) {
        //     return false;
        //   }
        // } else {
        if (!(number is int)) {
          return false;
        }
        // }

        number = await General(tableName).withFormat(column.type, number, column.name);

        if (minValidator != null && maxValidator == null) {
          if (number < int.parse(minValidator['value'].toString())) {
            return false;
          }
          else {
            return true;
          }
        }
        else if (minValidator == null && maxValidator != null) {
          if (number > int.parse(maxValidator['value'].toString())) {
            return false;
          }
          else {
            return true;
          }
        }
        else if (minValidator != null && maxValidator != null) {
          if (number < int.parse(minValidator['value'].toString()) ||
              number > int.parse(maxValidator['value'].toString())) {
            return false;
          }
          else {
            return true;
          }
        }
        if (onlyCountValidator != null) {
          if (number.abs().toString().length != int.parse(onlyCountValidator['value'].toString())) {
            showSnackbar(snackTypes.error, onlyCountValidator['message']);
            return false;
          }
          else {
            if (minCountValidator != null && maxCountValidator == null) {
              if (number.abs().toString().length < int.parse(minCountValidator['value'].toString())) {
                return false;
              }
              else {
                return true;
              }
            }
            else if (minCountValidator == null && maxCountValidator != null) {
              if (number
                  .abs()
                  .toString()
                  .length > int.parse(maxCountValidator['value'].toString())) {
                return false;
              }
              else {
                return true;
              }
            }
            else if (minCountValidator != null && maxCountValidator != null) {
              if (number
                  .abs()
                  .toString()
                  .length < int.parse(minCountValidator['value'].toString()) || number
                  .abs()
                  .toString()
                  .length > int.parse(maxCountValidator['value'].toString())) {
                return false;
              }
              else {
                return true;
              }
            }
            return true;
          }
        } else {
          return true;
        }
      }
    }
    else if (column.type == 'string') {
      var string;
      if (dataJson[name] != null) {
        string = dataJson[name];
        // string = await General(tableName).withFormat(column['type'], number, column.name);
        if (onlyCountValidator != null) {
          if (string.toString().length != int.parse(onlyCountValidator['value'].toString())) {
            showSnackbar(snackTypes.error, onlyCountValidator['message']);
            return false;
          }else {
            return true;
          }
        }else{
            if (minCountValidator != null && maxCountValidator == null) {
              if (string.toString().length < int.parse(minCountValidator['value'].toString())) {
                showSnackbar(snackTypes.error, minCountValidator['message']);

                return false;
              }
              else {
                return true;
              }
            } else if (minCountValidator == null && maxCountValidator != null) {
              if (string.toString().length > int.parse(maxCountValidator['value'].toString())) {
                showSnackbar(snackTypes.error, maxCountValidator['message']);

                return false;
              }
              else {
                return true;
              }
            } else if (minCountValidator != null && maxCountValidator != null) {
              if (string.toString().length < int.parse(minCountValidator['value'].toString()) || string.toString().length >int.parse(maxCountValidator['value'].toString())) {
                showSnackbar(snackTypes.error, '${minCountValidator['message']} , ${maxCountValidator['message']}');

                return false;
              }
              else {
                return true;
              }
            }
          }
        }
      }
      else if (column.type == 'file') {
        bool isContains = false;
        if (ViewController.fileSizeList[name] != null) {
          for (var size in ViewController.fileSizeList[name]!) {
            if (minValidator != null || maxValidator != null) {
              if (size > minValidator['value'] &&
                  size < maxValidator['value']) {
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
      }
      else if (column.type == 'email') {
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
        if (!emailRegex.hasMatch(dataJson[name])) {
          return false;
        } else {
          return true;
        }
      }
      else if (column.type == 'mobile') {
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
            for (ColumnModel column in columns) {
              if (column.name == key) {
                if (column.type == 'Number int') {
                  print(
                      'ValidatorController.validateByType Number int>>${request[key]}>>${request[key] is int}');
                  if (request[key] is int == false) {
                    return false;
                  }
                }
                // if (column['type'] == 'Number double') {
                //   if (request[key] is double == false) {
                //     return false;
                //   }
                // }
                if (column.type == 'multiSelect') {
                  print('ValidatorController.validateByType Number int>>${request[key]}>>${request[key] is List}');
                  if (request[key] is List == false) {
                    return false;
                  }
                }
                if (column.type == 'select' || column.type == 'radioButton') {
                  print(
                      'ValidatorController.validateByType Number select>>${request[key]}>>${request[key] is String}');

                  if (request[key] is String == false) {
                    return false;
                  }
                }
                if (column.type == 'checkBox') {
                  print(
                      'ValidatorController.validateByType Number checkBox>>${request[key]}>>${request[key] is bool}');

                  if (request[key] is bool == false) {
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

    // static validateByType(Map<String, dynamic> request, String tableName) {
    //   var columns = MainController.getColumnsTable(tableName);
    //   for (var key in request.keys) {
    //     if (key != '_id') {
    //       if (request[key] != null) {
    //         for (var column in columns) {
    //           if (column.name == key) {
    //             if (column['type'] == 'Number int') {
    //               print(
    //                   'ValidatorController.validateByType>>${request[key]}>>${request[key] is int}');
    //               if (request[key] is int == false) {
    //                 return false;
    //               }
    //             }
    //             if (column['type'] == 'Number double') {
    //               if (request[key] is double == false) {
    //                 return false;
    //               }
    //             }
    //             if (column['type'] == 'multiSelect') {
    //               if (request[key] is List == false) {
    //                 return false;
    //               }
    //             }
    //             if (column['type'] == 'select' || column['type'] == 'radioButton') {
    //               if (request[key] is String == false) {
    //                 return false;
    //               }
    //             }
    //             if (column['type'] == 'checkBox') {
    //               if (request[key] is bool == false) {
    //                 return false;
    //               }
    //             }
    //           }
    //         }
    //       }
    //     }
    //   }
    //   return true;
    // }

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
    static validationFile(ColumnModel column, PlatformFile? file) {
      if (file != null) {
        if (column.validators != []) {
          for (int i = 0; i < column.validators.length; i++) {
            if (column.validators[i]['type'] == 'image') {
              if (imageFormats.contains(file.extension!.toLowerCase())) {
                return [true, ''];
              } else {
                return [false, column.validators[i]['message']];
              }
            } else if (column.validators[i]['type'] == 'pdf') {
              if (file.extension!.toLowerCase() == 'pdf') {
                return [true, ''];
              } else {
                return [false, column.validators[i]['message']];
              }
            }
            if (column.validators[i]['type'] == 'xlsx') {
              if (excelFormats.contains(file.extension!.toLowerCase())) {
                return [true, ''];
              } else {
                return [false, column.validators[i]['message']];
              }
            }
            if (column.validators[i]['type'] == 'word') {
              if (wordFormats.contains(file.extension!.toLowerCase())) {
                return [true, ''];
              } else {
                return [false, column.validators[i]['message']];
              }
            }
            if (column.validators[i]['type'] == 'max') {
              if (file.size <= column.validators[i]['size']) {
                return [true, ''];
              } else {
                return [false, column.validators[i]['message']];
              }
            }
            if (column.validators[i]['type'] == 'min') {
              if (file.size >= column.validators[i]['size']) {
                return [true, ''];
              } else {
                return [false, column.validators[i]['message']];
              }
            }
          }
        }
        return [true, ''];
      }
      return [true, ''];
    }
  }
