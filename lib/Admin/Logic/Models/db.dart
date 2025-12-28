import 'dart:convert';
import 'dart:ffi';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/connection-controller.dart';
import 'package:finance/Admin/Logic/Controllers/validator-controller.dart';
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
  static Map<String, Map<String,dynamic>> parentItem =<String,Map<String,dynamic>>{};
  int counter = 0;
  List<Where> w = [];

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

  paginate() async {
    // MainController.tableData.value =[];
    MainController.endIndex.value = 0;
    MainController.startIndex.value = 0;
    var infoTable =
        await MainController.getInfoTable('${this.tableName}')['schema'];
    int countShowRow = infoTable['countShowRow'];
    int currentPage = infoTable['currentPage'];
    int perPage = countShowRow != null ? countShowRow : 10;
    int s = (currentPage - 1) * perPage;
    List<Map<String, dynamic>> getRecord = await getRecords();
    var totalItems = getRecord.length;
    // MainController.totalItems.value = totalItems;
    var end = s + perPage;
    MainController.startIndex.value = s;
    var endBycondition = end >= totalItems ? totalItems : end;
    MainController.endIndex.value = endBycondition;
    var data = [];
    if (infoTable['online'] == true) {
      data = getRecord;
    } else {
      MainController.totalItems.value = totalItems;
      data = getRecord.skip(s).take(perPage).toList();
    }
    return data;
  }

  infoPage() async {
    int countShowRow =
        await MainController.getInfoTable('${this.tableName}')['schema']
            ['countShowRow'];
    int perPage = countShowRow != null ? countShowRow : 10;
    int totalItems = MainController.totalItems.value;
    int totalPage = (totalItems / perPage).ceil();
    return totalPage;
  }

  getRecords() async {
    AppController.startLoading('get-records');
    await ConnectionController.checkConnectivity();
    List<Map<String, dynamic>> dataItems = [];
    Box box;
    List<Map<String, dynamic>> data = [];
    ConncetServerController.getRecordRes.value = [];
    int index = MainController.SubMenuList.indexWhere(
        (element) => element['schema']['name'] == '${this.tableName}');

    data = [];
    if (MainController.SubMenuList[index]['schema']['online'] == true) {
      if (parentItem.containsKey(this.tableName) && parentItem.length != 0) {
        where('parent_id', '\$eq', parentItem[this.tableName]!['parent_id']);
      } else {
        // where('parent_id', '\$eq', null);
        // await ConncetServerController.getRecordGeneral('${tableName}');
        // dataItems = ConncetServerController.getRecordRes.cast<Map<String, dynamic>>();
        // for(var s in dataItems){
        //   print(s['parent_id']);
        //   print(s['parent_id'].runtimeType);
        // }
      }
      if (this.whereList.length == 0 && this.orWhereList.length == 0) {
        List<Map<String, dynamic>> dataItems = [];
        await ConncetServerController.filterRecordGeneral([], this.tableName!, '\$or');
        dataItems =
            ConncetServerController.filterRecordRes.cast<Map<String, dynamic>>();
        if (dataItems.isNotEmpty) {
          data = dataItems;
          var tableInfo = MainController.SubMenuList[index];
          box = await Hive.openBox<DataModel>(
              MainController.apiKey.value + '${tableInfo['schema']['name']}');
          var boxList = box.values.toList();
          for (var item in boxList) {
            if (item.data['sync'] == 'false') {
              data.add(await getDataTypeOfFieldItem(item));
            }
          }
        } else {
          var tableInfo = MainController.SubMenuList[index];
          box = await Hive.openBox<DataModel>(
              MainController.apiKey.value + '${tableInfo['schema']['name']}');
          data = (await getDataTypeOfFieldList(box.values.toList()));
        }
      } else {
        var tableInfo = MainController.SubMenuList[index];
        box = await Hive.openBox<DataModel>(
            MainController.apiKey.value + '${tableInfo['schema']['name']}');
        data.addAll(await getDataTypeOfFieldList(box.values.toList()));
      }
    } else {
      var tableInfo = MainController.SubMenuList[index];
      box = await Hive.openBox<DataModel>(
          MainController.apiKey.value + '${tableInfo['schema']['name']}');
      data = await getDataTypeOfFieldList(box.values.toList());
    }
    if (index != -1) {
      // if (parentItem.length != 0) {
      //   data = data
      //       .where((element) => element['parent_id'] == parentItem['parent_id'])
      //       .toList();
      // }
      if (this.orWhereList.length != 0) {
        if (MainController.SubMenuList[index]['schema']['online'] == true) {
          await ConncetServerController.filterRecordGeneral(
              this.orWhereList, this.tableName!, '\$or');
          if (ConncetServerController.filterRecordRes.isNotEmpty) {
            dataItems = ConncetServerController.filterRecordRes;
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
          if (MainController.SubMenuList[index]['schema']['online'] == true &&
              ConnectionController.checkConnection.value == true) {
            await ConncetServerController.filterRecordGeneral(
                this.whereList, this.tableName!, '\$and');
            if (ConncetServerController.filterRecordRes.isNotEmpty) {
              dataItems = ConncetServerController.filterRecordRes;
            }
          } else {
            if (data.length != 0) {
              for (var d in data) {

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
  }

  // getRecord({bool withFormat = true}) async {
  //   Map<String, dynamic> dataItems = {};
  //   Box box;
  //   Map<String, dynamic> data = {};
  //   int index = MainController.SubMenuList.indexWhere(
  //           (element) => element['schema']['name'] == '${this.tableName}');
  //   if (MainController.SubMenuList[index]['schema']['online'] == true ) {
  //     if(this.whereList.length==0 && this.orWhereList.length==0) {
  //       // await ConncetServerController.getRecordGeneral('${tableName}');
  //       // if (ConncetServerController.getRecordRes.isNotEmpty) {
  //       //   data =
  //       //       ConncetServerController.getRecordRes.cast<Map<String, dynamic>>();
  //       // }
  //     }
  //   } else {
  //     var tableInfo = MainController.SubMenuList[index];
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
  //       if (MainController.SubMenuList[index]['online'] == true) {
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
  //         if (MainController.SubMenuList[index]['schema']['online'] == true) {
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
  parent({var parentTable = null, var parentId = null}) {
    parentItem = {};
    if (parentTable != null && parentId != null) {
      var json = {this.tableName!:
        {'parent_table': parentTable, 'parent_id': parentId}
      };
      parentItem = json;
    } else
      parentItem = {};

    return this;
  }

  Future<void> storeRecord(Map<dynamic, dynamic> request) async {
    AppController.startLoading('store-record');
    try {
      Box box = await Hive.openBox<DataModel>(
          MainController.apiKey.value + '${this.tableName}');
      ViewController.isClickedBtn.value = true;
      var Id = Uuid().v4();

      Map<String, dynamic> newRequest = Map.from(request);
      var columns = MainController.getColumnsTable('${this.tableName}');
      for (var col in columns) {
        if (newRequest.containsKey(col['name'])) {
          if (col['type'] == 'select' || col['type'] == 'radioButton') {
            if(newRequest[col['name']] is Map){
              if(col['source_items']=='custom'){
                newRequest[col['name']]=newRequest[col['name']]['value'];
              }
            }
          }
        }
      }
      newRequest['parent_table']=newRequest['parent_table']==""?null:newRequest['parent_table'];
      newRequest['parent_id']=newRequest['parent_id']==""?null:newRequest['parent_id'];
      if (ValidatorController.validateByType(newRequest, '${this.tableName}') == true) {
        List<dynamic> columns = MainController.getColumnsList('${this.tableName}');
        for (var column in columns) {
          if (!newRequest.keys.contains(column)) {
            newRequest.addAll({'${column}': null});
          }
        }
        if (parentItem.containsKey(this.tableName)&&parentItem[this.tableName] != {}) {
          newRequest.addAll(parentItem[this.tableName]!);
        }
        newRequest.addAll({
          "sync": "false",
          "server error": "Dont sync this record!",
        });
        DataModel newData = DataModel(
            id: newRequest.keys.contains('_id')
                ? request['_id'].toString()
                : '${Id}',
            data: newRequest);
        var beforValidate = HelperController.beforeStoreValidation(newData);
        if (beforValidate['status'] == false) {
          showSnackbar(snackTypes.error, beforValidate['message']);
        } else {
          if (await RecordController.validate(this.tableName!, newData, MainController.getInfoTable(this.tableName!)) == false) {

            var before = await HelperController.beforeStore(newData);
            if (before['status'] == false) {
              showSnackbar(snackTypes.error, before['message']);
            } else {
              DataModel customData = await HelperController.beforeStore(newData)['data'];
              if (customData.data.keys.contains('_id')) {
                customData.data['_id'] = null;
              }
              Map<String, dynamic> setRecord = {
                "table_name": '${this.tableName}',
                "record": json.encode(customData.data).toString(),
              };
              if (MainController.getStatusTable(this.tableName!) == true) {

                await ConncetServerController.storeRecordGeneral(setRecord);
                Box box = await Hive.openBox<DataModel>(
                    MainController.apiKey.value + '${this.tableName}');
                if (ConncetServerController.storeRecordRes.isNotEmpty) {

                  if (request.containsKey('_id')) {
                    var tableDataIndex = box.values
                        .toList()
                        .indexWhere((element) => element.id == request['_id']);
                    if (tableDataIndex != -1) {
                      await box.deleteAt(tableDataIndex);
                      // MainController.renderData(operation.delete,box.values.toList()[tableDataIndex].data);
                    } else {
                      DataModel recordStored = DataModel(
                          id: '${ConncetServerController.storeRecordRes['_id']}',
                          data: ConncetServerController.storeRecordRes);
                      await box.add(recordStored);
                      // MainController.renderData(operation.store,recordStored.data);
                    }
                  } else {
                    DataModel recordStored = DataModel(
                        id: '${ConncetServerController.storeRecordRes['_id']}',
                        data: ConncetServerController.storeRecordRes);
                    await box.add(recordStored);
                    // MainController.renderData(operation.store,recordStored.data);
                  }
                } else {

                  customData.data['sync'] = 'false';

                  if (request.containsKey('_id')) {
                    if (box.values.toList().indexWhere((element) => element.id == request['_id']) == -1) {
                      await box.add(customData);
                      // MainController.renderData(operation.store,customData.data);
                    }
                  } else {
                    await box.add(customData);
                    // MainController.renderData(operation.store,customData.data);
                  }
                }
              }
              else {
                await box.add(customData);
                // MainController.renderData(operation.store,customData.data);
              }
              var afterData = await HelperController.afterStore(
                  this.tableName!, newRequest, customData);
              if (afterData['status'] == false) {
                showSnackbar(snackTypes.error, afterData['message']);
              }
              // MainController.renderData(operation.store,data);
              MainController.goToTablePage(MainController
                  .SubMenuList[
              MainController
                  .selectedSubItem
                  .value]);
              ViewController.isClickedBtn.value = false;
              request = {};
              newRequest = {};
            }

          } else {
            showSnackbar(snackTypes.error,
                "${AppController.of(Get.context!)!.value('error')}");
          }
        }
      } else {
        showSnackbar(snackTypes.error, 'داده ها دارای مقادیر نادرستی هستند');
      }
      AppController.finishLoading('store-record');
    } catch (err) {
      showSnackbar(snackTypes.error, 'عملیات با خطا مواجه شد');
    }
  }

  convertFormatUpdate(var value, var key, var a) {
    if (value is List) {
      var sourceItem = MainController.getDetailsOfField(
          '${this.tableName}', key)['source_items'];
      if (sourceItem == 'custom') {
        List<String> idList = [];
        for (int i = 0; i < value.length; i++) {
          idList.add(value[i]['value']);
        }
        a[key] = idList;
      } else {
        List<String> idList = [];
        for (int i = 0; i < value.length; i++) {
          idList.add(value[i]['_id']);
        }
        a[key] = idList;
      }
    }
    if (value is Map) {
      var sourceItem = MainController.getDetailsOfField(
          '${this.tableName}', key)['source_items'];
      if (sourceItem == 'custom') {
        a[key] = value['value'];
      } else {
        a[key] = value['_id'];
      }
    }
  }

  updateRecords(Map<String, dynamic> request) async {
    print('request before>>>${request}');
    AppController.startLoading('update-records');
    List<dynamic> records = await getRecords();
    print('records>>>${records}');
    ViewController.isClickedEditBtn.value = true;
    Box box = await Hive.openBox<DataModel>(
        MainController.apiKey.value + '${this.tableName}');
    Map<String, dynamic> a = {};

    List<Map<String, dynamic>> toAdd = [];

    for (var data in records) {
      a = data;
      print('a list>>>${a}');
      for (var item in request.keys) {
        // if (!a.containsKey(item)) {
          a[item] = request[item];
        // }

      }

      a.forEach((key, value) {
        if (MainController.getDetailsOfField('${this.tableName}', key) !=
            null) {
          print('value aaaa>>>${value}');
          if (value is List) {
            var sourceItem = MainController.getDetailsOfField(
                '${this.tableName}', key)['source_items'];
            if (sourceItem == 'custom') {
              List<String> idList = [];
              for (int i = 0; i < value.length; i++) {
                idList.add(value[i]['value']);
              }
              a[key] = idList;
            } else {
              List<String> idList = [];
              for (int i = 0; i < value.length; i++) {
                if (value[i] is Map) {
                  if (value[i]['_id'] != null) {
                    idList.add(value[i]['_id']);
                  }
                } else {
                  idList.add(value[i]);
                }
              }
              a[key] = idList;
            }
          }
          print('request after>>>${request}');
          print('a[key] by map>>>${a[key]}');
          if (value is Map) {

            var sourceItem = MainController.getDetailsOfField(
                '${this.tableName}', key)['source_items'];
            if (sourceItem == 'custom') {
              a[key] = value['value'];
            } else {
              a[key] = value['_id'];
            }
          }
        }

        if (request.containsKey(key)) {
          // a[key] = request[key];
          request[key] = a[key];

        } else {
          // check key exist in records if not add!.
          toAdd.add({request.keys.first: request.values.first});
        }
      });
    }
    print('a order item>>>${a}');
    final record = DataModel(id: a['_id'], data: a);

    if (ValidatorController.validateByType(a, '${this.tableName}') == true) {
      var beforeValidate =
          await HelperController.beforeUpdateValidation(record);
      if (beforeValidate['status'] == false) {
        showSnackbar(snackTypes.error, beforeValidate['message']);
      } else {
        var validate = await RecordController.validate(this.tableName!, record,
            MainController.getInfoTable(this.tableName!));
        print('validate item>>>${validate}');

        if (validate == false) {
          var before = await HelperController.beforeUpdate(record);
          print('before[status]>>>${before['status']}');
          if (before['status'] == false) {
            showSnackbar(snackTypes.error, before['messsage']);
          } else {
            var customUpdate =
                await HelperController.beforeUpdate(record)['data'];
            var allDataIndex =
                records.indexWhere((element) => element['_id'] == a['_id']);
            print('records update>>>${records}');
            print('allDataIndex>>>${allDataIndex}');
            if (MainController.getStatusTable(this.tableName!) == true) {
              await ConncetServerController.setDatabaseme(customUpdate.data);
              Map<String, dynamic> setRecord = {
                "table_name": '${this.tableName}',
                "record": json.encode(customUpdate.data).toString(),
                "record_id": customUpdate.id
              };
              await ConncetServerController.updateRecordGeneral(setRecord);
              if (ConncetServerController.updateRecordRes.isNotEmpty) {
                DataModel record = DataModel(
                    id: ConncetServerController.updateRecordRes['_id'],
                    data: ConncetServerController.updateRecordRes);
                await box.putAt(allDataIndex, record);
                MainController.renderData(operation.update, record.data);
              } else {
                await box.putAt(allDataIndex, customUpdate);
                MainController.renderData(operation.update, customUpdate.data);
              }
            } else {
              await box.putAt(allDataIndex, customUpdate);
              MainController.renderData(operation.update, customUpdate.data);
            }

            MainController.isClickedItem.value = true;
            var after = await HelperController.afterUpdate(
                this.tableName!, customUpdate);
            if (after['status'] == false) {
              showSnackbar(snackTypes.error, after['message']);
            }
            // ViewController.isClickedEditBtn.value = false;
          }
        } else {
          showSnackbar(snackTypes.error,
              '${AppController.of(Get.context!)!.value('The operation encountered an error.')}');
        }
      }
    } else {
      showSnackbar(snackTypes.error, 'داده ها دارای مقادیر نادرستی هستند');
    }
    AppController.finishLoading('update-records');
  }

  // updateRecord(Map<String, dynamic> request) async {
  //   List<dynamic> allData = [];
  //   // Map<String,dynamic> recordItem = await getRecord();
  //   ViewController.isClickedEditBtn.value = true;
  //   Box box = await Hive.openBox<DataModel>('${this.tableName}');
  //   allData = box.values.toList();
  //   List<Map<String, dynamic>> toAdd = [];
  //
  //   recordItem.forEach((key, value) {
  //     convertFormatUpdate( value, key, recordItem);
  //     if (request.containsKey(key)) {
  //       recordItem[key] = request[key];
  //     } else {
  //       // check key exist in records if not add!.
  //       toAdd.add({request.keys.first: request.values.first});
  //     }
  //   });
  //   final record = DataModel(id: recordItem['_id'], data: recordItem);
  //   var beforeValidate = await HelperController.beforeUpdateValidation(record);
  //   if (beforeValidate['status'] == false) {
  //     showSnackbar(snackTypes.error, beforeValidate['message']);
  //   } else {
  //     var validate = await RecordController.validate(this.tableName!, record,
  //         MainController.getInfoTable(this.tableName!));
  //     if (validate == false) {
  //       var before = await HelperController.beforeUpdate(record);
  //       if (before['status'] == false) {
  //         showSnackbar(snackTypes.error, before['messsage']);
  //       } else {
  //         var customUpdate =
  //         await HelperController.beforeUpdate(record)['data'];
  //         var allDataIndex = allData.indexWhere((element) => element.id == recordItem['_id']);
  //         allData[allDataIndex] = customUpdate;
  //         if (MainController.getStatusTable(this.tableName!) == true) {
  //           await ConncetServerController.setDatabaseme(customUpdate.data);
  //           Map<String, dynamic> setRecord = {
  //             "table_name": '${this.tableName}',
  //             "record": json.encode(customUpdate.data).toString(),
  //             "record_id": customUpdate.id
  //           };
  //           if (MainController.getStatusTable(this.tableName!) == true) {
  //             await ConncetServerController.updateRecordGeneral(setRecord);
  //             if (ConncetServerController.updateRecordRes.isNotEmpty) {
  //               DataModel record = DataModel(
  //                   id: ConncetServerController.updateRecordRes['_id'],
  //                   data: ConncetServerController.updateRecordRes);
  //               await box.putAt(allDataIndex, record);
  //             }
  //           }
  //         } else {
  //           await box.putAt(allDataIndex, customUpdate);
  //         }
  //         MainController.isClickedItem.value = true;
  //         var after =
  //         await HelperController.afterUpdate(this.tableName!, customUpdate);
  //         if (after['status'] == false) {
  //           showSnackbar(snackTypes.error, after['message']);
  //         }
  //         await MainController.loadData(
  //             tableData: MainController.getInfoTable(this.tableName!));
  //         ViewController.isClickedEditBtn.value = false;
  //       }
  //     } else {
  //       showSnackbar(snackTypes.error,
  //           '${AppController.of(Get.context!)!.value('The operation encountered an error.')}');
  //     }
  //   }
  // }

  deleteRecord() async {
    AppController.startLoading('delete-record');
    List<dynamic> records = await getRecords();
    Box box = await Hive.openBox<DataModel>(
        MainController.apiKey.value + '${this.tableName}');
    var boxList = box.values.toList();
    var relations = MainController.getInfoTable(this.tableName!);
    // print("records >>>${records.length}");
    for (var data in records) {
      var tableDataIndex = boxList.indexWhere((element) => element.id == data['_id']);
      // var before = await HelperController.beforeDelete(tableDataIndex);
      //
      // if (before['status'] == false) {
      //   showSnackbar(snackTypes.error, before['message']);
      // }
      // else {
      if (MainController.getStatusTable(this.tableName!) == true) {
        await ConncetServerController.deleteRecordGeneral(
            {"table_name": '${this.tableName}', 'record_id': data['_id']});
        if (ConncetServerController.deleteRecordRes == true) {
          if (relations['schema']['relations'] != null &&
              relations['schema']['relations'].length != 0) {
            for (var relation in relations['schema']['relations']) {
              // DB(relation['schema']['name'])
              //     .where('parent_id', '\$eq', data['_id'])
              //     .deleteRecord();
              DB(relation)
                  .where('parent_id', '\$eq', data['_id'])
                  .deleteRecord();
            }
          }
          if (tableDataIndex != -1) {
            box.deleteAt(tableDataIndex);
          }
          MainController.renderData(operation.delete, data);
          // await MainController.loadData();
        } else {
          showSnackbar(snackTypes.error, 'error');
        }
      } else {
        if (tableDataIndex != -1) {
          box.deleteAt(tableDataIndex);
          if (relations['schema']['relations'].length != 0) {
            for (var relation in relations['schema']['relations']) {
              DB(relation)
                  .where('parent_id', '\$eq', data['_id'])
                  .deleteRecord();
            }
          }
          MainController.renderData(operation.delete, data);
        }
      }
      // DataModel item = box.values.toList()[tableDataIndex];

      // var after = HelperController.afterDelete(tableDataIndex, item);
      // if (after['status'] == false) {
      //   showSnackbar(snackTypes.error, after['message']);
      // }
    // }
    }
    AppController.finishLoading('delete-record');
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
