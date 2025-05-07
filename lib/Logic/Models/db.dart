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
      print('data that is>>>${d.data}');

      Map<String, dynamic> e = <String, dynamic>{};
      for (var key in d.data.keys) {
        type = MainController.getTypeOfField(this.tableName!, key);
        print('d.data[key]>>${d.data[key]}>>>${type}');
        if (type != null) {
          e['id'] = d.id;
          e[key] = General.withFormat(type, d.data[key]);
        }
      }
      newData.add(e);
      print('new>>>${newData}');
    }
    return newData;
  }

  getTypeOfFieldJson(Map<String, dynamic> d) {
    var type;
    Map<String, dynamic> newData = <String, dynamic>{};

      print('data that is>>>${d}');

      Map<String, dynamic> e = <String, dynamic>{};
      for (var key in d.keys) {
        type = MainController.getTypeOfField(this.tableName!, key);
        print('d.data[key]>>${d[key]}>>>${type}');
        if (type != null) {
          e['id'] = d['id'];
          e[key] = General.withFormat(type, d[key]);
        }
      }
      newData=(e);
      print('new>>>${newData}');

    return newData;
  }

  where(String? fieldName, String? oprator, var value) {
    counter++;
    Where l = Where(fieldName, oprator, value);
    w.add(l);
    this.whereList[counter] = l;
    print('w length>>${counter}>>>>>${w.length}>>>list>>>${this.whereList[counter]!.value}');

    return this;
  }
  
  orWhere(String? fieldName, String? oprator, var value) {
    counter++;
    Where l = Where(fieldName, oprator, value);
    w.add(l);
    this.orWhereList[counter] = l;
    print('w length>>${counter}>>>>>${w.length}>>>list>>>${this.orWhereList}');

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
    print('DB.searchList mainList>>${mainList}');
    // print('DB.searchList searchPattern>>${searchPattern}');
    return mainList.where((item) {
      // بررسی می‌کنیم که آیا تمام کلید-مقدارهای الگو در آیتم وجود دارد
      return searchPattern.entries.every((entry) {
        final key = entry.value.fieldName;
        final value = entry.value.value;
        print('DB.searchList searchPattern>>${key}>>>${value}>>item.key>>>${item[key]}');
        // if(item[key])
        return item.containsKey(key) &&( item[key] is List?item[key].contains(value): item[key] == value) ;
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
    List<Map<String,dynamic>> dataItems = [];
    Box box;
    int index = MainController.SubMenuList.indexWhere(
        (element) => element['table-name'] == '${this.tableName}');
    if (index != -1) {
      var tableInfo = MainController.SubMenuList[index];
      box = await Hive.openBox<DataModel>('${tableInfo['table-name']}');
      for(var i in box.values.toList())
      print('data box is>>${this.tableName}>>>${i.data}');
      List<Map<String,dynamic>> data = getTypeOfField(box.values.toList());
      print('data get record<>>>>${tableInfo['table-name']}>>${tableInfo}');
      print('this.list.length>>>>${this.orWhereList}');
      // if(tableInfo['type']=='multiSelect'){
      //   if(tableInfo['sourceItems']!='custom'&& tableInfo['sourceTable']!=null){
      //
      //   }
        // dataItems.add(value)
      // }
      if (this.parentItem.length != 0) {
        data = data.where((element) => element['parent_id'] == this.parentItem['parent_id']).toList();
      }

      if (this.orWhereList.length != 0){
        if (data.length != 0)
          for (var d in data) {
            if (this.orWhereList.length != 0) {
              for (int j = 1; j <= orWhereList.length; j++) {
                print('this.list is>>>${orWhereList[j]!.value}>>>${d['${orWhereList[j]!.fieldName}']}');
                if (d['${orWhereList[j]!.fieldName}'] != null) {
                  print('list my is>>>${d['${orWhereList[j]!.fieldName}'].runtimeType}>>>${orWhereList[j]!.value.runtimeType}>>>>>${orWhereList[j]!.value}>>>>${orWhereList[j]!.value!=null}>>>${orWhereList[j]!.value!=''}');
                  if( orWhereList[j]!.value!=''){
                    if (orWhereList[j]!.oprator == '==') {
                      if(d['${orWhereList[j]!.fieldName}'] is List<dynamic>){
                        if(d['${orWhereList[j]!.fieldName}'].contains(orWhereList[j]!.value)){
                          print('contains');
                          dataItems.add(d);
                          break;
                        }
                      }
                      if (d['${orWhereList[j]!.fieldName}'] == orWhereList[j]!.value) {
                        dataItems.add(d);
                        print('dataItems 1 >>>${dataItems}');
                      }
                      break;
                    } else if (orWhereList[j]!.oprator == '>=') {
                      if (d['${orWhereList[j]!.fieldName}'] >= orWhereList[j]!.value) {
                        dataItems.add(d);
                        print('dataItems 3 >>>${dataItems}');
                      }
                      break;
                    } else if (orWhereList[j]!.oprator == '<=') {
                      if (d['${orWhereList[j]!.fieldName}'] <= orWhereList[j]!.value) {
                        dataItems.add(d);
                        print('dataItems 4 >>>${dataItems}');
                      }
                      break;
                    } else if (orWhereList[j]!.oprator == '!=') {
                      if (d['${orWhereList[j]!.fieldName}'] != orWhereList[j]!.value) {
                        dataItems.add(d);
                        print('dataItems 5 >>>${dataItems}');
                      }
                      break;
                    } else if (orWhereList[j]!.oprator == '<') {
                      if (d['${orWhereList[j]!.fieldName}'] < orWhereList[j]!.value) {
                        dataItems.add(d);
                        print('dataItems 5 >>>${dataItems}');
                      }
                      break;
                    } else if (orWhereList[j]!.oprator == '>') {
                      if (d['${orWhereList[j]!.fieldName}'] > orWhereList[j]!.value) {
                        dataItems.add(d);
                        print('dataItems 5 >>>${dataItems}');
                      }
                      break;
                    }
                    else if (orWhereList[j]!.oprator == null) {
                      dataItems.add(d);
                      print('dataItems 6 >>>${dataItems}');

                      break;
                    }
                  }
                  else{
                    dataItems.add(d);
                    print('dataItems 01 >>>${dataItems}');
                  }
                }
              }
            }
            else {
              dataItems.add(d);
              print('dataItems 6 >>>${dataItems}');
            }
          }
      }
      else{
     if(this.whereList.length != 0) {
      bool check=true;
      List<dynamic>dataNew=[];
      dataItems=searchList(data,this.whereList);
      print('dataItems searchList>>>${dataItems}');

    }
     else{
       dataItems=data;
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
      print('data length sec>>>${data}');
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

    print('DB.parent>>>${parentItem}');
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
      if (await RecordController.validate(this.tableName!, newData, ViewCustomController.getDataTable(this.tableName!)) ==
          false) {
        var before = await HelperController.beforeStore(newData);
        if (before['status'] == false) {
          showSnackbar(snackTypes.error, before['message']);
        } else {
          DataModel customData = await HelperController.beforeStore(newData)['data'];
          await box.add(customData);
          var afterData = await HelperController.afterStore(this.tableName!, newRequest, customData);
          if (afterData['status'] == false) {
            showSnackbar(snackTypes.error, afterData['message']);
          }
          // await MainController.multiSelectStore(this.tableName!, Id);
          await MainController.loadData(tableData: ViewCustomController.getDataTable(this.tableName!));
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
    print('list is>>>${records.first['id']}');
    ViewController.isClickedEditBtn.value = true;
    Box box = await Hive.openBox<DataModel>('${this.tableName}');
    print('box Data>>>${box.values.toList()}');
    allData = box.values.toList();
    // for (DataModel da in dataController.allData.value)
    //   print('all Data>>>${da.data}');
    for (var data in records) {
      data.forEach((key, value) {
        if (!request.containsKey(key)) {
          request[key] = value;
        }
      });
      final record = DataModel(
        id: data['id'],
        data: request,
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
            print('allDataIndex>>>${allDataIndex}');
            allData[allDataIndex] = customUpdate;
            await box.putAt(allDataIndex, customUpdate);
            MainController.isClickedItem.value = true;
            var after = await HelperController.afterUpdate(
                this.tableName!, customUpdate);
            if (after['status'] == false) {
              showSnackbar(snackTypes.error, after['message']);
            }

            ViewController.isClickedEditBtn.value = false;
            // print('dataController.allData.value[allDataIndex]>>>${dataController.allData.value[allDataIndex].data}');

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
    print('DB.deleteRecord>>>${relations['relations']}');

    for (var data in records) {
      var tableDataIndex = box.values.toList().indexWhere((element) => element.id == data['id']);
      DataModel item = box.values.toList()[tableDataIndex];
      var index =
          box.values.toList().indexWhere((element) => element.id == data['id']);
      var before = await HelperController.beforeDelete(index);
      if (before['status'] == false) {
        showSnackbar(snackTypes.error, before['message']);
      } else {
        if(relations['relations'].length!=0){
          for(var relation in relations['relations']){
            DB(relation['table-name']).where('parent_id', '==', data['id']).deleteRecord();
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
