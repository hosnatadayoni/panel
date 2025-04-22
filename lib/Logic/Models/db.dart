import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:finance/Logic/Controllers/dataController.dart';
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
  Map<int, Where> list = <int, Where>{};
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

  where(String? fieldName, String? oprator, var value) {
    counter++;
    Where l = Where(fieldName, oprator, value);
    w.add(l);
    this.list[counter] = l;
    print('w length>>${w.length}>>>list>>>${this.list}');

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
  random(int count){
    this.randomCount=count;
    return this;
  }

  List getRandomItems(List list, int count) {
    if (count <= 0 || list.isEmpty) return [];
    if (count >= list.length) return List.from(list)..shuffle();
    final shuffled = List.from(list)..shuffle();
    return shuffled.take(count).toList();
  }

  getRecords() async {
    List<dynamic> dataItems = [];
    Box box;
    int index = MainController.SubMenuList.indexWhere(
        (element) => element['table-name'] == '${this.tableName}');
    if (index != -1) {
      var tableInfo = MainController.SubMenuList[index];
      box = await Hive.openBox<DataModel>('${tableInfo['table-name']}');
      List<dynamic> data = getTypeOfField(box.values.toList());
      if (this.parentItem.length != 0) {
        data = data
            .where((element) =>
                element['parent_id'] == this.parentItem['parent_id'])
            .toList();
      }
      if (data.length != 0)
        for (var d in data) {
          if (this.list.length != 0) {
            for (int j = 1; j <= list.length; j++) {
              if (d['${list[j]!.fieldName}'] != null){
                if (list[j]!.oprator == '==') {
                  if (d['${list[j]!.fieldName}'] == list[j]!.value) {
                    dataItems.add(d);
                    print('dataItems 1 >>>${dataItems}');
                  }
                  break;
                } else if (list[j]!.oprator == '>=') {
                  if (d['${list[j]!.fieldName}'] >= list[j]!.value) {
                    dataItems.add(d);
                    print('dataItems 3 >>>${dataItems}');
                  }
                  break;
                } else if (list[j]!.oprator == '<=') {
                  if (d['${list[j]!.fieldName}'] <= list[j]!.value) {
                    dataItems.add(d);
                    print('dataItems 4 >>>${dataItems}');
                  }
                  break;
                } else if (list[j]!.oprator == '!=') {
                  if (d['${list[j]!.fieldName}'] != list[j]!.value) {
                    dataItems.add(d);
                    print('dataItems 5 >>>${dataItems}');
                  }
                  break;
                } else if (list[j]!.oprator == '<') {
                  if (d['${list[j]!.fieldName}'] < list[j]!.value) {
                    dataItems.add(d);
                    print('dataItems 5 >>>${dataItems}');
                  }
                  break;
                } else if (list[j]!.oprator == '>') {
                  if (d['${list[j]!.fieldName}'] > list[j]!.value) {
                    dataItems.add(d);
                    print('dataItems 5 >>>${dataItems}');
                  }
                  break;
                } else if (list[j]!.oprator == null) {
                  dataItems.add(d);
                  print('dataItems 6 >>>${dataItems}');

                  break;
                }
            }}}
          else {
            dataItems.add(d);
            print('dataItems 6 >>>${dataItems}');
          }
        }
      data = dataItems;
      if (this.takeCount != null) {
        data = data.take(this.takeCount!).toList();
      }
      if (this.skipCount != null) {
        data = data.skip(this.skipCount!).toList();
      }
      if(this.randomCount!=null){
        data=getRandomItems(data, this.randomCount!);
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
    print('DB.storeRecord>>${newRequest}');
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
          dataController.allData.add(customData);
          var afterData = await HelperController.afterStore(
              this.tableName!, newRequest, customData);
          if (afterData['status'] == false) {
            showSnackbar(snackTypes.error, afterData['message']);
          }
          print('DB.storeRecord2>>${(this.tableName!)}');
          print('DB.storeRecord3>>${ViewCustomController.getDataTable(this.tableName!)}');
          MainController.multiSelectStore(this.tableName!,Id);
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
    dataController.allData.value = [];
    List<dynamic> records = await getRecords();
    print('list is>>>${records.first['id']}');
    ViewController.isClickedEditBtn.value = true;
    Box box = await Hive.openBox<DataModel>('${this.tableName}');
    print('box Data>>>${box.values.toList()}');
    dataController.allData.value = box.values.toList();
    for (DataModel da in dataController.allData.value)
      print('all Data>>>${da.data}');
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

            var allDataIndex = dataController.allData.value
                .indexWhere((element) => element.id == data['id']);

            var tableDataIndex = MainController.tableData.value
                .indexWhere((element) => element.id == data['id']);

            print('allDataIndex>>>${allDataIndex}');
            dataController.allData.value[allDataIndex] = customUpdate;
            // MainController.tableData.value[tableDataIndex] = customUpdate;
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
    // print('list is>>>${records.first['id']}');
    Box box = await Hive.openBox<DataModel>('${this.tableName}');
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
        box.deleteAt(index);
        // MainController.tableData.value.removeAt(tableDataIndex);
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
