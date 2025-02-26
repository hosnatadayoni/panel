import 'package:finance/Logic/Models/general.dart';
import 'package:hive/hive.dart';

import '../Controllers/main-controller.dart';
import 'dataModel.dart';

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
      Map<String, dynamic> e = <String, dynamic>{};
      for (var key in d.data.keys) {
        type = MainController.getTypeOfField(this.tableName!, key);
        e[key] = General.withFormat(type, d.data[key]);
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
      print('data length first>>>${data.length}');
      if (data.length != 0)
        for (var d in data) {
          print('for 1');
          if (this.list.length != 0) {
            print('for 2');
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

              }
            }
          }
        }
      data = dataItems;
      print('data length sec>>>${data}');
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
