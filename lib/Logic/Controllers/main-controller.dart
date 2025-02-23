import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/dataController.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Logic/Models/dataModel.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Form/form-checkBox.dart';
import 'package:finance/UI/Componenets/Items/Form/form-color.dart';
import 'package:finance/UI/Componenets/Items/Form/form-date.dart';
import 'package:finance/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:finance/UI/Componenets/Items/Form/form-radio-button.dart';
import 'package:finance/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/UI/Componenets/Items/Menu/menu-item.dart';
import 'package:finance/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/boxes.dart';
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
// import 'dart:html' as html;

class MainController extends GetxController {
  static Rx<bool> isLightMode = true.obs;
  static Rx<int> countShowRow = 10.obs;
  static Rx<bool> isClickedItem = false.obs;

  //dehdar remove this section read icon of json
  static List<Item> items = [
    Item(
      title: 'Home',
      icon: Icons.home,
    ),
  ];

  //
  static Rx<int> selectedItem = (-1).obs;
  static Rx<int> selectedSubItem = (-1).obs;
  static Rx<Item> itemSelected = Item().obs;
  static Rx<int> subItemSelectedIndex = (-1).obs;
  static Rx<String> subItemSelected = ''.obs;
  static Rx<int> totalPages = 1.obs;
  static Rx<int> startIndex = 0.obs;
  static Rx<int> endIndex = 0.obs;
  static RxList<dynamic> tableData = [].obs;
  static RxString searchQuery = ''.obs;
  static  Rx<bool> isSelected = false.obs;

  static List<dynamic> data = [];

  static Map<String, dynamic> dataJson = {};

  static Rx<int> selectedItemList = 0.obs;

  static List<dynamic> SubMenuList = [];
  static dynamic tableInfo = null;
  DataModel? dataModel;
  static var allColumn;



  static  GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

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
          print('cell>>>${cell.value}');
          excelColumnIndex++;
        }
      }
      int rowIndex = 2;
      for (var data in MainController.tableData.value) {
        List<exl.CellValue> rowData = [];
        rowData.add(exl.TextCellValue(data.id));
        print('data.id>>>>${data.id}');
        for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
          if (MainController.tableInfo['columns'][j]['is-show-excel'] == true) {
            var column = MainController.tableInfo['columns'][j];
            var name = column['name'];
            var value = data.data[name]?.toString() ?? '';
            List<dynamic> items=[];
            if(column['type'] == 'select' || column['type'] == 'multiSelect' || column['type'] == 'radiobutton'){
             items = await ViewController.itemsList(column);
            }
            if(column['type'] =='multiSelect'){
              String listTitle = ViewController.hintMultiSelectBox(items, data.data[name]);
              print('listTitle>>>${listTitle}');
              rowData.add(exl.TextCellValue(listTitle));
            }
            else if(column['type'] =='select' || column['type'] == 'radiobutton'){
              String tableName ='';
              if (column['sourceItems'] != 'custom') {
                tableName = column['sourceTable'];

              }
              String title = await ViewController.getTitleSelectedItem('${tableName}',
                  data.data[name] , column);
              rowData.add(exl.TextCellValue(title));
            }
            else{
              rowData.add(exl.TextCellValue(value));
            }


          }
        }
        print('rowData>>>${rowData}');
        sheet.appendRow(rowData);
        rowIndex++;
      }
    // }

     String? fileExelPath;

    if(kIsWeb) {
      fileExelPath = 'C:\\Downloads';
    }
    else{
      fileExelPath = await FilePicker.platform.getDirectoryPath();
    }
    print('path>>>>${fileExelPath}');
    String? filePath;
    if (fileExelPath != null) {
      filePath = '${fileExelPath}\\${tableInfo['table-name']}.xlsx';
      print('filePath>>>${filePath}');

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
      }
      else{
        File(filePath!)
          ..createSync(recursive: true)
          ..writeAsBytesSync(excel.save()!);
      }
      print('Excel file created at $filePath');
      showSnackbar(snackTypes.success,
          '${AppController.of(Get.context!)!.value('the desired file')}  ${fileExelPath} ${AppController.of(Get.context!)!.value('saved')}');
    }
  }

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
        if(result != null){
          List<int> bytes = result.files.first.bytes as List<int>;
          excel = exl.Excel.decodeBytes(bytes);
        }

      }
      else{
        filePath = await FilePicker.platform.pickFiles(
            type: FileType.custom, allowedExtensions: ['xlsx']).then((result) {
          return result?.files.single.path;
        });
        if(filePath != null){
          print('s2');
          var bytes = File(filePath!).readAsBytesSync();
          excel = exl.Excel.decodeBytes(bytes);
        }

      }


      List<Map<String, dynamic>> rowdetail = [];

      //keys[0] dehdar
      int counter = 0;
      List<dynamic> excelColumns = [];

      List<String> currentIds = [];
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
              if (cell?.value is exl.DoubleCellValue) {
                double doubleValue = (cell!.value as exl.DoubleCellValue).value;
                cell.value = exl.IntCellValue(doubleValue.toInt());
              }
              rowData.add(cell?.value);
              rowDataTest[excelColumns[counterColumn]] = cell?.value;
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
      print('all data is:${rowdetail}');

      var columnPrime = getColumnPrime();

      for (var data in rowdetail) {
        var findIndexRecord = findByColumn(data, columnPrime);
        print('findIndexRecord>>>${findIndexRecord}');

        //create data json
        //function generate json record with columns name and data excel
        var excelJson = generateJsonExcel(data, findIndexRecord);

        if (findIndexRecord != -1) {
          updateRecord(excelJson, findIndexRecord, columnPrime);
        } else {
          createRecord(excelJson);
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

      MainController.renderPagination();
    // }
  }

  static int findByColumn(var dataRow, var primeColumn) {

    // search by id
    if (primeColumn == null) {
      String Id = dataRow['id'].toString();
      var existingDataIndex =
          MainController.tableData.value.indexWhere((data) => data.id == Id);
      print('existingDataIndex>>>${existingDataIndex}');
      return existingDataIndex;
    }
    //search by prime
    else {
      var primeColumnName = primeColumn['name'];
      String dataToUpdate = dataRow[primeColumnName].toString();
      var existingPrimeIndex = MainController.tableData.value
          .indexWhere((d) => d.data[primeColumnName] == dataToUpdate);
      print('existingPrimeIndex>>>${existingPrimeIndex}');
      return existingPrimeIndex;
    }
  }

  static updateRecord(var excelJson, var recordIndex, var primeColumn) async {
    DataModel existingData = MainController.tableData.value[recordIndex];
    existingData.data = excelJson;
    await box.putAt(recordIndex, existingData);
    dataController.allData.value[recordIndex] = existingData;
  }

  static createRecord(var excelJson) async {
    var id = Uuid().v4();
    print('create record:${excelJson}');
    excelJson.remove('id');
    print('create record:${excelJson}');
    DataModel newData = DataModel(
      id: '${id}',
      data: excelJson,
    );
    await box.add(newData);
    print('newData>>>${newData}');
    dataController.allData.value.add(newData);
    await MainController.loadData();
    MainController.renderPagination();
  }

  static Map generateJsonExcel(var dataRowExcel, var recordIndex) {
    Map<String, dynamic> dataExlJson = {};
    for (var i = 0; i < MainController.tableInfo['columns'].length; i++) {
      var column = MainController.tableInfo['columns'][i];
      var name = column['name'];
      var type = column['type'];
      var items = column['items'];
      print('items excel>>>${items}');
      var isImportable = column['import-of-excel'];

      if (isImportable == null || isImportable) {
        //is importable be true or null: null==true default value
        {

          if (type == 'select') {
            if (items.contains(dataRowExcel[name].toString())) {
              dataExlJson[name] = dataRowExcel[name].toString();
            } else {
              dataExlJson[name] = '';
            }
          }
          else {
            if (dataRowExcel[name] != null) {
              dataExlJson[name] = dataRowExcel[name].toString();
            } else {
              dataExlJson[name] = '';
            }
          }
        }
      } else {
        if (recordIndex != -1) {
          if (type == 'select') {
            if (items.contains(dataRowExcel[name].toString())) {
              dataExlJson[name] =
                  MainController.tableData.value[recordIndex].data['${name}'];
            } else {
              dataExlJson[name] = '';
            }
          } else {
            if (dataRowExcel[name] != null) {
              dataExlJson[name] =
                  MainController.tableData.value[recordIndex].data['${name}'];
            } else {
              dataExlJson[name] = '';
            }
          }
        }
        else {
          if (type == 'select') {
            if (items.contains(dataRowExcel[name].toString())) {
              dataExlJson[name] = dataRowExcel[name].toString();
            } else {
              dataExlJson[name] = '';
            }
          } else {
            if (dataRowExcel[name] != null) {
              dataExlJson[name] = dataRowExcel[name].toString();
            } else {
              dataExlJson[name] = '';
            }
          }
        }
      }
    }
    print('dataExlJson>>>${dataExlJson}');
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

  static void renderPagination() {
    // if (MainController.table['table-name'] == box.name) {
      print('filterList.value.length>>>${tableData.value.length}');
      MainController.totalPages.value =
          (tableData.value.length / MainController.tableInfo['countShowRow'])
              .ceil();
      MainController.startIndex.value =
          (tableInfo['currentPage'] - 1) * MainController.tableInfo['countShowRow'];
      MainController.endIndex.value = MainController.startIndex.value +
          int.parse('${MainController.tableInfo['countShowRow']}');
      if (MainController.endIndex.value > tableData.value.length) {
        MainController.endIndex.value = tableData.value.length;
      }
    // }
    else {
      print('not exsits');
    }
    print('MainController.startIndex.value>>>${MainController.startIndex.value}');
      print('MainController.endIndex.value>>>${MainController.endIndex.value}');

  }

  static Future<void> search(String query) async {
    dataController.allData.value = box.values.toList();

    searchQuery.value = query;
    // if (MainController.table['table-name'] == box.name) {
      if (query.isEmpty) {
        MainController.tableData.value = dataController.allData.value;
      } else {
        MainController.tableInfo['currentPage'] = 1;
        tableData.value = dataController.allData.value.where((data) {
          for (int j = 0; j < MainController.tableInfo['columns'].length; j++) {
            var column = MainController.tableInfo['columns'][j];
            var name = column['name'];
            if (data.data[name] != null &&
                data.data[name]
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
              return true;
            }
          }
          return false;
        }).toList();
        for(var data in tableData.value){
          print('data.data2>>>${data.data}');
        }
      }
    // }
    MainController.renderPagination();
  }

  static Future<void> loadJson() async {
    String jsonFileString;
    jsonFileString = await rootBundle.loadString('assets/menu.json');
    // if(kIsWeb){
    //   jsonFileString = await rootBundle.loadString('assets/menu.json');
    // }
    // else{
    //   String jsonFile = 'C:\\menu.json';
    //   jsonFileString = await File(jsonFile).readAsString();
    // }
    SubMenuList = json.decode(jsonFileString);
  }

  static Future<void> loadData() async {
    if (MainController.selectedSubItem.value != -1) {
      tableInfo = SubMenuList[MainController.selectedSubItem.value];
      print('tableInfo>>>${tableInfo['columns']}');
      box = await Hive.openBox<DataModel>('${tableInfo['table-name']}');
      MainController.tableData.value = box.values.toList();
    } else {
      if (SubMenuList.length > 0) {
        tableInfo = SubMenuList[0];
        box = await Hive.openBox<DataModel>('${tableInfo['table-name']}');

      }


    }
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


  }

}
