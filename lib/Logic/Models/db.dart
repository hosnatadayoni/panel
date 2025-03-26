import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:finance/Logic/Controllers/dataController.dart';
import '../../UI/Componenets/Popups/snackbar.dart';
import '../../UI/Views/table-page.dart';
import '../Controllers/helper-controller.dart';
import '../Controllers/main-controller.dart';
import '../Controllers/record-controller.dart';
import '../Controllers/view-controller.dart';
import 'dataModel.dart';
import 'general.dart';

class DB {
  String? tableName;
  Map<int, Where> list = <int, Where>{};
  int counter = 0;
  List<Where> w = [];

  DB(String tableName) {
    this.tableName = tableName;
  }

  getTypeOfField(List<dynamic> data) {
    var type;
    List<Map<String, dynamic>> newData = <Map<String, dynamic>>[];
    for (var d in data) {
      print('d>>>${d.data}');

      Map<String, dynamic> e = <String, dynamic>{};
      for (var key in d.data.keys) {
        type = MainController.getTypeOfField(this.tableName!, key);
        print('d.data[key]>>${d.data[key]}>>>${type}');
        if(type!=null){
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

  getRecords() async {
    List<dynamic> dataItems = [];
    Box box;
    int index = MainController.SubMenuList.indexWhere(
        (element) => element['table-name'] == '${this.tableName}');
    if (index != -1) {
      var tableInfo = MainController.SubMenuList[index];
      box = await Hive.openBox<DataModel>('${tableInfo['table-name']}');
      List<dynamic> data = getTypeOfField(box.values.toList());
      print('data length first>>>${data}');
      if (data.length != 0)
        for (var d in data) {
          if (this.list.length != 0) {
            for (int j = 1; j <= list.length; j++) {
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
              }
            }
          }
        }
      data = dataItems;
      print('data length sec>>>${data}');
      return data;
    }
  }

  storeRecord(Map<String, dynamic> request) async {
    print('store record>>>${request}');
    Box box = await Hive.openBox<DataModel>('${this.tableName}');

    ViewController.isClickedBtn.value = true;
    var Id = Uuid().v4();
    DataModel newData = DataModel(id: '${Id}', data: request);
    var beforValidate = HelperController.beforeStoreValidation(newData);
    if (beforValidate['status'] == false) {
      showSnackbar(snackTypes.error, beforValidate['message']);
    } else {
      print('validate record>>>${await RecordController.validate(this.tableName!, newData)}');

      if (await RecordController.validate(this.tableName!, newData) == false) {
        var before = await HelperController.beforeStore(newData);
        if (before['status'] == false) {
          showSnackbar(snackTypes.error, before['message']);
        } else {
          DataModel customData = await HelperController.beforeStore(newData)['data'];
          print('customData>>>${customData.data}');
          await box.add(customData);
          dataController.allData.add(customData);
          print('allData is length>>>${dataController.allData.length}');
          for(var d in dataController.allData){
            print('allData is >>>${d.id}');
          }
          await MainController.loadData();
          MainController.renderPagination();
          var afterData = await HelperController.afterStore(request, customData);
          if (afterData['status'] == false) {
            showSnackbar(snackTypes.error, afterData['message']);
          }
          ViewController.isClickedBtn.value = false;
          request = {};
          Get.to(() => TablePage());
        }
      }
    }
  }

  updateRecord(Map<String, dynamic> request) async {
    List<dynamic> records = await getRecords();
    print('list is>>>${records.first['id']}');
    ViewController.isClickedEditBtn.value = true;

    Box box = await Hive.openBox<DataModel>('${this.tableName}');

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
       var validate= await RecordController.validate(this.tableName!, record);
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
            MainController.tableData.value[tableDataIndex] = customUpdate;
            await box.putAt(allDataIndex, customUpdate);
            MainController.isClickedItem.value = true;
            var after = await HelperController.afterStore(data, customUpdate);
            if (after['status'] == false) {
              showSnackbar(snackTypes.error, after['message']);
            }
            ViewController.isClickedEditBtn.value = false;
            Get.to(() => TablePage());
          }
        }
        else{
          showSnackbar(snackTypes.error, 'عملیات با خطا مواجه شد.');

        }
      }
    }
  }

  deleteRecord() async {
    List<dynamic> records = await getRecords();
    print('list is>>>${records.first['id']}');
    Box box = await Hive.openBox<DataModel>('${this.tableName}');
    for (var data in records) {
      var tableDataIndex = MainController.tableData.value.indexWhere((element) => element.id == data['id']);
      DataModel item=MainController.tableData.value[tableDataIndex];
      var index=  box.values.toList().indexWhere((element) => element.id == data['id']);
      var before = await HelperController.beforeDelete(index);
      if (before['status'] == false) {
        showSnackbar(snackTypes.error, before['message']);
      } else {
        box.deleteAt(index);
        MainController.tableData.value.removeAt(tableDataIndex);
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
