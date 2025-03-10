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
            // var value = data.data[name]?.toString() ?? '';
            var value = data.data[name] ?? '';
            List<dynamic> items=[];
            String tableName ='';
            if(column['type'] == 'select' || column['type'] == 'multiSelect' || column['type'] == 'radiobutton'){
              items = await ViewController.itemsList(column);
            }
            if(column['type'] =='select' || column['type'] == 'radiobutton'){
              if (column['sourceItems'] != 'custom') {
                      tableName = column['sourceTable'];

              }
              String title;
              if(data.data[name] != null){
                title = await ViewController.getTitleSelectedItem('${tableName}', data.data[name] , column);

              }
              else{
                title = '';
              }
              rowData.add(exl.TextCellValue(title));
            }
            else if(column['type'] =='multiSelect'){
              if (column['sourceItems'] != 'custom'){
                  if(column['sourceTable'] != null){
                   tableName = column['sourceTable'];
              }
              }
              List<String> listTitle=[];
              if(data.data[name] != null){
                 listTitle = await ViewController.getTitleMultiSelectedItem('${tableName}', data.data[name] , column);
              }

              rowData.add(exl.TextCellValue(listTitle.join(',')));
              }
            else if(column['type'] =='checkbox'){
              print('value checkbox>>>${value}');
              rowData.add(exl.BoolCellValue(value));
            }
            else if(column['type'] =='file'){
              if(value != ''){
                String fileName = getNameFile(value);
                rowData.add(exl.TextCellValue(fileName.toString()));
              }
              else{
                rowData.add(exl.TextCellValue(''));
              }

            }

            else{
              rowData.add(exl.TextCellValue(value.toString()));
            }
            // rowData.add(exl.TextCellValue(value));

            // List<dynamic> items=[];
            // String tableName ='';
            // if(column['type'] == 'select' || column['type'] == 'multiSelect' || column['type'] == 'radiobutton'){
            //   items = await ViewController.itemsList(column);
            // }
            // if(value.runtimeType == 'String'){
            //   if(column['type'] =='select' || column['type'] == 'radiobutton'){
            //     if (column['sourceItems'] != 'custom') {
            //       tableName = column['sourceTable'];
            //
            //     }
            //     String title = await ViewController.getTitleSelectedItem('${tableName}',
            //         data.data[name] , column);
            //     rowData.add(exl.TextCellValue(title));
            //   }
            //   else{
            //     rowData.add(exl.TextCellValue(value));
            //   }
            // }
            // if(value.runtimeType == 'List<String>'){
            //   if(column['type'] =='multiSelect'){
            //     if (column['sourceItems'] != 'custom'){
            //       if(column['sourceTable'] != null){
            //         tableName = column['sourceTable'];
            //       }
            //     }
            //     List<String> listTitle = await ViewController.getTitleMultiSelectedItem('${tableName}', data.data[name] , column);
            //     rowData.add(exl.TextCellValue(listTitle.join(',')));
            //   }
            // }
            // if(value.runtimeType == 'bool'){
            //   rowData.add(exl.BoolCellValue(value));
            // }
            // else if(value.runtimeType == 'List<dynamic'){
            //   rowData.add(exl.TextCellValue(value));
            // }


            // List<dynamic> items=[];
            // String tableName ='';
            // if(column['type'] == 'select' || column['type'] == 'multiSelect' || column['type'] == 'radiobutton'){
            //  items = await ViewController.itemsList(column);
            // }
            // if(column['type'] =='multiSelect'){
            //   if (column['sourceItems'] != 'custom'){
            //     if(column['sourceTable'] != null){
            //       tableName = column['sourceTable'];
            //     }
            //   }
            //   List<String> listTitle = await ViewController.getTitleMultiSelectedItem('${tableName}', data.data[name] , column);
            //   rowData.add(exl.TextCellValue(listTitle.join(',')));
            // }
            // if(column['type'] =='select' || column['type'] == 'radiobutton'){
            //   if (column['sourceItems'] != 'custom') {
            //     tableName = column['sourceTable'];
            //
            //   }
            //   String title = await ViewController.getTitleSelectedItem('${tableName}',
            //       data.data[name] , column);
            //   rowData.add(exl.TextCellValue(title));
            // }

          }
        }
        for(var i=0;i<rowData.length;i++){
          print('rowData>>>${rowData[i].runtimeType}');
        }

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
          var bytes = File(filePath!).readAsBytesSync();
          excel = exl.Excel.decodeBytes(bytes);
        }

      }
      List<Map<String, dynamic>> rowdetail = [];

      //keys[0] dehdar
      int counter = 0;
      List<dynamic> excelColumns = [];

      List<String> currentIds = [];
      if(excel != null && excel.tables != null){
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
                var columnType = MainController.tableInfo['columns']
                    .firstWhere((col) => col['name'] == columnName, orElse: () => null)?['type'];

                dynamic cellValue = cell?.value;

                if (columnType != null) {
                  switch (columnType) {
                    case 'select':
                      if(cellValue != null){
                        cellValue = cellValue.toString();
                      }
                      break;
                    case 'radiobutton':
                      if(cellValue != null){
                        cellValue = cellValue.toString();
                      }
                      break;
                    case 'multiSelect':
                      if(cellValue != null){
                        cellValue = cellValue.toString().split(',').map((e) => e.trim()).toList();
                      }
                      else{
                        cellValue = [];
                      }
                      break;
                    case 'checkbox':
                      cellValue = cellValue.toString().toLowerCase() == 'true';
                      break;
                    case 'color':
                      if(cellValue != null){
                        cellValue = cellValue.toString();
                      }
                      else{
                        cellValue = '';
                      }
                      break;
                    case 'mobile':
                      print('cell value before mobile>>>${cellValue} ${cellValue.runtimeType}');
                      if (cellValue != null) {
                        if(cellValue is exl.DoubleCellValue){
                          double doubleValue = (cellValue as exl.DoubleCellValue).value;
                          cellValue = exl.IntCellValue(doubleValue.toInt());
                        }
                        else{
                          cellValue = int.tryParse(cellValue.toString());
                        }

                        print('cellValue after mobile>>>${cellValue}');
                      } else {
                        cellValue = 0;
                      }
                      print('cell value mobile type>>>${cellValue} ${cellValue.runtimeType}');
                      break;
                    default:
                      if(cellValue != null){
                        cellValue = cellValue.toString();
                      }
                      break;
                  }
                }
                if (cell?.value is exl.DoubleCellValue) {
                  double doubleValue = (cell!.value as exl.DoubleCellValue).value;
                  cell.value = exl.IntCellValue(doubleValue.toInt());
                }
                if(columnType == 'select'){
                  print('columnType selct type>>>${cellValue.runtimeType}  ${cellValue}');
                }
                else if(columnType == 'radiobutton'){
                  print('columnType radiobutton type>>>${cellValue.runtimeType}  ${cellValue}');
                }
                else if(columnType == 'multiSelect'){
                  print('columnType multiSelect type>>>${cellValue.runtimeType}  ${cellValue}');
                }
                else if(columnType == 'checkbox'){
                  print('columnType checkbox type>>>${cellValue.runtimeType}  ${cellValue}');
                }
                else if(columnType == 'file'){
                  print('columnType file type>>>${cellValue.runtimeType} ${cellValue}');
                }
                else if(columnType == 'mobile'){
                  print('columnType mobile type>>>${cellValue.runtimeType} ${cellValue}');
                }
                rowData.add(cellValue);
                rowDataTest[excelColumns[counterColumn]] = cellValue;
                // rowData.add(cell?.value);
                // rowDataTest[excelColumns[counterColumn]] = cell?.value;
                counterColumn++;
              }
              print('rowData>>>${rowData}');
              currentIds.add('${rowDataTest[excelColumns[0]]}');
              if (rowData.any((element) => element != null)) {
                rowdetail.add(rowDataTest);
              }
              print('rowdetail.length>>>${rowdetail.length}');
            }
            counter++;
          }
        }
      }

      print('all data is:${rowdetail}');

      var columnPrime = getColumnPrime();

      for (var data in rowdetail) {

        var findIndexRecord = findByColumn(data, columnPrime);
        print('findIndexRecord>>>${findIndexRecord}');

        //create data json
        //function generate json record with columns name and data excel
        var excelJson = await generateJsonExcel(data, findIndexRecord);
        bool isValidator;
        List<bool> isValidatorList=[];
        for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
          var column = MainController.tableInfo['columns'][j];
          bool isValidator=  await identificationValidator(excelJson[column['name']] , column);

          isValidatorList.add(isValidator);
        }
        bool isExsistsValidation = isValidatorList.contains(false);
        print('isValidatorList>>>${isValidatorList}');
        print('findIndexRecord excel>>>${findIndexRecord}');

        if (findIndexRecord != -1) {
          // updateRecord(excelJson, findIndexRecord, columnPrime);
          bool isValidator;
          List<bool> isValidatorList=[];
          for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
            var column = MainController.tableInfo['columns'][j];
            bool isValidator=  await identificationValidator(excelJson[column['name']] , column);
            isValidatorList.add(isValidator);
          }
          bool isExsistsValidation = isValidatorList.contains(false);
          if(isExsistsValidation){
            isValidatorList=[];
          }
          else{
            updateRecord(excelJson, findIndexRecord, columnPrime);
          }

        }
        else {
          bool isValidator;
          List<bool> isValidatorList=[];
          for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
            var column = MainController.tableInfo['columns'][j];
            bool isValidator=  await identificationValidator(excelJson[column['name']] , column);
            isValidatorList.add(isValidator);
          }
          bool isExsistsValidation = isValidatorList.contains(false);
          if(isExsistsValidation){
            isValidatorList=[];
          }
          else{
            createRecord(excelJson);
          }

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

      // String dataToUpdate = dataRow[primeColumnName].toString();
      var dataToUpdate = dataRow[primeColumnName];
      print('dataToUpdate>>>${dataToUpdate.runtimeType}  ${dataToUpdate}');
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
    MainController.tableData.value[recordIndex] = existingData;

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
    MainController.tableData.value.add(newData);
    await MainController.loadData();
    MainController.renderPagination();
  }

  static Future<Map> generateJsonExcel(var dataRowExcel, var recordIndex) async {

    Map<String, dynamic> dataExlJson = {};
    for (var i = 0; i < MainController.tableInfo['columns'].length; i++) {
      var column = MainController.tableInfo['columns'][i];
      var name = column['name'];
      var type = column['type'];
      // var items = column['items'];

      var items;
      if(type == 'select' || type == 'radiobutton' || type == 'multiSelect'){
        items = await ViewController.itemsList(column);
      }

      var isImportable = column['import-of-excel'];

      if (isImportable == null || isImportable) {
        //is importable be true or null: null==true default value
        {
          if (type == 'select' || type == 'radiobutton') {
            if(dataRowExcel[name] == null || dataRowExcel[name] == '' || (dataRowExcel[name] is String && dataRowExcel[name].isEmpty)){
              dataExlJson[name] = '';
            }
            else{
              var itemSelected = items.firstWhere(
                      (element) => element['title'] == dataRowExcel[name],
                  orElse: () => null);
              // if (items.contains(dataRowExcel[name].toString())) {
              //   dataExlJson[name] = dataRowExcel[name].toString();
              // } else {
              //   dataExlJson[name] = '';
              // }

              if(itemSelected != null){
                dataExlJson[name] = itemSelected['value'];
              }
              else{
                // dataExlJson[name] = '${AppController.of(Get.context!)!.value('The corresponding item was not found')}';
                dataExlJson[name] = '';

              }
            }

          }

          // not select or radio button
          else {
            if (dataRowExcel[name] != null) {
              if(type == 'multiSelect'){
                var selectedItem;
                List<String> itemSelectedList=[];
                for(var data in dataRowExcel[name]){
                  if(data == null || data == ''){
                    itemSelectedList = [];
                  }
                  else{
                    selectedItem =  items.firstWhere((item) => data == item['title'] , orElse: () => null);
                    if(selectedItem != null){
                      itemSelectedList.add('${selectedItem['value']}');
                    }
                    // else{
                    //   itemSelectedList.add('${AppController.of(Get.context!)!.value('The corresponding item was not found')}');
                    // }
                  }


                }
                dataExlJson[name] = itemSelectedList;
              }
              else if(type == 'checkbox'){
                dataExlJson[name] = dataRowExcel[name];
              }
              else if(type == 'file'){

                if(dataRowExcel[name] != null){
                  var columnPrime = getColumnPrime();
                  int findIndexRecord = findByColumn(dataRowExcel, columnPrime);
                  if(MainController.tableData.value.length != 0){
                    if(findIndexRecord != -1){
                      dataExlJson[name] = MainController.tableData.value[findIndexRecord].data[name];
                    }
                  }
                  else{
                    dataExlJson[name] = [];
                  }

                  // if(MainController.tableData.value.length != 0){
                  //   // Map<String,List<dynamic>> fileInfolist={};
                  //
                  //   for (var data in MainController.tableData.value) {
                  //     print('zasdf>>>${data.data[name]}');
                  //   }
                  //
                  //   // int indexRow = MainController.tableData.value.indexWhere((element) => element.id == dataRowExcel.id);
                  //   // print('indexRow>>>${indexRow}');
                  //
                  //
                  //   // dataExlJson[name] = fileInfolist;
                  // }
                  // else{
                  //   dataExlJson[name] = '';
                  // }
                }
                else{
                  dataExlJson[name] = [];
                }
              }
              else if(type == 'color'){

                if(dataRowExcel[name] != ''){
                  dataExlJson[name] = dataRowExcel[name];
                }
                else{
                  dataExlJson[name] = null;
                }
              }
              else{
                dataExlJson[name] = dataRowExcel[name].toString();
              }

            }
            else {
              if(type == 'file'){
                dataExlJson[name] = [];
              }
              else{
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
            if(itemSelected != null){
              dataExlJson[name] = MainController.tableData.value[recordIndex].data['${name}'];
            }
            else{
              dataExlJson[name] = MainController.tableData.value[recordIndex].data['${name}'];
            }
          }
          else {
            if (dataRowExcel[name] != null) {
              dataExlJson[name] =
                  MainController.tableData.value[recordIndex].data['${name}'];
            }
            else {
              dataExlJson[name] = '';
            }
          }
        }

        else {

          if (dataRowExcel[name] != null){
            if (type == 'select'|| type == 'radiobutton') {
              // if (items.contains(dataRowExcel[name].toString())) {
              //   dataExlJson[name] = dataRowExcel[name].toString();
              // } else {
              //   dataExlJson[name] = '';
              // }
              if(dataRowExcel[name] == null || dataRowExcel[name] == '' || (dataRowExcel[name] is String && dataRowExcel[name].isEmpty)){
                dataExlJson[name] = '';
              }
              else{
                var itemSelected = items.firstWhere(
                        (element) => element['title'] == dataRowExcel[name],
                    orElse: () => null);
                if(itemSelected != null){
                  dataExlJson[name] = itemSelected['value'];
                }
                // else{
                //   dataExlJson[name] = '${AppController.of(Get.context!)!.value('The corresponding item was not found')}';
                // }
              }
            }
            if(type == 'multiSelect'){
              var selectedItem;
              List<String> itemSelectedList=[];
              for(var data in dataRowExcel[name]){
                if(data == null || data == ''){
                  itemSelectedList = [];
                }
                else{
                  selectedItem=  items.firstWhere((item) => data == item['title'] , orElse: () => null);
                  if(selectedItem != null){
                    itemSelectedList.add('${selectedItem['value']}');

                  }
                  // else{
                  //   itemSelectedList.add('${AppController.of(Get.context!)!.value('The corresponding item was not found')}');
                  // }
                }

              }

              dataExlJson[name] = itemSelectedList;
            }
            else if(type == 'checkbox'){
              dataExlJson[name] = dataRowExcel[name];
            }
            else if(type == 'file'){
              if(dataRowExcel[name] != null){
                var columnPrime = getColumnPrime();
                int findIndexRecord = findByColumn(dataRowExcel, columnPrime);
                if(MainController.tableData.value.length != 0){
                  if(findIndexRecord != -1){
                    dataExlJson[name] = MainController.tableData.value[findIndexRecord].data[name];
                  }
                  else{
                    dataExlJson[name] = [];
                  }
                }
                else{
                  dataExlJson[name] = [];
                }

                // if(MainController.tableData.value.length != 0){
                //
                //
                // }
                // else{
                //   dataExlJson[name] = '';
                // }

              }
              else{
                dataExlJson[name] = [];
              }
            }
            else if(type == 'color'){

              if(dataRowExcel[name] != ''){
                dataExlJson[name] = dataRowExcel[name];
              }
              else{
                dataExlJson[name] = null;
              }
            }
            else{
              dataExlJson[name] = dataRowExcel[name].toString();
            }
          }
          else{
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

  static String getNameFile(List<dynamic> filesList){
    List<String> fileNameList=[];
    print('filesList>>>${filesList}');
    for(var file in filesList){
     fileNameList.add('${file['name']}');
    }
    return fileNameList.join(',');
  }


  // static bool identificationValidator(var cellExcel , var column){
  //
  //   //check null cell
  //
  //     if(column['validators'] != null){
  //
  //       // check null cell
  //       print('cellExcel 56>>>${cellExcel} ${cellExcel.runtimeType} ${column['name']}');
  //
  //       if(cellExcel == null || cellExcel == '' || cellExcel is List && cellExcel.isEmpty){
  //         print('column name is null>>>${column['name']}');
  //       var inputRequired = column['validators'].firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
  //       if(inputRequired != null){
  //
  //         if(inputRequired['type'] == 'required'){
  //           return false;
  //         }
  //         else{
  //           return true;
  //         }
  //       }
  //     }
  //
  //       //cehcek not range cell
  //       else{
  //         if(column['type'] == 'number'){
  //           var minValidator = column['validators'].firstWhere((validator) => validator['type'] == 'min', orElse: () => null);
  //           var maxValidator = column['validators'].firstWhere((validator) => validator['type'] == 'max', orElse: () => null);
  //           // int numberExcel = int.parse('${cellExcel}');
  //           print('cellExcel number>>>${cellExcel}');
  //             int intValue = int.parse(cellExcel);
  //             if(minValidator != null && maxValidator != null){
  //               if(intValue < minValidator['value'] || intValue > maxValidator['value']){
  //                 return false;
  //               }
  //               else{
  //                 return true;
  //               }
  //             }
  //
  //           // print('numberExcel>>>>${intValue} ${numberExcel.runtimeType}');
  //         }
  //         else if(column['type'] == 'email'){
  //           final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  //           if (!emailRegex.hasMatch(cellExcel)) {
  //             return false;
  //           }
  //           else{
  //             return true;
  //           }
  //         }
  //         else if(column['type'] == 'mobile'){
  //           print('cellExcel mobile type>>>${cellExcel} ${cellExcel.runtimeType}');
  //           print('cellExcel.startsWith(9)>>>${cellExcel.startsWith('9')}');
  //           print('cellExcel.length>>>${cellExcel.length}');
  //           if(cellExcel.length > 13){
  //             return false;
  //           }
  //           else if(!cellExcel.startsWith('9')){
  //             return false;
  //           }
  //           else{
  //             return true;
  //           }
  //         }
  //
  //       }
  //   }
  // return true;
  //
  // }
  static Future<bool> identificationValidator(var cellExcel , var column) async {

    //check null cell

    if(column['validators'] != null){

      // check null cell
      print('cellExcel 56>>>${cellExcel} ${cellExcel.runtimeType} ${column['name']}');

      if(cellExcel == null || cellExcel == '' || cellExcel is List && cellExcel.isEmpty){
        print('column name is null>>>${column['name']}');
        var inputRequired = column['validators'].firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
        if(inputRequired != null){

          if(inputRequired['type'] == 'required'){
            if(column['type']=='multiSelect' || column['type']=='select' || column['type']=='radiobutton'){
              List<dynamic> items = await ViewController.itemsList(
                  column);
              if(items.length == 0){
                return true;
              }
              else{
                return false;
              }
            }
            else{
              return false;
            }
            // return false;
          }
          else{
            return true;
          }
        }
      }

      //cehcek not range cell
      else{
        if(column['type'] == 'number'){
          var minValidator = column['validators'].firstWhere((validator) => validator['type'] == 'min', orElse: () => null);
          var maxValidator = column['validators'].firstWhere((validator) => validator['type'] == 'max', orElse: () => null);
          // int numberExcel = int.parse('${cellExcel}');
          print('cellExcel number>>>${cellExcel}');
          int intValue = int.parse(cellExcel);
          if(minValidator != null && maxValidator != null){
            if(intValue < minValidator['value'] || intValue > maxValidator['value']){
              return false;
            }
            else{
              return true;
            }
          }

          // print('numberExcel>>>>${intValue} ${numberExcel.runtimeType}');
        }
        else if(column['type'] == 'email'){
          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
          if (!emailRegex.hasMatch(cellExcel)) {
            return false;
          }
          else{
            return true;
          }
        }
        else if(column['type'] == 'mobile'){
          print('cellExcel mobile type>>>${cellExcel} ${cellExcel.runtimeType}');
          print('cellExcel.startsWith(9)>>>${cellExcel.startsWith('9')}');
          print('cellExcel.length>>>${cellExcel.length}');
          if(cellExcel.length > 13){
            return false;
          }
          else if(!cellExcel.startsWith('9')){
            return false;
          }
          else{
            return true;
          }
        }

      }
    }
    return true;

  }

  static Future<dynamic> getDataNull(var column  , Map<String,dynamic> data) async {
    if(column['type'] == 'select' || column['type'] == 'radiobutton'){
      List<dynamic> items = await ViewController.itemsList(
          column);
      if(items.length != 0){
        Map<String, dynamic> selectedItem = items.firstWhere(
                (element) => element['value'] == data['${column['name']}'],
            orElse: () => items.first);
        if(selectedItem['value'] != data['${column['name']}']){
          data['${column['name']}'] = '';
        }
      }
    }
    return data['${column['name']}'];

  }



}
