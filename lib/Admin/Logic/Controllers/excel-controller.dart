import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:excel/excel.dart' as exl;
import '../../UI/Componenets/Popups/snackbar.dart';
import '../Models/db.dart';
import 'app-controller.dart';
import 'connect-server-controller.dart';
import 'main-controller.dart';

class ExcelController extends GetxController {

  static Future<void> createExel(String? fileExelPath) async {
    var excel = exl.Excel.createExcel();
    var cell;

    exl.Sheet sheet = excel['Sheet1'];
    sheet.isRTL = true;

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
    List<dynamic> Data=[];
    if(MainController.tableInfo['schema']['online']==true){
      await ConncetServerController.getRecordGeneral(MainController.tableInfo['schema']['name'],page: 0,perpage: 0);
      Data=ConncetServerController.getRecordRes;
    }else{
      Data= await DB('${MainController.tableInfo['schema']['name']}').getRecords();
    }
    for (var data in Data) {
      List<exl.CellValue> rowData = [];
      rowData.add(exl.TextCellValue(data['_id']));
      for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
        if (MainController.tableInfo['columns'][j]['is-show-excel'] == true) {
          var column = MainController.tableInfo['columns'][j];
          var name = column['name'];
          var value = data[name] ?? '';
          Map<String,dynamic> items = {};
          String tableName = '';
          // if (column['type'] == 'select' ||
          //     column['type'] == 'multiSelect' ||
          //     column['type'] == 'radiobutton') {
          //   items = data[name];
          //   var  title =ViewController.itemsShowSelectItem(data['${name}'], column);
          //   rowData.add(exl.TextCellValue('${title}'));
          // }
          if (column['type'] == 'select' || column['type'] == 'radiobutton') {
            // if (column['source_items'] != 'custom') {
            //   tableName = column['source_table'];
            // }
            String title='';
            if (data[name] != null) {
              title =
                  ViewController.itemsShowSelectItem(data['${name}'], column);
            }
            // else {
            //   title = '';
            // }
            rowData.add(exl.TextCellValue(title));
          }
          else if (column['type'] == 'multiSelect') {
            if (column['source_items'] != 'custom') {
              if (column['source_table'] != null) {
                tableName = column['source_table'];
              }
            }
            // List<dynamic> listTitle = [];
            String listTitle = '';
            if (data[name] != null) {
              listTitle = ViewController.itemsShowSelectItem(data['${name}'], column);
            }

            rowData.add(exl.TextCellValue(listTitle));
          }
          else if (column['type'] == 'checkbox') {
            rowData.add(exl.BoolCellValue(value));
          } else if (column['type'] == 'file') {
            if (value != '') {
              String fileName = MainController.getNameFile(value);
              rowData.add(exl.TextCellValue(fileName.toString()));
            } else {
              rowData.add(exl.TextCellValue(''));
            }
          } else {
            rowData.add(exl.TextCellValue(value.toString()));
          }
        }
      }
      for (var i = 0; i < rowData.length; i++) {}

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
      filePath = '${fileExelPath}\\${MainController.tableInfo['schema']['name']}.xlsx';

      if (kIsWeb) {
        String tableName = MainController.tableInfo['schema']['name'];
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
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(excel.save()!);
      }
      showSnackbar(snackTypes.success,
          '${AppController.of(Get.context!)!.value('the desired file')}  ${fileExelPath} ${AppController.of(Get.context!)!.value('saved')}');
    }
  }

  static Future<void>  readExcelFile(String? fileExelPath) async {
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
    }
    else {
      filePath = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['xlsx']).then((result) {
        return result?.files.single.path;
      });
      if (filePath != null) {
        var bytes = File(filePath).readAsBytesSync();
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

    var columnPrime = MainController.getColumnPrime();

    for (var data in rowdetail) {
      var findIndexRecord = findByColumn(data, columnPrime);
      //create data json
      //function generate json record with columns name and data excel
      var excelJson = await generateJsonExcel(data, findIndexRecord);
      excelJson.removeWhere((key, value) => key=='sync');
      excelJson.removeWhere((key, value) => key=='server error');
      if (findIndexRecord != -1) {
        await DB('${MainController.tableInfo['schema']['name']}')
            .where('_id', '\$eq', '${data['id']}')
            .updateRecords(excelJson);
      }
      else {
        await DB('${MainController.tableInfo['schema']['name']}').storeRecord(excelJson);
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
      var existingDataIndex = MainController.tableData.value.indexWhere((data) => data['_id'] == Id);
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

  static Future<Map> generateJsonExcel(
      var dataRowExcel, var recordIndex) async {
    Map<String, dynamic> dataExlJson = {};
    for (var i = 0; i < MainController.tableInfo['columns'].length; i++) {
      var column = MainController.tableInfo['columns'][i];
      var name = column['name'];
      var type = column['type'];
      // var items = column['items'];

      var items;
      // if (type == 'select' || type == 'radiobutton' || type == 'multiSelect') {
      //   items = await ViewController.itemsList(column);
      // }

      var isImportable = column['import-of-excel'];

      if (isImportable == null || isImportable) {
        //is importable be true or null: null==true default value
        {

          if (dataRowExcel[name] != null) {
            if (type == 'select' || type == 'radiobutton') {
              // dataExlJson[name]=null;
            }else if (type == 'multiSelect' ) {
              // dataExlJson[name]=null;
            }
            else if (type == 'checkbox') {
              dataExlJson[name] = dataRowExcel[name];
            } else if (type == 'file') {
              if (dataRowExcel[name] != null) {
                var columnPrime = MainController.getColumnPrime();
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
            }  else if (type == 'select' || type == 'radiobutton') {
              // dataExlJson[name]=null;
            }else if (type == 'multiSelect' ) {
              // dataExlJson[name]=null;
            }else{
              dataExlJson[name] =null;
            }
          }
        }
      }


      // import excel true
      else {
        if (recordIndex != -1) {
          if (dataRowExcel[name] != null) {
            dataExlJson[name] =
            MainController.tableData.value[recordIndex].data['${name}'];
          } else {
            dataExlJson[name] = '';
          }
        }
        else {
          if (dataRowExcel[name] != null) {
            if (type == 'checkbox') {
              dataExlJson[name] = dataRowExcel[name];
            } else if (type == 'file') {
              if (dataRowExcel[name] != null) {
                var columnPrime = MainController.getColumnPrime();
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
}
