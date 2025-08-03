import 'dart:convert';
import 'dart:io';
import 'package:chunked_uploader/chunked_uploader.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:panel/Admin/Logic/Controllers/app-controller.dart';
import 'package:panel/Admin/Logic/Controllers/dataController.dart';
import 'package:panel/Admin/Logic/Controllers/view-controller.dart';
import 'package:panel/Admin/Logic/Controllers/view-custom-controller.dart';
import 'package:panel/Admin/Logic/Helpers/api-methods.dart';
import 'package:panel/Admin/Logic/Helpers/token-methods.dart';
import 'package:panel/Admin/Logic/Models/dataModel.dart';
import 'package:panel/Admin/Logic/Models/db.dart';
import 'package:panel/Admin/Public/api-urls.dart';
import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-checkBox.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-color.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-date.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-radio-button.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:panel/Admin/UI/Componenets/Items/Menu/menu-item.dart';
import 'package:panel/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:panel/Admin/boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' as exl;
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../UI/Views/table-page.dart';
import 'connect-server-controller.dart';
import 'helper-controller.dart';
import 'package:intl/intl.dart';
// import 'dart:html' as html;

class MainController extends GetxController {
  static Rx<bool> isLightMode = true.obs;
  static Rx<int> countShowRow = 10.obs;
  static Rx<bool> isClickedItem = false.obs;
  //get all data for search
  static RxList<dynamic> allData=[].obs;
  static Rx<double> progress = 0.0.obs;

  //dehdar remove this section read icon of json
  static List<Item> items = [
    Item(
      title: 'داشبورد',
      icon: Icons.bar_chart,
    ),
    Item(
      title: 'component',
      icon: Icons.settings_input_component,
    ),
    Item(
      title: 'Home',
      icon: Icons.home,
    )

  ];

  //
  static RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;

  static String formatNumber(String number) {
    try {
      final num value = num.tryParse(number) ?? 0;
      return NumberFormat.decimalPattern().format(value);
    } catch (e) {
      return number;
    }
  }

  // static Rx<int> selectedItem = (-1).obs;
  static Rx<int> selectedItem = 0.obs;
  static Rx<int> selectedSubItem = (-1).obs;
  static Rx<Item> itemSelected = Item().obs;
  static Rx<int> subItemSelectedIndex = (-1).obs;
  static Rx<String> subItemSelected = ''.obs;
  static Rx<int> totalPages = 1.obs;
  static Rx<int> startIndex = 0.obs;
  static Rx<int> endIndex = 0.obs;
  static Rx<int> totalItems = 0.obs;
  static RxList<dynamic> tableData = [].obs;
  static RxString searchQuery = ''.obs;
  static Rx<bool> isSelected = false.obs;
  static Rx<String> tableName=''.obs;

  //dasboard page
  static var hoveredIndex = (-1).obs;

  static List<dynamic> data = [];

  static Map<String, dynamic> dataJson = {};

  static Rx<int> selectedItemList = 0.obs;

  static List<dynamic> SubMenuList = [];
  static dynamic tableInfo = null;
  DataModel? dataModel;
  static var allColumn;

  static GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

  static Future<void> createExel(String? fileExelPath) async {
    var excel = exl.Excel.createExcel();
    var cell;

    exl.Sheet sheet = excel['Sheet1'];
    sheet.isRTL = true;

    // if (MainController.table['table-name'] == box.name) {
    int excelColumnIndex = 0;
    cell = sheet.cell(exl.CellIndex.indexByString(
        '${String.fromCharCode(65 + (excelColumnIndex))}1'));
    cell.value = exl.TextCellValue('id');
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      if (MainController.tableInfo['columns'][j]['is-show-excel'] == true) {
        var column = MainController.tableInfo['columns'][j];
        var name = column['name'];
        cell = sheet.cell(exl.CellIndex.indexByString(
            '${String.fromCharCode(65 + (excelColumnIndex + 1))}1'));
        cell.value = exl.TextCellValue('${name}');
        excelColumnIndex++;
      }
    }
    int rowIndex = 2;
    for (var data in MainController.tableData.value) {
      List<exl.CellValue> rowData = [];
      // rowData.add(exl.TextCellValue(data.id));
      rowData.add(exl.TextCellValue(data['_id']));
      for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
        if (MainController.tableInfo['columns'][j]['is-show-excel'] == true) {
          var column = MainController.tableInfo['columns'][j];
          var name = column['name'];
          // var value = data.data[name]?.toString() ?? '';
          // var value = data.data[name] ?? '';
          var value = data[name] ?? '';
          List<dynamic> items = [];
          String tableName = '';
          if (column['type'] == 'select' ||
              column['type'] == 'multiSelect' ||
              column['type'] == 'radiobutton') {
            items = await ViewController.itemsList(column);
          }
          if (column['type'] == 'select' || column['type'] == 'radiobutton') {
            if (column['sourceItems'] != 'custom') {
              tableName = column['sourceTable'];
            }
            String title;
            if (data[name] != null) {
              print('data[name] f>>>${data[name]} ${name}');
              print('sdfgh>>>>${ViewController.itemsShowSelectItem(data['${name}'], column) }');
              // title = await ViewController.getTitleSelectedItem(
              //     '${tableName}', data[name], column);
              title = ViewController.itemsShowSelectItem(data['${name}'], column);
            } else {
              title = '';
            }
            rowData.add(exl.TextCellValue(title));
          } else if (column['type'] == 'multiSelect') {
            if (column['sourceItems'] != 'custom') {
              if (column['sourceTable'] != null) {
                tableName = column['sourceTable'];
              }
            }
            // List<dynamic> listTitle = [];
            String listTitle='';
            if (data[name] != null) {
              // listTitle = await ViewController.getTitleMultiSelectedItem(
              //     '${tableName}', data[name], column);
              listTitle = ViewController.itemsShowSelectItem(data['${name}'], column);
            }

            rowData.add(exl.TextCellValue(listTitle));
          } else if (column['type'] == 'checkbox') {
            rowData.add(exl.BoolCellValue(value));
          } else if (column['type'] == 'file') {
            if (value != '') {
              String fileName = getNameFile(value);
              rowData.add(exl.TextCellValue(fileName.toString()));
            } else {
              rowData.add(exl.TextCellValue(''));
            }
          } else {
            rowData.add(exl.TextCellValue(value.toString()));
          }
        }
      }
      for (var i = 0; i < rowData.length; i++) {
      }

      sheet.appendRow(rowData);
      rowIndex++;
    }

    String? fileExelPath;

    if (kIsWeb) {
      fileExelPath = 'C:\\Downloads';
    } else {
      fileExelPath = await FilePicker.platform.getDirectoryPath();
    }
    String? filePath;
    if (fileExelPath != null) {
      filePath = '${fileExelPath}\\${tableInfo['table-name']}.xlsx';

      if (kIsWeb) {
        String tableName = tableInfo['table-name'];
        // final bytes = excel.encode();
        // final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        //
        // final url = html.Url.createObjectUrlFromBlob(blob);
        //
        // final anchor = html.AnchorElement(href: url)
        //   ..setAttribute('download', '$tableName.xlsx')
        //   ..click();
        //
        // html.Url.revokeObjectUrl(url);
      } else {
        File(filePath!)
          ..createSync(recursive: true)
          ..writeAsBytesSync(excel.save()!);
      }
      showSnackbar(snackTypes.success,
          '${AppController.of(Get.context!)!.value('the desired file')}  ${fileExelPath} ${AppController.of(Get.context!)!.value('saved')}');
    }
  }

  // static Future<void> readExcelFile(String? fileExelPath) async {
  //   String? filePath;
  //   FilePickerResult? result;
  //   // if (filePath != null) {
  //   var excel;
  //   if (kIsWeb) {
  //     // result = await FilePicker.platform.pickFiles(
  //     //   type: FileType.custom,
  //     //   allowedExtensions: ['xlsx'],
  //     // );
  //     // if(result != null){
  //     //   var bytes = File(filePath!).readAsBytesSync();
  //     //   excel = exl.Excel.decodeBytes(bytes);
  //     // }
  //
  //     // html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  //     // uploadInput.accept = 'xlsx';
  //     // uploadInput.click();
  //     //
  //     // uploadInput.onChange.listen((e) async {
  //     //   final files = uploadInput.files;
  //     //   if (files!.isEmpty) return;
  //     //
  //     //   final reader = html.FileReader();
  //     //   reader.readAsArrayBuffer(files[0]);
  //     //   reader.onLoadEnd.listen((e) async {
  //     //     var bytes = reader.result as Uint8List;
  //     //     excel = exl.Excel.decodeBytes(bytes);
  //     //   });
  //     // });
  //     result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['xlsx'],
  //     );
  //     if (result != null) {
  //       List<int> bytes = result.files.first.bytes as List<int>;
  //       excel = exl.Excel.decodeBytes(bytes);
  //     }
  //   } else {
  //     filePath = await FilePicker.platform.pickFiles(
  //         type: FileType.custom, allowedExtensions: ['xlsx']).then((result) {
  //       return result?.files.single.path;
  //     });
  //     if (filePath != null) {
  //       var bytes = File(filePath).readAsBytesSync();
  //       excel = exl.Excel.decodeBytes(bytes);
  //     }
  //   }
  //   List<Map<String, dynamic>> rowdetail = [];
  //
  //   //keys[0] dehdar
  //   int counter = 0;
  //   List<dynamic> excelColumns = [];
  //
  //   List<String> currentIds = [];
  //   if (excel != null && excel.tables != null) {
  //     for (var table in excel.tables.keys) {
  //       for (var row in excel.tables[table]!.rows) {
  //         // rowData.value = [];
  //         // rowdetail = [];
  //         if (counter == 0) {
  //           for (var cell in row) {
  //             excelColumns.add(cell?.value.toString());
  //           }
  //         } else {
  //           List<dynamic> rowData = [];
  //           Map<String, dynamic> rowDataTest = {};
  //           int counterColumn = 0;
  //           for (var cell in row) {
  //             var columnName = excelColumns[counterColumn];
  //             var columnType = MainController.tableInfo['columns'].firstWhere(
  //                 (col) => col['name'] == columnName,
  //                 orElse: () => null)?['type'];
  //
  //             dynamic cellValue = cell?.value;
  //
  //             if (columnType != null) {
  //               switch (columnType) {
  //                 case 'select':
  //                   if (cellValue != null) {
  //                     cellValue = cellValue.toString();
  //                   }
  //                   break;
  //                 case 'radiobutton':
  //                   if (cellValue != null) {
  //                     cellValue = cellValue.toString();
  //                   }
  //                   break;
  //                 case 'multiSelect':
  //                   if (cellValue != null) {
  //                     cellValue = cellValue
  //                         .toString()
  //                         .split(',')
  //                         .map((e) => e.trim())
  //                         .toList();
  //                   } else {
  //                     cellValue = [];
  //                   }
  //                   break;
  //                 case 'checkbox':
  //                   cellValue = cellValue.toString().toLowerCase() == 'true';
  //                   break;
  //                 case 'color':
  //                   if (cellValue != null) {
  //                     cellValue = cellValue.toString();
  //                   } else {
  //                     cellValue = '';
  //                   }
  //                   break;
  //                 case 'mobile':
  //                   if (cellValue != null) {
  //                     if (cellValue is exl.DoubleCellValue) {
  //                       double doubleValue =
  //                           (cellValue as exl.DoubleCellValue).value;
  //                       cellValue = exl.IntCellValue(doubleValue.toInt());
  //                     } else {
  //                       cellValue = int.tryParse(cellValue.toString());
  //                     }
  //
  //                   } else {
  //                     cellValue = 0;
  //                   }
  //                   break;
  //                 default:
  //                   if (cellValue != null) {
  //                     cellValue = cellValue.toString();
  //                   }
  //                   break;
  //               }
  //             }
  //             if (cell?.value is exl.DoubleCellValue) {
  //               double doubleValue = (cell!.value as exl.DoubleCellValue).value;
  //               cell.value = exl.IntCellValue(doubleValue.toInt());
  //             }
  //             if (columnType == 'select') {
  //             } else if (columnType == 'radiobutton') {
  //             } else if (columnType == 'multiSelect') {
  //             } else if (columnType == 'checkbox') {
  //             } else if (columnType == 'file') {
  //             } else if (columnType == 'mobile') {
  //             }
  //             rowData.add(cellValue);
  //             rowDataTest[excelColumns[counterColumn]] = cellValue;
  //             // rowData.add(cell?.value);
  //             // rowDataTest[excelColumns[counterColumn]] = cell?.value;
  //             counterColumn++;
  //           }
  //           currentIds.add('${rowDataTest[excelColumns[0]]}');
  //           if (rowData.any((element) => element != null)) {
  //             rowdetail.add(rowDataTest);
  //           }
  //         }
  //         counter++;
  //       }
  //     }
  //   }
  //
  //
  //   var columnPrime = getColumnPrime();
  //
  //   for (var data in rowdetail) {
  //     var findIndexRecord = findByColumn(data, columnPrime);
  //
  //     //create data json
  //     //function generate json record with columns name and data excel
  //     var excelJson = await generateJsonExcel(data, findIndexRecord);
  //     bool isValidator;
  //     List<bool> isValidatorList = [];
  //     for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
  //       var column = MainController.tableInfo['columns'][j];
  //       bool isValidator =
  //           await identificationValidator(excelJson[column['name']], column);
  //
  //       isValidatorList.add(isValidator);
  //     }
  //     bool isExsistsValidation = isValidatorList.contains(false);
  //
  //     if (findIndexRecord != -1) {
  //       // updateRecord(excelJson, findIndexRecord, columnPrime);
  //       bool isValidator;
  //       List<bool> isValidatorList = [];
  //       for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
  //         var column = MainController.tableInfo['columns'][j];
  //         bool isValidator =
  //             await identificationValidator(excelJson[column['name']], column);
  //         isValidatorList.add(isValidator);
  //       }
  //       bool isExsistsValidation = isValidatorList.contains(false);
  //       if (isExsistsValidation) {
  //         isValidatorList = [];
  //       } else {
  //         updateRecord(excelJson, findIndexRecord, columnPrime);
  //       }
  //     } else {
  //       bool isValidator;
  //       List<bool> isValidatorList = [];
  //       for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
  //         var column = MainController.tableInfo['columns'][j];
  //         bool isValidator =
  //             await identificationValidator(excelJson[column['name']], column);
  //         isValidatorList.add(isValidator);
  //       }
  //       bool isExsistsValidation = isValidatorList.contains(false);
  //       if (isExsistsValidation) {
  //         isValidatorList = [];
  //       } else {
  //         createRecord(excelJson);
  //       }
  //     }
  //   }
  //   //read all record of excel
  //   //if this record is column prime or id prime
  //   //is prime column:find function by column ===> check this record has in table yes or no with prime value
  //   //yes:update
  //   //no :add
  //
  //   //else is prime id:find function by id ===>check this record has in table yes or no with id
  //   //yes:update
  //   //no:add
  //
  //   //function find by column:column-excel record
  //   //loop search in table
  //   //if find data of table column prime with column prime
  //   //yes:return record table
  //   //no :return null
  //
  //   ///create function update:excel data - table data
  //   /// create new json for update
  //   /// check column is false for load of excel
  //   /// yes:old data add to json
  //   /// no:new data read of excel
  //   /// finaly :upadate table with new json
  //
  //   ///create function add:excel data
  //   /// create new json for update
  //   /// check column is false for load of excel
  //   /// yes:null to json
  //   /// no:new data read of excel
  //   /// finaly :add table with new json
  //
  //   MainController.renderPagination();
  //   // }
  // }
  // static Future<void> readExcelFile(String? fileExelPath) async {
  //   String? filePath;
  //   FilePickerResult? result;
  //   // if (filePath != null) {
  //   var excel;
  //   if (kIsWeb) {
  //     // result = await FilePicker.platform.pickFiles(
  //     //   type: FileType.custom,
  //     //   allowedExtensions: ['xlsx'],
  //     // );
  //     // print('result>>>${result!.names}');
  //     // if(result != null){
  //     //   var bytes = File(filePath!).readAsBytesSync();
  //     //   excel = exl.Excel.decodeBytes(bytes);
  //     // }
  //
  //     // html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  //     // uploadInput.accept = 'xlsx';
  //     // uploadInput.click();
  //     //
  //     // uploadInput.onChange.listen((e) async {
  //     //   final files = uploadInput.files;
  //     //   if (files!.isEmpty) return;
  //     //
  //     //   final reader = html.FileReader();
  //     //   reader.readAsArrayBuffer(files[0]);
  //     //   reader.onLoadEnd.listen((e) async {
  //     //     var bytes = reader.result as Uint8List;
  //     //     print('bytes>>>${bytes}');
  //     //     excel = exl.Excel.decodeBytes(bytes);
  //     //   });
  //     // });
  //     result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['xlsx'],
  //     );
  //     if (result != null) {
  //       List<int> bytes = result.files.first.bytes as List<int>;
  //       excel = exl.Excel.decodeBytes(bytes);
  //     }
  //   } else {
  //     filePath = await FilePicker.platform.pickFiles(
  //         type: FileType.custom, allowedExtensions: ['xlsx']).then((result) {
  //       return result?.files.single.path;
  //     });
  //     if (filePath != null) {
  //       var bytes = File(filePath!).readAsBytesSync();
  //       excel = exl.Excel.decodeBytes(bytes);
  //     }
  //   }
  //   List<Map<String, dynamic>> rowdetail = [];
  //
  //   //keys[0] dehdar
  //   int counter = 0;
  //   List<dynamic> excelColumns = [];
  //
  //   List<String> currentIds = [];
  //   if (excel != null && excel.tables != null) {
  //     for (var table in excel.tables.keys) {
  //       for (var row in excel.tables[table]!.rows) {
  //         // rowData.value = [];
  //         // rowdetail = [];
  //         if (counter == 0) {
  //           for (var cell in row) {
  //             excelColumns.add(cell?.value.toString());
  //           }
  //         } else {
  //           List<dynamic> rowData = [];
  //           Map<String, dynamic> rowDataTest = {};
  //           int counterColumn = 0;
  //           for (var cell in row) {
  //             var columnName = excelColumns[counterColumn];
  //             var columnType = MainController.tableInfo['columns'].firstWhere(
  //                     (col) => col['name'] == columnName,
  //                 orElse: () => null)?['type'];
  //
  //             dynamic cellValue = cell?.value;
  //
  //             if (columnType != null) {
  //               switch (columnType) {
  //                 case 'select':
  //                   if (cellValue != null) {
  //                     cellValue = cellValue.toString();
  //                   }
  //                   break;
  //                 case 'radiobutton':
  //                   if (cellValue != null) {
  //                     cellValue = cellValue.toString();
  //                   }
  //                   break;
  //                 case 'multiSelect':
  //                   if (cellValue != null) {
  //                     cellValue = cellValue
  //                         .toString()
  //                         .split(',')
  //                         .map((e) => e.trim())
  //                         .toList();
  //                   } else {
  //                     cellValue = [];
  //                   }
  //                   break;
  //                 case 'checkbox':
  //                   cellValue = cellValue.toString().toLowerCase() == 'true';
  //                   break;
  //                 case 'color':
  //                   if (cellValue != null) {
  //                     cellValue = cellValue.toString();
  //                   } else {
  //                     cellValue = '';
  //                   }
  //                   break;
  //                 case 'mobile':
  //                   print(
  //                       'cell value before mobile>>>${cellValue} ${cellValue.runtimeType}');
  //                   if (cellValue != null) {
  //                     if (cellValue is exl.DoubleCellValue) {
  //                       double doubleValue =
  //                           (cellValue as exl.DoubleCellValue).value;
  //                       cellValue = exl.IntCellValue(doubleValue.toInt());
  //                     } else {
  //                       cellValue = int.tryParse(cellValue.toString());
  //                     }
  //
  //                   } else {
  //                     cellValue = 0;
  //                   }
  //                   print(
  //                       'cell value mobile type>>>${cellValue} ${cellValue.runtimeType}');
  //                   break;
  //                 default:
  //                   if (cellValue != null) {
  //                     cellValue = cellValue.toString();
  //                   }
  //                   break;
  //               }
  //             }
  //             if (cell?.value is exl.DoubleCellValue) {
  //               double doubleValue = (cell!.value as exl.DoubleCellValue).value;
  //               cell.value = exl.IntCellValue(doubleValue.toInt());
  //             }
  //             if (columnType == 'select') {
  //               print(
  //                   'columnType selct type>>>${cellValue.runtimeType}  ${cellValue}');
  //             } else if (columnType == 'radiobutton') {
  //               print(
  //                   'columnType radiobutton type>>>${cellValue.runtimeType}  ${cellValue}');
  //             } else if (columnType == 'multiSelect') {
  //               print(
  //                   'columnType multiSelect type>>>${cellValue.runtimeType}  ${cellValue}');
  //             } else if (columnType == 'checkbox') {
  //               print(
  //                   'columnType checkbox type>>>${cellValue.runtimeType}  ${cellValue}');
  //             } else if (columnType == 'file') {
  //               print(
  //                   'columnType file type>>>${cellValue.runtimeType} ${cellValue}');
  //             } else if (columnType == 'mobile') {
  //               print(
  //                   'columnType mobile type>>>${cellValue.runtimeType} ${cellValue}');
  //             }
  //             rowData.add(cellValue);
  //             rowDataTest[excelColumns[counterColumn]] = cellValue;
  //             // rowData.add(cell?.value);
  //             // rowDataTest[excelColumns[counterColumn]] = cell?.value;
  //             counterColumn++;
  //           }
  //           currentIds.add('${rowDataTest[excelColumns[0]]}');
  //           if (rowData.any((element) => element != null)) {
  //             rowdetail.add(rowDataTest);
  //           }
  //         }
  //         counter++;
  //       }
  //     }
  //   }
  //
  //
  //   var columnPrime = getColumnPrime();
  //
  //   for (var data in rowdetail) {
  //     var findIndexRecord = findByColumn(data, columnPrime);
  //
  //     //create data json
  //     //function generate json record with columns name and data excel
  //     var excelJson = await generateJsonExcel(data, findIndexRecord);
  //     bool isValidator;
  //     // List<bool> isValidatorList = [];
  //     // for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
  //     //   var column = MainController.tableInfo['columns'][j];
  //     //   bool isValidator =
  //     //       await identificationValidator(excelJson[column['name']], column);
  //     //
  //     //   isValidatorList.add(isValidator);
  //     // }
  //     // bool isExsistsValidation = isValidatorList.contains(false);
  //     // print('isValidatorList>>>${isValidatorList}');
  //     // print('findIndexRecord excel>>>${findIndexRecord}');
  //
  //     if (findIndexRecord != -1) {
  //       DataModel k =DataModel(data: excelJson,id: MainController.tableData.value[findIndexRecord]['id']);
  //       await DB('${MainController.tableInfo['table-name']}').where('id', '==', '${MainController.tableData.value[findIndexRecord]['id']}').updateRecord(k.data);
  //       // updateRecord(excelJson, findIndexRecord, columnPrime);
  //       // bool isValidator;
  //       // List<bool> isValidatorList = [];
  //       // for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
  //       //   var column = MainController.tableInfo['columns'][j];
  //       //   bool isValidator =
  //       //       await identificationValidator(excelJson[column['name']], column);
  //       //   isValidatorList.add(isValidator);
  //       // }
  //       // bool isExsistsValidation = isValidatorList.contains(false);
  //       // if (isExsistsValidation) {
  //       //   isValidatorList = [];
  //       // } else {
  //       //   print('excelJsonf>>>${excelJson}');
  //       //   DataModel k =DataModel(data: excelJson,id: MainController.tableData.value[findIndexRecord]['id']);
  //       //   print('k.data>>>${k.data}');
  //       //   // updateRecord(excelJson, findIndexRecord, columnPrime);
  //       //     print('kjhgft>>>${DB('${MainController.tableInfo['table-name']}').getTypeOfField([k])}');
  //       //   await DB('${MainController.tableInfo['table-name']}').where('id', '==', '${MainController.tableData.value[findIndexRecord]['id']}').updateRecord(k.data);
  //
  //       // }
  //     } else {
  //       await DB('${MainController.tableInfo['table-name']}').storeRecord(excelJson);
  //       // bool isValidator;
  //       // List<bool> isValidatorList = [];
  //       // for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
  //       //   var column = MainController.tableInfo['columns'][j];
  //       //   bool isValidator =
  //       //       await identificationValidator(excelJson[column['name']], column);
  //       //   isValidatorList.add(isValidator);
  //       // }
  //       // bool isExsistsValidation = isValidatorList.contains(false);
  //       // if (isExsistsValidation) {
  //       //   isValidatorList = [];
  //       // } else {
  //       //   createRecord(excelJson);
  //       // }
  //     }
  //   }
  //   //read all record of excel
  //   //if this record is column prime or id prime
  //   //is prime column:find function by column ===> check this record has in table yes or no with prime value
  //   //yes:update
  //   //no :add
  //
  //   //else is prime id:find function by id ===>check this record has in table yes or no with id
  //   //yes:update
  //   //no:add
  //
  //   //function find by column:column-excel record
  //   //loop search in table
  //   //if find data of table column prime with column prime
  //   //yes:return record table
  //   //no :return null
  //
  //   ///create function update:excel data - table data
  //   /// create new json for update
  //   /// check column is false for load of excel
  //   /// yes:old data add to json
  //   /// no:new data read of excel
  //   /// finaly :upadate table with new json
  //
  //   ///create function add:excel data
  //   /// create new json for update
  //   /// check column is false for load of excel
  //   /// yes:null to json
  //   /// no:new data read of excel
  //   /// finaly :add table with new json
  //
  //   // MainController.renderPagination();
  //
  //
  //   // }
  //
  // }

  static Future<void> readExcelFile(String? fileExelPath) async {
    String? filePath;
    FilePickerResult? result;
    // if (filePath != null) {
    var excel;
    if (kIsWeb) {
      // result = await FilePicker.platform.pickFiles(
      //   type: FileType.custom,
      //   allowedExtensions: ['xlsx'],
      // );
      // print('result>>>${result!.names}');
      // if(result != null){
      //   var bytes = File(filePath!).readAsBytesSync();
      //   excel = exl.Excel.decodeBytes(bytes);
      // }

      // html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      // uploadInput.accept = 'xlsx';
      // uploadInput.click();
      //
      // uploadInput.onChange.listen((e) async {
      //   final files = uploadInput.files;
      //   if (files!.isEmpty) return;
      //
      //   final reader = html.FileReader();
      //   reader.readAsArrayBuffer(files[0]);
      //   reader.onLoadEnd.listen((e) async {
      //     var bytes = reader.result as Uint8List;
      //     print('bytes>>>${bytes}');
      //     excel = exl.Excel.decodeBytes(bytes);
      //   });
      // });
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      if (result != null) {
        List<int> bytes = result.files.first.bytes as List<int>;
        excel = exl.Excel.decodeBytes(bytes);
      }
    } else {
      filePath = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['xlsx']).then((result) {
        return result?.files.single.path;
      });
      if (filePath != null) {
        var bytes = File(filePath!).readAsBytesSync();
        excel = exl.Excel.decodeBytes(bytes);
      }
    }
    List<Map<String, dynamic>> rowdetail = [];

    //keys[0] dehdar
    int counter = 0;
    List<dynamic> excelColumns = [];

    List<String> currentIds = [];
    if (excel != null && excel.tables != null) {
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          // rowData.value = [];
          // rowdetail = [];
          if (counter == 0) {
            for (var cell in row) {
              excelColumns.add(cell?.value.toString());
            }
          } else {
            List<dynamic> rowData = [];
            Map<String, dynamic> rowDataTest = {};
            int counterColumn = 0;
            for (var cell in row) {
              var columnName = excelColumns[counterColumn];
              var columnType = MainController.tableInfo['columns'].firstWhere(
                      (col) => col['name'] == columnName,
                  orElse: () => null)?['type'];

              dynamic cellValue = cell?.value;

              if (columnType != null) {
                switch (columnType) {
                  case 'select':
                    if (cellValue != null) {
                      cellValue = cellValue.toString();
                    }
                    break;
                  case 'radiobutton':
                    if (cellValue != null) {
                      cellValue = cellValue.toString();
                    }
                    break;
                  case 'multiSelect':
                    if (cellValue != null) {
                      cellValue = cellValue
                          .toString()
                          .split(',')
                          .map((e) => e.trim())
                          .toList();
                    } else {
                      cellValue = [];
                    }
                    break;
                  case 'checkbox':
                    cellValue = cellValue.toString().toLowerCase() == 'true';
                    break;
                  case 'color':
                    if (cellValue != null) {
                      cellValue = cellValue.toString();
                    } else {
                      cellValue = '';
                    }
                    break;
                  case 'mobile':
                    print(
                        'cell value before mobile>>>${cellValue} ${cellValue.runtimeType}');
                    if (cellValue != null) {
                      if (cellValue is exl.DoubleCellValue) {
                        double doubleValue =
                            (cellValue as exl.DoubleCellValue).value;
                        cellValue = exl.IntCellValue(doubleValue.toInt());
                      } else {
                        cellValue = int.tryParse(cellValue.toString());
                      }

                    } else {
                      cellValue = 0;
                    }
                    print(
                        'cell value mobile type>>>${cellValue} ${cellValue.runtimeType}');
                    break;
                  default:
                    if (cellValue != null) {
                      cellValue = cellValue.toString();
                    }
                    break;
                }
              }
              if (cell?.value is exl.DoubleCellValue) {
                double doubleValue = (cell!.value as exl.DoubleCellValue).value;
                cell.value = exl.IntCellValue(doubleValue.toInt());
              }
              if (columnType == 'select') {
                print(
                    'columnType selct type>>>${cellValue.runtimeType}  ${cellValue}');
              } else if (columnType == 'radiobutton') {
                print(
                    'columnType radiobutton type>>>${cellValue.runtimeType}  ${cellValue}');
              } else if (columnType == 'multiSelect') {
                print(
                    'columnType multiSelect type>>>${cellValue.runtimeType}  ${cellValue}');
              } else if (columnType == 'checkbox') {
                print(
                    'columnType checkbox type>>>${cellValue.runtimeType}  ${cellValue}');
              } else if (columnType == 'file') {
                print(
                    'columnType file type>>>${cellValue.runtimeType} ${cellValue}');
              } else if (columnType == 'mobile') {
                print(
                    'columnType mobile type>>>${cellValue.runtimeType} ${cellValue}');
              }
              rowData.add(cellValue);
              rowDataTest[excelColumns[counterColumn]] = cellValue;
              // rowData.add(cell?.value);
              // rowDataTest[excelColumns[counterColumn]] = cell?.value;
              counterColumn++;
            }
            currentIds.add('${rowDataTest[excelColumns[0]]}');
            if (rowData.any((element) => element != null)) {
              rowdetail.add(rowDataTest);
            }
          }
          counter++;
        }
      }
    }


    var columnPrime = getColumnPrime();

    for (var data in rowdetail) {
      var findIndexRecord = findByColumn(data, columnPrime);

      //create data json
      //function generate json record with columns name and data excel
      var excelJson = await generateJsonExcel(data, findIndexRecord);
      bool isValidator;
      // List<bool> isValidatorList = [];
      // for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      //   var column = MainController.tableInfo['columns'][j];
      //   bool isValidator =
      //       await identificationValidator(excelJson[column['name']], column);
      //
      //   isValidatorList.add(isValidator);
      // }
      // bool isExsistsValidation = isValidatorList.contains(false);
      // print('isValidatorList>>>${isValidatorList}');
      // print('findIndexRecord excel>>>${findIndexRecord}');

      if (findIndexRecord != -1) {
        DataModel k =DataModel(data: excelJson,id: MainController.tableData.value[findIndexRecord]['_id']);
        await DB('${MainController.tableInfo['table-name']}').where('_id', '\$eq', '${MainController.tableData.value[findIndexRecord]['_id']}').updateRecord(k.data);
        // updateRecord(excelJson, findIndexRecord, columnPrime);
        // bool isValidator;
        // List<bool> isValidatorList = [];
        // for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
        //   var column = MainController.tableInfo['columns'][j];
        //   bool isValidator =
        //       await identificationValidator(excelJson[column['name']], column);
        //   isValidatorList.add(isValidator);
        // }
        // bool isExsistsValidation = isValidatorList.contains(false);
        // if (isExsistsValidation) {
        //   isValidatorList = [];
        // } else {
        //   print('excelJsonf>>>${excelJson}');
        //   DataModel k =DataModel(data: excelJson,id: MainController.tableData.value[findIndexRecord]['id']);
        //   print('k.data>>>${k.data}');
        //   // updateRecord(excelJson, findIndexRecord, columnPrime);
        //     print('kjhgft>>>${DB('${MainController.tableInfo['table-name']}').getTypeOfField([k])}');
        //   await DB('${MainController.tableInfo['table-name']}').where('id', '==', '${MainController.tableData.value[findIndexRecord]['id']}').updateRecord(k.data);

        // }
      } else {
        await DB('${MainController.tableInfo['table-name']}').storeRecord(excelJson);
        // bool isValidator;
        // List<bool> isValidatorList = [];
        // for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
        //   var column = MainController.tableInfo['columns'][j];
        //   bool isValidator =
        //       await identificationValidator(excelJson[column['name']], column);
        //   isValidatorList.add(isValidator);
        // }
        // bool isExsistsValidation = isValidatorList.contains(false);
        // if (isExsistsValidation) {
        //   isValidatorList = [];
        // } else {
        //   createRecord(excelJson);
        // }
      }
    }
    //read all record of excel
    //if this record is column prime or id prime
    //is prime column:find function by column ===> check this record has in table yes or no with prime value
    //yes:update
    //no :add

    //else is prime id:find function by id ===>check this record has in table yes or no with id
    //yes:update
    //no:add

    //function find by column:column-excel record
    //loop search in table
    //if find data of table column prime with column prime
    //yes:return record table
    //no :return null

    ///create function update:excel data - table data
    /// create new json for update
    /// check column is false for load of excel
    /// yes:old data add to json
    /// no:new data read of excel
    /// finaly :upadate table with new json

    ///create function add:excel data
    /// create new json for update
    /// check column is false for load of excel
    /// yes:null to json
    /// no:new data read of excel
    /// finaly :add table with new json

    // MainController.renderPagination();


    // }

  }

  static int findByColumn(var dataRow, var primeColumn) {
    // search by id
    if (primeColumn == null) {
      String Id = dataRow['id'].toString();
      var existingDataIndex =
          MainController.tableData.value.indexWhere((data) => data.id == Id);
      return existingDataIndex;
    }
    //search by prime
    else {
      var primeColumnName = primeColumn['name'];

      // String dataToUpdate = dataRow[primeColumnName].toString();
      var dataToUpdate = dataRow[primeColumnName];
      var existingPrimeIndex = MainController.tableData.value
          .indexWhere((d) => d.data[primeColumnName] == dataToUpdate);
      return existingPrimeIndex;
    }
  }

  static updateRecord(var excelJson, var recordIndex, var primeColumn) async {
    DataModel existingData = MainController.tableData.value[recordIndex];
    existingData.data = excelJson;
    await box.putAt(recordIndex, existingData);
    // dataController.allData.value[recordIndex] = existingData;
    MainController.tableData.value[recordIndex] = existingData;
  }

  static createRecord(var excelJson) async {
    var id = Uuid().v4();
    excelJson.remove('id');
    DataModel newData = DataModel(
      id: '${id}',
      data: excelJson,
    );
    await box.add(newData);
    // dataController.allData.value.add(newData);
    MainController.tableData.add(newData);
    await MainController.loadData();
  }

  static Future<Map> generateJsonExcel(
      var dataRowExcel, var recordIndex) async {
    Map<String, dynamic> dataExlJson = {};
    for (var i = 0; i < MainController.tableInfo['columns'].length; i++) {
      var column = MainController.tableInfo['columns'][i];
      var name = column['name'];
      var type = column['type'];
      // var items = column['items'];

      var items;
      if (type == 'select' || type == 'radiobutton' || type == 'multiSelect') {
        items = await ViewController.itemsList(column);
      }

      var isImportable = column['import-of-excel'];

      if (isImportable == null || isImportable) {
        //is importable be true or null: null==true default value
        {
          if (type == 'select' || type == 'radiobutton') {
            if (dataRowExcel[name] == null ||
                dataRowExcel[name] == '' ||
                (dataRowExcel[name] is String && dataRowExcel[name].isEmpty)) {
              dataExlJson[name] = '';
            } else {
              var itemSelected = items.firstWhere(
                  (element) => element['title'] == dataRowExcel[name],
                  orElse: () => null);
              // if (items.contains(dataRowExcel[name].toString())) {
              //   dataExlJson[name] = dataRowExcel[name].toString();
              // } else {
              //   dataExlJson[name] = '';
              // }

              if (itemSelected != null) {
                dataExlJson[name] = itemSelected['value'];
              } else {
                // dataExlJson[name] = '${AppController.of(Get.context!)!.value('The corresponding item was not found')}';
                dataExlJson[name] = '';
              }
            }
          }

          // not select or radio button
          else {
            if (dataRowExcel[name] != null) {
              if (type == 'multiSelect') {
                var selectedItem;
                List<String> itemSelectedList = [];
                for (var data in dataRowExcel[name]) {
                  if (data == null || data == '') {
                    itemSelectedList = [];
                  } else {
                    selectedItem = items.firstWhere(
                        (item) => data == item['title'],
                        orElse: () => null);
                    if (selectedItem != null) {
                      itemSelectedList.add('${selectedItem['value']}');
                    }
                    // else{
                    //   itemSelectedList.add('${AppController.of(Get.context!)!.value('The corresponding item was not found')}');
                    // }
                  }
                }
                dataExlJson[name] = itemSelectedList;
              } else if (type == 'checkbox') {
                dataExlJson[name] = dataRowExcel[name];
              } else if (type == 'file') {
                if (dataRowExcel[name] != null) {
                  var columnPrime = getColumnPrime();
                  int findIndexRecord = findByColumn(dataRowExcel, columnPrime);
                  if (MainController.tableData.value.length != 0) {
                    if (findIndexRecord != -1) {
                      dataExlJson[name] = MainController
                          .tableData.value[findIndexRecord].data[name];
                    }
                  } else {
                    dataExlJson[name] = [];
                  }

                  // if(MainController.tableData.value.length != 0){
                  //   // Map<String,List<dynamic>> fileInfolist={};
                  //
                  //   for (var data in MainController.tableData.value) {
                  //   }
                  //
                  //   // int indexRow = MainController.tableData.value.indexWhere((element) => element.id == dataRowExcel.id);
                  //
                  //
                  //   // dataExlJson[name] = fileInfolist;
                  // }
                  // else{
                  //   dataExlJson[name] = '';
                  // }
                } else {
                  dataExlJson[name] = [];
                }
              } else if (type == 'color') {
                if (dataRowExcel[name] != '') {
                  dataExlJson[name] = dataRowExcel[name];
                } else {
                  dataExlJson[name] = null;
                }
              } else {
                dataExlJson[name] = dataRowExcel[name].toString();
              }
            } else {
              if (type == 'file') {
                dataExlJson[name] = [];
              } else {
                dataExlJson[name] = '';
              }
            }
          }
        }
      }

      // import excel true
      else {
        if (recordIndex != -1) {
          if (type == 'select' || type == 'radiobutton') {
            // if (items.contains(dataRowExcel[name].toString())) {
            //   dataExlJson[name] =
            //       MainController.tableData.value[recordIndex].data['${name}'];
            // } else {
            //   dataExlJson[name] = '';
            // }
            var itemSelected = items.firstWhere(
                (element) => element['title'] == dataRowExcel[name],
                orElse: () => null);
            if (itemSelected != null) {
              dataExlJson[name] =
                  MainController.tableData.value[recordIndex].data['${name}'];
            } else {
              dataExlJson[name] =
                  MainController.tableData.value[recordIndex].data['${name}'];
            }
          } else {
            if (dataRowExcel[name] != null) {
              dataExlJson[name] =
                  MainController.tableData.value[recordIndex].data['${name}'];
            } else {
              dataExlJson[name] = '';
            }
          }
        } else {
          if (dataRowExcel[name] != null) {
            if (type == 'select' || type == 'radiobutton') {
              // if (items.contains(dataRowExcel[name].toString())) {
              //   dataExlJson[name] = dataRowExcel[name].toString();
              // } else {
              //   dataExlJson[name] = '';
              // }
              if (dataRowExcel[name] == null ||
                  dataRowExcel[name] == '' ||
                  (dataRowExcel[name] is String &&
                      dataRowExcel[name].isEmpty)) {
                dataExlJson[name] = '';
              } else {
                var itemSelected = items.firstWhere(
                    (element) => element['title'] == dataRowExcel[name],
                    orElse: () => null);
                if (itemSelected != null) {
                  dataExlJson[name] = itemSelected['value'];
                }
                // else{
                //   dataExlJson[name] = '${AppController.of(Get.context!)!.value('The corresponding item was not found')}';
                // }
              }
            }
            if (type == 'multiSelect') {
              var selectedItem;
              List<String> itemSelectedList = [];
              for (var data in dataRowExcel[name]) {
                if (data == null || data == '') {
                  itemSelectedList = [];
                } else {
                  selectedItem = items.firstWhere(
                      (item) => data == item['title'],
                      orElse: () => null);
                  if (selectedItem != null) {
                    itemSelectedList.add('${selectedItem['value']}');
                  }
                  // else{
                  //   itemSelectedList.add('${AppController.of(Get.context!)!.value('The corresponding item was not found')}');
                  // }
                }
              }

              dataExlJson[name] = itemSelectedList;
            } else if (type == 'checkbox') {
              dataExlJson[name] = dataRowExcel[name];
            } else if (type == 'file') {
              if (dataRowExcel[name] != null) {
                var columnPrime = getColumnPrime();
                int findIndexRecord = findByColumn(dataRowExcel, columnPrime);
                if (MainController.tableData.value.length != 0) {
                  if (findIndexRecord != -1) {
                    dataExlJson[name] = MainController
                        .tableData.value[findIndexRecord].data[name];
                  } else {
                    dataExlJson[name] = [];
                  }
                } else {
                  dataExlJson[name] = [];
                }

                // if(MainController.tableData.value.length != 0){
                //
                //
                // }
                // else{
                //   dataExlJson[name] = '';
                // }
              } else {
                dataExlJson[name] = [];
              }
            } else if (type == 'color') {
              if (dataRowExcel[name] != '') {
                dataExlJson[name] = dataRowExcel[name];
              } else {
                dataExlJson[name] = null;
              }
            } else {
              dataExlJson[name] = dataRowExcel[name].toString();
            }
          } else {
            dataExlJson[name] = '';
          }
          // else {
          //   if (dataRowExcel[name] != null) {
          //     dataExlJson[name] = dataRowExcel[name].toString();
          //   } else {
          //     dataExlJson[name] = '';
          //   }
          // }
        }
      }
    }
    return dataExlJson;
  }

  static getColumnInfo(String title) {
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      var column = MainController.tableInfo['columns'][j];
      if (column['name'] == title) {
        return column;
      }
    }
    return null;
  }
  static getTypeColumn(String title) {
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      var column = MainController.tableInfo['columns'][j];
      if (column['name'] == title) {
        return column['type'];
      }
    }
    return null;
  }

  static getColumnPrime() {
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      var column = MainController.tableInfo['columns'][j];
      if (column['is-prime'] == true) {
        return column;
      }
    }
    return null;
  }

  static getColumnImportExcel(bool isImportExcel) {
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      var column = MainController.tableInfo['columns'][j];
      if (column['import-of-excel'] == isImportExcel) {
        return column;
      }
    }
    return null;
  }

  static priceFormat(int value) {
    NumberFormat myFormat = NumberFormat.decimalPattern();
    return myFormat.format(value);
  }

  static bool isNumeric(String str) {
    if (str.isEmpty) return false;
    return double.tryParse(str) != null;
  }


  static getInfoTable(String tableName) {
    int index = MainController.SubMenuList.indexWhere(
        (element) => element['table-name'] == '${tableName}');
    if (index != -1) {
      var tableInfo = MainController.SubMenuList[index];

      return tableInfo;
    }
    return null;
  }
  static getStatusTable(String tableName) {
    var infoTable=getInfoTable(tableName);
    if(infoTable!=null){
      return infoTable['online'];
    }
    return false;
  }
  static List<dynamic> getColumnsTable(String tableName) {
    int index = MainController.SubMenuList.indexWhere(
            (element) => element['table-name'] == '${tableName}');
    if (index != -1) {
      var tableInfo = MainController.SubMenuList[index];

      return tableInfo['columns'];
    }
    return [];
  }

  static List<dynamic> getColumnsList (String tableName) {
    List<dynamic> columns=getColumnsTable( tableName);
    if (columns.length!=0) {
      List<dynamic> list=[];
      for (var column in columns) {
        list.add(column['name']);
      }
      return list;
    }
    return [];
  }


  static getTypeOfField(String tableName, String name) {
    var type;
    var column = getColumnsTable(tableName);
    for (var item in column) {
      if(item['name'] == '_id'){
        return 'string';
      }
      if (item['name'] == name) {
        type = item['type'];
        return type;
      }
    }
  }

  static getDetailsOfField(String tableName, String name) {
    var i;
    var column = getColumnsTable(tableName);
    for (var item in column) {
      if (item['name'] == name) {
        i = item;
        return i;
      }
    }
  }

  static Future<void> search(String query) async {
    List<Map<String, dynamic>> allData = [];
    for (var item in MainController.allData.value) {
      if (item is Map) {
        allData.add(Map<String, dynamic>.from(item));
      }
    }
    searchQuery.value = query;
    if (query.isEmpty) {
      MainController.tableData.value = MainController.allData.value;
    } else {
      List<dynamic>list=[];
      MainController.tableInfo['currentPage'] = 1;
        for(Map<String, dynamic> data in allData) {
          bool flag=true;

          for(var key in data.keys) {
            if (key != '_id'){
              if (data[key] != null) {
                var type = getTypeOfField(
                    MainController.tableInfo['table-name'], key);

                if (type == 'select' || type == 'multiSelect' || type == 'radiobutton') {
                  var column = getDetailsOfField(
                      MainController.tableInfo['table-name'], key);
                  data[key] = ViewController.itemsShowSelectItem(data[key], column);
                }

                var val = data[key];
                  if (val.toString().toLowerCase().contains(query.toString().toLowerCase())) {
                    flag = true;
                    break;
                  } else {
                    flag = false;
                  }
              }
              else {
                flag = false;
              }
          } else {
              flag = false;
            }
          } if (flag == true) {
            list.add(data);
          }
      }
      MainController.tableData.value=list;
      }
  }

  static Future<void> loadJson() async {
    String jsonFileString;
    jsonFileString = await rootBundle.loadString('assets/menu.json');
    SubMenuList = json.decode(jsonFileString);
    // await createJsonSchemaApi();
    // await ConncetServerController.deleteSchema({'table_name':'details'});
    // ConncetServerController.listSchema();

    for (var name in tableNames()) {
      // addsyncField('${name}');
      createMultiSelectTable('${name}');
      addParentForRelations('${name}');
    }

  }

  static addsyncField(String tableName){
    var index = SubMenuList.indexWhere((element) => element['table-name'] == tableName);
    var items = SubMenuList[index];
    items['columns'].add({
      'name': 'sync',
      'title': 'sync',
      'type': 'string',
      'is-show-table': true,
      'is-show-edit': false,
      'is-show-store': false,
    });
    items['columns'].add({
      'name': 'server error',
      'title': 'server error',
      'type': 'string',
      'is-show-table': true,
      'is-show-edit': false,
      'is-show-store': false,
    });
  }

  static List<dynamic> tableNames() {
    var list = [];
    for (var table in SubMenuList) {
      list.add(table['table-name']);
    }
    return list;
  }

  static List<dynamic> createJsonSchemaApi() {
    List<dynamic>l=[];
    Map<String,dynamic> c={};
    for (var table in SubMenuList) {
      Map<String,dynamic> list ={};
      for(var column in table['columns']){
        c.addAll({'${column['name']}': {"type": "${column['type_filed']}"}
        });
      }
      list.addAll({
        'columns':(json.encode(c)).toString(),
      });
      // ConncetServerController.updateSchema(list);
      l.add(list);
    };

    return l;
  }

  static createMultiSelectTable(String tableName) {
    var getDataTable = ViewCustomController.getDataTable(tableName);
    List<dynamic> columnList = MainController.getColumnsTable(tableName);
    for (var column in columnList) {
      if (column['type'] == 'multiSelect' && column['sourceItems'] == 'table') {
        String tableNameNew =
            '${tableName}_${column['title']}_${column['sourceTable']}';
        if (!tableNames().contains('${tableNameNew}')) {
          var table = {
            'title': '${tableNameNew}',
            "table-name": '${tableNameNew}',
            "tooltip": "",
            'columns': [
              {
                "title": '${getDataTable['table-name']}_id',
                "type": "string",
                "name": '${getDataTable['table-name']}_id',
                'is-show-store':false,
                'is-show-edit':false,
              },
              {
                "title": '${column['sourceTable']}_id',
                "type": "string",
                "name": '${column['sourceTable']}_id',
                'is-show-store':false,
                'is-show-edit':false,
              },
            ],
            "main-menu": false,
            "currentPage": 1,
            "countShowRow": 10,
            "relations": [],
          };
          SubMenuList.add(table);
        } else {
          showSnackbar(snackTypes.error,
              "${AppController.of(Get.context!)!.value('Ability to create multiselect columns for')} ${tableName} ${AppController.of(Get.context!)!.value('does not exist')} ");
        }
      }
    }
  }

  static multiSelectStore(String tableName, var id) async {
    var getDataTable = ViewCustomController.getDataTable(tableName);
    for (var item in getDataTable['columns']) {
      if (item['type'] == 'multiSelect') {
        if (item['sourceItems'] != 'custom' && item['sourceTable'] != null) {
          if (ViewController.requestMultiSelect.length != 0) if (ViewController.requestMultiSelect.containsKey(item['sourceTable']))
            for (var data in ViewController.requestMultiSelect[item['sourceTable']]) {
             await DB(tableName + "_" + item['title'] + "_" + item['sourceTable']).storeRecord({'${tableName}_id': id, '${item['sourceTable']}_id': data});
            }
        }
      }
    }
  }

  static addParentForRelations (String tableName) {
    var getDataTable = ViewCustomController.getDataTable(tableName);
    if (getDataTable['relations'].length != 0) {
      for (var relate in getDataTable['relations']) {
        var index = SubMenuList.indexWhere(
            (element) => element['table-name'] == relate['table-name']);
        var items = SubMenuList[index];
        items['columns'].add({
          'name': 'parent_table',
          'title': 'parent_table',
          'type': 'string',
          'is-show-table': false,
          'is-show-edit': false,
          'is-show-store': false,
        });
        items['columns'].add({
          'name': 'parent_id',
          'title': 'parent_id',
          'type': 'string',
          'is-show-table': false,
          'is-show-edit': false,
          'is-show-store': false,
        });
      }
    }
  }

  static Future<void> loadData({var tableData, var tableDataItems}) async {
    if (MainController.selectedSubItem.value != -1) {
      if (tableData == null) {
        tableInfo = SubMenuList[MainController.selectedSubItem.value];
        // if(tableInfo['status']=="online")
        // await ConncetServerController.getRecordGeneral('${tableInfo['table-name']}');
        // else
        MainController.tableData.value = (await DB('${tableInfo['table-name']}').paginate());
        MainController.allData.value=MainController.tableData.value;
      } else {
        tableInfo = tableData;
        if (tableDataItems != null) {
          MainController.tableData.value = tableDataItems;
          MainController.allData.value=MainController.tableData.value;
        } else {
          // if (tableInfo['status'] == "online")
          //   await ConncetServerController.getRecordGeneral('${tableInfo['table-name']}');
          // else
            MainController.tableData.value = (await DB('${tableInfo['table-name']}').paginate());

            MainController.allData.value=MainController.tableData.value;
        }
      }
    } else {
      if (SubMenuList.length > 0) {
        tableInfo = SubMenuList[0];
      }
    }
    if (tableData == null) {
      for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
        if (MainController.tableInfo['columns'][j]['is-show-store'] == null) {
          MainController.tableInfo['columns'][j]['is-show-store'] = true;
        }
        if (MainController.tableInfo['columns'][j]['is-show-table'] == null) {
          MainController.tableInfo['columns'][j]['is-show-table'] = true;
        }
        if (MainController.tableInfo['columns'][j]['is-show-edit'] == null) {
          MainController.tableInfo['columns'][j]['is-show-edit'] = true;
        }
        if (MainController.tableInfo['columns'][j]['is-show-excel'] == null) {
          MainController.tableInfo['columns'][j]['is-show-excel'] = true;
        }
      }
    } else {
      for (var j = 0; j < tableData['columns'].length; j++) {
        if (tableData['columns'][j]['is-show-store'] == null) {
          tableData['columns'][j]['is-show-store'] = true;
        }
        if (tableData['columns'][j]['is-show-table'] == null) {
          tableData['columns'][j]['is-show-table'] = true;
        }
        if (tableData['columns'][j]['is-show-edit'] == null) {
          tableData['columns'][j]['is-show-edit'] = true;
        }
        if (tableData['columns'][j]['is-show-excel'] == null) {
          tableData['columns'][j]['is-show-excel'] = true;
        }
      }
    }
  }



  static String getNameFile(List<dynamic> filesList) {
    List<String> fileNameList = [];
    for (var file in filesList) {
      fileNameList.add('${file['name']}');
    }
    return fileNameList.join(',');
  }

  static Future<bool> identificationValidator(var cellExcel, var column) async {
    //check null cell

    if (column['validators'] != null) {
      // check null cell
      if (cellExcel == null ||
          cellExcel == '' ||
          cellExcel is List && cellExcel.isEmpty) {
        var inputRequired = column['validators'].firstWhere(
            (validator) => validator['type'] == 'required',
            orElse: () => null);
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
            // return false;
          } else {
            return true;
          }
        }
      }

      //cehcek not range cell
      else {
        if (column['type'] == 'Number int' || column['type'] == 'Number double') {
          var minValidator = column['validators'].firstWhere(
              (validator) => validator['type'] == 'min',
              orElse: () => null);
          var maxValidator = column['validators'].firstWhere(
              (validator) => validator['type'] == 'max',
              orElse: () => null);
          // int numberExcel = int.parse('${cellExcel}');
          num? intValue;
          if(column['type'] == 'Number int'){
            intValue = int.tryParse(cellExcel);
          }
          else if(column['type'] == 'Number double'){
            intValue = double.tryParse(cellExcel);
          }
          if (intValue == null) {
            return false;
          }
          if (minValidator != null || maxValidator != null) {
            if (intValue < minValidator['value'] ||
                intValue > maxValidator['value']) {
              return false;
            } else {
              return true;
            }
          }
        } else if (column['type'] == 'email') {
          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
          if (!emailRegex.hasMatch(cellExcel)) {
            return false;
          } else {
            return true;
          }
        } else if (column['type'] == 'mobile') {
          if (cellExcel.length > 13) {
            return false;
          } else if (!cellExcel.startsWith('9')) {
            return false;
          } else {
            return true;
          }
        }
      }
    }
    return true;
  }

  static goToTablePage(var table,{bool loadData=true,var tableFields=null, var tableData=null}) async {
    if (table['view'] == 'custom') {
      await HelperController.pageInateFunction();
      Navigator.push(Get.context!, MaterialPageRoute(builder: (context)=>TablePage()));
    } else {
      if(loadData==true)
      await MainController.loadData(tableData: tableFields,tableDataItems: tableData);
      ViewController.totalPage.value = await DB('${MainController.tableInfo['table-name']}').infoPage();
      await Get.to(() => TablePage());
    }
  }

  static copyClipboard(var text) async {
    await Clipboard.setData(ClipboardData(text:text.toString()));
    showSnackbar(snackTypes.info, "${AppController.of(Get.context!)!.value('copied')}");
  }

  static upload(var file) async {
    AppController.isLoading.value = true;
    int chunkSize = 500000000;
    int totalChunks = (file.size / chunkSize).ceil();
    int currentChunkIndex = 0;
    print('uploadFileUrl>>>${uploadFileUrl}');
    String tableName = MainController.SubMenuList[MainController.selectedSubItem.value]['title'];
    print('tableName a>>>${tableName}');
    ChunkedUploader chunkedUploader = ChunkedUploader(
      Dio(
        BaseOptions(
          baseUrl: uploadFileUrl,
          headers: {
            'Content-Type': 'multipart/form-data',
            'Connection': 'Keep-Alive',
            "authorization": await Token.getToken() ?? '',
          },
          validateStatus: (status) => true,
        ),
      ),
    );

    try {
      final response = await chunkedUploader.upload(
        fileKey: "file",
        method: "POST",
        maxChunkSize: chunkSize,
        path: uploadFileUrl,
        fileDataStream: file.readStream,
        fileName: file.name,
        fileSize: file.size,
        data: {
          'table_name': tableName,
          'api_key': await Token.getToken(),
          'data': file.readStream,
          'name': file.name,
          'currentChunkIndex': currentChunkIndex,
          'totalChunks': totalChunks,
        },
        onUploadProgress: (progress) {
          print('progress>>>$progress%');
          MainController.progress.value = 0.0;
          MainController.progress.value = progress;
          currentChunkIndex = ((progress / 100) * totalChunks).floor();
          print('currentChunkIndex>>>$currentChunkIndex');
        },
      );
      print('information response>>>${MainController.tableName.value}>>>${await Token.getToken()}>>>'
          '${await file.readStream}>>>${file.name}>>>${currentChunkIndex}>>>${totalChunks}');
      print('response chunck>>>${response}');
      if (response?.statusCode == 200) {
        print('Upload successful: ${response?.data}');
        return response;
      } else {
        print('Upload failed with status: ${response?.statusCode}');
        throw Exception('Upload failed');
      }
    }catch (e) {
      print('Upload error: $e');
      throw e;
    }
    finally {
      AppController.isLoading.value = false;
    }
  }

  static Future<String?> uploadFileInChunks(var picked,var column,  {int chunkSize = 512 * 1024}) async {
    var filePath=null;
    if(picked==null)
      return null;
    // MainController.chunckCurrentIndex.value = 0;
    // MainController.totlaChunck.value = 0;

    final path = picked!.files.single.path!;
    final file = File(path);
    final totalLength = await file.length();
    final raf = file.openSync(mode: FileMode.read);
    int offset = 0;
    int chunkIndex = 1;
    try {
      for (var f in picked.files) {
        if (!MainController.fileInfo.value.containsKey(f.name)) {
          MainController.fileInfo.value[f.name] = [];
        }
      }
      while (offset < totalLength) {
        final remaining = totalLength - offset;
        final currentChunkSize = remaining > chunkSize ? chunkSize : remaining;
        final bytes = raf.readSync(chunkSize);
        final String chunk =  base64Encode(bytes);
        // MainController.totlaChunck.value = (totalLength/chunkSize).ceil();
        // MainController.chunckCurrentIndex.value = chunkIndex;

        for (var f in picked.files) {
          MainController.updateFileInfo(f.name, (totalLength / chunkSize).ceil(), chunkIndex);
        }

        var body= {
          'table_name': tableName,
          'data': chunk,
          'name': file.uri.pathSegments.last,
          'currentChunkIndex': chunkIndex,
          'totalChunks': (totalLength/chunkSize).ceil(),
        };
        var response = await RestApi.post(uploadFileUrl, body: body,useToken: false);
        RestApi.responseHandler(
            response: response,
            successCallback: () async {
              print('MainController.uploadFileInChunks>>${response!.data['data']}');
              filePath= response.data['data'];
            },
            errorCallback: (){
              print('Failed to upload chunk $chunkIndex');
              return null;
            },printResponse: false);
        offset += currentChunkSize;
        chunkIndex++;
      }
    } catch (e) {
      print('Error during upload: $e');
      return null;
    } finally {
      raf.closeSync();
    }
    print('Upload finished.');

    return filePath;
  }

  static void updateFileInfo(String fileName, int totalChunks, int currentChunk) {
    fileInfo[fileName] = [totalChunks, currentChunk];
    fileInfo.refresh();
  }

  // static  deleteFileInChunks(String filePath) async {
  //   var response = await RestApi.post(deleteFileUrl, body: {'fileName':filePath,'table_name': tableName,}, useToken: false);
  //   RestApi.responseHandler(
  //       response: response,
  //       successCallback: () async {
  //
  //       },
  //       errorCallback: () {
  //
  //       }, printResponse: true);
  // }

}
