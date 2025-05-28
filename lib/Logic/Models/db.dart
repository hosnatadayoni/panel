import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../UI/Componenets/Popups/snackbar.dart';
import '../Controllers/helper-controller.dart';
import '../Controllers/main-controller.dart';
import '../Controllers/record-controller.dart';
import '../Controllers/view-controller.dart';
import '../Controllers/view-custom-controller.dart';
import 'dataModel.dart';
import 'general.dart';
import 'package:get/get.dart';
import 'dart:math';

class DB {
  String? tableName;
  String? parentTable;
  String? parentId;
  Map<int, Where> whereList = <int, Where>{};
  Map<int, Where> orWhereList = <int, Where>{};
  int? takeCount;
  int? skipCount;
  int? randomCount;
  Map<String, dynamic> parentItem = <String, dynamic>{};
  int counter = 0;
  List<Where> w = [];

  DB(String tableName) {
    this.tableName = tableName;
  }

  getTypeOfField(List<dynamic> data) {
    var type;
    List<Map<String, dynamic>> newData = <Map<String, dynamic>>[];
    for (var d in data) {

      Map<String, dynamic> e = <String, dynamic>{};
      for (var key in d.data.keys) {
        type = MainController.getTypeOfField(this.tableName!, key);
        if (type != null) {
          e['id'] = d.id;
          e[key] = General.withFormat(type, d.data[key]);
        }
      }
      newData.add(e);
    }
    return newData;
  }

  getTypeOfFieldJson(Map<String, dynamic> d) {
    var type;
    Map<String, dynamic> newData = <String, dynamic>{};


    Map<String, dynamic> e = <String, dynamic>{};
    for (var key in d.keys) {
      type = MainController.getTypeOfField(this.tableName!, key);
      if (type != null) {
        e['id'] = d['id'];
        e[key] = General.withFormat(type, d[key]);
      }
    }
    newData = (e);

    return newData;
  }

  where(String? fieldName, String? oprator, var value) {
    counter++;
    Where l = Where(fieldName, oprator, value);
    w.add(l);
    this.whereList[counter] = l;

    return this;
  }

  orWhere(String? fieldName, String? oprator, var value) {
    counter++;
    Where l = Where(fieldName, oprator, value);
    w.add(l);
    this.orWhereList[counter] = l;

    return this;
  }

  take(int count) {
    this.takeCount = count;
    return this;
  }

  skip(int count) {
    this.skipCount = count;
    return this;
  }

  random(int count) {
    this.randomCount = count;
    return this;
  }

  getRandomItems(List list, int count) {
    if (count <= 0 || list.isEmpty) return [];
    if (count >= list.length) return List.from(list)..shuffle();
    final shuffled = List.from(list)..shuffle();
    return shuffled.take(count).toList();
  }

  List<Map<String, dynamic>> searchList(
    List<Map<String, dynamic>> mainList,
    Map<int, Where> searchPattern,
  ) {
    return mainList.where((item) {
      // بررسی می‌کنیم که آیا تمام کلید-مقدارهای الگو در آیتم وجود دارد
      return searchPattern.entries.every((entry) {
        final key = entry.value.fieldName;
        final value = entry.value.value;
        // if(item[key])
        return item.containsKey(key) &&
            (item[key] is List
                ? item[key].contains(value)
                : item[key] == value);
      });
    }).toList();
  }

  Future<List<Map<String, dynamic>>> filterInBackground(
    List<dynamic> mainList,
    List<dynamic> searchPattern,
  ) async {
    return await compute(_filterListIsolate, {
      'mainList': mainList,
      'searchPattern': searchPattern,
    });
  }

  List<Map<String, dynamic>> _filterListIsolate(Map<String, dynamic> data) {
    final mainList = data['mainList'] as List<Map<String, dynamic>>;
    final searchPattern = data['searchPattern'] as List<Map<String, dynamic>>;

    return mainList.where((mainItem) {
      return searchPattern.every((patternItem) {
        return patternItem.entries.every((patternEntry) {
          final key = patternEntry.key;
          final value = patternEntry.value;
          return mainItem.containsKey(key) && mainItem[key] == value;
        });
      });
    }).toList();
  }

  getRecords() async {
    List<Map<String, dynamic>> dataItems = [];
    Box box;
    List<Map<String, dynamic>> data=[];
    int index = MainController.SubMenuList.indexWhere((element) => element['table-name'] == '${this.tableName}');
    if (index != -1) {
      var tableInfo = MainController.SubMenuList[index];
      box = await Hive.openBox<DataModel>('${tableInfo['table-name']}');
      for (var i in box.values.toList())
      data = getTypeOfField(box.values.toList());
      // if(tableInfo['type']=='multiSelect'){
      //   if(tableInfo['sourceItems']!='custom'&& tableInfo['sourceTable']!=null){
      //
      //   }
      // dataItems.add(value)
      // }
      if (this.parentItem.length != 0) {
        data = data
            .where((element) =>
                element['parent_id'] == this.parentItem['parent_id'])
            .toList();
      }

      if (this.orWhereList.length != 0) {

        if (data.length != 0)
          for (var d in data) {
            if (this.orWhereList.length != 0) {
              for (int j = 1; j <= orWhereList.length; j++) {
                if (d['${orWhereList[j]!.fieldName}'] != null) {
                if (orWhereList[j]!.value != '') {
                    if (orWhereList[j]!.oprator == '==') {
                      if (d['${orWhereList[j]!.fieldName}'] is List<dynamic>) {
                        if (d['${orWhereList[j]!.fieldName}']
                            .contains(orWhereList[j]!.value)) {
                          dataItems.add(d);
                          break;
                        }
                      }
                      if (d['${orWhereList[j]!.fieldName}'] ==
                          orWhereList[j]!.value) {
                        dataItems.add(d);
                      }
                      break;
                    } else if (orWhereList[j]!.oprator == '>=') {
                      if (d['${orWhereList[j]!.fieldName}'] >=
                          orWhereList[j]!.value) {
                        dataItems.add(d);
                      }
                      break;
                    } else if (orWhereList[j]!.oprator == '<=') {
                      if (d['${orWhereList[j]!.fieldName}'] <=
                          orWhereList[j]!.value) {
                        dataItems.add(d);
                      }
                      break;
                    } else if (orWhereList[j]!.oprator == '!=') {
                      if (d['${orWhereList[j]!.fieldName}'] !=
                          orWhereList[j]!.value) {
                        dataItems.add(d);
                      }
                      break;
                    } else if (orWhereList[j]!.oprator == '<') {
                      if (d['${orWhereList[j]!.fieldName}'] <
                          orWhereList[j]!.value) {
                        dataItems.add(d);
                      }
                      break;
                    } else if (orWhereList[j]!.oprator == '>') {
                      if (d['${orWhereList[j]!.fieldName}'] >
                          orWhereList[j]!.value) {
                        dataItems.add(d);
                      }
                      break;
                    } else if (orWhereList[j]!.oprator == null) {
                      dataItems.add(d);

                      break;
                    }
                  } else {
                    dataItems.add(d);
                  }
                }
              }
            } else {
              dataItems.add(d);
            }
          }
      } else {
        if (this.whereList.length != 0) {
          if (data.length != 0)
            for (var d in data) {
              bool flag = true;
              for (int j = 1; j <= whereList.length; j++) {
                if (d['${whereList[j]!.fieldName}'] != null) {
                  if (whereList[j]!.value != '') {
                    if (whereList[j]!.oprator == '==' ||
                        whereList[j]!.oprator == null) {
                      if (d['${whereList[j]!.fieldName}'] is List) {
                        if (d['${whereList[j]!.fieldName}']
                                .contains(whereList[j]!.value) &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                        if (d['${whereList[j]!.fieldName}'] ==
                                whereList[j]!.value &&
                            flag == true) {

                          flag = true;
                        } else
                          flag = false;
                      }
                    } else if (whereList[j]!.oprator == '>=') {
                      if (d['${whereList[j]!.fieldName}'] >=
                              whereList[j]!.value &&
                          flag == true) {
                        flag = true;
                      } else
                        flag = false;
                    } else if (whereList[j]!.oprator == '<=') {
                      if (d['${whereList[j]!.fieldName}'] <=
                              whereList[j]!.value &&
                          flag == true) {
                        flag = true;
                      } else
                        flag = false;
                    } else if (whereList[j]!.oprator == '!=') {
                      if (d['${whereList[j]!.fieldName}'] !=
                              whereList[j]!.value &&
                          flag == true) {
                        flag = true;
                      } else
                        flag = false;
                    } else if (whereList[j]!.oprator == '<') {
                      if (d['${whereList[j]!.fieldName}'] <
                              whereList[j]!.value &&
                          flag == true) {
                        flag = true;
                      } else
                        flag = false;
                    } else if (whereList[j]!.oprator == '>') {
                      if (d['${whereList[j]!.fieldName}'] >
                              whereList[j]!.value &&
                          flag == true) {
                        flag = true;
                      } else
                        flag = false;
                    } else if (whereList[j]!.oprator == 'whereDate ==') {
                      if (HelperController.filterDate(
                                  d['${whereList[j]!.fieldName}'],
                                  whereList[j]!.value,
                                  "==") ==
                              true &&
                          flag == true) {
                        flag = true;
                      } else
                        flag = false;
                    } else if (whereList[j]!.oprator == 'whereDate <=') {
                      if (HelperController.filterDate(
                                  d['${whereList[j]!.fieldName}'],
                                  whereList[j]!.value,
                                  "<=") ==
                              true &&
                          flag == true) {
                        flag = true;
                      } else
                        flag = false;
                    } else if (whereList[j]!.oprator == 'whereDate >=') {
                      if (HelperController.filterDate(
                                  d['${whereList[j]!.fieldName}'],
                                  whereList[j]!.value,
                                  ">=") ==
                              true &&
                          flag == true) {
                        flag = true;
                      } else
                        flag = false;
                    }
                  } else
                    flag = false;
                } else
                  flag = false;
              }
              if (flag == true) {
                dataItems.add(d);
              }
            }
        } else {
          dataItems = data;
        }
      }

      data = dataItems;
      if (this.takeCount != null) {
        data = data.take(this.takeCount!).toList();
      }
      if (this.skipCount != null) {
        data = data.skip(this.skipCount!).toList();
      }
      if (this.randomCount != null) {
        data = getRandomItems(data, this.randomCount!);
      }
      return data;
    }
  }

  parent({String parentTable = "", String parentId = ""}) {
    parentItem = <String, dynamic>{};
    if (parentTable != "" && parentId != "") {
      var json = {'parent_table': parentTable, 'parent_id': parentId};
      parentItem = json;
    } else
      parentItem = <String, dynamic>{};

    return this;
  }

  Future<void> storeRecord(Map<String, dynamic> request) async {
    Box box = await Hive.openBox<DataModel>('${this.tableName}');
    ViewController.isClickedBtn.value = true;
    var Id = Uuid().v4();
    Map<String, dynamic> newRequest = Map.from(request); // ایجاد یک کپی جدید
    if (parentItem != {}) {
      newRequest.addAll(parentItem);
    }

    DataModel newData = DataModel(id: '${Id}', data: newRequest);
    var beforValidate = HelperController.beforeStoreValidation(newData);
    if (beforValidate['status'] == false) {
      showSnackbar(snackTypes.error, beforValidate['message']);
    } else {
      if (await RecordController.validate(this.tableName!, newData,
              ViewCustomController.getDataTable(this.tableName!)) ==
          false) {
        var before = await HelperController.beforeStore(newData);
        if (before['status'] == false) {
          showSnackbar(snackTypes.error, before['message']);
        } else {
          DataModel customData =
              await HelperController.beforeStore(newData)['data'];
          await box.add(customData);
          var afterData = await HelperController.afterStore(
              this.tableName!, newRequest, customData);
          if (afterData['status'] == false) {
            showSnackbar(snackTypes.error, afterData['message']);
          }
          // await MainController.multiSelectStore(this.tableName!, Id);
          await MainController.loadData(
              tableData: ViewCustomController.getDataTable(this.tableName!));
          MainController.renderPagination();
          ViewController.isClickedBtn.value = false;
          request = {};
          newRequest = {};
        }
      } else {
        showSnackbar(snackTypes.error, "خطا");
      }
    }
  }

  updateRecord(Map<String, dynamic> request) async {
    List<dynamic> allData = [];
    List<dynamic> records = await getRecords();

    ViewController.isClickedEditBtn.value = true;
    Box box = await Hive.openBox<DataModel>('${this.tableName}');
    allData = box.values.toList();

    Map<String,dynamic>a={};
    for (var data in records) {
      a=data;
      a.forEach((key, value) {
        if (request.containsKey(key)) {
          a[key] = request[key];
        }
      });

      final record = DataModel(
        id: data['id'],
        data: a,
      );
      var beforeValidate =
          await HelperController.beforeUpdateValidation(record);
      if (beforeValidate['status'] == false) {
        showSnackbar(snackTypes.error, beforeValidate['message']);
      } else {
        var validate = await RecordController.validate(this.tableName!, record,
            ViewCustomController.getDataTable(this.tableName!));
        if (validate == false) {
          var before = await HelperController.beforeUpdate(record);
          if (before['status'] == false) {
            showSnackbar(snackTypes.error, before['messsage']);
          } else {
            var customUpdate =
                await HelperController.beforeUpdate(record)['data'];
            var allDataIndex =
                allData.indexWhere((element) => element.id == data['id']);
            allData[allDataIndex] = customUpdate;
            await box.putAt(allDataIndex, customUpdate);
            MainController.isClickedItem.value = true;
            var after = await HelperController.afterUpdate(
                this.tableName!, customUpdate);
            if (after['status'] == false) {
              showSnackbar(snackTypes.error, after['message']);
            }
            await MainController.loadData(
                tableData: ViewCustomController.getDataTable(this.tableName!));
            MainController.renderPagination();
            ViewController.isClickedEditBtn.value = false;
            // Get.to(() => TablePage());
          }
        } else {
          showSnackbar(snackTypes.error,
              '${AppController.of(Get.context!)!.value('The operation encountered an error.')}');
        }
      }
    }
  }

  deleteRecord() async {
    List<dynamic> records = await getRecords();
    Box box = await Hive.openBox<DataModel>('${this.tableName}');
    var relations = ViewCustomController.getDataTable(this.tableName!);

    for (var data in records) {
      var tableDataIndex =
          box.values.toList().indexWhere((element) => element.id == data['id']);
      DataModel item = box.values.toList()[tableDataIndex];
      var index =
          box.values.toList().indexWhere((element) => element.id == data['id']);
      var before = await HelperController.beforeDelete(index);
      if (before['status'] == false) {
        showSnackbar(snackTypes.error, before['message']);
      } else {
        if (relations['relations'].length != 0) {
          for (var relation in relations['relations']) {
            DB(relation['table-name'])
                .where('parent_id', '==', data['id'])
                .deleteRecord();
          }
        }
        box.deleteAt(index);
        await MainController.loadData();
        MainController.renderPagination();
        var after = HelperController.afterDelete(index, item);
        if (after['status'] == false) {
          showSnackbar(snackTypes.error, after['message']);
        }
      }
    }
  }
}

class Where {
  String? fieldName;
  String? oprator;
  var value;

  Where(String? fieldName, String? oprator, var value) {
    this.value = value;
    this.oprator = oprator;
    this.fieldName = fieldName;
    this;
  }
}
