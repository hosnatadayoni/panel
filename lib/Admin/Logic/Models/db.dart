import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:math';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/connection-controller.dart';
import 'package:finance/Admin/Logic/Controllers/validator-controller.dart';
import 'package:finance/Admin/Logic/Models/tableModel.dart';
import 'package:finance/Admin/Logic/Models/paginate.dart';
import 'package:finance/Admin/Public/enums.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../UI/Componenets/Popups/snackbar.dart';
import '../Controllers/connect-server-controller.dart';
import '../Controllers/helper-controller.dart';
import '../Controllers/main-controller.dart';
import '../Controllers/record-controller.dart';
import '../Controllers/view-controller.dart';
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
  static Map<String, Map<String, dynamic>> parentItem =
  <String, Map<String, dynamic>>{};
  int counter = 0;
  List<Where> w = [];

  // static RxMap<String,PageInfo> pageInfo = {'':PageInfo(totalPage: 1,totalRecords: 0,end: 0,start: 0)}.obs;

  DB(String tableName) {
    this.tableName = tableName;
  }

  getDataTypeOfFieldList(List<dynamic> data) async {
    var type;
    List<Map<String, dynamic>> newData = <Map<String, dynamic>>[];
    for (var d in data) {
      Map<String, dynamic> e = <String, dynamic>{};
      for (var key in d.data.keys) {
        type = MainController.getTypeOfField(this.tableName!, key);
        if (type != null) {
          e['_id'] = d.id;
          e[key] = d.data[key] == null
              ? ''
              : await General(this.tableName!)
              .withFormat(type, d.data[key], key);
        }
      }
      newData.add(e);
    }
    return newData;
  }

  getDataTypeOfFieldItem(DataModel data) async {
    var type;
    List<Map<String, dynamic>> newData = <Map<String, dynamic>>[];

    Map<String, dynamic> e = <String, dynamic>{};
    for (var key in data.data.keys) {
      type = MainController.getTypeOfField(this.tableName!, key);
      if (type != null) {
        e['_id'] = data.id;
        e[key] = data.data[key] == null
            ? ''
            : await General(this.tableName!)
            .withFormat(type, data.data[key], key);
      }
    }

    return e;
  }

  where(String? fieldName, String? operator, var value) {
    counter++;
    Where l = Where(fieldName, operator, value);
    w.add(l);
    this.whereList[counter] = l;
    return this;
  }

  orWhere(String? fieldName, String? operator, var value) {
    counter++;
    Where l = Where(fieldName, operator, value);
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

  Future<List<Map<String, dynamic>>> paginate() async {
    List<Map<String, dynamic>> records = await getRecords();
    print('DB.paginate>>>${MainController.pageInfo}');

    if (MainController.pageInfo[tableName] == null) {
      MainController.pageInfo[tableName!] = PageInfo();
    }
    final pageInfo = MainController.pageInfo[tableName];
    final infoTable = (await MainController.getInfoTable(this.tableName!)).schema;
    int currentPage = infoTable.currentPage ?? 1;
    int perPage = infoTable.countShowRow ?? 10;

    int start = (currentPage - 1) * perPage;

    int totalRecords = records.length;

    pageInfo?.start = start;
    var end = start + perPage;
    var endBycondition = end >= totalRecords ? totalRecords : end;
    pageInfo?.end = endBycondition;
    // pageInfo?.totalRecords = totalRecords;
    MainController.pageInfo[this.tableName!] = pageInfo!;

    if (infoTable.online == true) {
      return records;
    }

    return records.skip(start).take(perPage).toList();
  }

  // paginate() async {
  //
  //   // MainController.tableData.value =[];
  //   MainController.pageInfo['${this.tableName}']?.end=0;
  //   MainController.pageInfo['${this.tableName}']?.start=0;
  //   // MainController.endIndex.value = 0;
  //   // MainController.startIndex.value = 0;
  //   var infoTable = await MainController.getInfoTable('${this.tableName}').schema;
  //   var countShowRow = infoTable.countShowRow!=null?infoTable.countShowRow:null;
  //   int currentPage = infoTable.currentPage!;
  //   int perPage = countShowRow != null ? countShowRow : 10;
  //   int s = (currentPage - 1) * perPage;
  //   List<Map<String, dynamic>> getRecord = await getRecords();
  //   var totalRecords = getRecord.length;
  //   // MainController.totalRecords.value = totalRecords;
  //   var end = s + perPage;
  //   MainController.pageInfo['${this.tableName}']?.start = s;
  //   var endBycondition = end >= totalRecords ? totalRecords : end;
  //   MainController.pageInfo['${this.tableName}']?.end = endBycondition;
  //   var data = [];
  //   if (infoTable.online == true) {
  //     data = getRecord;
  //   } else {
  //     MainController.pageInfo['${this.tableName}']!.totalRecords= totalRecords;
  //     data = getRecord.skip(s).take(perPage).toList();
  //   }
  //   return data;
  // }

  infoPage() async {
    var countShowRow = await MainController.getInfoTable('${this.tableName}')
        .schema
        .countShowRow ??
        null;
    int perPage = countShowRow != null ? countShowRow : 10;
    int totalRecords = MainController.pageInfo['${this.tableName}']!.totalRecords;
    int totalPage = (totalRecords / perPage).ceil();
    return totalPage;
  }

  parent({var parentTable = null, var parentId = null}) {
    parentItem = <String, Map<String, dynamic>>{};
    print('DB.parent>>>${parentTable}>>${parentId}');
    if (parentTable != null && parentId != null) {
      var json = {'parent_table': parentTable, 'parent_id': parentId};
      TableModel table=MainController.getInfoTable(this.tableName!);
      // table.schema.currentPage=1;
      parentItem = {"${this.tableName}": json};
    } else
      parentItem = <String, Map<String, dynamic>>{};

    return this;
  }

  getRecords() async {
    AppController.startLoading('get-records');
    List<Map<String, dynamic>> getData = [];
    await ConnectionController.checkConnectivity();
    List<Map<String, dynamic>> dataItems = [];
    Box box;
    List<Map<String, dynamic>> data = [];
    ConncetServerController.getRecordRes.value = [];
    int index = MainController.menuList
        .indexWhere((element) => element.schema.name == '${this.tableName}');
    data = [];
    if (parentItem.containsKey(this.tableName) &&
        parentItem[this.tableName]!.length != 0) {
      where('parent_id', '\$eq', parentItem[this.tableName]!['parent_id']);
      print('DB.getRecords where list is>>>${this.whereList}');
    } else {
      // where('parent_id', '\$eq', null);
      // print('DB.getRecords where list is2>>>${this.whereList}');
      // await ConncetServerController.getRecordGeneral('${tableName}');
      // dataItems = ConncetServerController.getRecordRes.cast<Map<String, dynamic>>();
      // for(var s in dataItems){
      //   print(s['parent_id']);
      //   print(s['parent_id'].runtimeType);
      // }
    }
    if (MainController.menuList[index].schema.online == true) {
      if (this.whereList.length == 0 && this.orWhereList.length == 0) {
        List<Map<String, dynamic>> dataItems = [];
        getData = await ConncetServerController.filterRecordGeneral([], '${tableName}', '\$or');
        dataItems = getData;
        if (dataItems.isNotEmpty) {
          data = dataItems;
          var tableInfo = MainController.menuList[index];
          box = await Hive.openBox<DataModel>(
              MainController.apiKey.value + '${tableInfo.schema.name}');
          var boxList = box.values.toList();
          print('DB.getRecords boxList>>${boxList}');
          for (var item in boxList) {
            if (item.data['sync'] == 'false') {
              data.add(await getDataTypeOfFieldItem(item));
            }
          }
        } else {
          var tableInfo = MainController.menuList[index];
          box = await Hive.openBox<DataModel>(
              MainController.apiKey.value + '${tableInfo.schema.name}');
          data = (await getDataTypeOfFieldList(box.values.toList()));
        }
      } else {
        var tableInfo = MainController.menuList[index];
        box = await Hive.openBox<DataModel>(
            MainController.apiKey.value + '${tableInfo.schema.name}');
        data.addAll(await getDataTypeOfFieldList(box.values.toList()));
      }
    } else {
      var tableInfo = MainController.menuList[index];
      box = await Hive.openBox<DataModel>(
          MainController.apiKey.value + '${tableInfo.schema.name}');
      // data = await getDataTypeOfFieldList(box.values.toList());

      data.addAll(await getDataTypeOfFieldList(box.values.toList()));
    }
    // print('DB.getRecords>>>${data}');
    if (index != -1) {
      // if (parentItem.length != 0) {
      //   data = data
      //       .where((element) => element['parent_id'] == parentItem['parent_id'])
      //       .toList();
      // }
      if (this.orWhereList.length != 0) {
        if (MainController.menuList[index].schema.online == true) {
          getData = await ConncetServerController.filterRecordGeneral(
              this.orWhereList, this.tableName!, '\$or');
          if (getData.isNotEmpty) {
            dataItems = getData;
          }
        } else {
          if (data.length != 0) {
            for (var d in data) {
              bool flag = true;
              for (int j = 1; j <= orWhereList.length; j++) {
                if (d['${orWhereList[j]!.fieldName}'] != null) {
                  if (orWhereList[j]!.value != '') {
                    if (orWhereList[j]!.operator == '\$eq' ||
                        orWhereList[j]!.operator == null) {
                      if (d['${orWhereList[j]!.fieldName}'] is List) {
                        if (d['${orWhereList[j]!.fieldName}']
                            .contains(orWhereList[j]!.value) &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                        if (MainController.getTypeOfField(
                            this.tableName!, orWhereList[j]!.fieldName!) ==
                            'Date') {
                          if (HelperController.filterDate(
                              d['${orWhereList[j]!.fieldName}'],
                              orWhereList[j]!.value,
                              "==") ==
                              true &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        } else if (MainController.getTypeOfField(
                            this.tableName!, orWhereList[j]!.fieldName!) ==
                            'time') {
                          if (HelperController.filterTime(
                              d['${orWhereList[j]!.fieldName}'],
                              orWhereList[j]!.value,
                              "==") ==
                              true &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        } else {
                          if (d['${orWhereList[j]!.fieldName}'] ==
                              orWhereList[j]!.value &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        }
                      }
                    } else if (orWhereList[j]!.operator == '\$gte') {
                      if (MainController.getTypeOfField(
                          this.tableName!, orWhereList[j]!.fieldName!) ==
                          'Date') {
                        if (HelperController.filterDate(
                            d['${orWhereList[j]!.fieldName}'],
                            orWhereList[j]!.value,
                            ">=") ==
                            true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else if (MainController.getTypeOfField(
                          this.tableName!, orWhereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${orWhereList[j]!.fieldName}'],
                            orWhereList[j]!.value,
                            ">=") ==
                            true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                        if (d['${orWhereList[j]!.fieldName}'] >=
                            orWhereList[j]!.value &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                    } else if (orWhereList[j]!.operator == '\$lte') {
                      if (MainController.getTypeOfField(
                          this.tableName!, orWhereList[j]!.fieldName!) ==
                          'Date') {
                        if (HelperController.filterDate(
                            d['${orWhereList[j]!.fieldName}'],
                            orWhereList[j]!.value,
                            "<=") ==
                            true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else if (MainController.getTypeOfField(
                          this.tableName!, orWhereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${orWhereList[j]!.fieldName}'],
                            orWhereList[j]!.value,
                            "<=") ==
                            true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                        if (d['${orWhereList[j]!.fieldName}'] <=
                            orWhereList[j]!.value &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                    } else if (orWhereList[j]!.operator == '\$nq') {
                      if (MainController.getTypeOfField(
                          this.tableName!, orWhereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${orWhereList[j]!.fieldName}'],
                            orWhereList[j]!.value,
                            "!=") ==
                            true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                        if (d['${orWhereList[j]!.fieldName}'] !=
                            orWhereList[j]!.value &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      }
                    } else if (orWhereList[j]!.operator == '\$lt') {
                      if (MainController.getTypeOfField(
                          this.tableName!, orWhereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${orWhereList[j]!.fieldName}'],
                            orWhereList[j]!.value,
                            "<") ==
                            true &&
                            flag == true) {
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
                    } else if (orWhereList[j]!.operator == '\$gt') {
                      if (MainController.getTypeOfField(
                          this.tableName!, orWhereList[j]!.fieldName!) ==
                          'time') {
                        if (HelperController.filterTime(
                            d['${orWhereList[j]!.fieldName}'],
                            orWhereList[j]!.value,
                            ">") ==
                            true &&
                            flag == true) {
                          flag = true;
                        } else
                          flag = false;
                      } else {
                        if (d['${orWhereList[j]!.fieldName}'] >
                            orWhereList[j]!.value &&
                            flag == true) {
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
      } else {
        if (this.whereList.length != 0) {
          print(
              'DB.getRecords whereList>>${MainController.menuList[index].schema.online}>>>${ConnectionController.checkConnection.value}');
          if (MainController.menuList[index].schema.online == true &&
              ConnectionController.checkConnection.value == true) {
            getData = await ConncetServerController.filterRecordGeneral(
                this.whereList, this.tableName!, '\$and');
            if (getData.isNotEmpty) {
              dataItems = getData;
            }
          } else {
            if (data.length != 0) {
              for (var d in data) {
                print('DB.getRecords else >>${d}');

                bool flag = true;
                for (int j = 1; j <= whereList.length; j++) {
                  if (whereList[j]!.fieldName != '_id')
                    whereList[j]!.value = await General(this.tableName!)
                        .withFormat(
                        MainController.getTypeOfField(
                            this.tableName!, whereList[j]!.fieldName!),
                        whereList[j]!.value,
                        whereList[j]!.fieldName!);
                  if (d['${whereList[j]!.fieldName}'] != null) {
                    if (whereList[j]!.value != '' &&
                        whereList[j]!.value != null &&
                        whereList[j]!.value != 'null') {
                      if (whereList[j]!.operator == '\$eq' ||
                          whereList[j]!.operator == null) {
                        if (d['${whereList[j]!.fieldName}'] is List) {
                          if (d['${whereList[j]!.fieldName}']
                              .contains(whereList[j]!.value) &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        } else {
                          if (MainController.getTypeOfField(
                              this.tableName!, whereList[j]!.fieldName!) ==
                              'Date') {
                            if (HelperController.filterDate(
                                d['${whereList[j]!.fieldName}'],
                                whereList[j]!.value,
                                "==") ==
                                true &&
                                flag == true) {
                              flag = true;
                            } else
                              flag = false;
                          } else if (MainController.getTypeOfField(
                              this.tableName!, whereList[j]!.fieldName!) ==
                              'time') {
                            if (HelperController.filterTime(
                                d['${whereList[j]!.fieldName}'],
                                whereList[j]!.value,
                                "==") ==
                                true &&
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
                        }
                      } else if (whereList[j]!.operator == '\$gte') {
                        if (MainController.getTypeOfField(
                            this.tableName!, whereList[j]!.fieldName!) ==
                            'Date') {
                          if (HelperController.filterDate(
                              d['${whereList[j]!.fieldName}'],
                              whereList[j]!.value,
                              ">=") ==
                              true &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        } else if (MainController.getTypeOfField(
                            this.tableName!, whereList[j]!.fieldName!) ==
                            'time') {
                          if (HelperController.filterTime(
                              d['${whereList[j]!.fieldName}'],
                              whereList[j]!.value,
                              ">=") ==
                              true &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        } else {
                          if (d['${whereList[j]!.fieldName}'] >=
                              whereList[j]!.value &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        }
                      } else if (whereList[j]!.operator == '\$lte') {
                        if (MainController.getTypeOfField(
                            this.tableName!, whereList[j]!.fieldName!) ==
                            'Date') {
                          if (HelperController.filterDate(
                              d['${whereList[j]!.fieldName}'],
                              whereList[j]!.value,
                              "<=") ==
                              true &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        } else if (MainController.getTypeOfField(
                            this.tableName!, whereList[j]!.fieldName!) ==
                            'time') {
                          if (HelperController.filterTime(
                              d['${whereList[j]!.fieldName}'],
                              whereList[j]!.value,
                              "<=") ==
                              true &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        } else {
                          if (d['${whereList[j]!.fieldName}'] <=
                              whereList[j]!.value &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        }
                      } else if (whereList[j]!.operator == '\$nq') {
                        if (MainController.getTypeOfField(
                            this.tableName!, whereList[j]!.fieldName!) ==
                            'time') {
                          if (HelperController.filterTime(
                              d['${whereList[j]!.fieldName}'],
                              whereList[j]!.value,
                              "!=") ==
                              true &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        } else {
                          if (d['${whereList[j]!.fieldName}'] !=
                              whereList[j]!.value &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        }
                      } else if (whereList[j]!.operator == '\$lt') {
                        if (MainController.getTypeOfField(
                            this.tableName!, whereList[j]!.fieldName!) ==
                            'time') {
                          if (HelperController.filterTime(
                              d['${whereList[j]!.fieldName}'],
                              whereList[j]!.value,
                              "<") ==
                              true &&
                              flag == true) {
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
                      } else if (whereList[j]!.operator == '\$gt') {
                        if (MainController.getTypeOfField(
                            this.tableName!, whereList[j]!.fieldName!) ==
                            'time') {
                          if (HelperController.filterTime(
                              d['${whereList[j]!.fieldName}'],
                              whereList[j]!.value,
                              ">") ==
                              true &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        } else {
                          if (d['${whereList[j]!.fieldName}'] >
                              whereList[j]!.value &&
                              flag == true) {
                            flag = true;
                          } else
                            flag = false;
                        }
                      }
                    } else
                      flag = true;
                  } else
                    flag = false;
                }
                if (flag == true) {
                  dataItems.add(d);
                }
              }
            }
          }
        } else {
          print('DB.getRecords else else>>$data');
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
      AppController.finishLoading('get-records');
      return data;
    }
    return getData;
  }

  // getRecord({bool withFormat = true}) async {
  //   Map<String, dynamic> dataItems = {};
  //   Box box;
  //   Map<String, dynamic> data = {};
  //   int index = MainController.menuList.indexWhere(
  //           (element) => element.value.schema.name == '${this.tableName}');
  //   if (MainController.menuList[index].schema.online == true ) {
  //     if(this.whereList.length==0 && this.orWhereList.length==0) {
  //       // await ConncetServerController.getRecordGeneral('${tableName}');
  //       // if (ConncetServerController.getRecordRes.isNotEmpty) {
  //       //   data =
  //       //       ConncetServerController.getRecordRes.cast<Map<String, dynamic>>();
  //       // }
  //     }
  //   } else {
  //     var tableInfo = MainController.menuList[index];
  //     box = await Hive.openBox<DataModel>('${tableInfo['name']}');
  //     data = (await getDataTypeOfFieldList(box.values.toList())).first;
  //   }
  //   if (index != -1) {
  //     if (parentItem.length != 0) {
  //       if(data['parent_id'] == parentItem['parent_id']){
  //         data=data;
  //       }
  //     }
  //     if (this.orWhereList.length != 0) {
  //       if (MainController.menuList[index]['online'] == true) {
  //         // await ConncetServerController.filterRecordGeneral(
  //         //     this.orWhereList, this.tableName!, '\$or');
  //         // if (ConncetServerController.filterRecordRes.isNotEmpty) {
  //         //   dataItems = ConncetServerController.filterRecordRes;
  //         // }
  //       }
  //       else {
  //         if (data.length != 0) {
  //           var d=data;
  //           // for (var d in data) {
  //           bool flag = true;
  //           for (int j = 1; j <= orWhereList.length; j++) {
  //             if (d['${orWhereList[j]!.fieldName}'] != null) {
  //               if (orWhereList[j]!.value != '') {
  //                 if (orWhereList[j]!.oprator == '\$eq' || orWhereList[j]!.oprator == null) {
  //                   if (d['${orWhereList[j]!.fieldName}'] is List) {
  //                     if (d['${orWhereList[j]!.fieldName}'].contains(orWhereList[j]!.value) && flag == true) {
  //                       flag = true;
  //                     } else {
  //                       flag = false;
  //                     }
  //                   } else {
  //                     if (MainController.getTypeOfField(
  //                         this.tableName!, orWhereList[j]!.fieldName!) ==
  //                         'Date') {
  //                       if (HelperController.filterDate(
  //                           d['${orWhereList[j]!.fieldName}'],
  //                           orWhereList[j]!.value,
  //                           "==") ==
  //                           true &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     } else if (MainController.getTypeOfField(
  //                         this.tableName!, orWhereList[j]!.fieldName!) ==
  //                         'time') {
  //                       if (HelperController.filterTime(
  //                           d['${orWhereList[j]!.fieldName}'],
  //                           orWhereList[j]!.value,
  //                           "==") ==
  //                           true &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     } else {
  //                       if (d['${orWhereList[j]!.fieldName}'] ==
  //                           orWhereList[j]!.value &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     }
  //                   }
  //                 } else if (orWhereList[j]!.oprator == '\$gte') {
  //                   if (MainController.getTypeOfField(
  //                       this.tableName!, orWhereList[j]!.fieldName!) ==
  //                       'Date') {
  //                     if (HelperController.filterDate(
  //                         d['${orWhereList[j]!.fieldName}'],
  //                         orWhereList[j]!.value,
  //                         ">=") ==
  //                         true &&
  //                         flag == true) {
  //                       flag = true;
  //                     } else
  //                       flag = false;
  //                   } else if (MainController.getTypeOfField(
  //                       this.tableName!, orWhereList[j]!.fieldName!) ==
  //                       'time') {
  //                     if (HelperController.filterTime(
  //                         d['${orWhereList[j]!.fieldName}'],
  //                         orWhereList[j]!.value,
  //                         ">=") ==
  //                         true &&
  //                         flag == true) {
  //                       flag = true;
  //                     } else
  //                       flag = false;
  //                   } else {
  //                     if (d['${orWhereList[j]!.fieldName}'] >=
  //                         orWhereList[j]!.value &&
  //                         flag == true) {
  //                       flag = true;
  //                     } else
  //                       flag = false;
  //                   }
  //                 } else if (orWhereList[j]!.oprator == '\$lte') {
  //                   if (MainController.getTypeOfField(
  //                       this.tableName!, orWhereList[j]!.fieldName!) ==
  //                       'Date') {
  //                     if (HelperController.filterDate(
  //                         d['${orWhereList[j]!.fieldName}'],
  //                         orWhereList[j]!.value,
  //                         "<=") ==
  //                         true &&
  //                         flag == true) {
  //                       flag = true;
  //                     } else
  //                       flag = false;
  //                   } else if (MainController.getTypeOfField(
  //                       this.tableName!, orWhereList[j]!.fieldName!) ==
  //                       'time') {
  //                     if (HelperController.filterTime(
  //                         d['${orWhereList[j]!.fieldName}'],
  //                         orWhereList[j]!.value,
  //                         "<=") ==
  //                         true &&
  //                         flag == true) {
  //                       flag = true;
  //                     } else
  //                       flag = false;
  //                   } else {
  //                     if (d['${orWhereList[j]!.fieldName}'] <=
  //                         orWhereList[j]!.value &&
  //                         flag == true) {
  //                       flag = true;
  //                     } else
  //                       flag = false;
  //                   }
  //                 } else if (orWhereList[j]!.oprator == '\$nq') {
  //                   if (MainController.getTypeOfField(
  //                       this.tableName!, orWhereList[j]!.fieldName!) ==
  //                       'time') {
  //                     if (HelperController.filterTime(
  //                         d['${orWhereList[j]!.fieldName}'],
  //                         orWhereList[j]!.value,
  //                         "!=") ==
  //                         true &&
  //                         flag == true) {
  //                       flag = true;
  //                     } else
  //                       flag = false;
  //                   } else {
  //                     if (d['${orWhereList[j]!.fieldName}'] !=
  //                         orWhereList[j]!.value &&
  //                         flag == true) {
  //                       flag = true;
  //                     } else
  //                       flag = false;
  //                   }
  //                 } else if (orWhereList[j]!.oprator == '\$lt') {
  //                   if (MainController.getTypeOfField(
  //                       this.tableName!, orWhereList[j]!.fieldName!) ==
  //                       'time') {
  //                     if (HelperController.filterTime(
  //                         d['${orWhereList[j]!.fieldName}'],
  //                         orWhereList[j]!.value,
  //                         "<") ==
  //                         true &&
  //                         flag == true) {
  //                       flag = true;
  //                     } else
  //                       flag = false;
  //                   } else {
  //                     if (d['${orWhereList[j]!.fieldName}'] <
  //                         orWhereList[j]!.value &&
  //                         flag == true) {
  //                       flag = true;
  //                     } else
  //                       flag = false;
  //                   }
  //                 } else if (orWhereList[j]!.oprator == '\$gt') {
  //                   if (MainController.getTypeOfField(
  //                       this.tableName!, orWhereList[j]!.fieldName!) ==
  //                       'time') {
  //                     if (HelperController.filterTime(
  //                         d['${orWhereList[j]!.fieldName}'],
  //                         orWhereList[j]!.value,
  //                         ">") ==
  //                         true &&
  //                         flag == true) {
  //                       flag = true;
  //                     } else
  //                       flag = false;
  //                   } else {
  //                     if (d['${orWhereList[j]!.fieldName}'] >
  //                         orWhereList[j]!.value &&
  //                         flag == true) {
  //                       flag = true;
  //                     } else
  //                       flag = false;
  //                   }
  //                 }
  //               } else
  //                 flag = false;
  //             } else
  //               flag = false;
  //           }
  //           if (flag == true) {
  //             dataItems=d;
  //           }
  //           // }
  //         }
  //       }
  //
  //     } else {
  //       if (this.whereList.length != 0) {
  //         if (MainController.menuList[index].schema.online == true) {
  //           // await ConncetServerController.filterRecordGeneral(
  //           //     this.whereList, this.tableName!, '\$and');
  //           // if (ConncetServerController.filterRecordRes.isNotEmpty) {
  //           //   dataItems = ConncetServerController.filterRecordRes;
  //           // }
  //         } else {
  //           if (data.length != 0) {
  //             var d=data;
  //             bool flag = true;
  //             for (int j = 1; j <= whereList.length; j++) {
  //               // if (whereList[j]!.fieldName != '_id')
  //               // whereList[j]!.value=await General(this.tableName!).withFormat(MainController.getTypeOfField(this.tableName!, whereList[j]!.fieldName!),whereList[j]!.value,whereList[j]!.fieldName!);
  //               if (d['${whereList[j]!.fieldName}'] != null) {
  //                 if (whereList[j]!.value != '') {
  //                   if (whereList[j]!.oprator == '\$eq' ||
  //                       whereList[j]!.oprator == null) {
  //                     if (d['${whereList[j]!.fieldName}'] is List) {
  //                       if (d['${whereList[j]!.fieldName}']
  //                           .contains(whereList[j]!.value) &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     } else {
  //                       if (MainController.getTypeOfField(
  //                           this.tableName!, whereList[j]!.fieldName!) ==
  //                           'Date') {
  //                         if (HelperController.filterDate(
  //                             d['${whereList[j]!.fieldName}'],
  //                             whereList[j]!.value,
  //                             "==") ==
  //                             true &&
  //                             flag == true) {
  //                           flag = true;
  //                         } else
  //                           flag = false;
  //                       } else if (MainController.getTypeOfField(
  //                           this.tableName!, whereList[j]!.fieldName!) ==
  //                           'time') {
  //                         if (HelperController.filterTime(
  //                             d['${whereList[j]!.fieldName}'],
  //                             whereList[j]!.value,
  //                             "==") ==
  //                             true &&
  //                             flag == true) {
  //                           flag = true;
  //                         } else
  //                           flag = false;
  //                       } else {
  //                         if (d['${whereList[j]!.fieldName}'] == whereList[j]!.value && flag == true) {
  //                           flag = true;
  //                         } else
  //                           flag = false;
  //                       }
  //                     }
  //                   } else if (whereList[j]!.oprator == '\$gte') {
  //                     if (MainController.getTypeOfField(
  //                         this.tableName!, whereList[j]!.fieldName!) ==
  //                         'Date') {
  //                       if (HelperController.filterDate(
  //                           d['${whereList[j]!.fieldName}'],
  //                           whereList[j]!.value,
  //                           ">=") ==
  //                           true &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     } else if (MainController.getTypeOfField(
  //                         this.tableName!, whereList[j]!.fieldName!) ==
  //                         'time') {
  //                       if (HelperController.filterTime(
  //                           d['${whereList[j]!.fieldName}'],
  //                           whereList[j]!.value,
  //                           ">=") ==
  //                           true &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     } else {
  //                       if (d['${whereList[j]!.fieldName}'] >=
  //                           whereList[j]!.value &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     }
  //                   } else if (whereList[j]!.oprator == '\$lte') {
  //                     if (MainController.getTypeOfField(
  //                         this.tableName!, whereList[j]!.fieldName!) ==
  //                         'Date') {
  //                       if (HelperController.filterDate(
  //                           d['${whereList[j]!.fieldName}'],
  //                           whereList[j]!.value,
  //                           "<=") ==
  //                           true &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     } else if (MainController.getTypeOfField(
  //                         this.tableName!, whereList[j]!.fieldName!) ==
  //                         'time') {
  //                       if (HelperController.filterTime(
  //                           d['${whereList[j]!.fieldName}'],
  //                           whereList[j]!.value,
  //                           "<=") ==
  //                           true &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     } else {
  //                       if (d['${whereList[j]!.fieldName}'] <=
  //                           whereList[j]!.value &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     }
  //                   } else if (whereList[j]!.oprator == '\$nq') {
  //                     if (MainController.getTypeOfField(
  //                         this.tableName!, whereList[j]!.fieldName!) ==
  //                         'time') {
  //                       if (HelperController.filterTime(
  //                           d['${whereList[j]!.fieldName}'],
  //                           whereList[j]!.value,
  //                           "!=") ==
  //                           true &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     } else {
  //                       if (d['${whereList[j]!.fieldName}'] !=
  //                           whereList[j]!.value &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     }
  //                   } else if (whereList[j]!.oprator == '\$lt') {
  //                     if (MainController.getTypeOfField(
  //                         this.tableName!, whereList[j]!.fieldName!) ==
  //                         'time') {
  //                       if (HelperController.filterTime(
  //                           d['${whereList[j]!.fieldName}'],
  //                           whereList[j]!.value,
  //                           "<") ==
  //                           true &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     } else {
  //                       if (d['${whereList[j]!.fieldName}'] <
  //                           whereList[j]!.value &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     }
  //                   } else if (whereList[j]!.oprator == '\$gt') {
  //                     if (MainController.getTypeOfField(
  //                         this.tableName!, whereList[j]!.fieldName!) ==
  //                         'time') {
  //                       if (HelperController.filterTime(
  //                           d['${whereList[j]!.fieldName}'],
  //                           whereList[j]!.value,
  //                           ">") ==
  //                           true &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     } else {
  //                       if (d['${whereList[j]!.fieldName}'] >
  //                           whereList[j]!.value &&
  //                           flag == true) {
  //                         flag = true;
  //                       } else
  //                         flag = false;
  //                     }
  //                   }
  //                 } else
  //                   flag = false;
  //               } else
  //                 flag = false;
  //             }
  //             if (flag == true) {
  //               dataItems=(d);
  //             }
  //           }
  //         }
  //
  //       } else {
  //         dataItems = data;
  //       }
  //     }
  //
  //     data = dataItems;
  //
  //     return data;
  //   }
  // }

  Future<Map<String, dynamic>> storeRecord(Map<dynamic, dynamic> request) async {
    AppController.startLoading('store-record');
    bool connectivity = await ConnectionController.checkConnectivity();
    Map<String, dynamic> storeRecordRes = {};
    try {
      Box box = await Hive.openBox<DataModel>(MainController.apiKey.value + '${this.tableName}');
      ViewController.isClickedBtn.value = true;
      var Id = Uuid().v4();
      Map<String, dynamic> newRequest = Map.from(request);
      print('DB.storeRecord request>>${request}');
      var columns = MainController.getColumnsTable('${this.tableName}');
      for (var col in columns) {
        if (newRequest.containsKey(col.name)) {
          if (col.type == 'select' || col.type == 'radioButton') {
            if (newRequest[col.type] is Map) {
              if (col.sourceItems == 'custom') {
                newRequest[col.name] = newRequest[col.name]['value'];
              }
            }
          }
        }
      }
      newRequest['parent_table'] = newRequest['parent_table'] == "" ? null : newRequest['parent_table'];
      newRequest['parent_id'] = newRequest['parent_id'] == "" ? null : newRequest['parent_id'];
      newRequest['version'] = newRequest['parent_id'] == null ? 1 : newRequest['version'];
      print('DB.storeRecord newRequest>>${newRequest}');
      if (ValidatorController.validateByType(newRequest, '${this.tableName}') ==
          true) {
        print('DB.storeRecord request>>>${newRequest}');
        List<dynamic> columns =
        MainController.getColumnsList('${this.tableName}');
        for (var column in columns) {
          if (!newRequest.keys.contains(column)) {
            newRequest.addAll({'${column}': null});
          }
        }
        if (parentItem.containsKey(this.tableName) &&
            parentItem[this.tableName] != {}) {
          newRequest.addAll(parentItem[this.tableName]!);
        }

        print('DB.storeRecord 1 ');
        DataModel newData = DataModel(id: newRequest.keys.contains('_id') ? request['_id'].toString() : '${Id}', data: newRequest);
        var beforValidate = HelperController.beforeStoreValidation(newData.data);
        if (beforValidate['status'] == false) {
          showSnackbar(snackTypes.error, beforValidate['message']);
          print('>>>>>>>>>>>>>>ShowSnackbar beforValidate<<<<<<<<<<<<<<<<');
        } else {
          print('DB.storeRecord 2');

          if (await RecordController.validate(
              this.tableName!,
              beforValidate['data'],
              MainController.getInfoTable(this.tableName!)) ==
              false) {
            var before = await HelperController.beforeStore(beforValidate['data']);
            if (before['status'] == false) {
              showSnackbar(snackTypes.error, before['message']);
              print('>>>>>>>>>>>>>>ShowSnackbar before<<<<<<<<<<<<<<<<');
            } else {
              var customData =before['data'];
              print('DB.storeRecord customData>>${customData}');
              if (customData.keys.contains('_id')) {
                customData['_id'] = null;
              }
              Map<String, dynamic> setRecord = {
                "table_name": '${this.tableName}',
                "record": json.encode(customData).toString(),
              };
              var dataModelItem = DataModel(id: newData.id, data: customData);
              if (request.containsKey('_id')) {
                var tableDataIndex = box.values.toList().indexWhere((element) => element.id == request['_id']);
                if (tableDataIndex != -1) {
                  await box.deleteAt(tableDataIndex);
                }
              }

              if (MainController.getStatusTable(this.tableName!) == true) {
                if (connectivity) {
                  storeRecordRes =
                  await ConncetServerController.storeRecordGeneral(setRecord);
                  if (storeRecordRes.isNotEmpty) {
                    DataModel recordStored = DataModel(
                        id: '${storeRecordRes['_id']}', data: storeRecordRes);
                    await box.add(recordStored);
                  } else {
                    customData.addAll({
                      "sync": "false",
                      "sync_type": "store",
                      "server error": "Dont sync 'store' this record!",
                    });
                    var dataModelItem = DataModel(
                        id: newData.id, data: customData);

                    if (request.containsKey('_id')) {
                      if (box.values.toList().indexWhere((element) =>
                      element.id == request['_id']) == -1) {
                        await box.add(dataModelItem);
                      }
                    }

                    storeRecordRes =
                    Map<String, dynamic>.from(dataModelItem.data);
                  }
                }
                else {
                  customData.addAll({
                    "sync": "false",
                    "sync_type": "store",
                    "server error": "Dont sync 'store' this record!",
                  });
                  var dataModelItem = DataModel(
                      id: newData.id, data: customData);
                  print('DB.storeRecord connect false>>${dataModelItem}>>${request}>>${customData}');

                  if (request.containsKey('_id')) {
                    if (box.values.toList().indexWhere((element) =>
                    element.id == request['_id']) == -1) {
                      await box.add(dataModelItem);
                    }
                  }else{
                    await box.add(dataModelItem);
                  }

                  // MainController.renderData(operation.store,customData.data);
                }
              }else{
                await box.add(dataModelItem);
                storeRecordRes = Map<String, dynamic>.from(dataModelItem.data);
              }

              var afterData = await HelperController.afterStore(
                  this.tableName!, newRequest, customData);
              if (afterData['status'] == false) {
                showSnackbar(snackTypes.error, afterData['message']);
                print('>>>>>>>>>>>>>>ShowSnackbar afterData<<<<<<<<<<<<<<<<');
              }
              // MainController.renderData(operation.store,data);

              ViewController.isClickedBtn.value = false;
              request = {};
              newRequest = {};
            }
          } else {
            // showSnackbar(snackTypes.error,
            //     "${AppController.of(Get.context!)!.value('error')}");
            print('>>>>>>>>>>>>>>ShowSnackbar last<<<<<<<<<<<<<<<<');
          }
        }
      } else {
        showSnackbar(snackTypes.error, 'داده ها دارای مقادیر نادرستی هستند');
      }
    } catch (err, stackTrace) {
      print('DB.storeRecord ERROR >>> $err');
      print('DB.storeRecord STACKTRACE >>> $stackTrace');
      showSnackbar(snackTypes.error, 'عملیات با خطا مواجه شد');
    }finally{
      AppController.finishLoading('store-record');

    }
    return storeRecordRes;
  }

  dynamic normalizeFieldValue({
    required String tableName,
    required String key,
    required dynamic value,
  }) {
    final fieldDetail = MainController.getDetailsOfField(tableName, key);

    if (fieldDetail == null) return value;

    final sourceItem = fieldDetail.sourceItems;
    String type = fieldDetail.type;
    if (type.contains('file')) {
      print('DB.normalizeFieldValue>>${value}');

      if (value.toString().isNotEmpty)
        value = value.contains('/') ? value.split('/').last : value;
    }
    if (value is List) {
      List<dynamic> result = [];

      for (var item in value) {
        // custom source
        if (sourceItem == 'custom') {
          if (item is Map && item.containsKey('value')) {
            result.add(item['value']);
          } else {
            result.add(item);
          }
        }
        // normal source
        else {
          if (item is Map && item.containsKey('_id')) {
            if (item['_id'] != null) {
              result.add(item['_id']);
            }
          } else {
            result.add(item);
          }
        }
      }

      return result;
    }

    /// ---------- MAP ----------
    if (value is Map) {
      if (sourceItem == 'custom') {
        return value['value'] ?? value;
      } else {
        return value['_id'] ?? value;
      }
    }

    /// ---------- PRIMITIVE ----------
    return value;
  }
  Map<String, dynamic> normalizeRecord(Map<String, dynamic> record) {
    Map<String, dynamic> normalizedRecord = Map<String, dynamic>.from(record);
    normalizedRecord.updateAll((key, value) {
      return normalizeFieldValue(
        tableName: this.tableName!,
        key: key,
        value: value,
      );
    });

    return normalizedRecord;
  }


  Future<Map<String, dynamic>> updateRecordOfflineSchema(String id,Map<String, dynamic> request) async {
    Map<String, dynamic> updateRecordRes = {};
    try {
      where('_id', '\$eq', id);
      Map<String,dynamic> record={};
      List<Map<String,dynamic>> records = await getRecords();
      ViewController.isClickedEditBtn.value = true;
      Box box = await Hive.openBox<DataModel>(MainController.apiKey.value + '${this.tableName}');
      var boxIndex=box.values.toList().indexWhere((element) => element.id==id);

      if (records.isEmpty) {
        if(boxIndex!=-1) {
          record = (await getDataTypeOfFieldItem(box.values.toList()[boxIndex]));
        }else{
          showSnackbar(snackTypes.error, "Record not found!");
        }
      }else{
        record=records.first;
      }
      Map<String, dynamic> editedRecord = Map<String, dynamic>.from(record);
      for (var item in request.keys) {
        editedRecord[item] = request[item];
      }
      editedRecord=MainController.setVersionRecordInBox(editedRecord);
      print('DB.updateRecord containsKey>>${editedRecord}');
      Map<String, dynamic> normalize=normalizeRecord(editedRecord);

      editedRecord =normalize;
      // for( var a in editedRecords) {
      final dataModelRecord = DataModel(id: editedRecord['_id'], data: editedRecord);
      if (ValidatorController.validateByType(editedRecord, '${this.tableName}') == true) {
        var beforeValidate = await HelperController.beforeUpdateValidation(dataModelRecord.data);
        if (beforeValidate['status'] == false) {
          showSnackbar(snackTypes.error, beforeValidate['message']);
        } else {
          var validate = await RecordController.validate(this.tableName!, beforeValidate['data'], MainController.getInfoTable(this.tableName!));
          if (validate == false) {
            var before = await HelperController.beforeUpdate(dataModelRecord.data);
            if (before['status'] == false) {
              showSnackbar(snackTypes.error, before['messsage']);
            } else {
              Map<dynamic, dynamic> customUpdate = before['data'];
              DataModel dataModelItem = DataModel(id: dataModelRecord.id, data: customUpdate);
              await box.putAt(boxIndex, dataModelItem);
              MainController.setVersionSchemaInBox(this.tableName!);

              MainController.renderData(this.tableName!, operation.update, dataModelItem.data);
              updateRecordRes=(Map<String,dynamic>.from(dataModelItem.data)) ;

              MainController.isClickedItem.value = true;
              var after = await HelperController.afterUpdate(
                  this.tableName!, customUpdate);
              if (after['status'] == false) {
                showSnackbar(snackTypes.error, after['message']);
              }
              ViewController.isClickedEditBtn.value = false;
            }
          } else {
            showSnackbar(snackTypes.error, '${AppController.of(Get.context!)!.value('The operation encountered an error.')}');
          }
        }
      } else {
        showSnackbar(snackTypes.error, 'داده ها دارای مقادیر نادرستی هستند');
      }
      // }
    } catch (e, s) {
      print('DB.updateRecord catch>>${e.toString()}>>>${s}');
    }
    AppController.finishLoading('update-record');

    return updateRecordRes;
  }

  Future<List<Map<String, dynamic>>> updateRecordsOfflineSchema(Map<String, dynamic> request) async {
    List<Map<String, dynamic>> updateRecordRes = [];
    try {
      List<Map<String,dynamic>> records = await getRecords();
      ViewController.isClickedEditBtn.value = true;
      Box box = await Hive.openBox<DataModel>(
          MainController.apiKey.value + '${this.tableName}');
      if (records.isEmpty) {
        records = (await getDataTypeOfFieldList(box.values.toList()));
      }
      List<Map<String, dynamic>> editedRecords = [];
      print('DB.updateRecords containsKey request>>${request}');

      for (var data in records) {
        Map<String, dynamic> editedRecord = Map<String, dynamic>.from(data);
        for (var item in request.keys) {
          editedRecord[item] = request[item];
        }

        editedRecord=MainController.setVersionRecordInBox(editedRecord);
        if (MainController.getStatusTable(this.tableName!)) {
          editedRecord.addAll({
            "sync": "false",
            "sync_type": "update",
            "server error": "Dont sync 'update' this record!",
          });
          print('DB.updateRecords containsKey editedRecord>>${editedRecord}');

        }
        editedRecords.add(editedRecord);
      }
      print('DB.updateRecords containsKey editedRecord>>${editedRecords}');

      editedRecords = editedRecords.map(normalizeRecord).toList();
      for( var a in editedRecords) {
        final record = DataModel(id: a['_id'], data: a);
        if (ValidatorController.validateByType(a, '${this.tableName}') == true) {
          var beforeValidate = await HelperController.beforeUpdateValidation(record.data);
          if (beforeValidate['status'] == false) {
            showSnackbar(snackTypes.error, beforeValidate['message']);
          } else {
            var validate = await RecordController.validate(
                this.tableName!,
                beforeValidate['data'],
                MainController.getInfoTable(this.tableName!));
            if (validate == false) {
              var before = await HelperController.beforeUpdate(record.data);
              if (before['status'] == false) {
                showSnackbar(snackTypes.error, before['messsage']);
              } else {
                Map<dynamic, dynamic> customUpdate = before['data'];
                var boxDataIndex = box.values.toList().indexWhere((element) => element.id == a['_id']);
                print('DB.updateRecordsOfflineSchema>>${boxDataIndex}');
                DataModel dataModelItem = DataModel(id: record.id, data: customUpdate);
                await box.putAt(boxDataIndex, dataModelItem);
                MainController.setVersionSchemaInBox(this.tableName!);
                MainController.renderData(this.tableName!, operation.update, dataModelItem.data);
                updateRecordRes.add(Map<String,dynamic>.from(dataModelItem.data));
                MainController.isClickedItem.value = true;
                var after = await HelperController.afterUpdate(this.tableName!, customUpdate);
                if (after['status'] == false) {
                  showSnackbar(snackTypes.error, after['message']);
                }
                ViewController.isClickedEditBtn.value = false;
              }
            } else {
              showSnackbar(snackTypes.error,
                  '${AppController.of(Get.context!)!.value(
                      'The operation encountered an error.')}');
            }
          }
        } else {
          showSnackbar(snackTypes.error, 'داده ها دارای مقادیر نادرستی هستند');
        }
      }
    } catch (e, s) {
      print('DB.updateRecords catch>>${e.toString()}>>>${s}');
    }
    AppController.finishLoading('update-records');

    return updateRecordRes;
  }

  Future<List<Map<String, dynamic>>> updateRecordsOnlineSchema(Map<String, dynamic> request) async {
    List<Map<String, dynamic>> updateRecordRes = [];
    try {
      ViewController.isClickedEditBtn.value = true;
      Box box = await Hive.openBox<DataModel>(MainController.apiKey.value + '${this.tableName}');
      Map<String, dynamic> updatedRecord = {};
      for (var item in request.keys) {
        updatedRecord[item] = request[item];
      }
      // updatedRecord.updateAll((key, value) {
      //   return normalizeFieldValue(
      //     tableName: this.tableName!,
      //     key: key,
      //     value: value,
      //   );
      // });
      Map<String, dynamic> normalize=normalizeRecord(updatedRecord);
      updatedRecord = normalize;
      if (ValidatorController.validateByType(updatedRecord, '${this.tableName}') == true) {
        var beforeValidate =
        await HelperController.beforeUpdateValidation(updatedRecord);
        if (beforeValidate['status'] == false) {
          showSnackbar(snackTypes.error, beforeValidate['message']);
        } else {
          var validate = await RecordController.validate(
              this.tableName!,
              beforeValidate['data'],
              MainController.getInfoTable(this.tableName!));
          if (validate == false) {
            var before = await HelperController.beforeUpdate(updatedRecord);
            if (before['status'] == false) {
              showSnackbar(snackTypes.error, before['messsage']);
            } else {
              Map<dynamic, dynamic> customUpdate = before['data'];
              // print('DB.updateRecords records index>>${records[allDataIndex]}');
              // var dataModelItem = DataModel(id: record.id, data: customUpdate);

              if (MainController.getStatusTable(this.tableName!) == true) {
                // await ConncetServerController.setDatabaseme(customUpdate);
                var filterJson = await ConncetServerController.createJsonFilter(
                    this.whereList.length != 0
                        ? this.whereList
                        : this.orWhereList.length != 0
                        ? this.orWhereList
                        : [],
                    this.tableName!,
                    this.whereList.length != 0
                        ? '\$and'
                        : this.orWhereList.length != 0
                        ? '\$or'
                        : '');

                Map<String, dynamic> setRecord = {
                  "table_name": '${this.tableName}',
                  "record": json.encode(customUpdate).toString(),
                  "record_id": '',
                  "filter": filterJson['filter']
                };
                print('DB.updateRecords is>>>${setRecord}');
                updateRecordRes = await ConncetServerController.updateRecordsGeneral(setRecord);
                if (updateRecordRes.length != 0) {
                  for (var rec in updateRecordRes) {
                    // for(var i in box.values.toList())
                    // print('DB.updateRecordsOnlineSchema>>${i.data}');
                    var boxDataIndex = box.values.toList().indexWhere((element) => element.id == rec['_id']);
                    DataModel record = DataModel(id: rec['_id'], data: rec);
                    if(boxDataIndex!=-1) {
                      await box.putAt(boxDataIndex, record);
                      MainController.renderData(this.tableName!, operation.update, record.data);
                    }else{
                      await box.add(record);
                    }
                  }
                } else {
                  request.addAll({
                    "sync": "false",
                    "sync_type": "update",
                    "server error": "Dont sync 'update' this record!",
                  });
                  var updateOffline = await updateRecordsOfflineSchema(request);
                  updateRecordRes = List<Map<String, dynamic>>.from(updateOffline);
                }
              }

              MainController.isClickedItem.value = true;
              var after = await HelperController.afterUpdate(this.tableName!, customUpdate);
              if (after['status'] == false) {
                showSnackbar(snackTypes.error, after['message']);
              }
              ViewController.isClickedEditBtn.value = false;
            }
          } else {
            showSnackbar(snackTypes.error, '${AppController.of(Get.context!)!.value('The operation encountered an error.')}');
          }
        }
      } else {
        showSnackbar(snackTypes.error, 'داده ها دارای مقادیر نادرستی هستند');
      }
    } catch (e, s) {
      print('DB.updateRecords catch>>${e.toString()}>>>${s}');
    }
    AppController.finishLoading('update-records');

    return updateRecordRes;
  }

  Future<Map<String, dynamic>> updateRecordOnlineSchema(String id,Map<String, dynamic> request) async {
    Map<String, dynamic> updateRecordRes = {};
    try {
      ViewController.isClickedEditBtn.value = true;
      Box box = await Hive.openBox<DataModel>(MainController.apiKey.value + '${this.tableName}');
      var boxIndex=box.values.toList().indexWhere((element) => element.id==id);
      Map<String, dynamic> updatedRecord = {};
      for (var item in request.keys) {
        updatedRecord[item] = request[item];
      }

      Map<String, dynamic> normalize=normalizeRecord(updatedRecord);
      updatedRecord = normalize;
      if (ValidatorController.validateByType(updatedRecord, '${this.tableName}') == true) {
        var beforeValidate =
        await HelperController.beforeUpdateValidation(updatedRecord);
        if (beforeValidate['status'] == false) {
          showSnackbar(snackTypes.error, beforeValidate['message']);
        } else {
          var validate = await RecordController.validate(
              this.tableName!,
              beforeValidate['data'],
              MainController.getInfoTable(this.tableName!));
          if (validate == false) {
            var before = await HelperController.beforeUpdate(updatedRecord);
            if (before['status'] == false) {
              showSnackbar(snackTypes.error, before['messsage']);
            } else {
              Map<dynamic, dynamic> customUpdate = before['data'];
              // print('DB.updateRecords records index>>${records[allDataIndex]}');
              // var dataModelItem = DataModel(id: record.id, data: customUpdate);

              if (MainController.getStatusTable(this.tableName!) == true) {
                // await ConncetServerController.setDatabaseme(customUpdate);
                // var filterJson = await ConncetServerController.createJsonFilter(
                //     this.whereList.length != 0 ? this.whereList : this.orWhereList.length != 0 ? this.orWhereList
                //     : [],
                //     this.tableName!,
                //     this.whereList.length != 0
                //         ? '\$and'
                //         : this.orWhereList.length != 0
                //             ? '\$or'
                //             : '');

                Map<String, dynamic> setRecord = {
                  "table_name": '${this.tableName}',
                  "record": json.encode(customUpdate).toString(),
                  "record_id": id,
                };
                print('DB.updateRecords is>>>${setRecord}');
                updateRecordRes = await ConncetServerController.findAndUpdateRecordGeneral(setRecord);
                if (updateRecordRes.length != 0) {

                  DataModel record = DataModel(id: updateRecordRes['_id'], data: updateRecordRes);
                  if(boxIndex!=-1) {
                    await box.putAt(boxIndex, record);
                    MainController.renderData(this.tableName!, operation.update, record.data);
                  }else{
                    await box.add(record);
                  }

                } else {
                  request.addAll({
                    "sync": "false",
                    "sync_type": "update",
                    "server error": "Dont sync 'update' this record!",
                  });
                  var updateOffline = await updateRecordOfflineSchema(id,request);
                  updateRecordRes = Map<String, dynamic>.from(updateOffline);
                }
              }

              MainController.isClickedItem.value = true;
              var after = await HelperController.afterUpdate(this.tableName!, customUpdate);
              if (after['status'] == false) {
                showSnackbar(snackTypes.error, after['message']);
              }
              ViewController.isClickedEditBtn.value = false;
            }
          } else {
            showSnackbar(snackTypes.error, '${AppController.of(Get.context!)!.value('The operation encountered an error.')}');
          }
        }
      } else {
        showSnackbar(snackTypes.error, 'داده ها دارای مقادیر نادرستی هستند');
      }
    } catch (e, s) {
      print('DB.updateRecords catch>>${e.toString()}>>>${s}');
    }
    AppController.finishLoading('update-records');

    return updateRecordRes;
  }

  Future<List<Map<String, dynamic>>> updateRecords(Map<String, dynamic> request) async {
    AppController.startLoading('update-records');
    bool connectivity = await ConnectionController.checkConnectivity();
    List<Map<String, dynamic>> updateRecordRes=[];
    try {
      if (connectivity) {
        if (MainController.getStatusTable(this.tableName!)) {
          updateRecordRes = await updateRecordsOnlineSchema(request);
        } else {
          updateRecordRes = await updateRecordsOfflineSchema(request);
        }
      } else {
        updateRecordRes = await updateRecordsOfflineSchema(request);
      }
    } catch (e, s) {
      print('DB.updateRecords catch>>${e.toString()}>>>${s}');
    } finally {
      AppController.finishLoading('update-records');
    }

    return updateRecordRes;
  }

  Future<Map<String, dynamic>> findByIdAndUpdate(String id,Map<String, dynamic> request) async{
    AppController.startLoading('update-record');
    bool connectivity = await ConnectionController.checkConnectivity();
    Map<String, dynamic> updateRecordRes={};
    try {
      if (connectivity) {
        if (MainController.getStatusTable(this.tableName!)) {
          updateRecordRes = await updateRecordOnlineSchema(id,request);
        } else {
          updateRecordRes = await updateRecordOfflineSchema(id,request);
        }
      } else {
        updateRecordRes = await updateRecordOfflineSchema(id,request);
      }
    } catch (e, s) {
      print('DB.updateRecord catch>>${e.toString()}>>>${s}');
    } finally {
      AppController.finishLoading('update-record');
    }
    return updateRecordRes;
  }

  Future<bool> deleteItemAtIndex<T>(Box<T> box, int index) async {
    try {
      // بررسی اینکه index معتبر هست
      if (index < 0 || index >= box.length) return false;

      await box.deleteAt(index);

      // بررسی موفقیت حذف
      if (index >= box.length || box.getAt(index) == null) {
        return true; // حذف موفق
      } else {
        return false; // حذف انجام نشده
      }
    } catch (e) {
      print("خطا هنگام حذف: $e");
      return false;
    }
  }


  Future<Map<String, dynamic>> deleteRecordOfflineSchema(String id) async {
    Map<String, dynamic> deleteRecordRes = {};
    try {
      Map<String,dynamic> record = {};
      Box box = await Hive.openBox<DataModel>(MainController.apiKey.value + '${this.tableName}');
      var boxIndex=box.values.toList().indexWhere((element) => element.id==id);
      if (boxIndex!=-1) {
        record = (await getDataTypeOfFieldItem(box.values.toList()[boxIndex]));
      }
      else{
        showSnackbar(snackTypes.error, 'Record by id $id not found!');
        return {};
      }
      var before = await HelperController.beforeDelete(record);
      if (before['status'] == false) {
        showSnackbar(snackTypes.error, before['messsage']);
      } else {
        await box.deleteAt(boxIndex);
        MainController.renderData(this.tableName!, operation.delete, record);
        deleteRecordRes=Map<String,dynamic>.from(record);

        MainController.isClickedItem.value = true;
        var after = await HelperController.afterDelete( record);
        if (after['status'] == false) {
          showSnackbar(snackTypes.error, after['message']);
        }
        ViewController.isClickedEditBtn.value = false;
      }

    } catch (e, s) {
      print('DB.deleteRecord catch>>${e.toString()}>>>${s}');
    }
    AppController.finishLoading('delete-record');

    return deleteRecordRes;
  }
  Future<List<Map<String, dynamic>>> deleteRecordsOfflineSchema() async {
    List<Map<String, dynamic>> deleteRecordRes = [];
    try {
      List<Map<String,dynamic>> records = await getRecords();
      ViewController.isClickedEditBtn.value = true;
      Box box = await Hive.openBox<DataModel>(MainController.apiKey.value + '${this.tableName}');
      if (records.isEmpty) {
        records = (await getDataTypeOfFieldList(box.values.toList()));
      }

      for( var a in records) {
        var boxIndex=box.values.toList().indexWhere((element) => element.id==a['_id']);
        var before = await HelperController.beforeDelete(a);
        if (before['status'] == false) {
          showSnackbar(snackTypes.error, before['messsage']);
        } else {
          DataModel customData = box.values.toList()[boxIndex];
          print('DB.deleteRecordsOfflineSchema>>${MainController.getStatusTable(this.tableName!)}');
          if (MainController.getStatusTable(this.tableName!)==false) {
            await box.deleteAt(boxIndex);
            MainController.renderData(this.tableName!, operation.delete, customData.data);
            deleteRecordRes.add(Map<String, dynamic>.from(customData.data));
          }
          else {
            var request=({
              "sync": "false",
              "sync_type": "delete",
              "server error": "Dont sync 'delete' this record!",
            });
            print('DB.deleteRecordsOfflineSchema>>${customData.data['_id']}');
            var updateOffline = await updateRecordOfflineSchema(customData.data['_id'],request);
            deleteRecordRes.add(Map<String, dynamic>.from(updateOffline));
          }
          MainController.isClickedItem.value = true;
          var after = await HelperController.afterDelete( customData.data);
          if (after['status'] == false) {
            showSnackbar(snackTypes.error, after['message']);
          }
          ViewController.isClickedEditBtn.value = false;
        }
      }
    } catch (e, s) {
      print('DB.deleteRecords catch>>${e.toString()}>>>${s}');
    }
    AppController.finishLoading('delete-records');

    return deleteRecordRes;
  }

  Future<List<Map<String, dynamic>>> deleteRecordsOnlineSchema() async {
    List<Map<String, dynamic>> deleteRecordRes = [];
    try {
      // ViewController.isClickedEditBtn.value = true;
      Box box = await Hive.openBox<DataModel>(MainController.apiKey.value + '${this.tableName}');
      var before = await HelperController.beforeDelete(this.whereList);
      if (before['status'] == false) {
        showSnackbar(snackTypes.error, before['messsage']);
      } else {
        Map<dynamic, dynamic> customUpdate = before['data'];

        if (MainController.getStatusTable(this.tableName!) == true) {
          // await ConncetServerController.setDatabaseme(customUpdate);
          var filterJson = await ConncetServerController.createJsonFilter(this.whereList.length != 0 ? this.whereList : this.orWhereList.length != 0 ? this.orWhereList : [], this.tableName!, this.whereList.length != 0 ? '\$and' : this.orWhereList.length != 0 ? '\$or' : '');
          Map<String, dynamic> setRecord = {
            "table_name": '${this.tableName}',
            "filter": filterJson['filter']
          };
          deleteRecordRes = await ConncetServerController.deleteRecordsGeneral(setRecord);
          print('DB.deleteRecords is>>>${deleteRecordRes.length}');

          if (deleteRecordRes.length != 0) {
            for (var rec in deleteRecordRes) {
              var boxDataIndex = box.values.toList().indexWhere((element) => element.id == rec['_id']);
              if(boxDataIndex!=-1) {
                await box.deleteAt(boxDataIndex);
                MainController.renderData(this.tableName!, operation.delete, rec);
              }
              // else{
              //   DataModel model=DataModel(id:rec['_id'] ,data: rec);
              //   await box.add(rec);
              // }
            }
          }
          else {
            var request=({
              "sync": "false",
              "sync_type": "delete",
              "server error": "Dont sync 'delete' this record!",
            });
            var updateOffline = await updateRecordsOfflineSchema(request);
            deleteRecordRes = List<Map<String, dynamic>>.from(updateOffline);
          }
        }
        MainController.isClickedItem.value = true;
        var after = await HelperController.afterDelete( customUpdate);
        if (after['status'] == false) {
          showSnackbar(snackTypes.error, after['message']);
        }
        // ViewController.isClickedEditBtn.value = false;
      }

    } catch (e, s) {
      print('DB.deleteRecords catch>>${e.toString()}>>>${s}');
    }
    AppController.finishLoading('delete-records');

    return deleteRecordRes;
  }
  Future<Map<String, dynamic>> deleteRecordOnlineSchema(String id) async {
    Map<String, dynamic> deleteRecordRes = {};
    try {
      Box box = await Hive.openBox<DataModel>(MainController.apiKey.value + '${this.tableName}');
      var before = await HelperController.beforeDelete(this.whereList);
      if (before['status'] == false) {
        showSnackbar(snackTypes.error, before['messsage']);
      } else {
        Map<dynamic, dynamic> customUpdate = before['data'];

        if (MainController.getStatusTable(this.tableName!) == true) {
          Map<String, dynamic> setRecord = {
            "table_name": '${this.tableName}',
            "record_id": id,
          };
          deleteRecordRes = await ConncetServerController.findByIdAndDelete(setRecord);
          print('DB.deleteRecords is>>>${deleteRecordRes.length}');

          if (deleteRecordRes.length != 0) {
            var boxDataIndex = box.values.toList().indexWhere((element) => element.id == deleteRecordRes['_id']);
            if(boxDataIndex!=-1) {
              await box.deleteAt(boxDataIndex);
              MainController.renderData(this.tableName!, operation.delete, deleteRecordRes);
            }else{
              await box.add(deleteRecordRes);
            }
          } else {
            var request=({
              "sync": "false",
              "sync_type": "delete",
              "server error": "Dont sync 'delete' this record!",
            });
            var updateOffline = await updateRecordOfflineSchema(id,request);
            deleteRecordRes = Map<String, dynamic>.from(updateOffline);
          }
        }
        MainController.isClickedItem.value = true;
        var after = await HelperController.afterDelete( customUpdate);
        if (after['status'] == false) {
          showSnackbar(snackTypes.error, after['message']);
        }
        // ViewController.isClickedEditBtn.value = false;
      }

    } catch (e, s) {
      print('DB.deleteRecord catch>>${e.toString()}>>>${s}');
    }
    AppController.finishLoading('delete-record');

    return deleteRecordRes;
  }

  Future<bool> deleteRecord() async {
    AppController.startLoading('delete-records');
    bool connectivity = await ConnectionController.checkConnectivity();
    List<Map<String, dynamic>> deleteRecordRes=[];
    try {
      if (connectivity) {
        if (MainController.getStatusTable(this.tableName!)) {
          deleteRecordRes = await deleteRecordsOnlineSchema();
        } else {
          deleteRecordRes = await deleteRecordsOfflineSchema();
        }
      } else {
        deleteRecordRes = await deleteRecordsOfflineSchema();
      }
    } catch (e, s) {
      print('DB.deleteRecord catch>>${e.toString()}>>>${s}');
    } finally {
      AppController.finishLoading('delete-records');
    }

    return deleteRecordRes.length!=0?true:false;
  }
  Future<bool> findByIdAndDelete(String id) async{
    AppController.startLoading('delete-record');
    bool connectivity = await ConnectionController.checkConnectivity();
    Map<String, dynamic> deleteRecordRes={};
    try {
      if (connectivity) {
        if (MainController.getStatusTable(this.tableName!)) {
          deleteRecordRes = await deleteRecordOnlineSchema(id);
        } else {
          deleteRecordRes = await deleteRecordOfflineSchema(id);
        }
      } else {
        deleteRecordRes = await deleteRecordOnlineSchema(id);
      }
    } catch (e, s) {
      print('DB.deleteRecord catch>>${e.toString()}>>>${s}');
    } finally {
      AppController.finishLoading('delete-record');
    }
    return deleteRecordRes.isNotEmpty;
  }

}

class Where {
  String? fieldName;
  String? operator;
  var value;

  Where(String? fieldName, String? operator, var value) {
    this.value = value;
    this.operator = operator;
    this.fieldName = fieldName;
    this;
  }
}
