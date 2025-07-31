import 'dart:convert';

import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Models/dataModel.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/images.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/img.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-checkBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-color.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-date.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-radio-button.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-time.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/Admin/boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:finance/Admin/Logic/Controllers/dataController.dart';
import '../../Public/config.dart';
import '../../UI/Componenets/General/loading.dart';
import '../../UI/Componenets/Items/Form/form-file.dart';
import 'connect-server-controller.dart';

class ViewController extends GetxController {
  static Rx<String> selectedRadioButton = ''.obs;
  static Rx<bool> isClickedBtn = false.obs;
  static Rx<bool> isClickedEditBtn = false.obs;
  static Map<String, List<int>> fileSizeList = {};
  static Map<String, dynamic> request = {};
  static List<Map<String, dynamic>> requestFilter = [];
  static Map<String, dynamic> requestMultiSelect = <String, dynamic>{};
  static Map<String, dynamic> request2 = {};
  static RxInt totalPage=0.obs;

  static copyClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text:text));
    showSnackbar(snackTypes.info, "کپی شد");
  }

  static Future<Widget> generateFilterView(
      Map<String, dynamic> filterInfo) async {
    var columnInfo = MainController.getColumnInfo(filterInfo['column']);

    Widget child = (await generateFilterFormView([columnInfo],filterInfo));

    return child;
  }

  static Future<Widget> generateFilterFormView(var columns,var filterInfo) async {
    var children = <Widget>[];
    var textField;
    var selectBox;
    var dateBox;
    var multiSelectBox;
    var colorBox;
    var fileBox;
    var timeBox;

    for (var j = 0; j < columns.length; j++) {
      if (columns[j]['is_show_store'] == true) {
        var column = columns[j];
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
          textField = generateFormTextFieldFilter(_fbKey, column,filterInfo, type, '');
          children.add(textField);
        }

        if (type == 'select') {
          List<dynamic> items = await itemsList(column);
          selectBox = await generateStoreFormSelectBoxFilter(
              column,filterInfo, items, '', '', false.obs);

          children.add(selectBox);
        }

        else if (type == 'checkbox') {
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
                            '${AppController.of(Get.context!)!.value('not selected')}',
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

                      if (value != 'true') {
                        ViewController.request['${column['name']}${filterInfo['operator']}']=
                        {
                          'value': false,
                          'column': '${column['name']}',
                          'operator': '${filterInfo['operator']}',
                        };
                      } else {
                        ViewController.request['${column['name']}${filterInfo['operator']}']=
                        {
                          'value': true,
                          'column': '${column['name']}',
                          'operator': '${filterInfo['operator']}',
                        };
                      }
                    },
                    hintText: '',
                    isSeleted: false.obs,
                    selectedValue: ''),
              ],
            ),
          );
        }

        else if (type == 'radiobutton') {
          List<dynamic> items = await itemsList(column);
          selectBox = await generateStoreFormSelectBoxFilter(
              column,filterInfo, items, '', '', false.obs);

          children.add(selectBox);
        }

        else if (type == 'date') {
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
                      ViewController.request['${column['name']}${filterInfo['operator']}']=
                      {
                        'value': date,
                        'column': '${column['name']}',
                        'operator': '${filterInfo['operator']}',
                      };
                    },
                    column: column,
                  ),
                ],
              )
            ],
          );

          children.add(dateBox);
        }

        else if (type == 'time') {
          timeBox = generateFormTimeBoxFilter(column,filterInfo, TimeOfDay.now(), false.obs);

          children.add(timeBox);
        }

        else if (type == 'multiSelect') {
          List<dynamic> items = await itemsList(column);
          if (items.length != 0) {
            multiSelectBox = await generateStoreFormSelectBoxFilter(
                column,filterInfo, items, '', '', false.obs);
            ;

            children.add(multiSelectBox);
          }
        }

        else if (type == 'color') {
          colorBox = generateFormColorBoxFilter(column,filterInfo, Colors.blue, false.obs);

          children.add(colorBox);
        }
      }
    }
    return Wrap(
      children: children,
    );
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
      if (columns[j]['is_show_store'] == true) {
        var column = columns[j];
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

          List<dynamic> items = await itemsList(column);
          print('ViewController.generateStoreFormView>>$items');
          selectBox = await generateStoreFormSelectBox(
              column, items, '', '', false.obs);

          children.add(SizedBox(
            height: 20,
          ));
          children.add(selectBox);
        }
        else if (type == 'checkbox') {
          checkBox = generateFormCheckBox(column, false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(checkBox);
        }
        else if (type == 'radiobutton') {
          var initValue;
          List<dynamic> items = await itemsList(column);
          radioButtonBox = generateFormRadioButton(column, items, '', false.obs);
          children.add(SizedBox(height: 20,));
          children.add(radioButtonBox);
        }
        else if (type == 'date') {
          dateBox = generateFormDateBox(column, Jalali.now(), false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(dateBox);
        }
        else if (type == 'multiSelect') {

          multiSelectBox = await genarateStoreFormMuiltiSelectBox(column, RxString(''), <dynamic>[].obs, false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(multiSelectBox);

        } else if (type == 'color') {
          colorBox = generateFormColorBox(column, Colors.blue, false.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(colorBox);
        } else if (type == 'file' || type == 'multiFile') {
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

  static Future<Widget> generateEditFormView(Map<String, dynamic> dataModel) async {
    var children = <Widget>[];
    var textField;
    var selectBox;
    var checkBox;
    var dateBox;
    var multiSelectBox;
    var colorBox;
    var fileBox;
    var timeBox;
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      if (MainController.tableInfo['columns'][j]['is_show_edit'] == true) {
        var column = MainController.tableInfo['columns'][j];
        var type = column['type'];
        var name = column['name'];
        var maxValidator;
        var minValidator;
        List<dynamic> items = [];
        print('dataModel d>>>${dataModel['${name}']}');
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
          List<dynamic> items = await ViewController.itemsList(column);
          print('ViewController.generateStoreFormView>>${items}');

          if (items.length != 0) {
            if (column['source_items'] != 'custom') {
              if (dataModel[name] != null && dataModel[name] != ''){

                selectedItem = items.firstWhere((element) => element['_id'] == dataModel[name]['_id']);

              }
              selectBox = await generateStoreFormSelectBox(
                  column,
                  items,
                  '${selectedItem.isNotEmpty ? selectedItem['_id'] != null
                      ? selectedItem['_id']
                      : '' : ''}',
                  '${selectedItem.isNotEmpty ? selectedItem['_id'] != null
                      ? selectedItem['_id']
                      : '' : ''}',
                  dataModel[name] == '' ? false.obs : true.obs);
            } else {
              if (dataModel[name] != null && dataModel[name] != '')
                selectedItem = items.firstWhere((element) => element['value'] == dataModel[name]['value']);
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
          Map<String, dynamic> selectedItem = <String, dynamic>{};
          var items = await ViewController.itemsList(column);
          if (items.length != 0) {
            if (column['source_items'] != 'custom') {
              if (dataModel[name] != null && dataModel[name] != '')
                selectedItem = items
                    .firstWhere((element) => element['_id'] == dataModel[name]['_id']);
              selectBox = await generateFormRadioButton(
                  column,
                  items,
                  '${selectedItem.isNotEmpty ? selectedItem['_id'] != null
                      ? selectedItem['_id']
                      : '' : ''}',
                  dataModel[name] == '' ? false.obs : true.obs);
            } else {
              if (dataModel[name] != null && dataModel[name] != '')
                selectedItem = items.firstWhere(
                        (element) => element['value'] == dataModel[name]);
              selectBox = await generateFormRadioButton(
                  column,
                  items,
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
          List<dynamic> items = await ViewController.itemsList(column,dataModel: dataModel);
          List<dynamic> multiSelectedItemList = [];
          if (items.length != 0) {
            if (column['source_table'] != null) {
              for (var selectedItem in items) {
                multiSelectedItemList.add(itemsShowSelectItem(selectedItem, column));
              }
            } else {
              for (var selectedItem in items) {
                multiSelectedItemList.add(selectedItem['title']);
              }
            }
          }
          if(dataModel.isNotEmpty){
            multiSelectBox = await genarateEditFormMuiltiSelectBox(
                column,
                multiSelectedItemList.length != 0 ? RxString(multiSelectedItemList.join(' , ')) : RxString(''),
                items.length != 0 ? RxList(items) : <dynamic>[].obs,
                false.obs);
          }else{
            multiSelectBox = await genarateEditFormMuiltiSelectBox(column, RxString(''), <dynamic>[].obs, false.obs);
          }
          children.add(SizedBox(
            height: 20,
          ));
          children.add(multiSelectBox);


        }
        else if (type == 'color') {
          colorBox = generateFormColorBox(
              column,
              dataModel[name] != null && dataModel[name] != ''
                  ? Color(int.parse('${dataModel[name]}'))
                  : Colors.blue,
              dataModel[name] == '' || dataModel[name] == null
                  ? false.obs
                  : true.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(colorBox);
        }
        else if (type == 'file') {
          print('ViewController.generateEditFormView>>${dataModel}');
          fileBox = generateEditFileBox(
              dataModel[name] != null && dataModel[name] != ''? dataModel : null,
              column,
              dataModel[name] == null ? false.obs : true.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(fileBox);
        }
        else if (type == 'multiFile') {
          print('ViewController.generateEditFormView>>${dataModel}>>${column}');
          fileBox = generateEditMultiFileBox(
             dataModel[name] != null && dataModel[name].length != 0? dataModel : null,
              column,
              dataModel[name] == null ? false.obs : true.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(fileBox);
        }
        else if (type == 'time') {
          List<String>? TimeParts;
          int hour = TimeOfDay
              .now()
              .hour;
          int minute = TimeOfDay
              .now()
              .minute;
          if (dataModel['${name}'] != null) {
            TimeParts = dataModel['${name}'].split(':');
            hour = int.parse('${TimeParts![0]}');
            minute = int.parse('${TimeParts[1]}');
          }

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
    return Column(crossAxisAlignment:CrossAxisAlignment.start,children: children);
  }

  static Future<Widget> generateDataColumn(int indexColumn, int indexRow, {var table}) async {
    var size = MediaQuery.of(Get.context!).size;
    String name = '';
    name = MainController.tableInfo['columns'][indexColumn]['name'];
    var dataModel = MainController.tableData[indexRow]['${name}'];
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
      child = generateCheckBox(indexColumn, indexRow, tableData: table);
    }
    else if (type == 'color') {
      child = generateColor(indexColumn, indexRow, tableData: table);
    }
    else if (type == 'select' || type == 'radiobutton') {
      child = InkWell(
         onDoubleTap: () async {
           await copyClipboard( MainController.tableData[indexRow]['${name}']!=null?
           '${itemsShowSelectItem(MainController.tableData[indexRow]['${name}'], MainController.tableInfo['columns'][indexColumn]) }':'');
         },
        child: Txt(MainController.tableData[indexRow]['${name}']!=null?
        '${itemsShowSelectItem(MainController.tableData[indexRow]['${name}'], MainController.tableInfo['columns'][indexColumn]) }':'',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: MainController.isLightMode.value == true ? whiteColor : color2,
          textAlign: TextAlign.center,
        ),
      );
    }
    else if (type == 'multiSelect') {
      child = InkWell(
        onDoubleTap: () async {
          await copyClipboard( MainController.tableData[indexRow]['${name}']!=null?
          '${itemsShowSelectItem(MainController.tableData[indexRow]['${name}'], MainController.tableInfo['columns'][indexColumn])}':'');

        },
        child: Txt(MainController.tableData[indexRow]['${name}']!=null?
        '${itemsShowSelectItem(MainController.tableData[indexRow]['${name}'], MainController.tableInfo['columns'][indexColumn])}':'',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: MainController.isLightMode.value == true ? whiteColor : color2,
          textAlign: TextAlign.center,
        ),
      );
    }
    else if (type == 'file' ) {
      child = generateCellFileBox(indexColumn, indexRow, tableData: table);
    }
    else if (type == 'multiFile' ) {
      child = generateCellMultiFileBox(indexColumn, indexRow, tableData: table);
    }
    else {
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

        await DB('${MainController.tableInfo['schema']['name']}').where('_id', '\$eq', '${MainController.tableData.value[indexRow]['_id']}').updateRecords({'${name}':'${text}'});

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
    var dataModel = MainController.tableData[indexRow]['${name}'];

    return InkWell(
      onDoubleTap: () async {
        await copyClipboard('${dataModel}');
      },
      child: Center(
        child: dataModel != null
            ? Container(
          width: 50,
          height: 50,
          color: Color(int.parse('${dataModel}')),
        )
            : Container(),
      ),
    );
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
      return InkWell(
        onDoubleTap: () async {
          await copyClipboard('${dataModel != null ? dataModel : ''}');
        },
        child: Center(
          child: Txt(
            '${dataModel != null ? dataModel.length > 20 ? dataModel.substring(0, 20) + '...' : dataModel : ''}',
            fontSize: 14,
            fontWeight: FontWeight.w500,

            color: MainController.isLightMode.value == true ? whiteColor : color2,
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }

  static Widget generateFormTextField(GlobalKey<FormBuilderState> _fbKey, var column, var type, String initValue) {
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
                ViewController.request[column['name']]= int.parse('${text}');
              } else if (column['type'] == 'Number double') {
                ViewController.request[column['name']]= double.parse('${text}');
              } else {
                ViewController.request[column['name']]= text;
              }
            } else {
              ViewController.request[column['name']]= '';

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
  static Widget generateFormTextFieldFilter(GlobalKey<FormBuilderState> _fbKey, var column,var filterInfo, var type, String initValue) {
    return Column(
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
          width: 120,
          child: FormTextField(
            isValidate: false,
            name: '${column['title']}',
            fbKey: _fbKey,
            hint: '${column['title']}',
            lable: '',
            column: column,
            initValue: initValue,
            onChange: (text) {
              if (text != null && text != '') {
                if (column['type'] == 'Number int') {
                  ViewController.request['${column['name']}${filterInfo['operator']}']=
                  {
                    'value': '${int.parse('${text}')}',
                    'column': '${column['name']}',
                    'operator': '${filterInfo['operator']}',
                  };
                } else if (column['type'] == 'Number double') {
                  ViewController.request['${column['name']}${filterInfo['operator']}']=
                  {
                    'value': '${double.parse('${text}')}',
                    'column': '${column['name']}',
                    'operator': '${filterInfo['operator']}',
                  };
                } else {
                  ViewController.request['${column['name']} ${filterInfo['operator']}']=
                  {
                    'value': '${text}',
                    'column': '${column['name']}',
                    'operator': '${filterInfo['operator']}',
                  };
                }
              } else {
                ViewController.request['${column['name']} ${filterInfo['operator']}']=
                {
                  'value': '',
                  'column': '${column['name']}',
                  'operator': '${filterInfo['operator']}',
                };
              }
            },
            isMobile: type == 'mobile' ? true : false,
            isNumberInt: type == 'Number int' ? true : false,
            isNumberDouble: type == 'Number double' ? true : false,
            isEmail: type == 'email' ? true : false,
          ),
        ),
      ],
    );
  }
  static Widget generateStoreFormSelectBoxFilter(var column,var filterInfo, List<dynamic> items, String hintText, String initailValue, Rx<bool> isSeleted) {
    if (initailValue == '' || initailValue == null) {
      ViewController.request[column['name']] = null;
    }
    return items.length != 0
        ? new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt('${column['title']}',color: MainController.isLightMode.value == true ? whiteColor : color2);
        }),
        SizedBox(
          height: 10,
        ),
        column['source_items'] != 'custom'
            ? SelectBox(
            name: '${column['title']}',
            column: column,
            items: [
              DropdownMenuItem(
                  child: Obx(() {
                    return Txt(
                      '${AppController.of(Get.context!)!.value('not selected')}',
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
                        '${itemsShowSelectItem(item, column)}',
                        color:
                        MainController.isLightMode.value == true
                            ? whiteColor
                            : primaryDark,
                      );
                    }),
                    value: item['_id'].toString()),
            ],
            initalValue: initailValue == '' || initailValue == null
                ? ""
                : initailValue,
            onChanged: (value) async {
              if (value != '') {
                // selectedValue=value!;
                ViewController.request['${column['name']}${filterInfo['operator']}']=
                {
                  'value': value,
                  'column': '${column['name']}',
                  'operator': '${filterInfo['operator']}',

                };
                // ViewController.request[column['name']] = value;
              } else {
                ViewController.request['${column['name']}${filterInfo['operator']}']=
                {
                  'value': '',
                  'column': '${column['name']}',
                  'operator': '${filterInfo['operator']}',
                };
                // ViewController.request[column['name']] = '';
              }

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
              for (var item in items) {
                if (item['title'] == value) {
                  if (item['value'] == '') {
                    value = null;
                  }
                }
              }
              if (value != '') {
                ViewController.request['${column['name']}${filterInfo['operator']}']=
                {
                  'value': value,
                  'column': '${column['name']}',
                  'operator': '${filterInfo['operator']}',
                };
              } else {
                ViewController.request['${column['name']}${filterInfo['operator']}']=
                {
                  'value': '',
                  'column': '${column['name']}',
                  'operator': '${filterInfo['operator']}',
                };
              }
            },
            hintText: hintText,
            isSeleted: isSeleted,
            selectedValue: ''),
      ],
    )
        : Container();
  }
  static Widget generateFormTimeBoxFilter(var column,var filterInfo, TimeOfDay selectedTime,
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
            ViewController.request['${column['name']}${filterInfo['operator']}']=
            {
              'value': time,
              'column': '${column['name']}',
              'operator': '${filterInfo['operator']}',
            };
          },
        ),
      ],
    );
  }
  static Widget generateFormColorBoxFilter(var column,var filterInfo, Color selectedColor,
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

              ViewController.request['${column['name']}${filterInfo['operator']}']=
              {
                'value': hexColor,
                'column': '${column['name']}',
                'operator': '${filterInfo['operator']}',
              };
            },
            column: column,
          ),
        ),
      ],
    );
  }

  static Widget generateStoreFormSelectBox(var column, List<dynamic> items,
      String hintText, String initailValue, Rx<bool> isSeleted) {
    if (initailValue == '' || initailValue == null) {
      ViewController.request[column['name']] = null;
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
        SizedBox(
          height: 10,
        ),
        column['source_items'] != 'custom' ?
        SelectBox(
            name: '${column['title']}',
            column: column,
            items: [
              DropdownMenuItem(
                  child: Obx(() {
                    return Txt(
                      '${AppController.of(Get.context!)!.value('not selected')}',
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
                        '${itemsShowSelectItem(item, column)}',
                        color:
                        MainController.isLightMode.value == true
                            ? whiteColor
                            : primaryDark,
                      );
                    }),
                    value: item['_id'].toString()),
            ],
            initalValue: initailValue == '' || initailValue == null ?"":initailValue,
            onChanged: (value) async {

              if (value != '') {
                ViewController.request[column['name']] = value;
              } else {
                ViewController.request[column['name']] = '';
              }
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
    ) : Container();
  }

  static Widget generateFormCheckBox(var column, Rx<bool>? isClickedBtn,
      {var defultValue}) {
    ViewController.request[column['name']] =
        defultValue ?? column['default_value'];

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
        column['source_items'] != 'custom' ?
        RadioButton(
          name: '',
          radioButtonItems: [
            for (var item in items)
              FormBuilderChipOption(
                  value: item['_id'].toString(),
                  child: Obx(() {
                    return Txt(
                      '${itemsShowSelectItem(item, column)}',
                      color: MainController.isLightMode.value
                          ? whiteColor
                          : primaryDark,
                    );
                  })),
          ],
          onChanged: (text) {
            if (text != '') {
              // selectedValue=value!;
              ViewController.request[column['name']] = text;
            } else {
              ViewController.request[column['name']] = '';
            }

            // dataJson[columnName] = selectedRadioButton.value;
          },
          initalValue: initalValue,
          column: column,
          isSelectedItem: isSelectedItem,
        ):
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

  static Future<Widget> genarateEditFormMuiltiSelectBox(var column, Rx<String> hintTxt, RxList<dynamic> selectedItemsList, Rx<bool> isSelectedItem) async {
    RxList<String> selectedItemId = <String>[].obs;
    List<dynamic> items =[];
    List<dynamic> selectedId = [];


    if (column['source_items'] != 'custom') {
      items = await DB('${column['source_table']}').getRecords();

      if (selectedItemsList.length != 0) {
        for (var selectedItem in selectedItemsList) {
          if(selectedItem['_id']!=null) {
            selectedItemId.add(selectedItem['_id']);
          }
        }
        ViewController.request[column['name']] = selectedItemId;
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
                      value: item['_id'],
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
                                        value: selectedItemId.contains(item['_id']),
                                        onChanged: (isChecked) {
                                          if (isChecked != null) {

                                            hintTxt.value = '';
                                            if (!selectedItemsList.any((element) => element['_id']==item['_id'])) {
                                              requestMultiSelect = item;
                                              selectedItemsList.add(item);
                                              selectedItemId.add(item['_id']);
                                            } else {
                                              requestMultiSelect.removeWhere((key, value) => value == ['_id']);
                                              selectedItemsList.removeWhere( (element) => element['_id']==item['_id']);
                                              selectedItemId.remove(item['_id']);
                                            }
                                            if (item['_id'] == '') {
                                              selectedItemId.value.remove(item['_id']);
                                            }
                                            if (selectedItemId.value.length == 0) {
                                              isSelectedItem.value = false;
                                            } else {
                                              isSelectedItem.value = true;
                                            }
                                            for (var r in selectedItemsList)
                                              hintTxt.value = hintTxt.value + itemsShowSelectItem(r, column);
                                            ViewController.request[column['name']]= selectedItemId;
                                          }
                                        });
                                  })),
                            ),
                            Txt(itemsShowSelectItem(item, column),
                                color: MainController.isLightMode.value
                                    ? whiteColor
                                    : primaryDark),
                          ],
                        );
                      }))
              ],
              hintText: hintTxt.value != '' || hintTxt.value != null
                  ? hintTxt.value
                  : '${AppController.of(Get.context!)!.value('choice')}',
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

      return Column(
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
                                            hintTxt.value = '';
                                            if (!selectedItemsList.any((map) =>
                                                mapEquals(map, item))) {
                                              selectedId = [];
                                              requestMultiSelect = item;
                                              selectedItemsList.add(item);

                                            } else {
                                              selectedId = [];
                                              requestMultiSelect.removeWhere((key,
                                                  value) => value == ['value']);
                                              var index = selectedItemsList
                                                  .indexWhere((map) =>
                                                  mapEquals(map, item));

                                              selectedItemsList.removeAt(index);

                                            }

                                            if (selectedItemsList.value.length ==
                                                0) {
                                              isSelectedItem.value = false;
                                            } else {
                                              isSelectedItem.value = true;
                                            }
                                            for (var r in selectedItemsList)
                                              hintTxt.value = hintTxt.value + r['title'];

                                            for (var r in selectedItemsList)
                                              selectedId.add(r['value']);


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
                  : '${AppController.of(Get.context!)!.value('choice')}',
              selectedItems: selectedItemsList,
              isSelectedItem: isSelectedItem,
              // onChanged: (selectedList){

              //       selectedItemsList.value = selectedList;
              //   hintTxt.value = hintTxt.value;

              //       ViewController.request= requestMultiSelect;
              // },
              column: column,
            );
          }),
        ],
      );
    }
  }

  static Future<Widget> genarateStoreFormMuiltiSelectBox(var column, Rx<String> hintTxt, RxList<dynamic> selectedItemsList, Rx<bool> isSelectedItem) async {
    List<dynamic> items = [];
    items = await itemsList(column);
    List<dynamic> selectedId = [];
    return items.length != 0
        ? column['source_items'] != 'custom'
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
                    value: item['_id'],
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


                                          hintTxt.value = '';
                                          if (!selectedItemsList.any(
                                                  (map) =>
                                                  mapEquals(
                                                      map, item))) {
                                            selectedId = [];
                                            requestMultiSelect = item;
                                            selectedItemsList
                                                .add(item);

                                          } else {
                                            selectedId = [];
                                            requestMultiSelect
                                                .removeWhere((key,
                                                value) =>
                                            value == ['_id']);
                                            var index =
                                            selectedItemsList
                                                .indexWhere(
                                                    (map) =>
                                                    mapEquals(
                                                        map,
                                                        item));

                                            selectedItemsList
                                                .removeAt(index);

                                          }
                                          if (item['_id'] == '') {}
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
                                                    column);

                                          for (var r
                                          in selectedItemsList)
                                            selectedId.add(r['_id']);

                                          ViewController.request[column['name']]= selectedId;
                                        }
                                      });
                                })),
                          ),
                          Txt(
                              itemsShowSelectItem(
                                  item, column),
                              color: MainController.isLightMode.value
                                  ? whiteColor
                                  : primaryDark),
                        ],
                      );
                    }))
            ],
            hintText: hintTxt.value != '' && hintTxt.value != null
                ? hintTxt.value
                : '${AppController.of(Get.context!)!.value('choice')}',
            selectedItems: selectedItemsList,
            isSelectedItem: isSelectedItem,
            // onChanged: (selectedList){
            //       selectedItemsList.value = selectedList;
            //   hintTxt.value = hintTxt.value;
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


                                          hintTxt.value = '';
                                          if (!selectedItemsList.any((map) =>
                                              mapEquals(map, item))) {
                                            selectedId = [];
                                            requestMultiSelect = item;
                                            selectedItemsList.add(item);

                                          } else {
                                            selectedId = [];
                                            requestMultiSelect.removeWhere((key,
                                                value) => value == ['value']);
                                            var index = selectedItemsList
                                                .indexWhere((map) =>
                                                mapEquals(map, item));

                                            selectedItemsList.removeAt(index);

                                          }

                                          if (selectedItemsList.value.length ==
                                              0) {
                                            isSelectedItem.value = false;
                                          } else {
                                            isSelectedItem.value = true;
                                          }
                                          for (var r in selectedItemsList)
                                            hintTxt.value = hintTxt.value + r['title'];

                                          for (var r in selectedItemsList)
                                            selectedId.add(r['value']);


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
                : '${AppController.of(Get.context!)!.value('choice')}',
            selectedItems: selectedItemsList,
            isSelectedItem: isSelectedItem,
            // onChanged: (selectedList){
            //       selectedItemsList.value = selectedList;
            //   hintTxt.value = hintTxt.value;
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
  static Widget generateCellFileBox(int indexColumn, int indexRow, {var tableData}) {
    String name;
    if (tableData == null) {
      name = MainController.tableInfo['columns'][indexColumn]['name'];
    } else {
      name = tableData['columns'][indexColumn]['name'];
    }
    var dataModel = MainController.tableData.value[indexRow]['${name}'];
    return  dataModel != null &&dataModel.length != 0?
    Column(
      children: [
        Center(
            child:Image.network(
              baseUrl+'${dataModel}',
              width: 70,
              height: 70,
              fit: BoxFit.fill,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset(fileImage,width: 70,
                  height: 70,); // عکس جایگزین
              },
            )
          // Img('${ dataModel}',width: 70,height: 70,isNetwork: true,),

        ),
      ],
    ):Container();
  }
  static Widget generateCellMultiFileBox(int indexColumn, int indexRow, {var tableData}) {
    String name;
    if (tableData == null) {
      name = MainController.tableInfo['columns'][indexColumn]['name'];
    } else {
      name = tableData['columns'][indexColumn]['name'];
    }
    var dataModel = MainController.tableData.value[indexRow]['${name}_multi'];
    print('ViewController.generateCellMultiFileBox$dataModel');
    return  dataModel != null &&dataModel.length != 0?
    Row(
      children: [
        for(var data in dataModel)

          Center(
            child:Image.network(
              baseUrl+'${data['path']}',
              width: 40,
              height: 40,
              fit: BoxFit.fill,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset(fileImage,width: 70,
                  height: 40,); // عکس جایگزین
              },
            )
          // Img('${ dataModel}',width: 70,height: 70,isNetwork: true,),

        ),
      ],
    ):Container();
  }

  static Widget generateFileBox(var selecetdFiles, var column,
      Rx<bool>? isSeletedFile) {
    Map<String, List<dynamic>> selectedFilesMap = {};
    if (selectedFilesMap['${column['name']}'] == null) {
      selectedFilesMap['${column['name']}'] = [];
    }
    List<dynamic> filesSelectedList=[];
    RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;
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
          onChanged: (file) {
            // dataJson[columnName] = selecetdFiles;
            if(column['type'] == 'file'){
              ViewController.request[column['name']] = file;
              print('ViewController.generateFileBox>>>${file}>>>${ ViewController.request[column['name']]}');
            }
            else{
              filesSelectedList.add(file);
              ViewController.request[column['name']] = filesSelectedList;
            }

          },
          filesSelected: selectedFilesMap,
          selectedFilesTxt: column['type'] == 'file' ? selecetdFiles:filesSelectedList,
          isSeletedFile: isSeletedFile,
          column: column,
          fileInfo: fileInfo,
        ),
      ],
    );
  }
  static Widget generateEditFileBox(var data, var column,
      Rx<bool>? isSeletedFile) {
    String name=column['name'];
    RxString file= data!=null && data[name]!=null?'${data[name]}'.obs:''.obs;

    print('ViewController.generateEditFileBox${data.runtimeType}>>${name}');
    Map<String, List<dynamic>> selectedFilesMap = {};
    if (selectedFilesMap['${column['name']}'] == null) {
      selectedFilesMap['${column['name']}'] = [];
    }
    List<dynamic> filesSelectedList=[];
    RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;
    return Obx(() {
        return new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Txt(
                '${column['title']}',
                color:
                MainController.isLightMode.value == true ? whiteColor : color2,
              ),

            SizedBox(
              height: 10,
            ),

            file.value!=''?
              IntrinsicWidth(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(border: Border.all(color: MainController.isLightMode.value == true
                      ? whiteColor
                      : background,width: 0.5),  borderRadius: BorderRadius.circular(10),),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Image.network(
                              baseUrl+'${ file}',
                              width: 40,
                              height: 40,
                              fit: BoxFit.fill,
                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                return Image.asset(fileImage,width:40,
                                  height: 40,); // عکس جایگزین
                              },
                            ),
                            Txt(
                              '${data[name+'_name']}',
                              color: MainController.isLightMode.value == true ? whiteColor : color2,
                            ),
                          ],
                        )
                      ),
                      Positioned(
                        top: 0,
                          left: 0,
                          child: IconButton(color: redColor, onPressed: () async {
                            var status=await MainController.deleteFileInChunks(data[name+'_name'],recordId: data['_id'],record: json.encode({name:null}).toString());
                            if(status==true){
                              file.value='';
                            }
                          }, icon: Icon(Icons.delete, size: 25 , color:redColor ,),))
                    ],
                  ),
                ),
              ):
            FormFile(
              columnName: column['title'],
              onChanged: (selecetdFiles) {
                  ViewController.request[name] = selecetdFiles;
              },
              filesSelected: selectedFilesMap,
              // selectedFilesTxt: column['type'] == 'file' ? selecetdFiles:filesSelectedList,
              selectedFilesTxt:  '',
              isSeletedFile: isSeletedFile,
              column: column,
              fileInfo: fileInfo,
            ),
          ],
        );
      }
    );
  }

  static Widget generateEditMultiFileBox(var data, var column,
      Rx<bool>? isSeletedFile) {
    String name=column['name'];
    Map<String, List<dynamic>> selectedFilesMap = {};
    if (selectedFilesMap['${column['name']}'] == null) {
      selectedFilesMap['${column['name']}'] = [];
    }
    RxList<String> filesSelectedList=<String>[].obs;
    RxList<dynamic> filesList=[].obs;
    if(data!=null&&data.length!=0){

        if (data[name + '_name']!=null && data[name + '_name'].length!=0){


      }
        if (data[name ]!=null && data[name].length!=0){
          filesList.addAll(data[name+'_multi']);

          for(var file in data[name]) {
          filesSelectedList.add('${file}');

          }
      }
    }
    print('ViewController.generateEditMultiFileBox>>${filesSelectedList}');

    RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;
    return Obx(() {
        return new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Txt(
                '${column['title']}',
                color:
                MainController.isLightMode.value == true ? whiteColor : color2,
              ),

            SizedBox(
              height: 10,
            ),
            data!=null&&data.length!=0?
              IntrinsicWidth(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(border: Border.all(color: MainController.isLightMode.value == true
                      ? whiteColor
                      : background,width: 0.5),  borderRadius: BorderRadius.circular(10),),
                  child: Column(
                    children: [
                      FormFile(
                        columnName: column['title'],
                        onChanged: (selecetdFiles) {
                          filesSelectedList.add(selecetdFiles);
                          ViewController.request[column['name']] = filesSelectedList;
                        },
                        filesSelected: selectedFilesMap,
                        selectedFilesTxt: filesSelectedList,
                        // selectedFilesTxt:  '',
                        isSeletedFile: isSeletedFile,
                        column: column,
                        fileInfo: fileInfo,
                      ),
                      Row(
                        children: [
                          for(var file in filesList)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                              children: [
                                Center(
                                    child: Column(
                                      children: [
                                        Image.network(
                                          baseUrl+'${file['path']}',
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.fill,
                                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                            return Image.asset(fileImage,width:70,
                                              height: 70,); // عکس جایگزین
                                          },
                                        ),
                                        Txt(
                                          '${file['name']}',
                                          color: MainController.isLightMode.value == true ? whiteColor : color2,
                                        ),
                                      ],
                                    )
                                ),
                                Positioned(
                                  top: 0,
                                    left: 0,
                                    child: IconButton(color: redColor, onPressed: () async {
                                      var status=await MainController.deleteFileInChunks(file['name'],recordId: file['_id'],record: json.encode({name:null}).toString());
                                      if(status==true){

                                        filesSelectedList.removeWhere((element) => element==file['name']);
                                        filesList.removeWhere((element) => element['path']==file['path']);
                                        filesList.removeWhere((element) => element['name']==file['name']);
                                      }
                                    }, icon: Icon(Icons.delete, size: 25 , color:redColor ,),))
                              ],
                          ),
                            ),

                        ],
                      ),
                    ],
                  ),
                ),
              ):Container()

          ],
        );
      }
    );
  }

  static Widget generateMultiFileBox(var selecetdFiles, var column,
      Rx<bool>? isSeletedFile) {
    print('ViewController.generateFileBox>>>${selecetdFiles}');
    Map<String, List<dynamic>> selectedFilesMap = {};
    if (selectedFilesMap['${column['name']}'] == null) {
      selectedFilesMap['${column['name']}'] = [];
    }
    List<dynamic> filesSelectedList=[];
    RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;
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
            if(column['type'] == 'file'){
              ViewController.request[column['name']] = selecetdFiles;
            }
            else{
              filesSelectedList.add(selecetdFiles);
              ViewController.request[column['name']] = filesSelectedList;
            }

          },
          filesSelected: selectedFilesMap,
          selectedFilesTxt: column['type'] == 'file' ? selecetdFiles:filesSelectedList,
          isSeletedFile: isSeletedFile,
          column: column,
          fileInfo: fileInfo,
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
            ViewController.request[column['name']] = time;
          },
        ),
      ],
    );
  }


  static Future<String> getTitleSelectedItem(String tableName,
      String selectedId, var column) async {
    String selectedTitle = '';
    var sourceItem = column['sourceItems'];
    if (sourceItem != 'custom') {
      if (selectedId != '') {
        List<dynamic> itemSelect = [];
        var object =
        (await DB(tableName).where('_id', '\$eq', selectedId).getRecords());
        if (object.length == 0) {
          selectedTitle = '${AppController.of(Get.context!)!.value('Uncertain')}';
        } else {
          var objectItem = object.first;
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

  static Future<List<dynamic>> getTitleMultiSelectedItem (String tableName, List<dynamic> selectedId, var column) async {
    List<dynamic> multiSelectedTitleList = [];
    var sourceItem = column['sourceItems'];
    for (var i = 0; i < selectedId.length; i++) {
      if (sourceItem != 'custom') {
        var object = await DB(tableName).where('_id', '\$eq', selectedId[i]).getRecords();
        if (object.length != 0) {
          var objectItem = object.first;
          List<dynamic> items = column['items'];
          for (var item in items) {
            multiSelectedTitleList.add(objectItem['${item}']);
          }
        } else {
          multiSelectedTitleList = [''];
        }
      }
      else {
        Map<String, dynamic> selectedItem = column['items'].firstWhere(
                (element) => element['value'] == selectedId[i],
            orElse: () => {'error': ''});
        if (selectedItem['title'] != null) {
          multiSelectedTitleList.add(selectedItem['title']);
        }
      }
    }
    return multiSelectedTitleList;
  }

  static String itemsShowSelectItem(var listItems, var column) {
    var items=column['items'];
    List<dynamic> a = [];
    if (listItems is List) {
      if (listItems.length == 0) {
        return "${AppController.of(Get.context!)!.value('not selected')}";
      }
      for (int i = 0; i < listItems.length; i++) {
        if(listItems[i] is String){
          a.add(listItems[i]);
        }
        else {
          if(column['source_items']=='table') {
            List<dynamic> empty = [];
            for (var field in items) {
              empty.add(listItems[i][field]);
            }
            a.add(empty.join('%'));
          }
          else{
            a.add(listItems[i]['title']);
          }
        }
      }
    }
    else {
      if (listItems is String) {
        a.add(listItems);
      }
      else {
        if (listItems['_id'] == '') {
          return "${AppController.of(Get.context!)!.value('not selected')}";
        }
        if(column['source_items']=='table') {
          List<dynamic> empty = [];
          for (var field in items) {
            empty.add(listItems[field]);
          }
          a.add(empty.join('%'));
        } else{
          a.add(listItems['title']);
        }
      }
    }
    return a.join(' , ');
  }

  static Future<List> itemsList(var column, {var dataModel}) async {
    print('ViewController.itemsList>>>$column');
    var type = column['source_items'];
    var tableName = column['source_table'];
    List<dynamic> dropDownListItems = [];
    if (type != 'custom') {
      if (dataModel==null || dataModel.isEmpty ) {
        // Future.delayed(Duration.zero, () async {
        List<dynamic> data = await DB('${tableName}').getRecords();
        data.removeWhere((element) => element['sync']!=null);
        dropDownListItems = data;
        for (int i = 0; i < dropDownListItems.length; i++) {
          List<dynamic> a = [];
          for (var field in column['items']) {
            a.add(dropDownListItems[i][field]);
          }
        }
      }
      else {
        if(dataModel[column['name']]==null){
          dropDownListItems=[];
        }
        else{
          dataModel[column['name']].removeWhere((element) => element['sync']!=null);
          List<dynamic> a = [];
          for (int i = 0; i < dataModel[column['name']].length; i++) {
            a.add(dataModel[column['name']][i]);
          };
          dropDownListItems=a;
        }}
    }
    else {
      List<dynamic> itemss = [];
      if (dataModel==null || dataModel.isEmpty ) {
        itemss = column['items'];
      }
      else {
        if(dataModel[column['name']]==null || dataModel[column['name']]==''){
          itemss = [];
        }else {
          for (var item in dataModel[column['name']]) {
            itemss.add(item);
          }
        }
      }
      dropDownListItems = itemss;
    }
    return dropDownListItems;
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