import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chunked_uploader/chunked_uploader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:finance/Admin/Logic/Controllers/AdminController.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Helpers/token-methods.dart';
import 'package:finance/Admin/Logic/Models/tableModel.dart';
import 'package:finance/Admin/Logic/Models/dataModel.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Logic/Models/paginate.dart';
import 'package:finance/Admin/Public/api-urls.dart';
import 'package:finance/Admin/Public/enums.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu-item.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/Admin/UI/Views/login-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../UI/Views/dashboard.dart';
import '../../UI/Views/set-token-page.dart';
import '../../UI/Views/table-page.dart';
import '../Helpers/api-methods.dart';
import '../Models/columnModel.dart';
import '../Models/schemaModel.dart';
import 'connect-server-controller.dart';
import 'helper-controller.dart';
import 'dart:convert';

class MainController extends GetxController {
  static Rx<bool> isLightMode = true.obs;
  static Rx<int> countShowRow = 10.obs;
  static Rx<bool> isClickedItem = false.obs;

  //get all data for search
  static RxList<dynamic> allData = [].obs;

  //dehdar remove this section read icon of json
  static List<Item> menuItems = [
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
    ),
    Item(
      title: 'route',
      icon: Icons.link,
    ),
    Item(
      title: 'access',
      icon: Icons.accessibility,
    ),
    Item(
      title: 'role & access',
      icon: Icons.key,
    ),
    Item(
      title: 'admin',
      icon: Icons.person,
    ),
  ];

  static String formatNumber(String number) {
    try {
      final num value = num.tryParse(number) ?? 0;
      return NumberFormat.decimalPattern().format(value);
    } catch (e) {
      return number;
    }
  }

  static Rx<int> selectedItem = 0.obs;
  static Rx<int> selectedSubItem = (-1).obs;
  static Rx<Item> itemSelected = Item().obs;
  static Rx<int> subItemSelectedIndex = (-1).obs;
  static Rx<String> subItemSelected = ''.obs;

  // static RxMap<String,int> totalPages = <String,int>{}.obs;
  // static RxInt startIndex = 0.obs;
  // static RxInt  endIndex = 0.obs;
  // static RxMap<String,int> totalRecords = <String,int>{}.obs;
  static RxMap<String, PageInfo> pageInfo = <String, PageInfo>{}.obs;
  static RxString searchQuery = ''.obs;
  static Rx<bool> isSelected = false.obs;
  static Rx<String> tableName = ''.obs;

  //dasboard page
  static var hoveredIndex = (-1).obs;

  static List<dynamic> data = [];

  static Map<String, dynamic> dataJson = {};

  static Rx<int> selectedItemList = 0.obs;

  static RxList<TableModel> menuList = <TableModel>[].obs;
  static Rx<TableModel> infoSchema =
      TableModel(schema: SchemaModel(), columns: []).obs;
  static RxList<dynamic> dataRecord = <dynamic>[].obs;

  DataModel? dataModel;
  static var allColumn;

  static GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

  static getColumnInfoByName({String columnName = ''}) {
    for (var j = 0; j < MainController.infoSchema.value.columns.length; j++) {
      var column = MainController.infoSchema.value.columns[j];
      if (column.name == columnName) {
        return column;
      }
    }
    return null;
  }

  static getTypeOfColumnByName({String columnName = ''}) {
    for (var j = 0; j < MainController.infoSchema.value.columns.length; j++) {
      var column = MainController.infoSchema.value.columns[j];
      if (column.name == columnName) {
        return column.type;
      }
    }
    return null;
  }

  //question
  static getColumnPrime() {
    for (var j = 0; j < MainController.infoSchema.value.columns.length; j++) {
      var column = MainController.infoSchema.value.columns[j];
      // if (column['is-prime'] == true) {
      //   return column;
      // }
    }
    return null;
  }

  static getColumnImportExcel(bool isImportExcel) {
    for (var j = 0; j < MainController.infoSchema.value.columns.length; j++) {
      var column = MainController.infoSchema.value.columns[j];
      // if (column['import-of-excel'] == isImportExcel) {
      return column;
      // }
    }
    return null;
  }

  static bool isNumeric(String str) {
    if (str.isEmpty) return false;
    return double.tryParse(str) != null;
  }

  static getInfoTable(String tableName) {
    int index = MainController.menuList.indexWhere((element) {
      return element.schema.name == '${tableName}';
    });
    if (index != -1) {
      var tableInfo = MainController.menuList[index];
      return tableInfo;
    }
    return null;
  }

  static getStatusTable(String tableName) {
    var infoTable = getInfoTable(tableName);
    if (infoTable != null) {
      return infoTable.schema.online;
    }
    return false;
  }

  static List<ColumnModel> getColumnsTable(String tableName) {
    var infoTable = getInfoTable(tableName);
    if (infoTable != null) {
      return infoTable.columns;
    }
    return [];
  }

  static List<dynamic> getColumnsList(String tableName) {
    List<dynamic> columns = getColumnsTable(tableName);
    if (columns.length != 0) {
      List<dynamic> list = [];
      for (var column in columns) {
        list.add(column.name);
      }
      return list;
    }
    return [];
  }

  static getTypeOfField(String tableName, String name) {
    var type;
    var column = getColumnsTable(tableName);
    for (var item in column) {
      if (item.name == '_id') {
        return 'string';
      }
      if (item.name == name) {
        type = item.type;
        return type;
      }
    }
  }

  //all items in column
  static getDetailsOfField(String tableName, String name) {
    var i;
    var column = getColumnsTable(tableName);
    for (ColumnModel item in column) {
      if (item.name == name) {
        i = item;
        return i;
      }
    }
  }


  static Future<void> search(String query) async {
    searchQuery.value = query;

      List<dynamic> allDataItems = [];
      for (var item in MainController.allData) {
          allDataItems.add((item));

      }
    print('MainController.search>> query.isEmpty>>${allDataItems}');

    if (query.isEmpty) {
      // اگر سرچ خالی است، همه داده‌ها را نشان بده
      MainController.dataRecord.value = List.from(MainController.allData.value);
    } else {
      MainController.infoSchema.value.schema.currentPage = 1;

      List<int> matchedIndexes = [];

      for (int i = 0; i < MainController.allData.value.length; i++) {
        var data = MainController.allData.value[i];
        bool matches = false;

        for (var key in data.keys) {
          if (key == '_id') continue;

          var val = data[key];
          if (val != null) {
            var type = getTypeOfField(MainController.infoSchema.value.schema.name!, key);

            var displayVal = val;
            if (type == 'select' || type == 'multiSelect' || type == 'radiobutton') {
              var column = getDetailsOfField(MainController.infoSchema.value.schema.name!, key);
              displayVal = ViewController.itemsShowSelectItem(val, column);
            }

            if (!matches && displayVal.toString().toLowerCase().contains(query.toLowerCase())) {
              matches = true;
            }
          }
        }

        if (matches) {
          matchedIndexes.add(i);
        }
      }

      // با ایندکس‌ها مقادیر اصلی را به dataRecord اضافه کن
      MainController.dataRecord.value = matchedIndexes.map((i) {
        // deep copy از داده اصلی
        return jsonDecode(jsonEncode(MainController.allData.value[i]));
      }).toList();
      MainController.allData.value=allDataItems;
      // print('MainController.search>>>${MainController.allData.value}');

    }
  }

  // static Future<void> search(String query) async {
  //   print('MainController.search>>1}${MainController.allData.value}');
  //
  //   List<Map<String, dynamic>> allData = [];
  //   for (var item in MainController.allData) {
  //     if (item is Map) {
  //       allData.add(Map<String, dynamic>.from(item));
  //     }
  //   }
  //   searchQuery.value = query;
  //   if (query.isEmpty) {
  //     // MainController.dataRecord.value =allData;
  //     // if (MainController.dataRecord !=  allData2) {
  //     MainController.dataRecord.value = List.from(MainController.allData);
  //     // }
  //   } else {
  //     print('MainController.search else');
  //     List<dynamic> list = [];
  //     MainController.infoSchema.value.schema.currentPage = 1;
  //     for (Map<String, dynamic> data in allData) {
  //       bool flag = true;
  //
  //       for (var key in data.keys) {
  //         if (key != '_id') {
  //           if (data[key] != null) {
  //             var type = getTypeOfField(
  //                 MainController.infoSchema.value.schema.name!, key);
  //             if (type == 'select' ||
  //                 type == 'multiSelect' ||
  //                 type == 'radiobutton') {
  //               var column = getDetailsOfField(MainController.infoSchema.value.schema.name!, key);
  //               data[key] = ViewController.itemsShowSelectItem(data[key], column);
  //             }
  //
  //             var val = data[key];
  //             if (val.toString().toLowerCase().contains(query.toString().toLowerCase())) {
  //               flag = true;
  //               break;
  //             } else {
  //               flag = false;
  //             }
  //           } else {
  //             flag = false;
  //           }
  //         } else {
  //           flag = false;
  //         }
  //       }
  //       if (flag == true) {
  //         // MainController.allData.value.
  //         list.add(data);
  //       }
  //     }
  //     MainController.dataRecord.value = list;
  //     print('MainController.search>>2}${MainController.allData.value}');
  //   }
  // }

  static setRelations(String tableName) {
    var index =
        menuList.indexWhere((element) => element.schema.name == tableName);
    var items = menuList[index];
    if (items.schema.relations != [] && items.schema.relations!.length != 0) {
      var relates = [];

      for (var relations in items.schema.relations!) {
        var index =
            menuList.indexWhere((element) => element.schema.name == relations);
        if (index != -1) {
          relates.add(menuList[index].schema.name);
        }
      }
      menuList[index].schema.relations = relates;
    }
    return items.schema.relations;
  }

  static addsyncField(String tableName) {
    var index =
        menuList.indexWhere((element) => element.schema.name == tableName);
    var items = menuList[index];
    if (items.schema.view == null) {
      items.schema.view = 'default';
    }
    if (items.schema.online == true)
      items.columns.addAll(
        ['sync', 'server error','sync_type'].map(
          (colName) => ColumnModel(
            name: colName,
            title: colName,
            type: 'string',
            typeField: 'string',
            isShowEdit: false,
            isShowStore: false,
            isShowTable: true,
          ),
        ),
      );
    // items.columns.add(
    //   ColumnModel(
    //
    //     name: 'sync',
    //     title: 'sync',
    //     type: 'string',
    //     typeField: 'string',
    //     isShowEdit: false,
    //     isShowStore: false,
    //     isShowTable: true,
    //   ),
    // );
    // items.columns.add(
    //   ColumnModel(
    //
    //     name: 'server error',
    //     title: 'server error',
    //     type: 'string',
    //     typeField: 'string',
    //     isShowEdit: false,
    //     isShowStore: false,
    //     isShowTable: true,
    //   ),
    // );
    // items.columns.addAll([
    //   {
    //     'name': 'sync',
    //     'title': 'sync',
    //     'type': 'string',
    //     'is_show_table': true,
    //     'is_show_edit': false,
    //     'is_show_store': false,
    //   }
    // ]);
    // items['columns'].add({
    //   'name': 'server error',
    //   'title': 'server error',
    //   'type': 'string',
    //   'is_show_table': true,
    //   'is_show_edit': false,
    //   'is_show_store': false,
    // });
  }

  static List<dynamic> tableNames() {
    var list = [];
    for (TableModel table in menuList) {
      list.add(table.schema.name);
    }
    print('MainController.tableNames>>${list}');

    return list;
  }

  static List<dynamic> createJsonSchemaApi() {
    List<dynamic> l = [];
    Map<String, dynamic> c = {};
    for (var table in menuList) {
      Map<String, dynamic> list = {};
      for (ColumnModel column in table.columns) {
        c.addAll({
          '${column.name}': {"type": "${column.typeField}"}
        });
      }
      list.addAll({
        'columns': (json.encode(c)).toString(),
      });
      // ConncetServerController.updateSchema(list);
      l.add(list);
    }
    ;
    return l;
  }

  static addParentForRelations(String tableName) {
    TableModel getDataTable = MainController.getDataTable(tableName);
    if (getDataTable.schema.relations != null &&
        getDataTable.schema.relations!.length != 0) {
      for (var relate in getDataTable.schema.relations!) {
        var index =
            menuList.indexWhere((element) => element.schema.name == relate);
        var items = menuList[index];
        items.columns.addAll(
          ['parent_table', 'parent_id'].map(
            (colName) => ColumnModel(
              name: colName,
              title: colName,
              type: 'string',
              typeField: 'string',
              isShowEdit: false,
              isShowStore: false,
              isShowTable: false,
            ),
          ),
        );
      }
    }
  }

  static Future<void> loadData(
      {var tableData = null, var tableDataItems}) async {
    ViewController.request = {};
    if (MainController.selectedSubItem.value != -1) {
      if (tableData == null) {
        MainController.infoSchema.value =
            menuList[MainController.selectedSubItem.value];
        MainController.dataRecord.value =
            await DB('${infoSchema.value.schema.name}').paginate();
        MainController.allData.value = MainController.dataRecord;
      } else {
        MainController.infoSchema.value = tableData;
        if (tableDataItems != null) {
          MainController.dataRecord.value = tableDataItems;
          MainController.allData.value = MainController.dataRecord;
        } else {
          // if (tableInfo['status'] == "online")
          //   await ConncetServerController.getRecordGeneral('${tableInfo['name']}');
          // else
          MainController.dataRecord.value =
              await DB('${MainController.infoSchema.value.schema.name}')
                  .paginate();

          MainController.allData.value = MainController.dataRecord;
        }
      }
    } else {
      if (menuList.length > 0) {
        infoSchema.value = menuList[0];
      }
    }
    await ViewController.callFilterView();
    if (tableData == null
        // || tableData.length == 0
        ) {
      for (var j = 0; j < MainController.infoSchema.value.columns.length; j++) {
        if (MainController.infoSchema.value.columns[j].isShowStore == null) {
          MainController.infoSchema.value.columns[j].isShowStore = true;
        }
        if (MainController.infoSchema.value.columns[j].isShowTable == null) {
          MainController.infoSchema.value.columns[j].isShowTable = true;
        }
        if (MainController.infoSchema.value.columns[j].isShowEdit == null) {
          MainController.infoSchema.value.columns[j].isShowTable = true;
        }
        if (MainController.infoSchema.value.columns[j].isShowExcel == null) {
          MainController.infoSchema.value.columns[j].isShowExcel = true;
        }
      }
    } else {
      for (var j = 0; j < tableData.columns.length; j++) {
        if (tableData.columns[j].isShowStore == null) {
          tableData.columns[j].isShowStore = true;
        }
        if (tableData.columns[j].isShowTable == null) {
          tableData.columns[j].isShowTable = true;
        }
        if (tableData.columns[j].isShowEdit == null) {
          tableData.columns[j].isShowEdit = true;
        }
        if (tableData.columns[j].isShowExcel == null) {
          tableData.columns[j].isShowExcel = true;
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
        if (column['type'] == 'Number int' ||
            column['type'] == 'Number double') {
          var minValidator = column['validators'].firstWhere(
              (validator) => validator['type'] == 'min',
              orElse: () => null);
          var maxValidator = column['validators'].firstWhere(
              (validator) => validator['type'] == 'max',
              orElse: () => null);
          // int numberExcel = int.parse('${cellExcel}');
          num? intValue;
          if (column['type'] == 'Number int') {
            intValue = int.tryParse(cellExcel);
          } else if (column['type'] == 'Number double') {
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

  static Rx<String> apiKey = ''.obs;

  static getInitData() async {
    var token = await Token.getToken();
    print('MainController.getInitData>>${token}');
    if (token != '') {
      // apiKey.value = token;
      await AdminController.getAdmin();
    } else {
      Get.to(() => SetTokenPage());
    }
  }

  static TableModel getDataTable(String tableName) {
    TableModel dataTableName = TableModel(schema: SchemaModel(), columns: []);
    for (var subMenu in MainController.menuList) {
      if (subMenu.schema.name == tableName) {
        dataTableName = subMenu;
      }
    }
    return dataTableName;
  }

  static renderData(String tableName, operation type, var data) {
    // if(type== operation.store){
    //   print('MainController.renderData store>>${data}');
    //   MainController.tableData.add(data);
    //   MainController.allData.value = MainController.tableData;
    //   MainController.totalRecords.value++;
    //   MainController.endIndex.value++;
    // } else
    if (type == operation.delete) {
      MainController.dataRecord
          .removeWhere((element) => element['_id'] == data['_id']);
      MainController.allData.value = MainController.dataRecord;
      // print('MainController.renderData>>${tableName}>>>${MainController.pageInfo[tableName]!.end}>>>>${MainController.pageInfo[tableName]!.totalRecords}');
      // MainController.pageInfo[tableName]!.totalRecords= MainController.pageInfo[tableName]!.totalRecords -1;
      // MainController.pageInfo[tableName]!.end=MainController.pageInfo[tableName]!.end -1;
      // print('MainController.renderData>>${MainController.pageInfo[tableName]}');
    } else if (type == operation.update) {
      var index = MainController.dataRecord
          .indexWhere((element) => element['_id'] == data['_id']);
      if (index != -1) {
        MainController.dataRecord[index] = data;
        MainController.allData.value = MainController.dataRecord;
      }
    }
  }

  static Future<String?> uploadFileInChunks(
      var singleFile, ColumnModel column, RxMap<String, List<dynamic>> fileInfo,
      {int chunkSize = 512 * 1024}) async {
    var filePath = null;
    if (singleFile == null) return null;

    print('MainController.uploadFileInChunks>>${column}');
    final path = singleFile.path!;
    final file = File(path);
    final totalLength = await file.length();
    final raf = file.openSync(mode: FileMode.read);
    int offset = 0;
    int chunkIndex = 1;
    Map<String, dynamic> chunkName = {};
    try {
      if (!fileInfo.containsKey(singleFile.name)) {
        fileInfo[singleFile.name] = [];
      }
      while (offset < totalLength) {
        final remaining = totalLength - offset;
        final currentChunkSize = remaining > chunkSize ? chunkSize : remaining;
        final bytes = raf.readSync(chunkSize);
        final String chunk = base64Encode(bytes);
        MainController.updateFileInfo(singleFile.name,
            (totalLength / chunkSize).ceil(), chunkIndex, fileInfo);
        var body = {
          'table_name': tableName,
          'data': chunk,
          'field_id': column.id,
          'name': file.uri.pathSegments.last,
          'currentChunkIndex': chunkIndex,
          'totalChunks': (totalLength / chunkSize).ceil(),
        };
        var response =
            await RestApi.post(uploadFileUrl, body: body, useToken: true);
        RestApi.responseHandler(
            response: response,
            successCallback: () async {
              filePath = response!.data['data'];
              print('MainController.uploadFileInChunks>>${filePath}');
              if (filePath != null) {
                chunkName = filePath;
                if (chunkName.isNotEmpty) {
                  fileInfo[singleFile.name] = [
                    (totalLength / chunkSize).ceil(),
                    chunkIndex,
                    chunkName,
                  ];
                  fileInfo.refresh();
                }
              }
            },
            errorCallback: () {
              print('Failed to upload chunk $chunkIndex');
              showSnackbar(snackTypes.error, response!.data['error']);
              return null;
            },
            printResponse: true);
        offset += currentChunkSize;
        chunkIndex++;
      }
    } catch (e) {
      print('Error during upload: $e');
      return null;
    } finally {
      raf.closeSync();
    }
    print('Upload finished.>>>$filePath');

    return filePath['name'];
  }

  static void updateFileInfo(
    String fileName,
    int totalChunks,
    int currentChunk,
    RxMap<String, List<dynamic>> fileInfo,
  ) {
    dynamic existingChunkName =
        fileInfo[fileName]!.length > 2 ? fileInfo[fileName]![2] : null;
    fileInfo[fileName] = [
      totalChunks,
      currentChunk,
      existingChunkName,
    ];
    fileInfo.refresh();
  }

  static Future<bool> deleteFileInChunks(String filePath,
      {var recordId = null, var record = null}) async {
    bool status = false;
    var response = await RestApi.post(deleteFileUrl,
        body: {
          'fileName': filePath,
          'table_name': tableName,
          'record_id': recordId,
          'record': record
        },
        useToken: true);
    RestApi.responseHandler(
        response: response,
        successCallback: () async {
          if (recordId != null) {
            if (response!.data['data'] != null &&
                response.data['data'].length != 0)
              MainController.renderData(tableName.value, operation.update,
                  response.data['data'].first);
          }
          status = true;
          print('MainController.deleteFileInChunks>>$status');
        },
        errorCallback: () {
          status = false;
        },
        printResponse: true);
    return status;
  }

  //remove record dont sync in online schema
  static List<dynamic> removeOffRecord({String? tableName, var list}) {
    if (getStatusTable(tableName!) == true) {
      list.removeWhere((element) => element['sync'] != null);
    }
    return list;
  }

  static Map<String, dynamic> setVersionRecordInBox(Map<String, dynamic> data) {
    // if (data.containsKey('version') && data['version'] is int) {
      data['version'] = data['version'] + 1.0;
      print('MainController.setVersionRecordInBox>>${  data['version']}');

    // } else {
    //   data['version'] = 1.0;
    // }
    return data;
  }

  static Future<void> setVersionSchemaInBox(String tableName) async {
    // var index = MainController.menuList.indexWhere((element) => element.schema.name == tableName);
    // if (index != -1) {
    //   MainController.menuList[index].schema.version =
    //       (MainController.menuList[index].schema.version ?? 0) + 0.1;
    // } else {
    //   print('Schema not found in menuList!');
    //   return;
    // }
    final box = await Hive.openBox<TableModel>('menuBox');
    var boxIndex = box.values.toList().indexWhere((element) => element.schema.name == tableName);
    if (boxIndex != -1) {
      TableModel value = box.getAt(boxIndex)!;
      value.schema.version = value.schema.version + 0.1;
      await box.putAt(boxIndex, value);
    } else {
      print('Schema not found in Hive box!');
    }
  }

}
