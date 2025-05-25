import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Models/dataModel.dart';
import 'package:finance/Logic/Models/db.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Form/form-checkBox.dart';
import 'package:finance/UI/Componenets/Items/Form/form-color.dart';
import 'package:finance/UI/Componenets/Items/Form/form-date.dart';
import 'package:finance/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:finance/UI/Componenets/Items/Form/form-radio-button.dart';
import 'package:finance/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/UI/Componenets/Items/Form/form-time.dart';
import 'package:finance/boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:finance/Logic/Controllers/dataController.dart';
import '../../UI/Componenets/Items/Form/form-file.dart';

class ViewController extends GetxController {
  static Rx<String> selectedRadioButton = ''.obs;
  static Rx<bool> isClickedBtn = false.obs;
  static Rx<bool> isClickedEditBtn = false.obs;
  static Map<String, List<int>> fileSizeList = {};
  static Map<String, dynamic> request = {};
  static Map<String, dynamic> requestMultiSelect = <String, dynamic>{};
  static Map<String, dynamic> request2 = {};

  static Future<Widget> generateFilterView(
      Map<String, dynamic> columnName) async {
    var columnInfo = MainController.getColumnInfo(columnName['column']);

    Widget child = (await generateFilterFormView([columnInfo]));

    return child;
  }

  static Future<Widget> generateFilterFormView(var columns) async {
    var children = <Widget>[];
    var textField;
    var selectBox;
    var dateBox;
    var multiSelectBox;
    var colorBox;
    var fileBox;

    for (var j = 0; j < columns.length; j++) {
      print('ViewController.generateStoreFormView>>${columns}');
      if (columns[j]['is-show-store'] == true) {
        var column = columns[j];
        print('column table>>>${column}');
        var type = column['type'];
        GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
        GlobalKey<FormBuilderState> _fbKey2 = GlobalKey<FormBuilderState>();
        var maxValidator;
        var minValidator;
        if (column['validators'] != null) {
          maxValidator = column['validators'].firstWhere(
                  (validator) => validator['type'] == 'max',
              orElse: () => null);
          minValidator = column['validators'].firstWhere(
                  (validator) => validator['type'] == 'min',
              orElse: () => null);
        }
        if (type == 'string' ||
            type == 'int' ||
            type == 'Number double' ||
            type == 'Number int' ||
            type == 'email' ||
            type == 'mobile') {
          textField = generateFormTextField(_fbKey, column, type, '');
          children.add(SizedBox(
            height: 20,
          ));
          children.add(textField);
        }

        if (type == 'select') {
          List<dynamic> items = await itemsList(column);
          print('items 200>>>${items}');
          selectBox = await generateStoreFormSelectBox(
              column, items, '', '', false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(selectBox);
        } else if (type == 'checkbox') {
          children.add(
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Txt(
                  '${column['title']}',
                  color: MainController.isLightMode.value == true
                      ? whiteColor
                      : color2,
                ),
                SelectBox(
                    name: '${column['title']}',
                    column: column,
                    items: [
                      DropdownMenuItem(
                        child: Obx(() {
                          return Txt(
                            'انتخاب نشده',
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : primaryDark,
                          );
                        }),
                        value: '',
                      ),
                      DropdownMenuItem(
                        child: Obx(() {
                          return Txt(
                            'فعال',
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : primaryDark,
                          );
                        }),
                        value: 'true',
                      ),
                      DropdownMenuItem(
                          child: Obx(() {
                            return Txt(
                              'غیر فعال',
                              color: MainController.isLightMode.value == true
                                  ? whiteColor
                                  : primaryDark,
                            );
                          }),
                          value: 'false'),
                    ],
                    initalValue: '',
                    onChanged: (value) async {
                      print('selected item ${value}');

                      if (value != 'true') {
                        ViewController.request[column['name']] = false;
                      } else {
                        ViewController.request[column['name']] = true;
                      }
                    },
                    hintText: '',
                    isSeleted: false.obs,
                    selectedValue: ''),
              ],
            ),
          );
        } else if (type == 'radiobutton') {
          List<dynamic> items = await itemsList(column);
          print('items 200>>>${items}');
          selectBox = await generateStoreFormSelectBox(
              column, items, '', '', false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(selectBox);
        } else if (type == 'date') {
          dateBox = Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Txt(
                      '${column['title']}',
                      color: MainController.isLightMode.value == true
                          ? whiteColor
                          : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  DateBox(
                    selectedDate: Jalali.now(),
                    isSeletedDate: false.obs,
                    onDateChanged: (date) {
                      // dataJson[columnName] =  date;
                      ViewController.request[column['name']] = date;
                    },
                    column: column,
                  ),
                ],
              )
            ],
          );
          children.add(SizedBox(
            height: 20,
          ));
          children.add(dateBox);
        } else if (type == 'multiSelect') {
          List<dynamic> items = await itemsList(column);
          print('items items>>${items}');
          if (items.length != 0) {
            multiSelectBox = await generateStoreFormSelectBox(
                column, items, '', '', false.obs);
            ;
            children.add(SizedBox(
              height: 20,
            ));
            children.add(multiSelectBox);
          }
        } else if (type == 'color') {
          colorBox = generateFormColorBox(column, Colors.blue, false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(colorBox);
        } else if (type == 'file') {
          fileBox = generateFileBox('', column, false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(fileBox);
        }
      }
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  static Future<Widget> generateStoreFormView(var columns) async {
    var children = <Widget>[];
    var textField;
    var selectBox;
    var checkBox;
    var radioButtonBox;
    var dateBox;
    var multiSelectBox;
    var colorBox;
    var fileBox;
    var timeBox;

    for (var j = 0; j < columns.length; j++) {
      print('ViewController.generateStoreFormView>>${columns}');
      if (columns[j]['is-show-store'] == true) {
        var column = columns[j];
        print('column table>>>${column}');
        var type = column['type'];
        String name = column['title'];

        GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
        GlobalKey<FormBuilderState> _fbKey2 = GlobalKey<FormBuilderState>();
        var maxValidator;
        var minValidator;
        if (column['validators'] != null) {
          maxValidator = column['validators'].firstWhere(
                  (validator) => validator['type'] == 'max',
              orElse: () => null);
          minValidator = column['validators'].firstWhere(
                  (validator) => validator['type'] == 'min',
              orElse: () => null);
        }
        if (type == 'string' ||
            type == 'int' ||
            type == 'Number double' ||
            type == 'Number int' ||
            type == 'email' ||
            type == 'mobile') {
          textField = generateFormTextField(_fbKey, column, type, '');
          children.add(SizedBox(
            height: 20,
          ));
          children.add(textField);
        }
        if (type == 'select') {
          var initValue;
          List<dynamic> items = await itemsList(column);
          print('items 200>>>${items}');
          selectBox = await generateStoreFormSelectBox(
              column, items, '', '', false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(selectBox);
        } else if (type == 'checkbox') {
          checkBox = generateFormCheckBox(column, false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(checkBox);
        } else if (type == 'radiobutton') {
          var initValue;
          List<dynamic> items = await itemsList(column);
          // initValue = await getInitValue(column,items);
          radioButtonBox =
              generateFormRadioButton(column, items, '', false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(radioButtonBox);
        } else if (type == 'date') {
          dateBox = generateFormDateBox(column, Jalali.now(), false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(dateBox);
        } else if (type == 'multiSelect') {
          // print('items items>>${items}');
          // if(items.length != 0){
          multiSelectBox = await genarateStoreFormMuiltiSelectBox(
              column, RxString(''), <dynamic>[].obs, false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(multiSelectBox);
          // }
        } else if (type == 'color') {
          colorBox = generateFormColorBox(column, Colors.blue, false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(colorBox);
        } else if (type == 'file') {
          fileBox = generateFileBox('', column, false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(fileBox);
        } else if (type == 'time') {
          timeBox = generateFormTimeBox(column, TimeOfDay.now(), false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(timeBox);
        }
      }
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  static Future<Widget> generateEditFormView(
      Map<String, dynamic> dataModel) async {
    var children = <Widget>[];
    var textField;
    var selectBox;
    var checkBox;
    var radioButtonBox;
    var dateBox;
    var multiSelectBox;
    var colorBox;
    var fileBox;
    var timeBox;
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      if (MainController.tableInfo['columns'][j]['is-show-edit'] == true) {
        var column = MainController.tableInfo['columns'][j];
        var type = column['type'];
        var name = column['title'];
        var maxValidator;
        var minValidator;
        List<dynamic> items = [];
        if (column['validators'] != null) {
          maxValidator = column['validators'].firstWhere(
                  (validator) => validator['type'] == 'max',
              orElse: () => null);
          minValidator = column['validators'].firstWhere(
                  (validator) => validator['type'] == 'min',
              orElse: () => null);
        }
        if (type == 'string' ||
            type == 'int' ||
            type == 'Number double' ||
            type == 'Number int' ||
            type == 'email' ||
            type == 'mobile') {
          GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
          textField = generateFormTextField(_fbKey, column, type,
              '${dataModel['${name}'] != null ? dataModel['${name}'] : ''}');
          children.add(SizedBox(
            height: 20,
          ));
          children.add(textField);
        }
        else if (type == 'select') {
          Map<String, dynamic> selectedItem = <String, dynamic>{};
          var items = await ViewController.itemsList(column);
          if (items.length != 0) {
            if (column['sourceItems'] != 'custom') {
              if (dataModel[name] != null)
                selectedItem = items
                    .firstWhere((element) => element['id'] == dataModel[name]);
              selectBox = await generateStoreFormSelectBox(
                  column,
                  items,
                  '${selectedItem.isNotEmpty ? selectedItem['id'] != null
                      ? selectedItem['id']
                      : '' : ''}',
                  '${selectedItem.isNotEmpty ? selectedItem['id'] != null
                      ? selectedItem['id']
                      : '' : ''}',
                  dataModel[name] == '' ? false.obs : true.obs);
            } else {
              if (dataModel[name] != null)
                selectedItem = items.firstWhere(
                        (element) => element['value'] == dataModel[name]);
              selectBox = await generateStoreFormSelectBox(
                  column,
                  items,
                  '${selectedItem.isNotEmpty ? selectedItem['value'] != null
                      ? selectedItem['value']
                      : '' : ''}',
                  '${selectedItem.isNotEmpty ? selectedItem['value'] != null
                      ? selectedItem['value']
                      : '' : ''}',
                  dataModel[name] == '' ? false.obs : true.obs);
            }
            children.add(SizedBox(
              height: 20,
            ));
            children.add(selectBox);
          }
        }
        else if (type == 'checkbox') {
          checkBox = generateFormCheckBox(
              column,
              dataModel[name] == '' || dataModel[name] == null
                  ? false.obs
                  : true.obs,
              defultValue: dataModel['${name}']);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(checkBox);
        }
        else if (type == 'radiobutton') {
          List<dynamic> items = await itemsList(column);
          if (items.length != 0) {
            Map<String, dynamic> selectedRadioButton = items.firstWhere(
                    (element) => element['value'] == dataModel['${name}'],
                orElse: () => items.first);
            if (dataModel[name] != selectedRadioButton['value']) {
              dataModel[name] = '';
            }
            radioButtonBox = generateFormRadioButton(
                column,
                items,
                selectedRadioButton['value'],
                dataModel[name] == '' ? false.obs : true.obs);
            children.add(SizedBox(
              height: 20,
            ));
            children.add(radioButtonBox);
          }
        }
        else if (type == 'date') {
          List<String>? dateParts;
          int year = Jalali
              .now()
              .year;
          int month = Jalali
              .now()
              .month;
          int day = Jalali
              .now()
              .day;
          if (dataModel['${name}'] != null) {
            dateParts = dataModel['${name}'].split('/');
            year = int.parse('${dateParts![0]}');
            month = int.parse('${dateParts[1]}');
            day = int.parse('${dateParts[2]}');
          }
          dateBox = generateFormDateBox(
              column,
              Jalali(year, month, day),
              dataModel['${name}'] == null || dataModel['${name}'] == ''
                  ? false.obs
                  : true.obs);

          children.add(SizedBox(
            height: 20,
          ));
          children.add(dateBox);
        }
        else if (type == 'multiSelect') {
          print('dataModel multi is>>${dataModel}');
          List<dynamic> items =
          await ViewController.itemsList(column, dataModel: dataModel);
          print('items id>>>#${items}');
          if (items.length != 0) {
            List<dynamic> multiSelectedItemList = [];
            if (column['sourceTable'] != null) {
              for (var selectedItem in items) {
                print(
                    'ViewController.generateEditFormView>>>${itemsShowSelectItem(
                        selectedItem, column['items'])}');
                multiSelectedItemList.add(
                    itemsShowSelectItem(selectedItem, column['items']));
              }
            } else {
              for (var selectedItem in items) {
                multiSelectedItemList.add(selectedItem['title']);
              }

              print(
                  'ViewController.generateEditFormView2222>>>${multiSelectedItemList}');
            }

            print(
                'ViewController.generateEditFormView##>>${column}>>>${ multiSelectedItemList
                    .length != 0
                    ? RxString(multiSelectedItemList.join(','))
                    : RxString('انتخاب')}>>>${items.length != 0
                    ? RxList(items)
                    : <dynamic>[].obs}>>>${false.obs} ');
            multiSelectBox = await genarateEditFormMuiltiSelectBox(
                column,
                multiSelectedItemList.length != 0
                    ? RxString(multiSelectedItemList.join(','))
                    : RxString('انتخاب'),
                items.length != 0 ? RxList(items) : <dynamic>[].obs,
                false.obs);

            children.add(SizedBox(
              height: 20,
            ));
            children.add(multiSelectBox);
          }
        } else if (type == 'color') {
          colorBox = generateFormColorBox(
              column,
              dataModel[name] != null
                  ? Color(int.parse('${dataModel[name]}'))
                  : Colors.blue,
              dataModel[name] == '' || dataModel[name] == null
                  ? false.obs
                  : true.obs);
          // colorBox = new Container(
          //   child: ColorPickerBox(
          //     selectedColor: dataModel[name] != null ? Color(int.parse('${dataModel[name]}')):Colors.blue,
          //     onChanged: (color){
          //       ViewController.selectedColor = color;
          //       String hexColor = '0x${ViewController.selectedColor.value.toRadixString(16).padLeft(8, '0')}';
          //       dataModel[name] = hexColor;
          //     },
          //   ),
          // );
          children.add(SizedBox(
            height: 20,
          ));
          children.add(colorBox);
        } else if (type == 'file') {
          print(
              'dataModel[name] file box>>>${dataModel[name]} ${dataModel[name]
                  .runtimeType}');
          fileBox = generateFileBox(
              '${dataModel[name] != null ? dataModel[name] : []}',
              column,
              dataModel[name] == null ? false.obs : true.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(fileBox);
        } else if (type == 'time') {
          List<String>? TimeParts;
          int hour = TimeOfDay
              .now()
              .hour;
          int minute = TimeOfDay
              .now()
              .minute;
          print('dataModel[name]>>>${dataModel['${name}']}');
          if (dataModel['${name}'] != null) {
            TimeParts = dataModel['${name}'].split(':');
            print('TimeParts>>>${TimeParts}');
            hour = int.parse('${TimeParts![0]}');
            minute = int.parse('${TimeParts[1]}');
            print('hour minute>>>${hour} ${minute}');
          }
          print(
              'TimeOfDay(hour: hour , minute: minute)>>>${TimeOfDay(
                  hour: hour, minute: minute)}');
          timeBox = generateFormTimeBox(
              column,
              TimeOfDay(hour: hour, minute: minute),
              dataModel['${name}'] == null || dataModel['${name}'] == ''
                  ? false.obs
                  : true.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(timeBox);
        }
      }
    }
    return Column(children: children);
  }

  static Future<Widget> generateDataColumn(int indexColumn, int indexRow,
      {var table}) async {
    var size = MediaQuery
        .of(Get.context!)
        .size;
    String name = '';
    name = MainController.tableInfo['columns'][indexColumn]['name'];
    var dataModel = MainController.tableData.value[indexRow]['${name}'];
    String type = '';
    if (table == null) {
      type = MainController.tableInfo['columns'][indexColumn]['type'];
      name = MainController.tableInfo['columns'][indexColumn]['name'];
    } else {
      type = table['columns'][indexColumn]['type'];
      name = table['columns'][indexColumn]['name'];
    }

    var child;
    if (type == 'checkbox') {
      print('type:${type}');
      print('name:${name}');
      print('index:${indexRow}');
      // print('data:${dataModel.data['${name}']}');
      print('-------------------');
      child = generateCheckBox(indexColumn, indexRow, tableData: table);
    } else if (type == 'color') {
      child = generateColor(indexColumn, indexRow, tableData: table);
    } else if (type == 'select' || type == 'radiobutton') {
      child = FutureBuilder<Widget>(
        future: generateSelectBox(indexColumn, indexRow, tableData: table),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Txt(
                '${AppController.of(context)!.value('error')}: ${snapshot
                    .error}');
          } else {
            return snapshot.data ?? Container();
          }
        },
      );
      // child = await generateSelectBox(indexColumn , indexRow);
    } else if (type == 'multiSelect') {
      print('ViewController.generateDataColumn>>${table}');
      child = FutureBuilder<Widget>(
        future: generateMultiSelectBox(indexColumn, indexRow, tableData: table),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Txt(
                '${AppController.of(context)!.value('error')}: ${snapshot
                    .error}');
          } else {
            return snapshot.data ?? Container();
          }
        },
      );
    } else if (type == 'file') {
      child = generateCellFileBox(indexColumn, indexRow, tableData: table);
    } else {
      child = generateData(indexColumn, indexRow, tableData: table);
    }
    return Obx(() {
      return Center(
        child: Container(
            width: size.width / 5,
            decoration: BoxDecoration(
              color: MainController.isLightMode.value == true
                  ? background
                  : whiteColor,
            ),
            padding: EdgeInsets.all(5),
            child: child),
      );
    });
  }

  static Widget generateCheckBox(int indexColumn, int indexRow,
      {var tableData}) {
    // DataModel dataModel = MainController.tableData.value[indexRow];
    String name = '';
    if (tableData == null) {
      name = MainController.tableInfo['columns'][indexColumn]['name'];
    } else {
      name = tableData['columns'][indexColumn]['name'];
    }
    var dataModel = MainController.tableData.value[indexRow]['${name}'];

    if (dataModel == null) {
      dataModel = false;
    }
    return CheckBox(
      defaultValue: dataModel,
      checkBoxTitle: '',
      onChange: (text) async {
        dataModel = text;
        final data = DataModel(
          id: dataModel['id'],
          data: dataModel,
        );
        box.values.toList()[indexRow] = data;
        await box.putAt(indexRow, data);
      },
      index: indexRow,
      column: tableData == null
          ? MainController.tableInfo['columns'][indexColumn]
          : tableData['columns'][indexColumn],
    );
  }

  static Widget generateColor(int indexColumn, int indexRow, {var tableData}) {
    // DataModel dataModel = MainController.tableData.value[indexRow];
    String name;
    if (tableData == null) {
      name = MainController.tableInfo['columns'][indexColumn]['name'];
    } else {
      name = tableData['columns'][indexColumn]['name'];
    }
    var dataModel = MainController.tableData.value[indexRow]['${name}'];

    return Center(
      child: dataModel != null
          ? Container(
        width: 50,
        height: 50,
        color: Color(int.parse('${dataModel}')),
      )
          : Container(),
    );
  }

  static Future<Widget> generateSelectBox(int indexColumn, int indexRow,
      {var tableData}) async {
    // DataModel dataModel = MainController.tableData.value[indexRow];
    var column;
    String name;
    if (tableData == null) {
      column = MainController.tableInfo['columns'][indexColumn];
      name = MainController.tableInfo['columns'][indexColumn]['name'];
    } else {
      column = tableData['columns'][indexColumn];
      name = tableData['columns'][indexColumn]['name'];
    }
    var dataModel = MainController.tableData.value[indexRow]['${name}'];

    String tableName = '';
    if (column['sourceItems'] != 'custom') {
      tableName = column['sourceTable'];
    }

    String titleSelect = '';
    if (dataModel != null) {
      titleSelect =
      await getTitleSelectedItem('${tableName}', dataModel, column);
    }

    return Txt(
      '${titleSelect}',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: MainController.isLightMode.value == true ? whiteColor : color2,
      textAlign: TextAlign.center,
    );
  }

  static Future<Widget> generateMultiSelectBox(int indexColumn, int indexRow,
      {var tableData}) async {
    var column;
    String name;
    if (tableData == null) {
      column = MainController.tableInfo['columns'][indexColumn];
      name = MainController.tableInfo['columns'][indexColumn]['name'];
    } else {
      column = tableData['columns'][indexColumn];
      name = tableData['columns'][indexColumn]['name'];
    }

    String tableName = '';
    if (column['sourceItems'] != 'custom') tableName = column['sourceTable'];

    List<dynamic> titleMultiSelectList = [];
    if (MainController.tableData.value[indexRow]['${name}'] != null) {
      List<dynamic> dataModel = [];
      dataModel = MainController.tableData.value[indexRow]['${name}'];
      print('dataModel it is>>${dataModel}');
      titleMultiSelectList =
      await getTitleMultiSelectedItem('${tableName}', dataModel, column);
    }
    print('titleMultiSelectList>>${titleMultiSelectList}');
    return Txt(
      '${titleMultiSelectList.join(',')}',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: MainController.isLightMode.value == true ? whiteColor : color2,
      textAlign: TextAlign.center,
    );
  }

  static Widget generateCellFileBox(int indexColumn, int indexRow,
      {var tableData}) {
    // DataModel dataModel = MainController.tableData.value[indexRow];
    String name;
    if (tableData == null) {
      name = MainController.tableInfo['columns'][indexColumn]['name'];
    } else {
      name = tableData['columns'][indexColumn]['name'];
    }
    var dataModel = MainController.tableData.value[indexRow]['${name}'];

    return Obx(() {
      return Center(
        child: Txt(
          '${dataModel != null ? dataModel.length != 0 ? dataModel : '' : ''}',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: MainController.isLightMode.value == true ? whiteColor : color2,
          textAlign: TextAlign.center,
        ),
      );
    });
  }

  static Widget generateData(int indexColumn, int indexRow, {var tableData}) {
    // DataModel dataModel = MainController.tableData.value[indexRow];

    String name;
    if (tableData == null) {
      name = MainController.tableInfo['columns'][indexColumn]['name'];
    } else {
      name = tableData['columns'][indexColumn]['name'];
    }
    var dataModel = MainController.tableData.value[indexRow]['${name}'];

    return Obx(() {
      return Center(
        child: Txt(
          '${dataModel != null ? dataModel : ''}',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: MainController.isLightMode.value == true ? whiteColor : color2,
          textAlign: TextAlign.center,
        ),
      );
    });
  }

  static Widget generateFormTextField(GlobalKey<FormBuilderState> _fbKey,
      var column, var type, String initValue) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column['title']}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        FormTextField(
          name: '${column['title']}',
          fbKey: _fbKey,
          hint: '${column['title']}',
          lable: '',
          column: column,
          initValue: initValue,
          onChange: (text) {
            // dataJson[columnName] = text;
            if (text != null && text != '') {
              if (column['type'] == 'Number int') {
                ViewController.request[column['name']] = int.parse('${text}');
                print(
                    'request Number int>>>${ViewController
                        .request}>>${ViewController.request[column['name']]
                        .runtimeType}');
              } else if (column['type'] == 'Number double') {
                ViewController.request[column['name']] =
                    double.parse('${text}');
              } else {
                ViewController.request[column['name']] = text;
              }
            } else {
              ViewController.request[column['name']] = '';
              print(
                  'request Number int>>>>>${ViewController
                      .request[column['name']]}');
            }
          },
          isMobile: type == 'mobile' ? true : false,
          isNumberInt: type == 'Number int' ? true : false,
          isNumberDouble: type == 'Number double' ? true : false,
          isEmail: type == 'email' ? true : false,
        ),
      ],
    );
  }

  static Widget generateStoreFormSelectBox(var column, List<dynamic> items,
      String hintText, String initailValue, Rx<bool> isSeleted) {
    print('generateFormSelectBox column>>>${column}');
    print('generateFormSelectBox item>>>${items}');
    print('generateFormSelectBox initailValue>>>${initailValue}');
    print('generateFormSelectBox item>>>${items}');

    // if (column['sourceItems'] != 'custom') {
    // ViewController.request[column['name']]=items.first['id'];
    if (initailValue != '' && initailValue != null) {
      ViewController.request[column['name']] = null;
    }
    else {
      ViewController.request[column['name']] = null;
    }

    // } else {
    //   ViewController.request[column['name']] = null;
    // }
    return items.length != 0
        ? new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column['title']}',
            color: MainController.isLightMode.value == true
                ? whiteColor
                : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        column['sourceItems'] != 'custom'
            ? SelectBox(
            name: '${column['title']}',
            column: column,
            items: [
              DropdownMenuItem(
                  child: Obx(() {
                    return Txt(
                      'انتخاب نشده',
                      color: MainController.isLightMode.value == true
                          ? whiteColor
                          : primaryDark,
                    );
                  }),
                  value: ''),
              for (var item in items)
                DropdownMenuItem(
                    child: Obx(() {
                      return Txt(
                        '${itemsShowSelectItem(item, column['items'])}',
                        color:
                        MainController.isLightMode.value == true
                            ? whiteColor
                            : primaryDark,
                      );
                    }),
                    value: item['id'].toString()),
            ],
            initalValue: initailValue == '' || initailValue == null
                ? ""
                : initailValue,
            onChanged: (value) async {
              print('selected item ${value}');
              if (value != '') {
                // selectedValue=value!;
                ViewController.request[column['name']] = value;
              } else {
                ViewController.request[column['name']] = '';
              }

              print('request select>>${ViewController.request}');
            },
            hintText: hintText,
            isSeleted: isSeleted,
            selectedValue: '')
            : SelectBox(
            name: '${column['title']}',
            column: column,
            items: [
              for (var item in items)
                DropdownMenuItem(
                    child: Obx(() {
                      return Txt(
                        '${item['title']}',
                        color:
                        MainController.isLightMode.value == true
                            ? whiteColor
                            : primaryDark,
                      );
                    }),
                    value: item['value']),
            ],
            initalValue: initailValue == '' || initailValue == null
                ? items.first['value']
                : initailValue,
            onChanged: (value) async {
              print('selected item ${value}');
              for (var item in items) {
                if (item['title'] == value) {
                  if (item['value'] == '') {
                    value = null;
                  }
                }
              }
              if (value != '') {
                ViewController.request[column['name']] = value;
              } else {
                ViewController.request[column['name']] = '';
              }
            },
            hintText: hintText,
            isSeleted: isSeleted,
            selectedValue: ''),
      ],
    )
        : Container();
  }

  static Widget generateFormCheckBox(var column, Rx<bool>? isClickedBtn,
      {var defultValue}) {
    ViewController.request[column['name']] =
        defultValue ?? column['default_value'];
    print(
        'ViewController.generateFormCheckBox>>>${ViewController
            .request[column['name']]}');
    return new CheckBox(
      checkBoxName: '${column['title']}',
      checkBoxTitle: '${column['title']}',
      isClickedBtn: isClickedBtn,
      defaultValue: defultValue ?? column['default_value'],
      onChange: (text) {
        ViewController.request[column['name']] = text;
        // dataJson[columnName] = text;
      },
      column: column,
    );
  }

  static Widget generateFormRadioButton(var column, List<dynamic> items,
      String initalValue, Rx<bool> isSelectedItem) {
    // var radioButtonItems = column['items'];
    //
    // var selectedItem = radioButtonItems.firstWhere(
    //   (item) => item['is_selected'] == true,
    //   orElse: () => radioButtonItems.first,
    // );
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column['title']}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        RadioButton(
          name: '',
          radioButtonItems: [
            for (var radioButtonItem in items)
              FormBuilderChipOption(
                  value: '${radioButtonItem['value']}',
                  child: Obx(() {
                    return Txt(
                      '${radioButtonItem['title']}',
                      color: MainController.isLightMode.value
                          ? whiteColor
                          : primaryDark,
                    );
                  })),
          ],
          onChanged: (text) {
            ViewController.request[column['name']] = text;
            // dataJson[columnName] = selectedRadioButton.value;
          },
          initalValue: initalValue,
          column: column,
          isSelectedItem: isSelectedItem,
        ),
      ],
    );
  }

  static Widget generateFormDateBox(var column, Jalali selectedDate,
      Rx<bool>? isSeletedDate) {
    // if (ViewController.request[column['name']] == null) {
    //   ViewController.request[column['name']] =
    //       '${selectedDate.year}${'/'}${selectedDate.month}${'/'}${selectedDate.day}';
    // }
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column['title']}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        DateBox(
          selectedDate: selectedDate,
          isSeletedDate: isSeletedDate,
          onDateChanged: (date) {
            // dataJson[columnName] =  date;
            ViewController.request[column['name']] = date;
          },
          column: column,
        ),
      ],
    );
  }

  static Future<Widget> genarateEditFormMuiltiSelectBox(var column,
      Rx<String> hintTxt,
      RxList<dynamic> selectedItemsList,
      Rx<bool> isSelectedItem) async {
    RxList<String> selectedItemId = <String>[].obs;
    List<dynamic> items =[];
    if (column['sourceItems'] != 'custom') {
      items = await DB(column['sourceTable']).getRecords();

      print('items is ss>>${items}');

      if (selectedItemsList.length != 0) {
        // items.add({'id':'',});
        for (var selectedItem in selectedItemsList) {
          selectedItemId.add(selectedItem['id']);
        }
      }
      return items.length != 0
          ? new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return Txt(
              '${column['title']}',
              color: MainController.isLightMode.value == true
                  ? whiteColor
                  : color2,
            );
          }),
          Obx(() {
            return MultiSelectDropdown(
              items: [
                for (var item in items)
                  DropdownMenuItem(
                      value: item['id'],
                      child: Obx(() {
                        return Row(
                          children: [
                            Container(
                              height: 100,
                              child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Obx(() {
                                    return Checkbox(
                                        activeColor: colorBtn,
                                        value: selectedItemId
                                            .contains(item['id']),
                                        onChanged: (isChecked) {
                                          if (isChecked != null) {
                                            hintTxt.value = '';
                                            if (!selectedItemsList.any(
                                                    (map) =>
                                                    mapEquals(map, item))) {
                                              requestMultiSelect = item;
                                              selectedItemsList.add(item);
                                              selectedItemId
                                                  .add(item['id']);
                                            } else {
                                              requestMultiSelect
                                                  .removeWhere(
                                                      (key, value) =>
                                                  value == ['id']);
                                              var index = selectedItemsList
                                                  .indexWhere((map) =>
                                                  mapEquals(map, item));
                                              selectedItemsList
                                                  .removeAt(index);
                                            }
                                            if (item['id'] == '') {
                                              selectedItemId.value
                                                  .remove(item['id']);
                                            }
                                            if (selectedItemId
                                                .value.length ==
                                                0) {
                                              isSelectedItem.value = false;
                                            } else {
                                              isSelectedItem.value = true;
                                            }
                                            for (var r in selectedItemsList)
                                              hintTxt.value = hintTxt
                                                  .value +
                                                  itemsShowSelectItem(r, column['items']);
                                            print(
                                                'hintTxt.value>>>${hintTxt
                                                    .value}');
                                            ViewController.request[
                                            column['name']] = selectedItemId;

                                          }
                                        });
                                  })),
                            ),
                            Txt(itemsShowSelectItem(item, column['items']),
                                color: MainController.isLightMode.value
                                    ? whiteColor
                                    : primaryDark),
                          ],
                        );
                      }))
              ],
              hintText: hintTxt.value != '' || hintTxt.value != null
                  ? hintTxt.value
                  : 'انتخاب',
              selectedItems: selectedItemsList,
              isSelectedItem: isSelectedItem,
              column: column,
            );
          }),
        ],
      )
          : Container();
    }
    else {
      if (selectedItemsList.length != 0) {
      for (var selectedItem in selectedItemsList) {
        selectedItemId.add(selectedItem['value']);
      }
      }
      items = column['items'];

      return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return Txt(
              '${column['title']}',
              color: MainController.isLightMode.value == true
                  ? whiteColor
                  : color2,
            );
          }),
          Obx(() {
            return MultiSelectDropdown(
              items: [
                for (var item in items)
                  DropdownMenuItem(
                      value: item['value'],
                      child: Obx(() {
                        return Row(
                          children: [
                            Container(
                              height: 100,
                              child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Obx(() {
                                    return Checkbox(
                                        activeColor: colorBtn,
                                        value: selectedItemsList.any((map) =>
                                            mapEquals(map, item)),
                                        onChanged: (isChecked) {
                                          if (isChecked != null) {
                                            if (isChecked != null) {
                                              hintTxt.value = '';
                                              if (!selectedItemsList.any(
                                                      (map) =>
                                                      mapEquals(map, item))) {
                                                requestMultiSelect = item;
                                                selectedItemsList.add(item);
                                                selectedItemId
                                                    .add(item['value']);
                                              } else {
                                                requestMultiSelect
                                                    .removeWhere(
                                                        (key, value) =>
                                                    value == ['value']);
                                                var index = selectedItemsList
                                                    .indexWhere((map) =>
                                                    mapEquals(map, item));
                                                selectedItemsList
                                                    .removeAt(index);
                                              }
                                              if (item['value'] == '') {
                                                selectedItemId.value
                                                    .remove(item['value']);
                                              }
                                              if (selectedItemId.value.length == 0) {
                                                isSelectedItem.value = false;
                                              } else {
                                                isSelectedItem.value = true;
                                              }
                                              for (var r in selectedItemsList)
                                                hintTxt.value = hintTxt
                                                    .value +r['title'];
                                              print(
                                                  'hintTxt.value>>>${hintTxt
                                                      .value}');
                                              ViewController.request[
                                              column['name']] = selectedItemId;
                                            }
                                          }
                                        });
                                  })),
                            ),
                            Txt(item['title'],
                                color: MainController.isLightMode.value
                                    ? whiteColor
                                    : primaryDark),
                          ],
                        );
                      }))
              ],
              hintText: hintTxt.value != '' && hintTxt.value != null
                  ? hintTxt.value
                  : 'انتخاب',
              selectedItems: selectedItemsList,
              isSelectedItem: isSelectedItem,
              // onChanged: (selectedList){
              //   print('selectedList>>${selectedList}');
              //       selectedItemsList.value = selectedList;
              //   hintTxt.value = hintTxt.value;
              //   print(' hintTxt.value >>>${ hintTxt.value }');
              //       ViewController.request= requestMultiSelect;
              // },
              column: column,
            );
          }),
        ],
      );
    }
  }

  static Future<Widget> genarateStoreFormMuiltiSelectBox(var column,
      Rx<String> hintTxt,
      RxList<dynamic> selectedItemsList,
      Rx<bool> isSelectedItem) async {
    List<dynamic> items = [];
    items = await itemsList(column);
    List<dynamic> selectedId = [];

    return items.length != 0
        ? column['sourceItems'] != 'custom'
        ? new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column['title']}',
            color: MainController.isLightMode.value == true
                ? whiteColor
                : color2,
          );
        }),
        Obx(() {
          return MultiSelectDropdown(
            items: [
              for (var item in items)
                DropdownMenuItem(
                    value: item['id'],
                    child: Obx(() {
                      return Row(
                        children: [
                          Container(
                            height: 100,
                            child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Obx(() {
                                  return Checkbox(
                                      activeColor: colorBtn,
                                      value: selectedItemsList.any(
                                              (map) =>
                                              mapEquals(map, item)),
                                      onChanged: (isChecked) {
                                        if (isChecked != null) {
                                          print(
                                              'selectedItemsList 2>>${!selectedItemsList
                                                  .any((map) =>
                                                  mapEquals(map, item))}');

                                          hintTxt.value = '';
                                          if (!selectedItemsList.any(
                                                  (map) =>
                                                  mapEquals(
                                                      map, item))) {
                                            selectedId = [];
                                            requestMultiSelect = item;
                                            selectedItemsList
                                                .add(item);
                                            print(
                                                'selectedItemsList >>${selectedItemsList}');
                                          } else {
                                            selectedId = [];
                                            requestMultiSelect
                                                .removeWhere((key,
                                                value) =>
                                            value == ['id']);
                                            var index =
                                            selectedItemsList
                                                .indexWhere(
                                                    (map) =>
                                                    mapEquals(
                                                        map,
                                                        item));
                                            print(
                                                'selectedItemsList index>>${index}');
                                            selectedItemsList
                                                .removeAt(index);
                                            print(
                                                'selectedItemsList >>${selectedItemsList}');
                                          }
                                          if (item['id'] == '') {}
                                          if (selectedItemsList
                                              .value.length ==
                                              0) {
                                            isSelectedItem.value =
                                            false;
                                          } else {
                                            isSelectedItem.value =
                                            true;
                                          }
                                          for (var r
                                          in selectedItemsList)
                                            hintTxt.value = hintTxt
                                                .value +
                                                itemsShowSelectItem(r,
                                                    column['items']);

                                          for (var r
                                          in selectedItemsList)
                                            selectedId.add(r['id']);

                                          print(
                                              'hintTxt.value>>>${hintTxt
                                                  .value}');

                                          ViewController.request[
                                          column['name']] =
                                              selectedId;
                                        }
                                      });
                                })),
                          ),
                          Txt(
                              itemsShowSelectItem(
                                  item, column['items']),
                              color: MainController.isLightMode.value
                                  ? whiteColor
                                  : primaryDark),
                        ],
                      );
                    }))
            ],
            hintText: hintTxt.value != '' && hintTxt.value != null
                ? hintTxt.value
                : 'انتخاب',
            selectedItems: selectedItemsList,
            isSelectedItem: isSelectedItem,
            // onChanged: (selectedList){
            //   print('selectedList>>${selectedList}');
            //       selectedItemsList.value = selectedList;
            //   hintTxt.value = hintTxt.value;
            //   print(' hintTxt.value >>>${ hintTxt.value }');
            //       ViewController.request= requestMultiSelect;
            // },
            column: column,
          );
        }),
      ],
    )
        : new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column['title']}',
            color: MainController.isLightMode.value == true
                ? whiteColor
                : color2,
          );
        }),
        Obx(() {
          return MultiSelectDropdown(
            items: [
              for (var item in items)
                DropdownMenuItem(
                    value: item['value'],
                    child: Obx(() {
                      return Row(
                        children: [
                          Container(
                            height: 100,
                            child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Obx(() {
                                  return Checkbox(
                                      activeColor: colorBtn,
                                      value: selectedItemsList.any((map) =>
                                          mapEquals(map, item)),
                                      onChanged: (isChecked) {
                                        if (isChecked != null) {
                                          print(
                                              'selectedItemsList 2>>${!selectedItemsList
                                                  .any((map) =>
                                                  mapEquals(map, item))}');

                                          hintTxt.value = '';
                                          if (!selectedItemsList.any((map) =>
                                              mapEquals(map, item))) {
                                            selectedId = [];
                                            requestMultiSelect = item;
                                            selectedItemsList.add(item);
                                            print(
                                                'selectedItemsList >>${selectedItemsList}');
                                          } else {
                                            selectedId = [];
                                            requestMultiSelect.removeWhere((key,
                                                value) => value == ['value']);
                                            var index = selectedItemsList
                                                .indexWhere((map) =>
                                                mapEquals(map, item));
                                            print(
                                                'selectedItemsList index>>${index}');
                                            selectedItemsList.removeAt(index);
                                            print(
                                                'selectedItemsList >>${selectedItemsList}');
                                          }

                                          if (selectedItemsList.value.length ==
                                              0) {
                                            isSelectedItem.value = false;
                                          } else {
                                            isSelectedItem.value = true;
                                          }
                                          for (var r in selectedItemsList)
                                            hintTxt.value =
                                                hintTxt.value + r['title'];

                                          for (var r in selectedItemsList)
                                            selectedId.add(r['value']);

                                          print(
                                              'hintTxt.value>>>${selectedId}');

                                          ViewController
                                              .request[column['name']] =
                                              selectedId;
                                        }
                                      });
                                })),
                          ),
                          Txt(item['title'],
                              color: MainController.isLightMode.value
                                  ? whiteColor
                                  : primaryDark),
                        ],
                      );
                    }))
            ],
            hintText: hintTxt.value != '' && hintTxt.value != null
                ? hintTxt.value
                : 'انتخاب',
            selectedItems: selectedItemsList,
            isSelectedItem: isSelectedItem,
            // onChanged: (selectedList){
            //   print('selectedList>>${selectedList}');
            //       selectedItemsList.value = selectedList;
            //   hintTxt.value = hintTxt.value;
            //   print(' hintTxt.value >>>${ hintTxt.value }');
            //       ViewController.request= requestMultiSelect;
            // },
            column: column,
          );
        }),
      ],
    )
        : Container();
  }

  static Widget generateFormColorBox(var column, Color selectedColor,
      Rx<bool>? isSeletedColor) {
    Color colorChanged;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column['title']}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        Container(
          child: ColorPickerBox(
            selectedColor: selectedColor,
            isSeletedColor: isSeletedColor,
            onChanged: (color) {
              colorChanged = color;
              String hexColor =
                  '0x${colorChanged.value.toRadixString(16).padLeft(8, '0')}';
              // dataJson[columnName] = hexColor;
              ViewController.request[column['name']] = hexColor;
            },
            column: column,
          ),
        ),
      ],
    );
  }

  static Widget generateFileBox(String selecetdFiles, var column,
      Rx<bool>? isSeletedFile) {
    Map<String, List<dynamic>> selectedFilesMap = {};
    if (selectedFilesMap['${column['name']}'] == null) {
      selectedFilesMap['${column['name']}'] = [];
    }
    List<dynamic> filesSelectedList;
    if (ViewController.request[column['name']] != null) {
      filesSelectedList = ViewController.request[column['name']];
      for (var data in filesSelectedList) {
        selectedFilesMap['${column['name']}']!.add(data);
      }
    }
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column['title']}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        FormFile(
          columnName: column['title'],
          onChanged: (selecetdFiles) {
            // dataJson[columnName] = selecetdFiles;
            ViewController.request[column['name']] = selecetdFiles;
          },
          filesSelected: selectedFilesMap,
          selectedFilesTxt: selecetdFiles,
          isSeletedFile: isSeletedFile,
          column: column,
        ),
      ],
    );
  }

  static Widget generateFormTimeBox(var column, TimeOfDay selectedTime,
      Rx<bool>? isSeletedTime) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column['title']}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        TimePickerBox(
          column: column,
          selectedTime: selectedTime,
          isSeletedTime: isSeletedTime,
          onTimeChanged: (time) {
            print('timeeeeeee3>>>${time}');
            ViewController.request[column['name']] = time;
          },
        ),
      ],
    );
  }

  static Future<List<dynamic>> getRowTable(String tableName) async {
    List<DataModel> rowList = [];
    List<dynamic> tableData = [];
    Box box2;
    tableData = await DB('${tableName}').getRecords();
    return tableData;
  }

  static Future<String> getTitleSelectedItem(String tableName,
      String selectedId, var column) async {
    String selectedTitle = '';
    var sourceItem = column['sourceItems'];
    if (sourceItem != 'custom') {
      if (selectedId != '') {
        List<dynamic> itemSelect = [];
        var object =
        (await DB(tableName).where('id', '==', selectedId).getRecords());
        if (object.length == 0) {
          selectedTitle = 'نامشخص';
        } else {
          var objectItem = object.first;
          print('objectItem>>${objectItem}');
          List<dynamic> items = column['items'];
          for (var item in items) {
            itemSelect.add(objectItem[item]);
          }
          selectedTitle = itemSelect.join('%');
        }
      } else {
        selectedTitle = '';
      }
    } else {
      if (selectedId != '') {
        Map<String, dynamic> selectedItem = column['items'].firstWhere(
                (element) => element['value'] == selectedId,
            orElse: () => {'error': ''});
        if (selectedItem['title'] != null) {
          selectedTitle = selectedItem['title'];
        } else {
          selectedTitle = selectedItem['error'];
        }
      } else {
        selectedTitle = '';
      }
    }
    return selectedTitle;
  }

  static Future<List<dynamic>> getTitleMultiSelectedItem(String tableName,
      List<dynamic> selectedId, var column) async {
    print(
        'selectedId>>${selectedId}>>tableName${tableName}>>>column${column['items']}');
    List<dynamic> multiSelectedTitleList = [];

    var sourceItem = column['sourceItems'];
    for (var i = 0; i < selectedId.length; i++) {
      if (sourceItem != 'custom') {
        var object =
        (await DB(tableName).where('id', '==', selectedId[i]).getRecords());
        if (object.length != 0) {
          var objectItem = object.first;
          print('objectItem>>${objectItem}');
          List<dynamic> items = column['items'];
          for (var item in items) {
            multiSelectedTitleList.add(objectItem['${item}']);
          }
        } else {
          multiSelectedTitleList = [''];
        }
      } else {
        Map<String, dynamic> selectedItem = column['items'].firstWhere(
                (element) => element['value'] == selectedId[i],
            orElse: () => {'error': ''});
        print('selectedItem>>>${selectedItem}');
        if (selectedItem['title'] != null) {
          multiSelectedTitleList.add(selectedItem['title']);
        }
      }
    }
    return multiSelectedTitleList;
  }

  static String itemsShowSelectItem(var listItems, List<dynamic> items) {
    print('ViewController.itemsShowSelectItem>>${listItems}>>>${items}');
    List<dynamic> a = [];

    if (listItems['id'] == '') {
      return "انتخاب نشده";
    }
    for (var field in items) {
      print('itemsShowMultiSelect>>>${field}>>>${listItems[field]}');

      a.add(listItems[field]);
    }
    print('ViewController.itemsShowMultiSelect>>>${a}');
    return a.join('%');
  }

  static Future<List> itemsList(var column, {var dataModel}) async {
    List<dynamic> items = [];
    var type = column['sourceItems'];
    var tableName = column['sourceTable'];
    print('column itemsList>>>${column}');
    List<dynamic> dropDownListItems = [];
    if (type != 'custom') {
      if (dataModel != null) {
        for (var item in dataModel[column['name']])
          dropDownListItems.add(
              (await DB(tableName).where('id', '==', item).getRecords()).first);
        for (int i = 0; i < dropDownListItems.length; i++) {
          List<dynamic> a = [];
          for (var field in column['items']) {
            a.add(dropDownListItems[i][field]);
          }
          items
              .add({'title': a.join('%'), 'value': dropDownListItems[i]['id']});
        }
      } else {
        print('data>>model>>null');
        List<dynamic> data = await DB(tableName).getRecords();
        print('data is >>>${data}');
        dropDownListItems = data;
        for (int i = 0; i < dropDownListItems.length; i++) {
          List<dynamic> a = [];
          for (var field in column['items']) {
            a.add(dropDownListItems[i][field]);
          }
          items
              .add({'title': a.join('%'), 'value': dropDownListItems[i]['id']});
        }
        print('items isss>>>${dropDownListItems}');
      }
    } else {
      List<dynamic> itemss = [];
      if (dataModel != null) {
        for (var item in dataModel[column['name']])

          itemss.add(column['items'].firstWhere((element) => element['value'] ==
              item));

        // dropDownListItems.add(item);
      }
      else {
        itemss = column['items'];
      }
      dropDownListItems = itemss;
    }
    print('itemsss>>& aaa>>>>${dropDownListItems}');

    return dropDownListItems;
  }

  // static Future<String> getInitValue(
  //     var column, List<dynamic> items) async {
  //     String initValue = '';
  //     var type=column['sourceItems'];
  //     var selectedItem;
  //     print('getInitValue column>>${column}');
  //     print('getInitValue items>>${items}');
  //
  //   // List<dynamic> items = await itemsList(column, type, tableName);
  //   // for (var subMenu in MainController.SubMenuList) {
  //     if (type != 'custom') {
  //         initValue = items.length != 0 ? items[0]['value'] : "";
  //     } else {
  //       selectedItem = items.firstWhere(
  //         (item) => item['is_selected'] == true,
  //         orElse: () => items.first,
  //       );
  //       initValue = selectedItem['value'];
  //     }
  //   return initValue;
  // }

  static List<dynamic> getColumnList(String tableName) {
    List<dynamic> columns = [];
    for (var table in MainController.SubMenuList) {
      if (table['table-name'] == tableName) {
        columns = table['columns'];
      }
    }
    return columns;
  }

  static String hintMultiSelectBox(List<dynamic> items, List<dynamic> ListsId) {
    List<String> titles = [];
    for (var id in ListsId) {
      var selectedItem = items.firstWhere((element) => element['value'] == id,
          orElse: () => null);
      if (selectedItem != null) {
        titles.add(selectedItem['title']);
      }
    }
    return titles.join(',');
  }
}
