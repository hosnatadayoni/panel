import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chunked_uploader/chunked_uploader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:finance/Admin/Logic/Controllers/AdminController.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Helpers/token-methods.dart';
import 'package:finance/Admin/Logic/Models/dataModel.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/api-urls.dart';
import 'package:finance/Admin/Public/enums.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu-item.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/Admin/UI/Views/login-page.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../UI/Views/dashboard.dart';
import '../../UI/Views/set-token-page.dart';
import '../../UI/Views/table-page.dart';
import '../Helpers/api-methods.dart';
import 'connect-server-controller.dart';
import 'helper-controller.dart';

class MainController extends GetxController {
  static Rx<bool> isLightMode = true.obs;
  static Rx<int> countShowRow = 10.obs;
  static Rx<bool> isClickedItem = false.obs;

  //get all data for search
  static RxList<dynamic> allData = [].obs;

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
  static Rx<int> totalPages = 1.obs;
  static Rx<int> startIndex = 0.obs;
  static Rx<int> endIndex = 0.obs;
  static Rx<int> totalItems = 0.obs;
  static RxList<dynamic> tableData = <dynamic>[].obs;
  static RxString searchQuery = ''.obs;
  static Rx<bool> isSelected = false.obs;
  static Rx<String> tableName = ''.obs;

  //dasboard page
  static var hoveredIndex = (-1).obs;

  static List<dynamic> data = [];

  static Map<String, dynamic> dataJson = {};

  static Rx<int> selectedItemList = 0.obs;

  static RxList<dynamic> SubMenuList = [].obs;
  static RxMap<String, dynamic> tableInfo = <String, dynamic>{}.obs;
  DataModel? dataModel;
  static var allColumn;

  static GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

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

  static Future<void> loadJson() async {
    await ConncetServerController.listSchemaByField();
    // // String jsonFileString;
    // // jsonFileString = await rootBundle.loadString('assets/menu.json');
    // // SubMenuList = json.decode(jsonFileString);
    //
    // for (var name in tableNames()) {
    //   // addsyncField('${name}');
    //   addParentForRelations('${name}');
    // }
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
    int index = MainController.SubMenuList.indexWhere((element) {
      return element['schema']['name'] == '${tableName}';
    });
    if (index != -1) {
      var tableInfo = MainController.SubMenuList[index];
      return tableInfo;
    }
    return null;
  }

  static getStatusTable(String tableName) {
    var infoTable = getInfoTable(tableName);
    if (infoTable != null) {
      return infoTable['schema']['online'];
    }
    return false;
  }

  static List<dynamic> getColumnsTable(String tableName) {
    var infoTable = getInfoTable(tableName);
    if (infoTable != null) {
      return infoTable['columns'];
    }
    return [];
  }

  static List<dynamic> getColumnsList(String tableName) {
    List<dynamic> columns = getColumnsTable(tableName);
    if (columns.length != 0) {
      List<dynamic> list = [];
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
      if (item['name'] == '_id') {
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
    print('column table>>>${column}');
    for (var item in column) {
      print('item of name>>>${item['name']}');
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
      List<dynamic> list = [];
      MainController.tableInfo['currentPage'] = 1;
      for (Map<String, dynamic> data in allData) {
        bool flag = true;

        for (var key in data.keys) {
          if (key != '_id') {
            if (data[key] != null) {
              var type = getTypeOfField(
                  MainController.tableInfo['schema']['name'], key);

              if (type == 'select' ||
                  type == 'multiSelect' ||
                  type == 'radiobutton') {
                var column = getDetailsOfField(
                    MainController.tableInfo['schema']['name'], key);
                data[key] =
                    ViewController.itemsShowSelectItem(data[key], column);
              }

              var val = data[key];
              if (val
                  .toString()
                  .toLowerCase()
                  .contains(query.toString().toLowerCase())) {
                flag = true;
                break;
              } else {
                flag = false;
              }
            } else {
              flag = false;
            }
          } else {
            flag = false;
          }
        }
        if (flag == true) {
          list.add(data);
        }
      }
      MainController.tableData.value = list;
    }
  }

  static setRelations(String tableName) {
    var index = SubMenuList.indexWhere(
        (element) => element['schema']['name'] == tableName);
    var items = SubMenuList[index];
    print('MainController.setRelations>>>${index}>>${SubMenuList[index]}');

    if (items['schema']['relations'] != null &&
        items['schema']['relations'].length != 0) {
      var relates = [];

      for (var relations in items['schema']['relations']) {
        var index = SubMenuList.indexWhere(
            (element) => element['schema']['name'] == relations);
        if (index != -1) {
          relates.add(SubMenuList[index]['schema']['name']);
        }
      }
      SubMenuList[index]['relations'] = relates;
    }
    print('MainController.changeRelations>>${SubMenuList[index]['relations']}');
    return items['relations'];
  }

  static addsyncField(String tableName) {
    var index = SubMenuList.indexWhere(
        (element) => element['schema']['name'] == tableName);
    var items = SubMenuList[index];
    if (items['schema']['view'] == null) {
      items.addAll({'view': 'default'});
    }
    items['columns'].add({
      'name': 'sync',
      'title': 'sync',
      'type': 'string',
      'is_show_table': true,
      'is_show_edit': false,
      'is_show_store': false,
    });
    items['columns'].add({
      'name': 'server error',
      'title': 'server error',
      'type': 'string',
      'is_show_table': true,
      'is_show_edit': false,
      'is_show_store': false,
    });
  }

  static List<dynamic> tableNames() {
    var list = [];
    for (var table in SubMenuList) {
      list.add(table['schema']['name']);
    }
    print('MainController.tableNames>>${list}');

    return list;
  }

  static List<dynamic> createJsonSchemaApi() {
    List<dynamic> l = [];
    Map<String, dynamic> c = {};
    for (var table in SubMenuList) {
      Map<String, dynamic> list = {};
      for (var column in table['columns']) {
        c.addAll({
          '${column['name']}': {"type": "${column['type_filed']}"}
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
    var getDataTable = MainController.getDataTable(tableName);
    if (getDataTable['schema']['relations'] != null &&
        getDataTable['schema']['relations'].length != 0) {
      for (var relate in getDataTable['schema']['relations']) {
        var index = SubMenuList.indexWhere(
            (element) => element['schema']['name'] == relate);
        var items = SubMenuList[index];
        items['columns'].add({
          'name': 'parent_table',
          'title': 'parent_table',
          'type': 'string',
          'is_show_table': false,
          'is_show_edit': false,
          'is_show_store': false,
        });
        items['columns'].add({
          'name': 'parent_id',
          'title': 'parent_id',
          'type': 'string',
          'is_show_table': false,
          'is_show_edit': false,
          'is_show_store': false,
        });
      }
    }
  }

  static Future<void> loadData(
      {var tableData = null, var tableDataItems}) async {
    ViewController.request={};
    if (MainController.selectedSubItem.value != -1) {
      if (tableData == null || tableData.length == 0) {
        MainController.tableInfo.value =
            SubMenuList[MainController.selectedSubItem.value];
        MainController.tableData.value =
            (await DB('${tableInfo['schema']['name']}').paginate());
        MainController.allData.value = MainController.tableData.value;
      } else {
        MainController.tableInfo.value = tableData;
        if (tableDataItems != null) {
          MainController.tableData.value = tableDataItems;
          MainController.allData.value = MainController.tableData.value;
        } else {
          // if (tableInfo['status'] == "online")
          //   await ConncetServerController.getRecordGeneral('${tableInfo['name']}');
          // else
          MainController.tableData.value =
              (await DB('${MainController.tableInfo['schema']['name']}')
                  .paginate());

          MainController.allData.value = MainController.tableData.value;
        }
      }
    } else {
      if (SubMenuList.length > 0) {
        tableInfo = SubMenuList[0];
      }
    }
    await ViewController.callFilterView();
    if (tableData == null || tableData.length == 0) {
      for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
        if (MainController.tableInfo['columns'][j]['is_show_store'] == null) {
          MainController.tableInfo['columns'][j]['is_show_store'] = true;
        }
        if (MainController.tableInfo['columns'][j]['is_show_table'] == null) {
          MainController.tableInfo['columns'][j]['is_show_table'] = true;
        }
        if (MainController.tableInfo['columns'][j]['is_show_edit'] == null) {
          MainController.tableInfo['columns'][j]['is_show_edit'] = true;
        }
        if (MainController.tableInfo['columns'][j]['is-show-excel'] == null) {
          MainController.tableInfo['columns'][j]['is-show-excel'] = true;
        }
      }
    } else {
      for (var j = 0; j < tableData['columns'].length; j++) {
        if (tableData['columns'][j]['is_show_store'] == null) {
          tableData['columns'][j]['is_show_store'] = true;
        }
        if (tableData['columns'][j]['is_show_table'] == null) {
          tableData['columns'][j]['is_show_table'] = true;
        }
        if (tableData['columns'][j]['is_show_edit'] == null) {
          tableData['columns'][j]['is_show_edit'] = true;
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

  static goToTablePage(var table,
      {bool loadData = true,
      var tableFields = null,
      var tableData = null}) async {
    if (table['schema']['view'] == 'custom') {
      if(table['schema']['name'] == 'Orders'){
        ViewCustomController.containers =<String, Widget>{}.obs;
        // MainController.tableData.value = await DB('Orders').getRecords();
        // List<dynamic> ordersList = await DB('Orders').where('parent_id', '\$ne', 'null').getRecords();
        // MainController.tableData.addAll(ordersList);


      HelperController.pageInateFunction();
      // Navigator.push(
      //     Get.context!, MaterialPageRoute(builder: (context) => TablePage()));
      HelperController.tablePageFunction(table: table);
      }
    } else {
      if (loadData == true)
        await MainController.loadData(
            tableData: tableFields, tableDataItems: tableData);
      MainController.tableInfo['schema']['currentPage'] = 1;
      ViewController.totalPage.value =
          await DB('${MainController.tableInfo['schema']['name']}').infoPage();
      await Get.to(() => TablePage());
    }
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

  static Map<String, dynamic> getDataTable(String tableName) {
    Map<String, dynamic> dataTableName = {};
    for (var subMenu in MainController.SubMenuList) {
      if (subMenu['schema']['name'] == tableName) {
        dataTableName = subMenu;
      }
    }
    return dataTableName;
  }

  static renderData(operation type, var data) {
    // if(type== operation.store){
    //   print('MainController.renderData store>>${data}');
    //   MainController.tableData.add(data);
    //   MainController.allData.value = MainController.tableData;
    //   MainController.totalItems.value++;
    //   MainController.endIndex.value++;
    // } else
    if (type == operation.delete) {
      MainController.tableData
          .removeWhere((element) => element['_id'] == data['_id']);
      MainController.allData.value = MainController.tableData;
      MainController.totalItems.value--;
      MainController.endIndex.value--;
    } else if (type == operation.update) {
      var index = MainController.tableData
          .indexWhere((element) => element['_id'] == data['_id']);
      if (index != -1) {
        MainController.tableData[index] = data;
        MainController.allData.value = MainController.tableData;
      }
    }
  }

  static Future<String?> uploadFileInChunks(
      var singleFile, var column, RxMap<String, List<dynamic>> fileInfo,
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
          'field_id': column['_id'],
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
              showSnackbar(snackTypes.error,response!.data['error'] );
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
              MainController.renderData(
                  operation.update, response.data['data'].first);
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
}
