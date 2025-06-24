import 'dart:convert';
import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../UI/Componenets/Popups/snackbar.dart';
import '../Controllers/connect-server-controller.dart';
import '../Controllers/helper-controller.dart';
import '../Controllers/main-controller.dart';
import '../Controllers/record-controller.dart';
import '../Controllers/view-controller.dart';
import '../Controllers/view-custom-controller.dart';
import 'dataModel.dart';
import 'general.dart';
import 'package:get/get.dart';

class DB {
  String? tableName;
  Map<int, Where> whereList = <int, Where>{};
  Map<int, Where> orWhereList = <int, Where>{};
  int? takeCount;
  int? skipCount;
  int? randomCount;
  static Map<String, dynamic> parentItem = <String, dynamic>{};
  int counter = 0;
  List<Where> w = [];

  DB(String tableName) {
    this.tableName = tableName;
  }

  getTypeOfField (List<dynamic> data) async {
    var type;
    List<Map<String, dynamic>> newData = <Map<String, dynamic>>[];
    for (var d in data) {
      Map<String, dynamic> e = <String, dynamic>{};
      for (var key in d.data.keys) {
        type = MainController.getTypeOfField(this.tableName!, key);
        if (type != null) {
          e['_id'] = d.id;
          e[key] =d.data[key]==null?'':await General(this.tableName!).withFormat(type, d.data[key],key);
        }
      }
      newData.add(e);
    }
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

  List<Map<String, dynamic>> searchList (List<Map<String, dynamic>> mainList, Map<int, Where> searchPattern)
  {
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

  Future<List<Map<String, dynamic>>> filterInBackground(List<dynamic> mainList, List<dynamic> searchPattern)
  async {
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

  pageInate() async {
    MainController.endIndex.value=0;
    MainController.startIndex.value=0;

    int  countShowRow=await MainController.getInfoTable('${this.tableName}')['countShowRow'];
    int  currentPage=await MainController.getInfoTable('${this.tableName}')['currentPage'];
    int  perPage=countShowRow!=null?countShowRow:10;
    int s=(currentPage-1)*perPage;
    var getRecord=await getRecords();
    var totalItems=getRecord.length;
    var end = s+perPage;
    MainController.startIndex.value = s;
    var endBycondition=end >= totalItems ? totalItems:end;
    MainController.endIndex.value =endBycondition;
    var data=(await skip(s).getRecords()).take(perPage).toList();
    return data;
  }

  infoPage() async {
    int  countShowRow=await MainController.getInfoTable('${this.tableName}')['countShowRow'];
    int  perPage=countShowRow!=null?countShowRow:10;
    List<Map<String,dynamic>> items=await getRecords();
    int totalItems=items.length;
    int totalPage=(totalItems/perPage).ceil();
    MainController.totalItems.value = totalItems;
    return totalPage;
  }

  getBoxRecords() async {
    Box box;
    List<Map<String, dynamic>> data=[];
    int index = MainController.SubMenuList.indexWhere((element) => element['table-name'] == '${this.tableName}');
    if(MainController.SubMenuList[index]['online']==true){
      await ConncetServerController.getRecordGeneral('${tableName}');
      if(ConncetServerController.getRecordRes.isNotEmpty){
        data= ConncetServerController.getRecordRes.cast<Map<String, dynamic>>();
      }
    }
    else{
      var tableInfo = MainController.SubMenuList[index];

      box = await Hive.openBox<DataModel>('${tableInfo['table-name']}');

      List<Map<String, dynamic>> newData = <Map<String, dynamic>>[];

      for (var d in box.values.toList()) {
        Map<String, dynamic> e = <String, dynamic>{};
        for (var key in d.data.keys) {
          e['_id'] = d.id;
          e[key] = d.data[key];
        }
        newData.add(e);
      }
      data=newData;
    }
    return data;
  }

  getRecords({bool withFormat = true}) async {
    List<Map<String, dynamic>> dataItems = [];
    Box box;
    List<Map<String, dynamic>> data=[];
    int index = MainController.SubMenuList.indexWhere((element) => element['table-name'] == '${this.tableName}');
    if(MainController.SubMenuList[index]['online']==true){
    await ConncetServerController.getRecordGeneral('${tableName}');
    if(ConncetServerController.getRecordRes.isNotEmpty){
      data= ConncetServerController.getRecordRes.cast<Map<String, dynamic>>();
    }
    }
    else{
        var tableInfo = MainController.SubMenuList[index];
        box = await Hive.openBox<DataModel>('${tableInfo['table-name']}');
        data =await getTypeOfField(box.values.toList());
    }
    if (index != -1) {
      if (parentItem.length != 0) {
        data = data.where((element) => element['parent_id'] == parentItem['parent_id']).toList();
      }
      if (this.orWhereList.length != 0) {

        if (data.length != 0){
          if(MainController.SubMenuList[index]['online']==true){
          await ConncetServerController.filterRecordGeneral(this.orWhereList,this.tableName!,'\$or');
          if(ConncetServerController.filterRecordRes.isNotEmpty){
            dataItems=ConncetServerController.filterRecordRes;
          }}
          else{
            for (var d in data) {
              bool flag = true;
              for (int j = 1; j <= orWhereList.length; j++) {
                if (d['${orWhereList[j]!.fieldName}'] != null) {
                  if (orWhereList[j]!.value != '') {
                    if (orWhereList[j]!.oprator == '\$eq' ||
                        orWhereList[j]!.oprator == null) {
                      if (d['${orWhereList[j]!.fieldName}'] is List) {
                        if (d['${orWhereList[j]!.fieldName}'].contains(
                            orWhereList[j]!.value) && flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                        if (MainController.getTypeOfField(
                            this.tableName!, orWhereList[j]!.fieldName!) ==
                            'Date') {
                          if (HelperController.filterDate(
                              d['${orWhereList[j]!.fieldName}'],
                              orWhereList[j]!.value, "==") == true &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        } else if (MainController.getTypeOfField(
                            this.tableName!, orWhereList[j]!.fieldName!) ==
                            'time') {
                          if (HelperController.filterTime(
                              d['${orWhereList[j]!.fieldName}'],
                              orWhereList[j]!.value, "==") == true &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        }
                        else {
                          if (d['${orWhereList[j]!.fieldName}'] ==
                              orWhereList[j]!.value && flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        }
                      }
                    } else if (orWhereList[j]!.oprator == '\$gte') {
                      if (MainController.getTypeOfField(
                          this.tableName!, orWhereList[j]!.fieldName!) ==
                          'Date') {
                        if (HelperController.filterDate(
                            d['${orWhereList[j]!.fieldName}'],
                            orWhereList[j]!.value, ">=") == true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else if (MainController.getTypeOfField(
                          this.tableName!, orWhereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${orWhereList[j]!.fieldName}'],
                            orWhereList[j]!.value, ">=") == true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                        if (d['${orWhereList[j]!.fieldName}'] >=
                            orWhereList[j]!.value && flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                    } else if (orWhereList[j]!.oprator == '\$lte') {
                      if (MainController.getTypeOfField(
                          this.tableName!, orWhereList[j]!.fieldName!) ==
                          'Date') {
                        if (HelperController.filterDate(
                            d['${orWhereList[j]!.fieldName}'],
                            orWhereList[j]!.value, "<=") == true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                      else if (MainController.getTypeOfField(
                          this.tableName!, orWhereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${orWhereList[j]!.fieldName}'],
                            orWhereList[j]!.value, "<=") == true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                      else {
                        if (d['${orWhereList[j]!.fieldName}'] <=
                            orWhereList[j]!.value && flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                    } else if (orWhereList[j]!.oprator == '\$nq') {
                      if (MainController.getTypeOfField(
                          this.tableName!, orWhereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${orWhereList[j]!.fieldName}'],
                            orWhereList[j]!.value, "!=") == true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                        if (d['${orWhereList[j]!.fieldName}'] !=
                            orWhereList[j]!.value && flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                    } else if (orWhereList[j]!.oprator == '\$lt') {
                      if (MainController.getTypeOfField(
                          this.tableName!, orWhereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${orWhereList[j]!.fieldName}'],
                            orWhereList[j]!.value, "<") == true && flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                        if (d['${orWhereList[j]!.fieldName}'] <
                            orWhereList[j]!.value &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                    } else if (orWhereList[j]!.oprator == '\$gt') {
                      if (MainController.getTypeOfField(
                          this.tableName!, orWhereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${orWhereList[j]!.fieldName}'],
                            orWhereList[j]!.value, ">") == true && flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                        if (d['${orWhereList[j]!.fieldName}'] >
                            orWhereList[j]!.value && flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
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
          }}
      }
      else {
        if (this.whereList.length != 0) {
          if (data.length != 0){
            if(MainController.SubMenuList[index]['online']==true){
            await ConncetServerController.filterRecordGeneral(this.whereList,this.tableName!,'\$and');
            if(ConncetServerController.filterRecordRes.isNotEmpty){
              dataItems=ConncetServerController.filterRecordRes;
            }}
            else{
            for (var d in data) {
              bool flag = true;
              for (int j = 1; j <= whereList.length; j++) {
                if(whereList[j]!.fieldName!='_id')
                  whereList[j]!.value=await General(this.tableName!).withFormat(MainController.getTypeOfField(this.tableName!, whereList[j]!.fieldName!),whereList[j]!.value,whereList[j]!.fieldName!);
                if (d['${whereList[j]!.fieldName}'] != null) {
                  if (whereList[j]!.value != '') {
                    if (whereList[j]!.oprator == '\$eq' || whereList[j]!.oprator == null) {
                        if (d['${whereList[j]!.fieldName}'] is List) {
                        if (d['${whereList[j]!.fieldName}'].contains(
                            whereList[j]!.value) && flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                        else {
                        if (MainController.getTypeOfField(
                            this.tableName!, whereList[j]!.fieldName!) == 'Date') {
                          if (HelperController.filterDate(
                              d['${whereList[j]!.fieldName}'],
                              whereList[j]!.value, "==") == true &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        } else if (MainController.getTypeOfField(
                            this.tableName!, whereList[j]!.fieldName!) ==
                            'time') {
                          if (HelperController.filterTime(
                              d['${whereList[j]!.fieldName}'],
                              whereList[j]!.value, "==") == true &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        }
                        else {

                            if (d['${whereList[j]!.fieldName}'] ==
                              whereList[j]!.value && flag == true) {
                            flag = true;

                            } else
                            flag = false;
                        }
                      }
                    } else if (whereList[j]!.oprator == '\$gte') {
                      if (MainController.getTypeOfField(
                          this.tableName!, whereList[j]!.fieldName!) ==
                          'Date') {
                        if (HelperController.filterDate(
                            d['${whereList[j]!.fieldName}'],
                            whereList[j]!.value, ">=") == true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else if (MainController.getTypeOfField(
                          this.tableName!, whereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${whereList[j]!.fieldName}'],
                            whereList[j]!.value, ">=") == true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                          if (d['${whereList[j]!.fieldName}'] >=
                            whereList[j]!.value && flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                    } else if (whereList[j]!.oprator == '\$lte') {
                      if (MainController.getTypeOfField(
                          this.tableName!, whereList[j]!.fieldName!) ==
                          'Date') {
                        if (HelperController.filterDate(
                            d['${whereList[j]!.fieldName}'],
                            whereList[j]!.value, "<=") == true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                      else if (MainController.getTypeOfField(
                          this.tableName!, whereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${whereList[j]!.fieldName}'],
                            whereList[j]!.value, "<=") == true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                      else {
                        if (d['${whereList[j]!.fieldName}'] <=
                            whereList[j]!.value && flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                    } else if (whereList[j]!.oprator == '\$nq') {
                      if (MainController.getTypeOfField(
                          this.tableName!, whereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${whereList[j]!.fieldName}'],
                            whereList[j]!.value, "!=") == true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                        if (d['${whereList[j]!.fieldName}'] !=
                            whereList[j]!.value && flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                    } else if (whereList[j]!.oprator == '\$lt') {
                      if (MainController.getTypeOfField(
                          this.tableName!, whereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${whereList[j]!.fieldName}'],
                            whereList[j]!.value, "<") == true && flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                        if (d['${whereList[j]!.fieldName}'] <
                            whereList[j]!.value &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                    } else if (whereList[j]!.oprator == '\$gt') {
                      if (MainController.getTypeOfField(
                          this.tableName!, whereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${whereList[j]!.fieldName}'],
                            whereList[j]!.value, ">") == true && flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                        if (d['${whereList[j]!.fieldName}'] >
                            whereList[j]!.value && flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
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
        }
          }
        }
        else {
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

  Future<void> storeRecord (Map<dynamic, dynamic> request) async {
    Box box = await Hive.openBox<DataModel>('${this.tableName}');
    ViewController.isClickedBtn.value = true;
    var Id = Uuid().v4();
    Map<String, dynamic> newRequest = Map.from(request); // ایجاد یک کپی جدید
    List<dynamic>columns=MainController.getColumnsList('${this.tableName}');
    for(var column in columns){
      if(!newRequest.keys.contains(column)){
        newRequest.addAll({
          '${column}':null
        });
      }
    }
    if (parentItem != {}) {
      newRequest.addAll(parentItem);
    }
    newRequest.addAll({
      "sync":"false",
      "server error":"Dont sync this record!",
    });

    DataModel newData = DataModel(id: '${Id}', data: newRequest);
    var beforValidate = HelperController.beforeStoreValidation(newData);
    if (beforValidate['status'] == false) {
      showSnackbar(snackTypes.error, beforValidate['message']);
    } else {
      if (await RecordController.validate(this.tableName!, newData,
          ViewCustomController.getDataTable(this.tableName!)) == false) {

        var before = await HelperController.beforeStore(newData);
        if (before['status'] == false) {
          showSnackbar(snackTypes.error, before['message']);
        }
        else {
          DataModel customData = await HelperController.beforeStore(newData)['data'];
          Map<String,dynamic>setRecord={
            "table_name":'${this.tableName}',
            "record":json.encode(customData.data).toString(),
          };
          if(MainController.getStatusTable(this.tableName!)==true){
            await ConncetServerController.storeRecordGeneral(setRecord);
            if(ConncetServerController.storeRecordRes.isNotEmpty){
              DataModel recordStored=DataModel(id: '${ConncetServerController.storeRecordRes['_id']}', data: ConncetServerController.storeRecordRes);
              await box.add(recordStored);
            }
          }
          else {
            await box.add(customData);
          }
          var afterData = await HelperController.afterStore(this.tableName!, newRequest, customData);
          if (afterData['status'] == false) {
            showSnackbar(snackTypes.error, afterData['message']);
          }
          // await MainController.multiSelectStore(this.tableName!, Id);
          await MainController.loadData(tableData: ViewCustomController.getDataTable(this.tableName!));
          ViewController.isClickedBtn.value = false;
          request = {};
          newRequest = {};
        }
      } else {
        showSnackbar(snackTypes.error, "خطا");
      }
    }
  }

  updateRecord (Map<String, dynamic> request) async {
    List<dynamic> allData = [];
    List<dynamic> records = await getRecords();
    ViewController.isClickedEditBtn.value = true;
    Box box = await Hive.openBox<DataModel>('${this.tableName}');
      allData = box.values.toList();

    // request.forEach((key, value) {
    //   if(value is List) {
    //     var sourceItem = MainController.getDetailsOfField(
    //         '${this.tableName}', key)['sourceItems'];
    //     if (sourceItem == 'custom') {
    //       List<String> idList = [];
    //       for (int i = 0; i < value.length; i++) {
    //         idList.add(value[i]['value']);
    //       }
    //       request[key] = idList;
    //     }
    //     else {
    //       List<String> idList = [];
    //       for (int i = 0; i < value.length; i++) {
    //         idList.add(value[i]['_id']);
    //       }
    //       request[key] = idList;
    //     }
    //   }
    //   if(value is Map){
    //     var sourceItem=MainController.getDetailsOfField('${this.tableName}', key)['sourceItems'];
    //     if(sourceItem=='custom'){
    //
    //       request[key]=value['value'];
    //     }else {
    //       request[key] = value['_id'];
    //     }
    //   }
    // });
    print('DB.updateRecord>>records>>>>>>${request}');

    Map<String,dynamic>a={};

    List<Map<String, dynamic>> toAdd = [];

    for (var data in records) {

      a = data;

      a.forEach((key, value) {
        if(value is List) {
          var sourceItem = MainController.getDetailsOfField(
              '${this.tableName}', key)['sourceItems'];
          if (sourceItem == 'custom') {
            List<String> idList = [];
            for (int i = 0; i < value.length; i++) {
              print('DB.updateRecord>>${value[i]}');
              idList.add(value[i]['value']);
            }
            a[key] = idList;
          }
          else {
            List<String> idList = [];
            for (int i = 0; i < value.length; i++) {
              print('DB.updateRecord>>${value[i]}');
              idList.add(value[i]['_id']);
            }
            a[key] = idList;
          }
        }
        if(value is Map){
          var sourceItem=MainController.getDetailsOfField('${this.tableName}', key)['sourceItems'];
          if(sourceItem=='custom'){

            a[key]=value['value'];
          }else {
            a[key] = value['_id'];
            print('DB.updateRecord select >>>${a[key]}');
          }
        }
        if (request.containsKey(key)) {
          a[key] = request[key];
          print('DB.updateRecord items>>${key}>>>${a[key]}');
        } else {
          //must be check key exist in records if not add.
          toAdd.add({request.keys.first: request.values.first});
        }
      });
    }

    final record = DataModel(id: a['_id'], data: a);

    var beforeValidate = await HelperController.beforeUpdateValidation(record);
    if (beforeValidate['status'] == false) {
        showSnackbar(snackTypes.error, beforeValidate['message']);
      } else {
        var validate = await RecordController.validate(this.tableName!, record, ViewCustomController.getDataTable(this.tableName!));
        if (validate == false) {
          var before = await HelperController.beforeUpdate(record);
          if (before['status'] == false) {
            showSnackbar(snackTypes.error, before['messsage']);
          } else {
            var customUpdate = await HelperController.beforeUpdate(record)['data'];
            var allDataIndex = allData.indexWhere((element) => element.id == a['_id']);
            allData[allDataIndex] = customUpdate;
            if(MainController.getStatusTable(this.tableName!)==true) {
              await ConncetServerController.setDatabaseme(customUpdate.data);
              Map<String, dynamic> setRecord = {
                "table_name": '${this.tableName}',
                "record": json.encode(customUpdate.data).toString(),
                "record_id": customUpdate.id
              };
              if (MainController.getStatusTable(this.tableName!) == true) {
                await ConncetServerController.updateRecordGeneral(setRecord);
                if (ConncetServerController.updateRecordRes.isNotEmpty) {
                  DataModel record = DataModel(
                      id: ConncetServerController.updateRecordRes['_id'],
                      data: ConncetServerController.updateRecordRes);
                  await box.putAt(allDataIndex, record);
                }
              }
            }
            else {
            await box.putAt(allDataIndex, customUpdate);
          }

          MainController.isClickedItem.value = true;
            var after = await HelperController.afterUpdate(
                this.tableName!, customUpdate);
            if (after['status'] == false) {
              showSnackbar(snackTypes.error, after['message']);
            }
            await MainController.loadData(
                tableData: ViewCustomController.getDataTable(this.tableName!));
            ViewController.isClickedEditBtn.value = false;
          }
        } else {
          showSnackbar(snackTypes.error,'${AppController.of(Get.context!)!.value('The operation encountered an error.')}');
        }
      }
  }

  deleteRecord () async {
    List<dynamic> records = await getRecords();
    Box box = await Hive.openBox<DataModel>('${this.tableName}');
    var relations = ViewCustomController.getDataTable(this.tableName!);
    for (var data in records) {
      var tableDataIndex = box.values.toList().indexWhere((element) => element.id == data['_id']);
      if(tableDataIndex!=-1){
        DataModel item = box.values.toList()[tableDataIndex];
        var before = await HelperController.beforeDelete(tableDataIndex);
        if (before['status'] == false) {
          showSnackbar(snackTypes.error, before['message']);
        } else {
          if (relations['relations'].length != 0) {
            for (var relation in relations['relations']) {
              DB(relation['table-name']).where('parent_id', '\$eq', data['_id']).deleteRecord();
            }
          }
          if(MainController.getStatusTable(this.tableName!)==true){
            if(MainController.getStatusTable(this.tableName!) == true) {
              await ConncetServerController.deleteRecordGeneral({
                "table_name": '${this.tableName}',
                'record_id': data['_id']
              });
              if (ConncetServerController.deleteRecordRes == true) {
                box.deleteAt(tableDataIndex);
                await MainController.loadData();
              }
            }
          }else{
            box.deleteAt(tableDataIndex);
          }

          await MainController.loadData();
          var after = HelperController.afterDelete(tableDataIndex, item);
          if (after['status'] == false) {
            showSnackbar(snackTypes.error, after['message']);
          }
        }
      }

    }
  }

}

class Where {
  String? fieldName;
  String? oprator;
  var value;

  Where (String? fieldName, String? oprator, var value) {
    this.value = value;
    this.oprator = oprator;
    this.fieldName = fieldName;
    this;
  }
}
