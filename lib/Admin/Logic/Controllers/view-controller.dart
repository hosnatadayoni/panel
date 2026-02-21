import 'dart:convert';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Helpers/utils/extensions.dart';
import 'package:finance/Admin/Logic/Models/tableModel.dart';
import 'package:finance/Admin/Logic/Models/dataModel.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/api-urls.dart';
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
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import '../../Public/config.dart';
import '../../UI/Componenets/Items/Form/form-file.dart';
import '../Models/columnModel.dart';
import '../Models/general.dart';

class ViewController extends GetxController {
  static Rx<String> selectedRadioButton = ''.obs;
  static Rx<bool> isClickedBtn = false.obs;
  static Rx<bool> isClickedEditBtn = false.obs;
  static Map<String, List<int>> fileSizeList = {};
  static Map<String, dynamic> request = {};

  // static Map<String, dynamic> requestFilter ={};
  static Map<String, dynamic> requestMultiSelect = <String, dynamic>{};
  static Map<String, dynamic> request2 = {};
  static RxList<Widget> filters = <Widget>[].obs;

  static copyClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    showSnackbar(snackTypes.info, "کپی شد");
  }

  static callFilterView() async {
    if (MainController.infoSchema.value.schema.filters != null) {
      var futures = MainController.infoSchema.value.schema.filters
      !.map<Future<Widget>>(
              (filter) => ViewController.generateFilterView(filter))
          .toList();
      filters.value = await Future.wait(futures);
    }
  }

  static Future<Widget> generateFilterView(Map<String, dynamic> filterInfo) async {
    var columnInfo = MainController.getColumnInfoByName(columnName: filterInfo['column']);

    Widget child = (await generateFilterFormView([columnInfo], filterInfo));

    return child;
  }

  static Future<Widget> generateFilterFormView(var columns, var filterInfo) async {
    var children = <Widget>[];
    var textField;
    var selectBox;
    var dateBox;
    var multiSelectBox;
    var colorBox;
    var fileBox;
    var timeBox;

    for (var j = 0; j < columns.length; j++) {
      if (columns[j].isShowStore == true) {
        ColumnModel column = columns[j];
        var type = column.type;
        var maxValidator;
        var minValidator;
        if (column.validators != []) {
          maxValidator = column.validators.firstWhere((validator) => validator['type'] == 'max', orElse: () => null);
          minValidator = column.validators.firstWhere((validator) => validator['type'] == 'min', orElse: () => null);
        }
        if (type == 'string' ||
            type == 'int' ||
            type == 'Number double' ||
            type == 'Number int' ||
            type == 'email' ||
            type == 'mobile') {
          textField = generateFormTextFieldFilter(column, filterInfo, type, '');
          children.add(textField);
        }

        if (type == 'select') {
          List<dynamic> items = await itemsList(column);
          selectBox = await generateStoreFormSelectBoxFilter(
              column, filterInfo, items, '', '', false.obs);

          children.add(selectBox);
        } else if (type == 'checkbox') {
          children.add(
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Txt(
                  '${column.title}',
                  color: MainController.isLightMode.value == true
                      ? whiteColor
                      : color2,
                ),
                SelectBox(
                    name: '${column.title}',
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
                        ViewController.request[
                        '${column.name}${filterInfo['operator']}'] = {
                          'value': false,
                          'column': '${column.name}',
                          'operator': '${filterInfo['operator']}',
                        };
                      } else {
                        ViewController.request[
                        '${column.name}${filterInfo['operator']}'] = {
                          'value': true,
                          'column': '${column.name}',
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
        } else if (type == 'radiobutton') {
          List<dynamic> items = await itemsList(column);
          selectBox = await generateStoreFormSelectBoxFilter(
              column, filterInfo, items, '', '', false.obs);

          children.add(selectBox);
        } else if (type == 'date') {
          dateBox = Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Txt(
                      '${column.title}',
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
                      ViewController.request[
                      '${column.name}${filterInfo['operator']}'] = {
                        'value': date,
                        'column': '${column.name}',
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
        } else if (type == 'time') {
          timeBox = generateFormTimeBoxFilter(
              column, filterInfo, TimeOfDay.now(), false.obs);

          children.add(timeBox);
        } else if (type == 'multiSelect') {
          List<dynamic> items = await itemsList(column);
          if (items.length != 0) {
            multiSelectBox = await generateStoreFormSelectBoxFilter(
                column, filterInfo, items, '', '', false.obs);
            ;

            children.add(multiSelectBox);
          }
        } else if (type == 'color') {
          colorBox = generateFormColorBoxFilter(
              column, filterInfo, Colors.blue, false.obs);

          children.add(colorBox);
        }
      }
    }
    return Wrap(
      children: children,
    );
  }

  static RxString storeKey = (Uuid().v4().toString() + '_store').obs;

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
      if (columns[j].isShowStore == true) {
        ColumnModel column = columns[j];
        var type = column.type;
        String name = column.title;

        GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
        GlobalKey<FormBuilderState> _fbKey2 = GlobalKey<FormBuilderState>();
        var maxValidator;
        var minValidator;
        if (column.validators != []) {
          maxValidator = column.validators.firstWhere(
                  (validator) => validator['type'] == 'max',
              orElse: () => null);
          minValidator = column.validators.firstWhere(
                  (validator) => validator['type'] == 'min',
              orElse: () => null);
        }
        if (type == 'string' ||
            type == 'int' ||
            type == 'Number double' ||
            type == 'Number int' ||
            type == 'email' ||
            type == 'mobile') {
          GlobalKey<FormBuilderState> key = GlobalKey<FormBuilderState>(debugLabel: column.name + '_store');
          textField = generateFormTextField(fbKey: key, column: column, type: type);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(textField);
        }
        if (type == 'select') {
          List<dynamic> items = await itemsList(column);
          selectBox = await generateStoreFormSelectBox(column: column, items: items,);

          children.add(SizedBox(
            height: 20,
          ));
          children.add(selectBox);
        } else if (type == 'checkbox') {
          checkBox = generateFormCheckBox(
            column: column,
          );
          children.add(SizedBox(
            height: 20,
          ));
          children.add(checkBox);
        } else if (type == 'radiobutton') {
          var initValue;
          List<dynamic> items = await itemsList(column);
          radioButtonBox =
              generateFormRadioButton(column: column, items: items);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(radioButtonBox);
        } else if (type == 'date') {
          dateBox = generateFormDateBox(
            column: column,
          );
          children.add(SizedBox(
            height: 20,
          ));
          children.add(dateBox);
        } else if (type == 'multiSelect') {
          multiSelectBox = await genarateStoreFormMuiltiSelectBox(column: column);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(multiSelectBox);
        } else if (type == 'color') {
          colorBox = generateFormColorBox(column: column);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(colorBox);
        } else if (type == 'file' ||
            type == 'file_pv' ||
            type == 'multiFile' ||
            type == 'multiFile_pv') {
          fileBox = generateFileBox(column:  column);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(fileBox);
        } else if (type == 'time') {
          timeBox = generateFormTimeBox(column: column);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(timeBox);
        }
      }
    }
    return Container(
      child: Obx(() {
        return Container(
          key: ValueKey(storeKey.value),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: children),
        );
      }),
    );
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
    for (var j = 0; j < MainController.infoSchema.value.columns.length; j++) {
      if (MainController.infoSchema.value.columns[j].isShowEdit == true) {
        var column = MainController.infoSchema.value.columns[j];
        var type = column.type;
        var name = column.name;
        var maxValidator;
        var minValidator;
        List<dynamic> items = [];
        print('dataModel d>>>${dataModel['${name}']}');
        if (column.validators != []) {
          maxValidator = column.validators.firstWhere(
                  (validator) => validator['type'] == 'max',
              orElse: () => null);
          minValidator = column.validators.firstWhere(
                  (validator) => validator['type'] == 'min',
              orElse: () => null);
        }
        if (type == 'string' ||
            type == 'int' ||
            type == 'Number double' ||
            type == 'Number int' ||
            type == 'email' ||
            type == 'mobile') {
          GlobalKey<FormBuilderState> key =
          GlobalKey<FormBuilderState>(debugLabel: column.name + '_edit');
          textField = generateFormTextField(
              fbKey: key,
              column: column,
              type: type,
              initValue: dataModel['${name}']);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(textField);
        } else if (type == 'select') {
          Map<String, dynamic> selectedItem = <String, dynamic>{};
          List<dynamic> items = await ViewController.itemsList(column);
          if (items.length != 0) {
            if (column.sourceItems != 'custom') {
              if (dataModel[name] != null && dataModel[name] != '') {
                selectedItem = items.firstWhere(
                        (element) => element['_id'] == dataModel[name]['_id']);
              }
              selectBox = await generateStoreFormSelectBox(column: column, items: items, initailValue:selectedItem.isNotEmpty ? '${selectedItem['_id'] }': null, selected: dataModel[name]);
            } else {
              if (dataModel[name] != null && dataModel[name] != '')
                selectedItem = items.firstWhere(
                        (element) => element['value'] == dataModel[name]['value']);
              selectBox = await generateStoreFormSelectBox(
                  column: column,
                  items: items,
                  initailValue:selectedItem.isNotEmpty ? '${ selectedItem['value']}':null,
                  selected: dataModel[name]);
            }
            children.add(SizedBox(
              height: 20,
            ));
            children.add(selectBox);
          }
        } else if (type == 'checkbox') {
          checkBox = generateFormCheckBox(
              column: column,
              data: dataModel[name],
              defultValue: dataModel['${name}']);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(checkBox);
        } else if (type == 'radiobutton') {
          Map<String, dynamic> selectedItem = <String, dynamic>{};
          var items = await ViewController.itemsList(column);
          if (items.length != 0) {
            if (column.sourceItems != 'custom') {
              if (dataModel[name] != null && dataModel[name] != '')
                selectedItem = items.firstWhere(
                        (element) => element['_id'] == dataModel[name]['_id']);

              selectBox = await generateFormRadioButton(
                  column: column,
                  items: items,
                  initalValue:
                  '${selectedItem.isNotEmpty ? selectedItem['_id'] : ''}',
                  data: dataModel[name]);
            } else {
              if (dataModel[name] != null && dataModel[name] != '')
                selectedItem = items.firstWhere(
                        (element) => element['value'] == dataModel[name]);

              selectBox = await generateFormRadioButton(
                  column: column,
                  items: items,
                  initalValue:
                  '${selectedItem.isNotEmpty ? selectedItem['value'] : ''}',
                  data: dataModel[name]);
            }
            children.add(SizedBox(
              height: 20,
            ));
            children.add(selectBox);
          }
        } else if (type == 'date') {
          List<String>? dateParts;
          int year = Jalali.now().year;
          int month = Jalali.now().month;
          int day = Jalali.now().day;
          if (dataModel['${name}'] != null) {
            dateParts = dataModel['${name}'].split('/');
            year = int.parse('${dateParts![0]}');
            month = int.parse('${dateParts[1]}');
            day = int.parse('${dateParts[2]}');
          }
          dateBox = generateFormDateBox(
              column: column,
              selectedDate: Jalali(year, month, day),
              data: dataModel['${name}']);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(dateBox);
        } else if (type == 'multiSelect') {
          List<dynamic> items =
          await ViewController.itemsList(column, dataModel: dataModel);
          List<dynamic> multiSelectedItemList = [];
          if (items.length != 0) {
            if (column.sourceTable != null) {
              for (var selectedItem in items) {
                multiSelectedItemList
                    .add(itemsShowSelectItem(selectedItem, column));
              }
            } else {
              for (var selectedItem in items) {
                multiSelectedItemList.add(selectedItem['title']);
              }
            }
          }
          if (dataModel.isNotEmpty) {
            multiSelectBox = await genarateEditFormMuiltiSelectBox(
                column,
                multiSelectedItemList.length != 0
                    ? RxString(multiSelectedItemList.join(' , '))
                    : RxString(''),
                items.length != 0 ? RxList(items) : <dynamic>[].obs,
                false.obs);
          } else {
            multiSelectBox = await genarateEditFormMuiltiSelectBox(
                column, RxString(''), <dynamic>[].obs, false.obs);
          }
          children.add(SizedBox(
            height: 20,
          ));
          children.add(multiSelectBox);
        } else if (type == 'color') {
          colorBox = generateFormColorBox(
              column: column,
              selectedColor: dataModel[name] != null && dataModel[name] != ''
                  ? Color(int.parse('${dataModel[name]}'))
                  : null,
              data: dataModel[name]);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(colorBox);
        } else if (type == 'file' || type == 'file_pv') {
          fileBox = generateEditFileBox(
              dataModel[name] != null && dataModel[name] != ''
                  ? dataModel
                  : null,
              column);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(fileBox);
        } else if (type == 'multiFile' || type == 'multiFile_pv') {
          fileBox = generateEditMultiFileBox(
              dataModel[name] != null && dataModel[name].length != 0
                  ? dataModel
                  : null,
              column);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(fileBox);
        } else if (type == 'time') {
          List<String>? TimeParts;
          int hour = TimeOfDay.now().hour;
          int minute = TimeOfDay.now().minute;
          if (dataModel['${name}'] != null) {
            TimeParts = dataModel['${name}'].split(':');
            hour = int.parse('${TimeParts![0]}');
            minute = int.parse('${TimeParts[1]}');
          }

          timeBox = generateFormTimeBox(column: column, selectedTime: TimeOfDay(hour: hour, minute: minute), data:  dataModel['${name}'] );
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

  static Future<Widget> generateDataColumn(int indexColumn, int indexRow, {var table}) async {
    var size = MediaQuery.of(Get.context!).size;
    String name = '';
    name = MainController.infoSchema.value.columns[indexColumn].name;
    var dataModel = MainController.dataRecord[indexRow]['${name}'];
    String type = '';
    if (table == null) {
      type = MainController.infoSchema.value.columns[indexColumn].type;
      name = MainController.infoSchema.value.columns[indexColumn].name;
    } else {
      type = table['columns'][indexColumn]['type'];
      name = table['columns'][indexColumn]['name'];
    }
    var child;
    if (type == 'checkbox') {
      child = generateCheckBox(indexColumn, indexRow, tableData: table);
    } else if (type == 'color') {
      child = generateColor(indexColumn, indexRow, tableData: table);
    } else if (type == 'select' || type == 'radiobutton') {
      child = InkWell(
        onDoubleTap: () async {
          print('ViewController.generateDataColumn');
          await copyClipboard(MainController.dataRecord[indexRow]['${name}'] !=
              null
              ? '${itemsShowSelectItem(MainController.dataRecord[indexRow]['${name}'], MainController.infoSchema.value.columns[indexColumn])}'
              : '');
        },
        child: Txt(
          MainController.dataRecord[indexRow]['${name}'] != null
              ? '${itemsShowSelectItem(MainController.dataRecord[indexRow]['${name}'], MainController.infoSchema.value.columns[indexColumn])}'
              : '',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: MainController.isLightMode.value == true ? whiteColor : color2,
          textAlign: TextAlign.center,
        ),
      );
    } else if (type == 'multiSelect') {
      child = InkWell(
        onDoubleTap: () async {
          await copyClipboard(MainController.dataRecord[indexRow]['${name}'] !=
              null
              ? '${itemsShowSelectItem(MainController.dataRecord[indexRow]['${name}'], MainController.infoSchema.value.columns[indexColumn])}'
              : '');
        },
        child: Txt(
          MainController.dataRecord[indexRow]['${name}'] != null
              ? '${itemsShowSelectItem(MainController.dataRecord[indexRow]['${name}'], MainController.infoSchema.value.columns[indexColumn])}'
              : '',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: MainController.isLightMode.value == true ? whiteColor : color2,
          textAlign: TextAlign.center,
        ),
      );
    } else if (type == 'file' || type == 'file_pv') {
      child = generateCellFileBox(indexColumn, indexRow, tableData: table);
    } else if (type == 'multiFile' || type == 'multiFile_pv') {
      child = generateCellMultiFileBox(indexColumn, indexRow, tableData: table);
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

  static Widget generateCheckBox(int indexColumn, int indexRow, {var tableData}) {
    // DataModel dataModel = MainController.tableData.value[indexRow];
    String name = '';
    if (tableData == null) {
      name = MainController.infoSchema.value.columns[indexColumn].name;
    } else {
      name = tableData['columns'][indexColumn]['name'];
    }
    var dataModel = MainController.dataRecord.value[indexRow]['${name}'];
    if (dataModel == null) {
      dataModel = false;
    }
    return CheckBox(
      defaultValue: dataModel == "true" || dataModel==true? true : false,
      checkBoxTitle: '',
      onChange: (text) async {
        await DB('${MainController.infoSchema.value.schema.name}').where('_id', '\$eq', '${MainController.dataRecord.value[indexRow]['_id']}').updateRecords({'${name}': '${text}'});
      },
      index: indexRow,
      column: tableData == null
          ? MainController.infoSchema.value.columns[indexColumn]
          : tableData['columns'][indexColumn],
    );
  }

  static Widget generateColor(int indexColumn, int indexRow, {var tableData}) {
    // DataModel dataModel = MainController.tableData.value[indexRow];
    String name;
    if (tableData == null) {
      name = MainController.infoSchema.value.columns[indexColumn].name;
    } else {
      name = tableData['columns'][indexColumn]['name'];
    }
    var dataModel = MainController.dataRecord[indexRow]['${name}'];

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
    String type;
    if (tableData == null) {
      name = MainController.infoSchema.value.columns[indexColumn].name;
      type = MainController.infoSchema.value.columns[indexColumn].type;
    } else {
      name = tableData['columns'][indexColumn]['name'];
      type = tableData['columns'][indexColumn]['type'];
    }
    var dataModel = MainController.dataRecord[indexRow]['${name}'];
    return Obx(() {
      return InkWell(
        onDoubleTap: () async {
          await copyClipboard('${dataModel != null ? dataModel : ''}');
        },
        child: Center(
          child: Txt(
            '${dataModel != null ? type.toLowerCase().contains('int') ? int.parse(dataModel.toString()).toNumber() : dataModel.toString().length > 20 ? dataModel.toString().substring(0, 20) + '...' : dataModel : ''}',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }

  static Widget generateFormTextField(
      {var fbKey,
        ColumnModel? column,
        var type,
        Function? onChange,
        var initValue = null}) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column!.title}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        FormTextField(
          name: '${column!.name}',
          fbKey: fbKey,
          hint: '${column.title}',
          lable: '',
          column: column,
          initValue: initValue != null ? initValue.toString() : '',
          onChange: (text) {
            if (onChange != null) {
              onChange(text);
            } else {
              if (text != null && text != '') {
                if (column.type == 'Number int') {
                  ViewController.request[column.name] = int.parse('${text}');
                } else if (column.type == 'Number double') {
                  ViewController.request[column.name] =
                      double.parse('${text}');
                } else {
                  ViewController.request[column.name] = text;
                }
              } else {
                ViewController.request[column.name] = '';
              }
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

  static Widget generateFormTextFieldFilter(
      ColumnModel column, var filterInfo, var type, String initValue) {
    print('ViewController.generateFormTextFieldFilter>>${column.type}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Txt(
              '${column.title} (${General.oprator('${filterInfo['operator']}')})',
              color: MainController.isLightMode.value == true
                  ? whiteColor
                  : color2,
            ),
          );
        }),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 120,
          child: FormTextField(
            isValidate: false,
            name: '${column.title}',
            // fbKey: _fbKey,
            hint: '${column.title}',
            lable: '',
            column: column,
            initValue: initValue,
            onChange: (text) {
              if (text != null && text != '') {
                if (column.type == 'Number int') {
                  ViewController
                      .request['${column.name}${filterInfo['operator']}'] = {
                    'value': '${int.parse('${text}')}',
                    'column': '${column.name}',
                    'operator': '${filterInfo['operator']}',
                  };
                } else if (column.type == 'Number double') {
                  ViewController
                      .request['${column.name}${filterInfo['operator']}'] = {
                    'value': '${double.parse('${text}')}',
                    'column': '${column.name}',
                    'operator': '${filterInfo['operator']}',
                  };
                  print(
                      'ViewController.generateFormTextFieldFilter>>${ViewController.request}');
                } else {
                  ViewController
                      .request['${column.name}${filterInfo['operator']}'] = {
                    'value': '${text}',
                    'column': '${column.name}',
                    'operator': '${filterInfo['operator']}',
                  };
                }
              } else {
                ViewController
                    .request['${column.name}${filterInfo['operator']}'] = {
                  'value': '',
                  'column': '${column.name}',
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

  static Widget generateStoreFormSelectBoxFilter(
      ColumnModel column,
      var filterInfo,
      List<dynamic> items,
      String hintText,
      String initailValue,
      Rx<bool> isSeleted) {
    if (initailValue == '' || initailValue == null) {
      ViewController.request[column.name] = null;
    }
    return items.length != 0
        ? new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt('${column.title}',
              color: MainController.isLightMode.value == true
                  ? whiteColor
                  : color2);
        }),
        SizedBox(
          height: 10,
        ),
        column.sourceItems != 'custom'
            ? SelectBox(
            name: '${column.title}',
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
                ViewController.request['${column.name}${filterInfo['operator']}'] = {
                  'value': value,
                  'column': '${column.name}',
                  'operator': '${filterInfo['operator']}',
                };
                // ViewController.request[column.name] = value;
              } else {
                ViewController.request[
                '${column.name}${filterInfo['operator']}'] = {
                  'value': '',
                  'column': '${column.name}',
                  'operator': '${filterInfo['operator']}',
                };
                // ViewController.request[column.name] = '';
              }
            },
            hintText: hintText,
            isSeleted: isSeleted,
            selectedValue: '')
            : SelectBox(
            name: '${column.title}',
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
                ViewController.request[
                '${column.name}${filterInfo['operator']}'] = {
                  'value': value,
                  'column': '${column.name}',
                  'operator': '${filterInfo['operator']}',
                };
              } else {
                ViewController.request[
                '${column.name}${filterInfo['operator']}'] = {
                  'value': '',
                  'column': '${column.name}',
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

  static Widget generateFormTimeBoxFilter(var column, var filterInfo,
      TimeOfDay selectedTime, Rx<bool>? isSeletedTime) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column.title}',
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
            ViewController
                .request['${column.name}${filterInfo['operator']}'] = {
              'value': time,
              'column': '${column.name}',
              'operator': '${filterInfo['operator']}',
            };
          },
        ),
      ],
    );
  }

  static Widget generateFormColorBoxFilter(var column, var filterInfo,
      Color selectedColor, Rx<bool>? isSeletedColor) {
    Color colorChanged;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column.title}',
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

              ViewController
                  .request['${column.name}${filterInfo['operator']}'] = {
                'value': hexColor,
                'column': '${column.name}',
                'operator': '${filterInfo['operator']}',
              };
            },
            column: column,
          ),
        ),
      ],
    );
  }

  static Widget generateStoreFormSelectBox(
      {var column,
        List<dynamic> items = const [],
        var initailValue = null,
        var selected = null,
        Function? onChange}) {
    RxBool isSeleted = selected == '' || selected == null ? false.obs : true.obs;
    if (initailValue == '' || initailValue == null) {
      ViewController.request[column.name] = null;
    }
    print('ViewController.generateStoreFormSelectBox>>${initailValue=="null"}');

    return items.length != 0
        ? new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column.title}',
            color: MainController.isLightMode.value == true
                ? whiteColor
                : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        column.sourceItems != 'custom'
            ? SelectBox(
            name: '${column.title}',
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
                      return Txt('${itemsShowSelectItem(item, column)}',
                        color: MainController.isLightMode.value == true ? whiteColor : primaryDark,
                      );
                    }),
                    value: item['_id'].toString()),
            ],
            initalValue: initailValue == '' || initailValue == null ? "" : initailValue,
            onChanged: (value) async {
              if (onChange != null) {
                onChange(value);
              } else {
                if (value != '') {
                  ViewController.request[column.name] = value;
                } else {
                  ViewController.request[column.name] = '';
                }
              }
            },
            hintText: initailValue ?? '',
            isSeleted: isSeleted,
            selectedValue: '')
            : SelectBox(
            name: '${column.title}',
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
              if (onChange != null) {
                onChange(value);
              } else {
                for (var item in items) {
                  if (item['title'] == value) {
                    if (item['value'] == '') {
                      value = null;
                    }
                  }
                }
                if (value != '') {
                  ViewController.request[column.name] = value;
                } else {
                  ViewController.request[column.name] = '';
                }
              }
            },
            hintText: initailValue ?? '',
            isSeleted: isSeleted,
            selectedValue: ''),
      ],
    )
        : Container();
  }

  static Widget generateFormCheckBox({ColumnModel? column, var data = null, var defultValue = null, Function? onChange}) {
    print('ViewController.generateFormCheckBox>>${defultValue==null}>>${defultValue.runtimeType}');
    if(defultValue.toString().isEmpty)
      defultValue=false;

    ViewController.request[column!.name] = defultValue ?? column.defaultValue;
    return new CheckBox(
      checkBoxName: '${column.title}',
      checkBoxTitle: '${column.title}',
      isClickedBtn: data == null || data == '' ? false.obs : true.obs,
      defaultValue: defultValue ?? column.defaultValue,
      onChange: (text) {
        if (onChange != null) {
          onChange(text);
        } else {
          ViewController.request[column.name] = text;
        }
        // dataJson[columnName] = text;
      },
      column: column,
    );
  }

  static Widget generateFormRadioButton(
      {var column,
        List<dynamic> items = const [],
        var initalValue = null,
        var data = null,
        Function? onChange}) {
    print('ViewController.generateFormRadioButton>>${items}');
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column.title}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        column.sourceItems != 'custom'
            ? RadioButton(
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
            if (onChange != null) {
              onChange(text);
            } else {
              if (text != '') {
                //   // selectedValue=value!;
                ViewController.request[column.name] = text;
              } else {
                ViewController.request[column.name] = '';
              }

              // dataJson[columnName] = selectedRadioButton.value;
            }
          },
          initalValue: initalValue == null ? '' : initalValue,
          column: column,
          isSelectedItem:
          data == null || data == '' ? false.obs : true.obs,
        )
            : RadioButton(
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
            if (onChange != null) {
              onChange(text);
            } else {
              ViewController.request[column.name] = text;
              // dataJson[columnName] = selectedRadioButton.value;
            }
          },
          initalValue: initalValue == null ? '' : initalValue,
          column: column,
          isSelectedItem:
          data == null || data == '' ? false.obs : true.obs,
        ),
      ],
    );
  }

  static Widget generateFormDateBox(
      {var column,
        Jalali? selectedDate = null,
        var data = null,
        Function? onChange}) {
    if (selectedDate == null) {
      selectedDate = Jalali.now();
    }
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column.title}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        DateBox(
          selectedDate: selectedDate,
          isSeletedDate: data == null || data == '' ? false.obs : true.obs,
          onDateChanged: (date) {
            if (onChange != null)
              onChange(date)!;
            else
              ViewController.request[column.name] = date;
          },
          column: column,
        ),
      ],
    );
  }

  static Future<Widget> genarateEditFormMuiltiSelectBox(
      var column,
      Rx<String> hintTxt,
      RxList<dynamic> selectedItemsList,
      Rx<bool> isSelectedItem) async {
    RxList<String> selectedItemId = <String>[].obs;
    List<dynamic> items = [];
    List<dynamic> selectedId = [];

    if (column.sourceItems != 'custom') {
      items = await DB('${column.sourceTable}').getRecords();

      if (selectedItemsList.length != 0) {
        for (var selectedItem in selectedItemsList) {
          if (selectedItem['_id'] != null) {
            selectedItemId.add(selectedItem['_id']);
          }
        }
        ViewController.request[column.name] = selectedItemId;
      }

      return items.length != 0
          ? new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return Txt(
              '${column.title}',
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
                                        value: selectedItemId
                                            .contains(item['_id']),
                                        onChanged: (isChecked) {
                                          if (isChecked != null) {
                                            hintTxt.value = '';
                                            if (!selectedItemsList.any(
                                                    (element) =>
                                                element['_id'] ==
                                                    item['_id'])) {
                                              requestMultiSelect = item;
                                              selectedItemsList.add(item);
                                              selectedItemId
                                                  .add(item['_id']);
                                            } else {
                                              requestMultiSelect
                                                  .removeWhere((key,
                                                  value) =>
                                              value == ['_id']);
                                              selectedItemsList
                                                  .removeWhere(
                                                      (element) =>
                                                  element[
                                                  '_id'] ==
                                                      item['_id']);
                                              selectedItemId
                                                  .remove(item['_id']);
                                            }
                                            if (item['_id'] == '') {
                                              selectedItemId.value
                                                  .remove(item['_id']);
                                            }
                                            if (selectedItemId
                                                .value.length ==
                                                0) {
                                              isSelectedItem.value =
                                              false;
                                            } else {
                                              isSelectedItem.value = true;
                                            }
                                            for (var r
                                            in selectedItemsList)
                                              hintTxt.value =
                                                  hintTxt.value +
                                                      itemsShowSelectItem(
                                                          r, column);
                                            ViewController.request[
                                            column.name] =
                                                selectedItemId;
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
    } else {
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
              '${column.title}',
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
                                        value: selectedItemsList
                                            .any((map) => mapEquals(map, item)),
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
                                              requestMultiSelect.removeWhere(
                                                      (key, value) =>
                                                  value == ['value']);
                                              var index = selectedItemsList
                                                  .indexWhere((map) =>
                                                  mapEquals(map, item));

                                              selectedItemsList.removeAt(index);
                                            }

                                            if (selectedItemsList
                                                .value.length ==
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

                                            ViewController
                                                .request[column.name] =
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

  static Future<Widget> genarateStoreFormMuiltiSelectBox(
      {required var column,
        var hintText = null,
        List<dynamic>? selectedItemList,
        var data = null,
        Function? onChange}) async {
    RxString hintTxt = hintText != null ? hintText.obs : ''.obs;
    RxList<dynamic> selectedItemsList=[].obs;
    selectedItemsList.value = selectedItemList!=null? selectedItemList:[] ;
    Rx<bool> isSelectedItem = data == null || data == '' ? false.obs : true.obs;
    List<dynamic> items = [];
    items = await itemsList(column);
    List<dynamic> selectedId = [];
    return items.length != 0 ?
    column.sourceItems != 'custom'? new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column.title}',
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
                                                  (map) => mapEquals(
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
                                                itemsShowSelectItem(
                                                    r, column);

                                          for (var r
                                          in selectedItemsList)
                                            selectedId.add(r['_id']);

                                          ViewController.request[
                                          column.name] =
                                              selectedId;
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
            '${column.title}',
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
                                      value: selectedItemsList.any(
                                              (map) =>
                                              mapEquals(map, item)),
                                      onChanged: (isChecked) {
                                        if (isChecked != null) {
                                          hintTxt.value = '';
                                          if (!selectedItemsList.any(
                                                  (map) => mapEquals(
                                                  map, item))) {
                                            selectedId = [];
                                            requestMultiSelect = item;
                                            selectedItemsList
                                                .add(item);
                                          } else {
                                            selectedId = [];
                                            requestMultiSelect
                                                .removeWhere(
                                                    (key, value) =>
                                                value ==
                                                    ['value']);
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
                                            hintTxt.value =
                                                hintTxt.value +
                                                    r['title'];

                                          for (var r
                                          in selectedItemsList)
                                            selectedId
                                                .add(r['value']);

                                          ViewController.request[
                                          column.name] =
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

  static Widget generateFormColorBox(
      {var column, Color? selectedColor, var data, Function? onChange}) {
    Rx<bool> isSeletedColor = data == null || data == '' ? false.obs : true.obs;
    Color colorChanged;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column.title}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        Container(
          child: ColorPickerBox(
            selectedColor: selectedColor != null ? selectedColor : appColor,
            isSeletedColor: isSeletedColor,
            onChanged: (color) {
              if (onChange != null) {
                onChange(color);
              } else {
                colorChanged = color;
                String hexColor = '0x${colorChanged.value.toRadixString(16).padLeft(8, '0')}';
                // dataJson[columnName] = hexColor;
                ViewController.request[column.name] = hexColor;
              }
            },
            column: column,
          ),
        ),
      ],
    );
  }

  static Widget generateCellFileBox(int indexColumn, int indexRow,
      {var tableData}) {
    String name;
    String type;
    if (tableData == null) {
      name = MainController.infoSchema.value.columns[indexColumn].name;
      type = MainController.infoSchema.value.columns[indexColumn].type;
    } else {
      name = tableData.columns[indexColumn].name;
      type = tableData.columns[indexColumn].type;
    }
    var dataModel = MainController.dataRecord[indexRow]['${name}'];
    return dataModel != null && dataModel.length != 0
        ? Column(
      children: [
        Center(
            child: Image.network(
              type == 'file'
                  ? '${baseUrl}' + '${dataModel}'
                  : '${baseUrlPvFile}' + '${dataModel}',
              width: 60,
              height: 60,
              fit: BoxFit.fill,
              errorBuilder: (BuildContext context, Object error,
                  StackTrace? stackTrace) {
                return Image.asset(
                  fileImage,
                  width: 60,
                  height: 60,
                ); // عکس جایگزین
              },
            )
          // Img('${ dataModel}',width: 70,height: 70,isNetwork: true,),

        ),
      ],
    )
        : Container();
  }

  static Widget generateCellMultiFileBox(int indexColumn, int indexRow,
      {var tableData}) {
    String name;
    String type;
    if (tableData == null) {
      name = MainController.infoSchema.value.columns[indexColumn].name;
      type = MainController.infoSchema.value.columns[indexColumn].type;
    } else {
      name = tableData['columns'][indexColumn]['name'];
      type = tableData['columns'][indexColumn]['type'];
    }
    var dataModel = MainController.dataRecord[indexRow]['${name}_multi'];
    return dataModel != null && dataModel.length != 0
        ? Container(
      width: 150,
      child: Wrap(
        children: [
          for (var data in dataModel)
            Center(
                child: Image.network(
                  type == 'multiFile'
                      ? baseUrl + '${data['path']}'
                      : baseUrlPvFile + '${data['path']}',
                  width: 50,
                  height: 50,
                  fit: BoxFit.fill,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      fileImage,
                      width: 70,
                      height: 40,
                    );
                  },
                )
              // Img('${ dataModel}',width: 70,height: 70,isNetwork: true,),

            ),
        ],
      ),
    )
        : Container();
  }

  static Widget generateFileBox({var selecetdFiles=null, var column,
    Function? onChange}) {
    final RxBool isSelectedFile =
        (selecetdFiles != null && selecetdFiles!='').obs;
    Map<String, List<dynamic>> selectedFilesMap = {};
    if (selectedFilesMap['${column.name}'] == null) {
      selectedFilesMap['${column.name}'] = [];
    }
    List<dynamic> filesSelectedList = [];
    RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column.title}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        FormFile(
          columnName: column.title,
          onChanged: (file) {
            // dataJson[columnName] = selecetdFiles;
            if (column.type == 'file' || column.type == 'file_pv') {
              if (onChange != null) {
                onChange(file);
              } else {
                ViewController.request[column.name] = file;
              }
            } else {
              if (onChange != null) {
                onChange(filesSelectedList);
              } else {
                filesSelectedList.add(file);
                ViewController.request[column.name] = filesSelectedList;
              }
            }
          },
          filesSelected: selectedFilesMap,
          selectedFilesTxt:
          column.type == 'file' || column.type == 'file_pv'
              ? selecetdFiles
              : filesSelectedList,
          isSeletedFile: isSelectedFile,
          column: column,
          fileInfo: fileInfo,
        ),
      ],
    );
  }

  static Widget generateEditFileBox(var data, var column,
      {Function? onChange}) {
    final RxBool isSelectedFile = (data != null && data!.isNotEmpty).obs;

    String name = column.name;
    String type = column.type;
    RxString file =
    data != null && data[name] != null ? '${data[name]}'.obs : ''.obs;

    Map<String, List<dynamic>> selectedFilesMap = {};
    if (selectedFilesMap['${column.name}'] == null) {
      selectedFilesMap['${column.name}'] = [];
    }
    // ViewController.request[name] = data != null && data[name + '_name'] != null
    //     ? '${data[name + '_name']}'
    //     : '';
    List<dynamic> filesSelectedList = [];
    RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;
    return Obx(() {
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Txt(
            '${column.title}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          ),
          SizedBox(
            height: 10,
          ),
          file.value != ''
              ? IntrinsicWidth(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : background,
                    width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Image.network(
                            type == 'file'
                                ? baseUrl + '${file}'
                                : baseUrlPvFile + '${file}',
                            width: 40,
                            height: 40,
                            fit: BoxFit.fill,
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return Image.asset(
                                fileImage,
                                width: 40,
                                height: 40,
                              ); // عکس جایگزین
                            },
                          ),
                          Txt(
                            '${data[name + '_name']}',
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                          ),
                        ],
                      )),
                  Positioned(
                      top: 0,
                      left: 0,
                      child: IconButton(
                        color: redColor,
                        onPressed: () async {
                          widgetDeletePopup(onChange: () async {
                            var status =
                            await MainController.deleteFileInChunks(
                                data[name + '_name'],
                                recordId: data['_id'],
                                record: json
                                    .encode({name: null}).toString());
                            if (status == true) {
                              file.value = '';
                              Navigator.pop(Get.context!);
                            }
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 25,
                          color: redColor,
                        ),
                      ))
                ],
              ),
            ),
          )
              : FormFile(
            columnName: column.title,
            onChanged: (selecetdFiles) {
              if (onChange != null) {
                onChange(filesSelectedList);
              } else {
                ViewController.request[name] = selecetdFiles;
              }
            },
            filesSelected: selectedFilesMap,
            // selectedFilesTxt: column['type'] == 'file' ? selecetdFiles:filesSelectedList,
            selectedFilesTxt: '',
            isSeletedFile: isSelectedFile,
            column: column,
            fileInfo: fileInfo,
          ),
        ],
      );
    });
  }

  static Widget generateEditMultiFileBox(var data, var column,
      {Function? onChange}) {
    final RxBool isSelectedFile = (data != null && data!.isNotEmpty).obs;
    // ViewController.request[column.name] = [];
    String name = column.name;
    String type = column['type'];
    Map<String, List<dynamic>> selectedFilesMap = {};
    if (selectedFilesMap['${column.name}'] == null) {
      selectedFilesMap['${column.name}'] = [];
    }
    RxList<String> filesSelectedList = <String>[].obs;
    RxList<dynamic> filesList = [].obs;

    if (data != null && data.length != 0) {
      if (data[name + '_name'] != null && data[name + '_name'].length != 0) {
        // ViewController.request[column.name].add(data[name + '_name']);
      }
      if (data[name] != null && data[name].length != 0) {
        filesList.addAll(data[name + '_multi']);

        for (var file in data[name]) {
          filesSelectedList.add('${file}');
        }
      }
    }
    RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;
    return Obx(() {
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Txt(
            '${column.title}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          ),
          SizedBox(
            height: 10,
          ),
          data != null && data.length != 0
              ? IntrinsicWidth(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : background,
                    width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  FormFile(
                    columnName: column.title,
                    onChanged: (selecetdFiles) {
                      filesSelectedList.add(selecetdFiles);
                      ViewController.request[column.name] =
                          filesSelectedList;
                    },
                    filesSelected: selectedFilesMap,
                    selectedFilesTxt: filesSelectedList,
                    // selectedFilesTxt:  '',
                    isSeletedFile: isSelectedFile,
                    column: column,
                    fileInfo: fileInfo,
                  ),
                  Row(
                    children: [
                      for (var file in filesList)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Center(
                                  child: Column(
                                    children: [
                                      Image.network(
                                        type == 'multiFile'
                                            ? baseUrl + '${file['path']}'
                                            : baseUrlPvFile +
                                            '${file['path']}',
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.fill,
                                        errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) {
                                          return Image.asset(
                                            fileImage,
                                            width: 70,
                                            height: 70,
                                          );
                                        },
                                      ),
                                      Txt(
                                        '${file['name']}',
                                        color: MainController
                                            .isLightMode.value ==
                                            true
                                            ? whiteColor
                                            : color2,
                                      ),
                                    ],
                                  )),
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: IconButton(
                                    color: redColor,
                                    onPressed: () async {
                                      widgetDeletePopup(
                                          onChange: () async {
                                            if (data[name] != null) {
                                              data[name].removeWhere(
                                                      (element) =>
                                                  element ==
                                                      file['name']);
                                            }
                                            var status = await MainController
                                                .deleteFileInChunks(
                                                file['name'],
                                                recordId: data['_id'],
                                                record: json.encode({
                                                  name: data[name]
                                                }).toString());
                                            if (status == true) {
                                              filesSelectedList.removeWhere(
                                                      (element) =>
                                                  element ==
                                                      file['name']);
                                              filesList.removeWhere(
                                                      (element) =>
                                                  element['path'] ==
                                                      file['path']);
                                              filesList.removeWhere(
                                                      (element) =>
                                                  element['name'] ==
                                                      file['name']);
                                              if (ViewController.request[
                                              column.name] !=
                                                  null)
                                                ViewController
                                                    .request[column.name]
                                                    .removeWhere((element) =>
                                                element ==
                                                    file['name']);
                                              Navigator.pop(Get.context!);
                                            }
                                          });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 25,
                                      color: redColor,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          )
              : Container()
        ],
      );
    });
  }

  static Widget generateSelectFileBox(
      String type,
      RxList<String> fileSelectedList,
      RxMap<String, List<dynamic>> fileInfo,
      var index) {
    return Obx(() {
      var fileData = fileInfo[fileSelectedList[index]];
      var totalChunks = 1;
      var currentChunk = 0;
      RxMap<String, dynamic>? chunkName = <String, dynamic>{}.obs;
      if (fileInfo[fileSelectedList[index]] != null) {
        totalChunks = fileData?[0] ?? 1;
        currentChunk = fileData?[1] ?? 0;
        chunkName.value = fileData!.length > 2
            ? fileData[2] != null
            ? fileData[2]
            : {}
            : fileSelectedList[index];
      }
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            chunkName.isNotEmpty
                ? Image.network(
              type.endsWith('pv')
                  ? baseUrlPvFile + '${chunkName['path']}'
                  : baseUrl + '${chunkName['path']}',
              width: 70,
              height: 70,
              fit: BoxFit.fill,
              errorBuilder: (BuildContext context, Object error,
                  StackTrace? stackTrace) {
                return Img(
                  fileImage,
                  width: 70,
                  height: 70,
                );
              },
            )
                : Img(
              fileImage,
              width: 70,
              height: 70,
            ),
            SizedBox(
              width: 5,
            ),
            fileInfo[fileSelectedList[index]] != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 210,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Txt(
                        totalChunks == currentChunk
                            ? '${chunkName.isNotEmpty ? chunkName['name'] != null ? chunkName['name'] : '' : ''}'
                            : '',
                        fontSize: 16,
                        color: totalChunks == currentChunk
                            ? Colors.white
                            : Colors.grey,
                      ),
                      if (totalChunks == currentChunk)
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            ViewController.widgetDeletePopup(
                                onChange: () async {
                                  await MainController.deleteFileInChunks(
                                      chunkName['name']!);
                                  fileSelectedList.removeAt(index);
                                  Navigator.pop(Get.context!);
                                });
                          },
                        )
                    ],
                  ),
                ),
                currentChunk != 0
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: totalChunks > 0
                          ? currentChunk / totalChunks
                          : 0,
                      backgroundColor: Colors.grey,
                      minHeight: 5,
                      color: totalChunks == currentChunk
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                )
                    : Container(),
              ],
            )
                : Container()
          ],
        ),
      );
    });
  }

  static Widget generateFormTimeBox(
      {var column, TimeOfDay? selectedTime, var data,Function?onChange}) {
    selectedTime=selectedTime==null? TimeOfDay.now():selectedTime;
    Rx<bool>isSeletedTime=data==null||data==''?false.obs:true.obs;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column.title}',
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
            if(onChange!=null){
              onChange(time);
            }else{
              ViewController.request[column.name] = time;

            }
          },
        ),
      ],
    );
  }

  static Future<String> getTitleSelectedItem(
      String tableName, String selectedId, var column) async {
    String selectedTitle = '';
    var sourceItem = column.sourceItems;
    if (sourceItem != 'custom') {
      if (selectedId != '') {
        List<dynamic> itemSelect = [];
        var object =
        (await DB(tableName).where('_id', '\$eq', selectedId).getRecords());
        if (object.length == 0) {
          selectedTitle =
          '${AppController.of(Get.context!)!.value('Uncertain')}';
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

  static Future<List<dynamic>> getTitleMultiSelectedItem(
      String tableName, List<dynamic> selectedId, var column) async {
    List<dynamic> multiSelectedTitleList = [];
    var sourceItem = column['sourceItems'];
    for (var i = 0; i < selectedId.length; i++) {
      if (sourceItem != 'custom') {
        var object = await DB(tableName)
            .where('_id', '\$eq', selectedId[i])
            .getRecords();
        if (object.length != 0) {
          var objectItem = object.first;
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
        if (selectedItem['title'] != null) {
          multiSelectedTitleList.add(selectedItem['title']);
        }
      }
    }
    return multiSelectedTitleList;
  }

  static String itemsShowSelectItem(var listItems, ColumnModel column) {
    var items = column.items;
    List<dynamic> a = [];
    if (listItems is List) {
      if (listItems.length == 0) {
        return "${AppController.of(Get.context!)!.value('not selected')}";
      }
      for (int i = 0; i < listItems.length; i++) {
        if (listItems[i] is String) {
          a.add(listItems[i]);
        } else {
          if (column.sourceItems == 'table') {
            List<dynamic> empty = [];
            for (var field in items) {
              empty.add(listItems[i][field['name']]);
            }
            a.add(empty.join('%'));
          } else {
            a.add(listItems[i]['title']);
          }
        }
      }
    } else {
      if (listItems is String) {
        a.add(listItems);
      } else {
        if (listItems['_id'] == '') {
          return "${AppController.of(Get.context!)!.value('not selected')}";
        }
        if (column.sourceItems == 'table') {
          List<dynamic> empty = [];
          for (var field in items) {
            empty.add(listItems[field['name']]);
          }
          a.add(empty.join('%'));
        } else {
          a.add(listItems['title']);
        }
      }
    }
    return a.join(' , ');
  }

  static Future<List> itemsList(ColumnModel column, {var dataModel}) async {
    var type = column.sourceItems;
    var tableName = column.sourceTable;
    List<dynamic> dropDownListItems = [];
    if (type != 'custom') {
      if (dataModel == null || dataModel.isEmpty) {
        print('ViewController.itemsList>>>${tableName}');
        // Future.delayed(Duration.zero, () async {
        List<dynamic> data = await DB('${tableName}').getRecords();
        // data.removeWhere((element) => element['sync'] != null);
        dropDownListItems = MainController.removeOffRecord(tableName:tableName,list: data );
        print('ViewController.itemsList>>data>>>${dropDownListItems}');

        for (int i = 0; i < dropDownListItems.length; i++) {
          List<dynamic> a = [];
          for (var field in column.items) {

            a.add(dropDownListItems[i][field]);
          }
        }
      } else {
        if (dataModel[column.name] == null) {
          dropDownListItems = [];
        } else {
          dataModel[column.name]= MainController.removeOffRecord(tableName:tableName,list: dataModel[column.name] );
          // dataModel[column.name].removeWhere((element) => element['sync'] != null);
          List<dynamic> a = [];
          for (int i = 0; i < dataModel[column.name].length; i++) {
            a.add(dataModel[column.name][i]);
          }
          ;
          dropDownListItems = a;
        }
      }
    } else {
      List<dynamic> itemss = [];
      if (dataModel == null || dataModel.isEmpty) {
        itemss = column.items;
      } else {
        if (dataModel[column.name] == null ||
            dataModel[column.name] == '') {
          itemss = [];
        } else {
          for (var item in dataModel[column.name]) {
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

  static widgetDeletePopup({Function? onChange}) {
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
                width: 150,
                height: 150,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Txt('${AppController.of(context)!.value('Do you want this item to be removed?')}'),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: redColor),
                            child: Center(
                                child: Txt(
                                  '${AppController.of(context)!.value('no')}',
                                  color: whiteColor,
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () async {
                            if (onChange != null) {
                              onChange();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: successColor),
                            child: Center(
                                child: Txt(
                                  '${AppController.of(context)!.value('yes')}',
                                  color: whiteColor,
                                )),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ));
        });
  }
}

// import 'dart:convert';
//
// import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
// import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
// import 'package:finance/Admin/Logic/Helpers/utils/extensions.dart';
// import 'package:finance/Admin/Logic/Models/ServerModel/tableModel.dart';
// import 'package:finance/Admin/Logic/Models/dataModel.dart';
// import 'package:finance/Admin/Logic/Models/db.dart';
// import 'package:finance/Admin/Public/api-urls.dart';
// import 'package:finance/Admin/Public/images.dart';
// import 'package:finance/Admin/Public/styles.dart';
// import 'package:finance/Admin/UI/Componenets/General/img.dart';
// import 'package:finance/Admin/UI/Componenets/General/txt.dart';
// import 'package:finance/Admin/UI/Componenets/Items/Form/form-checkBox.dart';
// import 'package:finance/Admin/UI/Componenets/Items/Form/form-color.dart';
// import 'package:finance/Admin/UI/Componenets/Items/Form/form-date.dart';
// import 'package:finance/Admin/UI/Componenets/Items/Form/form-multiSelect.dart';
// import 'package:finance/Admin/UI/Componenets/Items/Form/form-radio-button.dart';
// import 'package:finance/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
// import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
// import 'package:finance/Admin/UI/Componenets/Items/Form/form-time.dart';
// import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
// import 'package:finance/Admin/boxes.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:get/get.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:persian_datetime_picker/persian_datetime_picker.dart';
// import 'package:uuid/uuid.dart';
// import '../../Public/config.dart';
// import '../../UI/Componenets/Items/Form/form-file.dart';
// import '../Models/general.dart';
//
// class ViewController extends GetxController {
//   static Rx<String> selectedRadioButton = ''.obs;
//   static Rx<bool> isClickedBtn = false.obs;
//   static Rx<bool> isClickedEditBtn = false.obs;
//   static Map<String, List<int>> fileSizeList = {};
//   static Map<String, dynamic> request = {};
//
//   // static Map<String, dynamic> requestFilter ={};
//   static Map<String, dynamic> requestMultiSelect = <String, dynamic>{};
//   static Map<String, dynamic> request2 = {};
//   static RxList<Widget> filters = <Widget>[].obs;
//
//   static copyClipboard(String text) async {
//     await Clipboard.setData(ClipboardData(text: text));
//     showSnackbar(snackTypes.info, "کپی شد");
//   }
//
//   static callFilterView() async {
//     if (MainController.infoSchema.value.schema.filters != null) {
//       var futures = MainController.infoSchema.value.schema.filters
//           !.map<Future<Widget>>(
//               (filter) => ViewController.generateFilterView(filter))
//           .toList();
//       filters.value = await Future.wait(futures);
//     }
//   }
//
//   static Future<Widget> generateFilterView(Map<String, dynamic> filterInfo) async {
//     var columnInfo = MainController.getColumnInfoByName(columnName: filterInfo['column']);
//
//     Widget child = (await generateFilterFormView([columnInfo], filterInfo));
//
//     return child;
//   }
//
//   static Future<Widget> generateFilterFormView(var columns, var filterInfo) async {
//     var children = <Widget>[];
//     var textField;
//     var selectBox;
//     var dateBox;
//     var multiSelectBox;
//     var colorBox;
//     var fileBox;
//     var timeBox;
//
//     for (var j = 0; j < columns.length; j++) {
//       if (columns[j].isShowStore == true) {
//         ColumnModel column = columns[j];
//         var type = column.type;
//         var maxValidator;
//         var minValidator;
//         if (column.validators != []) {
//           maxValidator = column.validators.firstWhere((validator) => validator['type'] == 'max', orElse: () => null);
//           minValidator = column.validators.firstWhere((validator) => validator['type'] == 'min', orElse: () => null);
//         }
//         if (type == 'string' ||
//             type == 'int' ||
//             type == 'Number double' ||
//             type == 'Number int' ||
//             type == 'email' ||
//             type == 'mobile') {
//           textField = generateFormTextFieldFilter(column, filterInfo, type, '');
//           children.add(textField);
//         }
//
//         if (type == 'select') {
//           List<dynamic> items = await itemsList(column);
//           selectBox = await generateStoreFormSelectBoxFilter(
//               column, filterInfo, items, '', '', false.obs);
//
//           children.add(selectBox);
//         } else if (type == 'checkbox') {
//           children.add(
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Txt(
//                   '${column.title}',
//                   color: MainController.isLightMode.value == true
//                       ? whiteColor
//                       : color2,
//                 ),
//                 SelectBox(
//                     name: '${column.title}',
//                     column: column,
//                     items: [
//                       DropdownMenuItem(
//                         child: Obx(() {
//                           return Txt(
//                             '${AppController.of(Get.context!)!.value('not selected')}',
//                             color: MainController.isLightMode.value == true
//                                 ? whiteColor
//                                 : primaryDark,
//                           );
//                         }),
//                         value: '',
//                       ),
//                       DropdownMenuItem(
//                         child: Obx(() {
//                           return Txt(
//                             'فعال',
//                             color: MainController.isLightMode.value == true
//                                 ? whiteColor
//                                 : primaryDark,
//                           );
//                         }),
//                         value: 'true',
//                       ),
//                       DropdownMenuItem(
//                           child: Obx(() {
//                             return Txt(
//                               'غیر فعال',
//                               color: MainController.isLightMode.value == true
//                                   ? whiteColor
//                                   : primaryDark,
//                             );
//                           }),
//                           value: 'false'),
//                     ],
//                     initalValue: '',
//                     onChanged: (value) async {
//                       if (value != 'true') {
//                         ViewController.request[
//                             '${column.name}${filterInfo['operator']}'] = {
//                           'value': false,
//                           'column': '${column.name}',
//                           'operator': '${filterInfo['operator']}',
//                         };
//                       } else {
//                         ViewController.request[
//                             '${column.name}${filterInfo['operator']}'] = {
//                           'value': true,
//                           'column': '${column.name}',
//                           'operator': '${filterInfo['operator']}',
//                         };
//                       }
//                     },
//                     hintText: '',
//                     isSeleted: false.obs,
//                     selectedValue: ''),
//               ],
//             ),
//           );
//         } else if (type == 'radiobutton') {
//           List<dynamic> items = await itemsList(column);
//           selectBox = await generateStoreFormSelectBoxFilter(
//               column, filterInfo, items, '', '', false.obs);
//
//           children.add(selectBox);
//         } else if (type == 'date') {
//           dateBox = Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Obx(() {
//                     return Txt(
//                       '${column.title}',
//                       color: MainController.isLightMode.value == true
//                           ? whiteColor
//                           : color2,
//                     );
//                   }),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   DateBox(
//                     selectedDate: Jalali.now(),
//                     isSeletedDate: false.obs,
//                     onDateChanged: (date) {
//                       // dataJson[columnName] =  date;
//                       ViewController.request[
//                           '${column.name}${filterInfo['operator']}'] = {
//                         'value': date,
//                         'column': '${column.name}',
//                         'operator': '${filterInfo['operator']}',
//                       };
//                     },
//                     column: column,
//                   ),
//                 ],
//               )
//             ],
//           );
//
//           children.add(dateBox);
//         } else if (type == 'time') {
//           timeBox = generateFormTimeBoxFilter(
//               column, filterInfo, TimeOfDay.now(), false.obs);
//
//           children.add(timeBox);
//         } else if (type == 'multiSelect') {
//           List<dynamic> items = await itemsList(column);
//           if (items.length != 0) {
//             multiSelectBox = await generateStoreFormSelectBoxFilter(
//                 column, filterInfo, items, '', '', false.obs);
//             ;
//
//             children.add(multiSelectBox);
//           }
//         } else if (type == 'color') {
//           colorBox = generateFormColorBoxFilter(
//               column, filterInfo, Colors.blue, false.obs);
//
//           children.add(colorBox);
//         }
//       }
//     }
//     return Wrap(
//       children: children,
//     );
//   }
//
//   static RxString storeKey = (Uuid().v4().toString() + '_store').obs;
//
//   static Future<Widget> generateStoreFormView(var columns) async {
//     var children = <Widget>[];
//     var textField;
//     var selectBox;
//     var checkBox;
//     var radioButtonBox;
//     var dateBox;
//     var multiSelectBox;
//     var colorBox;
//     var fileBox;
//     var timeBox;
//
//     for (var j = 0; j < columns.length; j++) {
//       if (columns[j].isShowStore == true) {
//         ColumnModel column = columns[j];
//         var type = column.type;
//         String name = column.title;
//
//         GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
//         GlobalKey<FormBuilderState> _fbKey2 = GlobalKey<FormBuilderState>();
//         var maxValidator;
//         var minValidator;
//         if (column.validators != []) {
//           maxValidator = column.validators.firstWhere(
//               (validator) => validator['type'] == 'max',
//               orElse: () => null);
//           minValidator = column.validators.firstWhere(
//               (validator) => validator['type'] == 'min',
//               orElse: () => null);
//         }
//         if (type == 'string' ||
//             type == 'int' ||
//             type == 'Number double' ||
//             type == 'Number int' ||
//             type == 'email' ||
//             type == 'mobile') {
//           GlobalKey<FormBuilderState> key = GlobalKey<FormBuilderState>(debugLabel: column.name + '_store');
//           textField = generateFormTextField(fbKey: key, column: column, type: type);
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(textField);
//         }
//         if (type == 'select') {
//           List<dynamic> items = await itemsList(column);
//           selectBox = await generateStoreFormSelectBox(column: column, items: items,);
//
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(selectBox);
//         } else if (type == 'checkbox') {
//           checkBox = generateFormCheckBox(
//             column: column,
//           );
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(checkBox);
//         } else if (type == 'radiobutton') {
//           var initValue;
//           List<dynamic> items = await itemsList(column);
//           radioButtonBox =
//               generateFormRadioButton(column: column, items: items);
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(radioButtonBox);
//         } else if (type == 'date') {
//           dateBox = generateFormDateBox(
//             column: column,
//           );
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(dateBox);
//         } else if (type == 'multiSelect') {
//           multiSelectBox = await genarateStoreFormMuiltiSelectBox(column: column);
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(multiSelectBox);
//         } else if (type == 'color') {
//           colorBox = generateFormColorBox(column: column);
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(colorBox);
//         } else if (type == 'file' ||
//             type == 'file_pv' ||
//             type == 'multiFile' ||
//             type == 'multiFile_pv') {
//           fileBox = generateFileBox(column:  column);
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(fileBox);
//         } else if (type == 'time') {
//           timeBox = generateFormTimeBox(column: column);
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(timeBox);
//         }
//       }
//     }
//     return Container(
//       child: Obx(() {
//         return Container(
//           key: ValueKey(storeKey.value),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start, children: children),
//         );
//       }),
//     );
//   }
//
//   static Future<Widget> generateEditFormView(Map<String, dynamic> dataModel) async {
//     var children = <Widget>[];
//     var textField;
//     var selectBox;
//     var checkBox;
//     var dateBox;
//     var multiSelectBox;
//     var colorBox;
//     var fileBox;
//     var timeBox;
//     for (var j = 0; j < MainController.infoSchema.value.columns.length; j++) {
//       if (MainController.infoSchema.value.columns[j].isShowEdit == true) {
//         var column = MainController.infoSchema.value.columns[j];
//         var type = column.type;
//         var name = column.name;
//         var maxValidator;
//         var minValidator;
//         List<dynamic> items = [];
//         print('dataModel d>>>${dataModel['${name}']}');
//         if (column.validators != []) {
//           maxValidator = column.validators.firstWhere(
//               (validator) => validator['type'] == 'max',
//               orElse: () => null);
//           minValidator = column.validators.firstWhere(
//               (validator) => validator['type'] == 'min',
//               orElse: () => null);
//         }
//         if (type == 'string' ||
//             type == 'int' ||
//             type == 'Number double' ||
//             type == 'Number int' ||
//             type == 'email' ||
//             type == 'mobile') {
//           GlobalKey<FormBuilderState> key =
//               GlobalKey<FormBuilderState>(debugLabel: column.name + '_edit');
//           textField = generateFormTextField(
//               fbKey: key,
//               column: column,
//               type: type,
//               initValue: dataModel['${name}']);
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(textField);
//         } else if (type == 'select') {
//           Map<String, dynamic> selectedItem = <String, dynamic>{};
//           List<dynamic> items = await ViewController.itemsList(column);
//           if (items.length != 0) {
//             if (column.sourceItems != 'custom') {
//               if (dataModel[name] != null && dataModel[name] != '') {
//                 selectedItem = items.firstWhere(
//                     (element) => element['_id'] == dataModel[name]['_id']);
//               }
//               selectBox = await generateStoreFormSelectBox(
//                   column: column,
//                   items: items,
//                   initailValue:
//                       '${selectedItem.isNotEmpty ? selectedItem['_id'] : null}',
//                   selected: dataModel[name]);
//             } else {
//               if (dataModel[name] != null && dataModel[name] != '')
//                 selectedItem = items.firstWhere(
//                     (element) => element['value'] == dataModel[name]['value']);
//               selectBox = await generateStoreFormSelectBox(
//                   column: column,
//                   items: items,
//                   initailValue:
//                       '${selectedItem.isNotEmpty ? selectedItem['value'] : null}',
//                   selected: dataModel[name]);
//             }
//             children.add(SizedBox(
//               height: 20,
//             ));
//             children.add(selectBox);
//           }
//         } else if (type == 'checkbox') {
//           checkBox = generateFormCheckBox(
//               column: column,
//               data: dataModel[name],
//               defultValue: dataModel['${name}']);
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(checkBox);
//         } else if (type == 'radiobutton') {
//           Map<String, dynamic> selectedItem = <String, dynamic>{};
//           var items = await ViewController.itemsList(column);
//           if (items.length != 0) {
//             if (column.sourceItems != 'custom') {
//               if (dataModel[name] != null && dataModel[name] != '')
//                 selectedItem = items.firstWhere(
//                     (element) => element['_id'] == dataModel[name]['_id']);
//
//               selectBox = await generateFormRadioButton(
//                   column: column,
//                   items: items,
//                   initalValue:
//                       '${selectedItem.isNotEmpty ? selectedItem['_id'] : ''}',
//                   data: dataModel[name]);
//             } else {
//               if (dataModel[name] != null && dataModel[name] != '')
//                 selectedItem = items.firstWhere(
//                     (element) => element['value'] == dataModel[name]);
//
//               selectBox = await generateFormRadioButton(
//                   column: column,
//                   items: items,
//                   initalValue:
//                       '${selectedItem.isNotEmpty ? selectedItem['value'] : ''}',
//                   data: dataModel[name]);
//             }
//             children.add(SizedBox(
//               height: 20,
//             ));
//             children.add(selectBox);
//           }
//         } else if (type == 'date') {
//           List<String>? dateParts;
//           int year = Jalali.now().year;
//           int month = Jalali.now().month;
//           int day = Jalali.now().day;
//           if (dataModel['${name}'] != null) {
//             dateParts = dataModel['${name}'].split('/');
//             year = int.parse('${dateParts![0]}');
//             month = int.parse('${dateParts[1]}');
//             day = int.parse('${dateParts[2]}');
//           }
//           dateBox = generateFormDateBox(
//               column: column,
//               selectedDate: Jalali(year, month, day),
//               data: dataModel['${name}']);
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(dateBox);
//         } else if (type == 'multiSelect') {
//           List<dynamic> items =
//               await ViewController.itemsList(column, dataModel: dataModel);
//           List<dynamic> multiSelectedItemList = [];
//           if (items.length != 0) {
//             if (column.sourceTable != null) {
//               for (var selectedItem in items) {
//                 multiSelectedItemList
//                     .add(itemsShowSelectItem(selectedItem, column));
//               }
//             } else {
//               for (var selectedItem in items) {
//                 multiSelectedItemList.add(selectedItem['title']);
//               }
//             }
//           }
//           if (dataModel.isNotEmpty) {
//             multiSelectBox = await genarateEditFormMuiltiSelectBox(
//                 column,
//                 multiSelectedItemList.length != 0
//                     ? RxString(multiSelectedItemList.join(' , '))
//                     : RxString(''),
//                 items.length != 0 ? RxList(items) : <dynamic>[].obs,
//                 false.obs);
//           } else {
//             multiSelectBox = await genarateEditFormMuiltiSelectBox(
//                 column, RxString(''), <dynamic>[].obs, false.obs);
//           }
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(multiSelectBox);
//         } else if (type == 'color') {
//           colorBox = generateFormColorBox(
//               column: column,
//               selectedColor: dataModel[name] != null && dataModel[name] != ''
//                   ? Color(int.parse('${dataModel[name]}'))
//                   : null,
//               data: dataModel[name]);
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(colorBox);
//         } else if (type == 'file' || type == 'file_pv') {
//           fileBox = generateEditFileBox(
//               dataModel[name] != null && dataModel[name] != ''
//                   ? dataModel
//                   : null,
//               column);
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(fileBox);
//         } else if (type == 'multiFile' || type == 'multiFile_pv') {
//           fileBox = generateEditMultiFileBox(
//               dataModel[name] != null && dataModel[name].length != 0
//                   ? dataModel
//                   : null,
//               column);
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(fileBox);
//         } else if (type == 'time') {
//           List<String>? TimeParts;
//           int hour = TimeOfDay.now().hour;
//           int minute = TimeOfDay.now().minute;
//           if (dataModel['${name}'] != null) {
//             TimeParts = dataModel['${name}'].split(':');
//             hour = int.parse('${TimeParts![0]}');
//             minute = int.parse('${TimeParts[1]}');
//           }
//
//           timeBox = generateFormTimeBox(column: column, selectedTime: TimeOfDay(hour: hour, minute: minute), data:  dataModel['${name}'] );
//           children.add(SizedBox(
//             height: 20,
//           ));
//           children.add(timeBox);
//         }
//       }
//     }
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.start, children: children);
//   }
//
//   static Future<Widget> generateDataColumn(int indexColumn, int indexRow, {var table}) async {
//     var size = MediaQuery.of(Get.context!).size;
//     String name = '';
//     name = MainController.infoSchema.value.columns[indexColumn].name;
//     var dataModel = MainController.dataRecord[indexRow]['${name}'];
//     String type = '';
//     if (table == null) {
//       type = MainController.infoSchema.value.columns[indexColumn].type;
//       name = MainController.infoSchema.value.columns[indexColumn].name;
//     } else {
//       type = table['columns'][indexColumn]['type'];
//       name = table['columns'][indexColumn]['name'];
//     }
//     var child;
//     if (type == 'checkbox') {
//       child = generateCheckBox(indexColumn, indexRow, tableData: table);
//     } else if (type == 'color') {
//       child = generateColor(indexColumn, indexRow, tableData: table);
//     } else if (type == 'select' || type == 'radiobutton') {
//       child = InkWell(
//         onDoubleTap: () async {
//           print('ViewController.generateDataColumn');
//           await copyClipboard(MainController.dataRecord[indexRow]['${name}'] !=
//                   null
//               ? '${itemsShowSelectItem(MainController.dataRecord[indexRow]['${name}'], MainController.infoSchema.value.columns[indexColumn])}'
//               : '');
//         },
//         child: Txt(
//           MainController.dataRecord[indexRow]['${name}'] != null
//               ? '${itemsShowSelectItem(MainController.dataRecord[indexRow]['${name}'], MainController.infoSchema.value.columns[indexColumn])}'
//               : '',
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//           color: MainController.isLightMode.value == true ? whiteColor : color2,
//           textAlign: TextAlign.center,
//         ),
//       );
//     } else if (type == 'multiSelect') {
//       child = InkWell(
//         onDoubleTap: () async {
//           await copyClipboard(MainController.dataRecord[indexRow]['${name}'] !=
//                   null
//               ? '${itemsShowSelectItem(MainController.dataRecord[indexRow]['${name}'], MainController.infoSchema.value.columns[indexColumn])}'
//               : '');
//         },
//         child: Txt(
//           MainController.dataRecord[indexRow]['${name}'] != null
//               ? '${itemsShowSelectItem(MainController.dataRecord[indexRow]['${name}'], MainController.infoSchema.value.columns[indexColumn])}'
//               : '',
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//           color: MainController.isLightMode.value == true ? whiteColor : color2,
//           textAlign: TextAlign.center,
//         ),
//       );
//     } else if (type == 'file' || type == 'file_pv') {
//       child = generateCellFileBox(indexColumn, indexRow, tableData: table);
//     } else if (type == 'multiFile' || type == 'multiFile_pv') {
//       child = generateCellMultiFileBox(indexColumn, indexRow, tableData: table);
//     } else {
//       child = generateData(indexColumn, indexRow, tableData: table);
//     }
//     return Obx(() {
//       return Center(
//         child: Container(
//             width: size.width / 5,
//             decoration: BoxDecoration(
//               color: MainController.isLightMode.value == true
//                   ? background
//                   : whiteColor,
//             ),
//             padding: EdgeInsets.all(5),
//             child: child),
//       );
//     });
//   }
//
//   static Widget generateCheckBox(int indexColumn, int indexRow,
//       {var tableData}) {
//     // DataModel dataModel = MainController.tableData.value[indexRow];
//     String name = '';
//     if (tableData == null) {
//       name = MainController.infoSchema.value.columns[indexColumn].name;
//     } else {
//       name = tableData['columns'][indexColumn]['name'];
//     }
//     var dataModel = MainController.dataRecord.value[indexRow]['${name}'];
//
//     if (dataModel == null) {
//       dataModel = false;
//     }
//     return CheckBox(
//       defaultValue: dataModel == "true" ? true : false,
//       checkBoxTitle: '',
//       onChange: (text) async {
//         await DB('${MainController.infoSchema.value.schema.name}')
//             .where('_id', '\$eq',
//                 '${MainController.dataRecord.value[indexRow]['_id']}')
//             .updateRecords({'${name}': '${text}'});
//       },
//       index: indexRow,
//       column: tableData == null
//           ? MainController.infoSchema.value.columns[indexColumn]
//           : tableData['columns'][indexColumn],
//     );
//   }
//
//   static Widget generateColor(int indexColumn, int indexRow, {var tableData}) {
//     // DataModel dataModel = MainController.tableData.value[indexRow];
//     String name;
//     if (tableData == null) {
//       name = MainController.infoSchema.value.columns[indexColumn].name;
//     } else {
//       name = tableData['columns'][indexColumn]['name'];
//     }
//     var dataModel = MainController.dataRecord[indexRow]['${name}'];
//
//     return InkWell(
//       onDoubleTap: () async {
//         await copyClipboard('${dataModel}');
//       },
//       child: Center(
//         child: dataModel != null
//             ? Container(
//                 width: 50,
//                 height: 50,
//                 color: Color(int.parse('${dataModel}')),
//               )
//             : Container(),
//       ),
//     );
//   }
//
//   static Widget generateData(int indexColumn, int indexRow, {var tableData}) {
//     // DataModel dataModel = MainController.tableData.value[indexRow];
//
//     String name;
//     String type;
//     if (tableData == null) {
//       name = MainController.infoSchema.value.columns[indexColumn].name;
//       type = MainController.infoSchema.value.columns[indexColumn].type;
//     } else {
//       name = tableData['columns'][indexColumn]['name'];
//       type = tableData['columns'][indexColumn]['type'];
//     }
//     var dataModel = MainController.dataRecord[indexRow]['${name}'];
//     return Obx(() {
//       return InkWell(
//         onDoubleTap: () async {
//           await copyClipboard('${dataModel != null ? dataModel : ''}');
//         },
//         child: Center(
//           child: Txt(
//             '${dataModel != null ? type.toLowerCase().contains('int') ? int.parse(dataModel.toString()).toNumber() : dataModel.toString().length > 20 ? dataModel.toString().substring(0, 20) + '...' : dataModel : ''}',
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color:
//                 MainController.isLightMode.value == true ? whiteColor : color2,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       );
//     });
//   }
//
//   static Widget generateFormTextField(
//       {var fbKey,
//       ColumnModel? column,
//       var type,
//       Function? onChange,
//       var initValue = null}) {
//
//
//     return new Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Obx(() {
//           return Txt(
//             '${column!.title}',
//             color:
//                 MainController.isLightMode.value == true ? whiteColor : color2,
//           );
//         }),
//         SizedBox(
//           height: 10,
//         ),
//         FormTextField(
//           name: '${column!.name}',
//           fbKey: fbKey,
//           hint: '${column.title}',
//           lable: '',
//           column: column,
//           initValue: initValue != null ? initValue.toString() : '',
//           onChange: (text) {
//             if (onChange != null) {
//               onChange(text);
//             } else {
//               if (text != null && text != '') {
//                 if (column.type == 'Number int') {
//                   ViewController.request[column.name] = int.parse('${text}');
//                 } else if (column.type == 'Number double') {
//                   ViewController.request[column.name] =
//                       double.parse('${text}');
//                 } else {
//                   ViewController.request[column.name] = text;
//                 }
//               } else {
//                 ViewController.request[column.name] = '';
//               }
//             }
//             print('TTTTSSS>>>${ViewController.request}');
//           },
//           isMobile: type == 'mobile' ? true : false,
//           isNumberInt: type == 'Number int' ? true : false,
//           isNumberDouble: type == 'Number double' ? true : false,
//           isEmail: type == 'email' ? true : false,
//         ),
//       ],
//     );
//   }
//
//
//   static Widget generateFormTextFieldFilter(
//       ColumnModel column, var filterInfo, var type, String initValue) {
//     print('ViewController.generateFormTextFieldFilter>>${column.type}');
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Obx(() {
//           return Directionality(
//             textDirection: TextDirection.ltr,
//             child: Txt(
//               '${column.title} (${General.oprator('${filterInfo['operator']}')})',
//               color: MainController.isLightMode.value == true
//                   ? whiteColor
//                   : color2,
//             ),
//           );
//         }),
//         SizedBox(
//           height: 10,
//         ),
//         Container(
//           width: 120,
//           child: FormTextField(
//             isValidate: false,
//             name: '${column.title}',
//             // fbKey: _fbKey,
//             hint: '${column.title}',
//             lable: '',
//             column: column,
//             initValue: initValue,
//             onChange: (text) {
//               if (text != null && text != '') {
//                 if (column.type == 'Number int') {
//                   ViewController
//                       .request['${column.name}${filterInfo['operator']}'] = {
//                     'value': '${int.parse('${text}')}',
//                     'column': '${column.name}',
//                     'operator': '${filterInfo['operator']}',
//                   };
//                 } else if (column.type == 'Number double') {
//                   ViewController
//                       .request['${column.name}${filterInfo['operator']}'] = {
//                     'value': '${double.parse('${text}')}',
//                     'column': '${column.name}',
//                     'operator': '${filterInfo['operator']}',
//                   };
//                   print(
//                       'ViewController.generateFormTextFieldFilter>>${ViewController.request}');
//                 } else {
//                   ViewController
//                       .request['${column.name}${filterInfo['operator']}'] = {
//                     'value': '${text}',
//                     'column': '${column.name}',
//                     'operator': '${filterInfo['operator']}',
//                   };
//                 }
//               } else {
//                 ViewController
//                     .request['${column.name}${filterInfo['operator']}'] = {
//                   'value': '',
//                   'column': '${column.name}',
//                   'operator': '${filterInfo['operator']}',
//                 };
//               }
//             },
//             isMobile: type == 'mobile' ? true : false,
//             isNumberInt: type == 'Number int' ? true : false,
//             isNumberDouble: type == 'Number double' ? true : false,
//             isEmail: type == 'email' ? true : false,
//           ),
//         ),
//       ],
//     );
//   }
//
//   static Widget generateStoreFormSelectBoxFilter(
//       ColumnModel column,
//       var filterInfo,
//       List<dynamic> items,
//       String hintText,
//       String initailValue,
//       Rx<bool> isSeleted) {
//     if (initailValue == '' || initailValue == null) {
//       ViewController.request[column.name] = null;
//     }
//     return items.length != 0
//         ? new Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Obx(() {
//                 return Txt('${column.title}',
//                     color: MainController.isLightMode.value == true
//                         ? whiteColor
//                         : color2);
//               }),
//               SizedBox(
//                 height: 10,
//               ),
//               column.sourceItems != 'custom'
//                   ? SelectBox(
//                       name: '${column.title}',
//                       column: column,
//                       items: [
//                         DropdownMenuItem(
//                             child: Obx(() {
//                               return Txt(
//                                 '${AppController.of(Get.context!)!.value('not selected')}',
//                                 color: MainController.isLightMode.value == true
//                                     ? whiteColor
//                                     : primaryDark,
//                               );
//                             }),
//                             value: ''),
//                         for (var item in items)
//                           DropdownMenuItem(
//                               child: Obx(() {
//                                 return Txt(
//                                   '${itemsShowSelectItem(item, column)}',
//                                   color:
//                                       MainController.isLightMode.value == true
//                                           ? whiteColor
//                                           : primaryDark,
//                                 );
//                               }),
//                               value: item['_id'].toString()),
//                       ],
//                       initalValue: initailValue == '' || initailValue == null
//                           ? ""
//                           : initailValue,
//                       onChanged: (value) async {
//                         if (value != '') {
//                           // selectedValue=value!;
//                           ViewController.request['${column.name}${filterInfo['operator']}'] = {
//                             'value': value,
//                             'column': '${column.name}',
//                             'operator': '${filterInfo['operator']}',
//                           };
//                           // ViewController.request[column.name] = value;
//                         } else {
//                           ViewController.request[
//                               '${column.name}${filterInfo['operator']}'] = {
//                             'value': '',
//                             'column': '${column.name}',
//                             'operator': '${filterInfo['operator']}',
//                           };
//                           // ViewController.request[column.name] = '';
//                         }
//                       },
//                       hintText: hintText,
//                       isSeleted: isSeleted,
//                       selectedValue: '')
//                   : SelectBox(
//                       name: '${column.title}',
//                       column: column,
//                       items: [
//                         for (var item in items)
//                           DropdownMenuItem(
//                               child: Obx(() {
//                                 return Txt(
//                                   '${item['title']}',
//                                   color:
//                                       MainController.isLightMode.value == true
//                                           ? whiteColor
//                                           : primaryDark,
//                                 );
//                               }),
//                               value: item['value']),
//                       ],
//                       initalValue: initailValue == '' || initailValue == null
//                           ? items.first['value']
//                           : initailValue,
//                       onChanged: (value) async {
//                         for (var item in items) {
//                           if (item['title'] == value) {
//                             if (item['value'] == '') {
//                               value = null;
//                             }
//                           }
//                         }
//                         if (value != '') {
//                           ViewController.request[
//                               '${column.name}${filterInfo['operator']}'] = {
//                             'value': value,
//                             'column': '${column.name}',
//                             'operator': '${filterInfo['operator']}',
//                           };
//                         } else {
//                           ViewController.request[
//                               '${column.name}${filterInfo['operator']}'] = {
//                             'value': '',
//                             'column': '${column.name}',
//                             'operator': '${filterInfo['operator']}',
//                           };
//                         }
//                       },
//                       hintText: hintText,
//                       isSeleted: isSeleted,
//                       selectedValue: ''),
//             ],
//           )
//         : Container();
//   }
//
//   static Widget generateFormTimeBoxFilter(var column, var filterInfo,
//       TimeOfDay selectedTime, Rx<bool>? isSeletedTime) {
//     return new Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Obx(() {
//           return Txt(
//             '${column.title}',
//             color:
//                 MainController.isLightMode.value == true ? whiteColor : color2,
//           );
//         }),
//         SizedBox(
//           height: 10,
//         ),
//         TimePickerBox(
//           column: column,
//           selectedTime: selectedTime,
//           isSeletedTime: isSeletedTime,
//           onTimeChanged: (time) {
//             ViewController
//                 .request['${column.name}${filterInfo['operator']}'] = {
//               'value': time,
//               'column': '${column.name}',
//               'operator': '${filterInfo['operator']}',
//             };
//           },
//         ),
//       ],
//     );
//   }
//
//   static Widget generateFormColorBoxFilter(var column, var filterInfo,
//       Color selectedColor, Rx<bool>? isSeletedColor) {
//     Color colorChanged;
//     return new Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Obx(() {
//           return Txt(
//             '${column.title}',
//             color:
//                 MainController.isLightMode.value == true ? whiteColor : color2,
//           );
//         }),
//         SizedBox(
//           height: 10,
//         ),
//         Container(
//           child: ColorPickerBox(
//             selectedColor: selectedColor,
//             isSeletedColor: isSeletedColor,
//             onChanged: (color) {
//               colorChanged = color;
//               String hexColor =
//                   '0x${colorChanged.value.toRadixString(16).padLeft(8, '0')}';
//               // dataJson[columnName] = hexColor;
//
//               ViewController
//                   .request['${column.name}${filterInfo['operator']}'] = {
//                 'value': hexColor,
//                 'column': '${column.name}',
//                 'operator': '${filterInfo['operator']}',
//               };
//             },
//             column: column,
//           ),
//         ),
//       ],
//     );
//   }
//
//   static Widget generateStoreFormSelectBox(
//       {var column,
//       List<dynamic> items = const [],
//       var initailValue = null,
//       var selected = null,
//       Function? onChange}) {
//     RxBool isSeleted =
//         selected == '' || selected == null ? false.obs : true.obs;
//     if (initailValue == '' || initailValue == null) {
//       ViewController.request[column.name] = null;
//     }
//     print('ViewController.generateStoreFormSelectBox>>${items}');
//
//     return items.length != 0
//         ? new Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Obx(() {
//                 return Txt(
//                   '${column.title}',
//                   color: MainController.isLightMode.value == true
//                       ? whiteColor
//                       : color2,
//                 );
//               }),
//               SizedBox(
//                 height: 10,
//               ),
//               column.sourceItems != 'custom'
//                   ? SelectBox(
//                       name: '${column.title}',
//                       column: column,
//                       items: [
//                         DropdownMenuItem(
//                             child: Obx(() {
//                               return Txt(
//                                 '${AppController.of(Get.context!)!.value('not selected')}',
//                                 color: MainController.isLightMode.value == true
//                                     ? whiteColor
//                                     : primaryDark,
//                               );
//                             }),
//                             value: ''),
//                         for (var item in items)
//                           DropdownMenuItem(
//                               child: Obx(() {
//                                 return Txt('${itemsShowSelectItem(item, column)}',
//                                   color: MainController.isLightMode.value == true ? whiteColor : primaryDark,
//                                 );
//                               }),
//                               value: item['_id'].toString()),
//                       ],
//                       initalValue: initailValue == '' || initailValue == null ? "" : initailValue,
//                       onChanged: (value) async {
//                         if (onChange != null) {
//                           onChange(value);
//                         } else {
//                           if (value != '') {
//                             ViewController.request[column.name] = value;
//                           } else {
//                             ViewController.request[column.name] = '';
//                           }
//                         }
//                       },
//                       hintText: initailValue ?? '',
//                       isSeleted: isSeleted,
//                       selectedValue: '')
//                   : SelectBox(
//                       name: '${column.title}',
//                       column: column,
//                       items: [
//                         for (var item in items)
//                           DropdownMenuItem(
//                               child: Obx(() {
//                                 return Txt(
//                                   '${item['title']}',
//                                   color:
//                                       MainController.isLightMode.value == true
//                                           ? whiteColor
//                                           : primaryDark,
//                                 );
//                               }),
//                               value: item['value']),
//                       ],
//                       initalValue: initailValue == '' || initailValue == null
//                           ? items.first['value']
//                           : initailValue,
//                       onChanged: (value) async {
//                         if (onChange != null) {
//                           onChange(value);
//                         } else {
//                           for (var item in items) {
//                             if (item['title'] == value) {
//                               if (item['value'] == '') {
//                                 value = null;
//                               }
//                             }
//                           }
//                           if (value != '') {
//                             ViewController.request[column.name] = value;
//                           } else {
//                             ViewController.request[column.name] = '';
//                           }
//                         }
//                       },
//                       hintText: initailValue ?? '',
//                       isSeleted: isSeleted,
//                       selectedValue: ''),
//             ],
//           )
//         : Container();
//   }
//
//   static Widget generateFormCheckBox(
//       {var column,
//       var data = null,
//       var defultValue = null,
//       Function? onChange}) {
//     ViewController.request[column.name] =
//         defultValue ?? column['default_value'];
//     return new CheckBox(
//       checkBoxName: '${column.title}',
//       checkBoxTitle: '${column.title}',
//       isClickedBtn: data == null || data == '' ? false.obs : true.obs,
//       defaultValue: defultValue ?? column['default_value'],
//       onChange: (text) {
//         if (onChange != null) {
//           onChange(text);
//         } else {
//           ViewController.request[column.name] = text;
//         }
//         // dataJson[columnName] = text;
//       },
//       column: column,
//     );
//   }
//
//   static Widget generateFormRadioButton(
//       {var column,
//       List<dynamic> items = const [],
//       var initalValue = null,
//       var data = null,
//       Function? onChange}) {
//     print('ViewController.generateFormRadioButton>>${items}');
//     return new Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Obx(() {
//           return Txt(
//             '${column.title}',
//             color:
//                 MainController.isLightMode.value == true ? whiteColor : color2,
//           );
//         }),
//         SizedBox(
//           height: 10,
//         ),
//         column.sourceItems != 'custom'
//             ? RadioButton(
//                 name: '',
//                 radioButtonItems: [
//                   for (var item in items)
//                     FormBuilderChipOption(
//                         value: item['_id'].toString(),
//                         child: Obx(() {
//                           return Txt(
//                             '${itemsShowSelectItem(item, column)}',
//                             color: MainController.isLightMode.value
//                                 ? whiteColor
//                                 : primaryDark,
//                           );
//                         })),
//                 ],
//                 onChanged: (text) {
//                   if (onChange != null) {
//                     onChange(text);
//                   } else {
//                     if (text != '') {
//                       //   // selectedValue=value!;
//                       ViewController.request[column.name] = text;
//                     } else {
//                       ViewController.request[column.name] = '';
//                     }
//
//                     // dataJson[columnName] = selectedRadioButton.value;
//                   }
//                 },
//                 initalValue: initalValue == null ? '' : initalValue,
//                 column: column,
//                 isSelectedItem:
//                     data == null || data == '' ? false.obs : true.obs,
//               )
//             : RadioButton(
//                 name: '',
//                 radioButtonItems: [
//                   for (var radioButtonItem in items)
//                     FormBuilderChipOption(
//                         value: '${radioButtonItem['value']}',
//                         child: Obx(() {
//                           return Txt(
//                             '${radioButtonItem['title']}',
//                             color: MainController.isLightMode.value
//                                 ? whiteColor
//                                 : primaryDark,
//                           );
//                         })),
//                 ],
//                 onChanged: (text) {
//                   if (onChange != null) {
//                     onChange(text);
//                   } else {
//                     ViewController.request[column.name] = text;
//                     // dataJson[columnName] = selectedRadioButton.value;
//                   }
//                 },
//                 initalValue: initalValue == null ? '' : initalValue,
//                 column: column,
//                 isSelectedItem:
//                     data == null || data == '' ? false.obs : true.obs,
//               ),
//       ],
//     );
//   }
//
//   static Widget generateFormDateBox(
//       {var column,
//       Jalali? selectedDate = null,
//       var data = null,
//       Function? onChange}) {
//     if (selectedDate == null) {
//       selectedDate = Jalali.now();
//     }
//     return new Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Obx(() {
//           return Txt(
//             '${column.title}',
//             color:
//                 MainController.isLightMode.value == true ? whiteColor : color2,
//           );
//         }),
//         SizedBox(
//           height: 10,
//         ),
//         DateBox(
//           selectedDate: selectedDate,
//           isSeletedDate: data == null || data == '' ? false.obs : true.obs,
//           onDateChanged: (date) {
//             if (onChange != null)
//               onChange(date)!;
//             else
//               ViewController.request[column.name] = date;
//           },
//           column: column,
//         ),
//       ],
//     );
//   }
//
//   static Future<Widget> genarateEditFormMuiltiSelectBox(
//       var column,
//       Rx<String> hintTxt,
//       RxList<dynamic> selectedItemsList,
//       Rx<bool> isSelectedItem) async {
//     RxList<String> selectedItemId = <String>[].obs;
//     List<dynamic> items = [];
//     List<dynamic> selectedId = [];
//
//     if (column.sourceItems != 'custom') {
//       items = await DB('${column.sourceTable}').getRecords();
//
//       if (selectedItemsList.length != 0) {
//         for (var selectedItem in selectedItemsList) {
//           if (selectedItem['_id'] != null) {
//             selectedItemId.add(selectedItem['_id']);
//           }
//         }
//         ViewController.request[column.name] = selectedItemId;
//       }
//
//       return items.length != 0
//           ? new Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Obx(() {
//                   return Txt(
//                     '${column.title}',
//                     color: MainController.isLightMode.value == true
//                         ? whiteColor
//                         : color2,
//                   );
//                 }),
//                 Obx(() {
//                   return MultiSelectDropdown(
//                     items: [
//                       for (var item in items)
//                         DropdownMenuItem(
//                             value: item['_id'],
//                             child: Obx(() {
//                               return Row(
//                                 children: [
//                                   Container(
//                                     height: 100,
//                                     child: SizedBox(
//                                         width: 50,
//                                         height: 50,
//                                         child: Obx(() {
//                                           return Checkbox(
//                                               activeColor: colorBtn,
//                                               value: selectedItemId
//                                                   .contains(item['_id']),
//                                               onChanged: (isChecked) {
//                                                 if (isChecked != null) {
//                                                   hintTxt.value = '';
//                                                   if (!selectedItemsList.any(
//                                                       (element) =>
//                                                           element['_id'] ==
//                                                           item['_id'])) {
//                                                     requestMultiSelect = item;
//                                                     selectedItemsList.add(item);
//                                                     selectedItemId
//                                                         .add(item['_id']);
//                                                   } else {
//                                                     requestMultiSelect
//                                                         .removeWhere((key,
//                                                                 value) =>
//                                                             value == ['_id']);
//                                                     selectedItemsList
//                                                         .removeWhere(
//                                                             (element) =>
//                                                                 element[
//                                                                     '_id'] ==
//                                                                 item['_id']);
//                                                     selectedItemId
//                                                         .remove(item['_id']);
//                                                   }
//                                                   if (item['_id'] == '') {
//                                                     selectedItemId.value
//                                                         .remove(item['_id']);
//                                                   }
//                                                   if (selectedItemId
//                                                           .value.length ==
//                                                       0) {
//                                                     isSelectedItem.value =
//                                                         false;
//                                                   } else {
//                                                     isSelectedItem.value = true;
//                                                   }
//                                                   for (var r
//                                                       in selectedItemsList)
//                                                     hintTxt.value =
//                                                         hintTxt.value +
//                                                             itemsShowSelectItem(
//                                                                 r, column);
//                                                   ViewController.request[
//                                                           column.name] =
//                                                       selectedItemId;
//                                                 }
//                                               });
//                                         })),
//                                   ),
//                                   Txt(itemsShowSelectItem(item, column),
//                                       color: MainController.isLightMode.value
//                                           ? whiteColor
//                                           : primaryDark),
//                                 ],
//                               );
//                             }))
//                     ],
//                     hintText: hintTxt.value != '' || hintTxt.value != null
//                         ? hintTxt.value
//                         : '${AppController.of(Get.context!)!.value('choice')}',
//                     selectedItems: selectedItemsList,
//                     isSelectedItem: isSelectedItem,
//                     column: column,
//                   );
//                 }),
//               ],
//             )
//           : Container();
//     } else {
//       if (selectedItemsList.length != 0) {
//         for (var selectedItem in selectedItemsList) {
//           selectedItemId.add(selectedItem['value']);
//         }
//       }
//       items = column['items'];
//
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Obx(() {
//             return Txt(
//               '${column.title}',
//               color: MainController.isLightMode.value == true
//                   ? whiteColor
//                   : color2,
//             );
//           }),
//           Obx(() {
//             return MultiSelectDropdown(
//               items: [
//                 for (var item in items)
//                   DropdownMenuItem(
//                       value: item['value'],
//                       child: Obx(() {
//                         return Row(
//                           children: [
//                             Container(
//                               height: 100,
//                               child: SizedBox(
//                                   width: 50,
//                                   height: 50,
//                                   child: Obx(() {
//                                     return Checkbox(
//                                         activeColor: colorBtn,
//                                         value: selectedItemsList
//                                             .any((map) => mapEquals(map, item)),
//                                         onChanged: (isChecked) {
//                                           if (isChecked != null) {
//                                             hintTxt.value = '';
//                                             if (!selectedItemsList.any((map) =>
//                                                 mapEquals(map, item))) {
//                                               selectedId = [];
//                                               requestMultiSelect = item;
//                                               selectedItemsList.add(item);
//                                             } else {
//                                               selectedId = [];
//                                               requestMultiSelect.removeWhere(
//                                                   (key, value) =>
//                                                       value == ['value']);
//                                               var index = selectedItemsList
//                                                   .indexWhere((map) =>
//                                                       mapEquals(map, item));
//
//                                               selectedItemsList.removeAt(index);
//                                             }
//
//                                             if (selectedItemsList
//                                                     .value.length ==
//                                                 0) {
//                                               isSelectedItem.value = false;
//                                             } else {
//                                               isSelectedItem.value = true;
//                                             }
//                                             for (var r in selectedItemsList)
//                                               hintTxt.value =
//                                                   hintTxt.value + r['title'];
//
//                                             for (var r in selectedItemsList)
//                                               selectedId.add(r['value']);
//
//                                             ViewController
//                                                     .request[column.name] =
//                                                 selectedId;
//                                           }
//                                         });
//                                   })),
//                             ),
//                             Txt(item['title'],
//                                 color: MainController.isLightMode.value
//                                     ? whiteColor
//                                     : primaryDark),
//                           ],
//                         );
//                       }))
//               ],
//               hintText: hintTxt.value != '' && hintTxt.value != null
//                   ? hintTxt.value
//                   : '${AppController.of(Get.context!)!.value('choice')}',
//               selectedItems: selectedItemsList,
//               isSelectedItem: isSelectedItem,
//               // onChanged: (selectedList){
//
//               //       selectedItemsList.value = selectedList;
//               //   hintTxt.value = hintTxt.value;
//
//               //       ViewController.request= requestMultiSelect;
//               // },
//               column: column,
//             );
//           }),
//         ],
//       );
//     }
//   }
//
//   static Future<Widget> genarateStoreFormMuiltiSelectBox(
//       {required var column,
//       var hintText = null,
//       List<dynamic>? selectedItemList,
//       var data = null,
//       Function? onChange}) async {
//     RxString hintTxt = hintText != null ? hintText.obs : ''.obs;
//     RxList<dynamic> selectedItemsList=[].obs;
//     selectedItemsList.value = selectedItemList!=null? selectedItemList:[] ;
//     Rx<bool> isSelectedItem = data == null || data == '' ? false.obs : true.obs;
//     List<dynamic> items = [];
//     items = await itemsList(column);
//     List<dynamic> selectedId = [];
//     return items.length != 0 ?
//     column.sourceItems != 'custom'? new Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Obx(() {
//                     return Txt(
//                       '${column.title}',
//                       color: MainController.isLightMode.value == true
//                           ? whiteColor
//                           : color2,
//                     );
//                   }),
//                   Obx(() {
//                     return MultiSelectDropdown(
//                       items: [
//                         for (var item in items)
//                           DropdownMenuItem(
//                               value: item['_id'],
//                               child: Obx(() {
//                                 return Row(
//                                   children: [
//                                     Container(
//                                       height: 100,
//                                       child: SizedBox(
//                                           width: 50,
//                                           height: 50,
//                                           child: Obx(() {
//                                             return Checkbox(
//                                                 activeColor: colorBtn,
//                                                 value: selectedItemsList.any(
//                                                     (map) =>
//                                                         mapEquals(map, item)),
//                                                 onChanged: (isChecked) {
//                                                   if (isChecked != null) {
//                                                     hintTxt.value = '';
//                                                     if (!selectedItemsList.any(
//                                                         (map) => mapEquals(
//                                                             map, item))) {
//                                                       selectedId = [];
//                                                       requestMultiSelect = item;
//                                                       selectedItemsList
//                                                           .add(item);
//                                                     } else {
//                                                       selectedId = [];
//                                                       requestMultiSelect
//                                                           .removeWhere((key,
//                                                                   value) =>
//                                                               value == ['_id']);
//                                                       var index =
//                                                           selectedItemsList
//                                                               .indexWhere(
//                                                                   (map) =>
//                                                                       mapEquals(
//                                                                           map,
//                                                                           item));
//
//                                                       selectedItemsList
//                                                           .removeAt(index);
//                                                     }
//                                                     if (item['_id'] == '') {}
//                                                     if (selectedItemsList
//                                                             .value.length ==
//                                                         0) {
//                                                       isSelectedItem.value =
//                                                           false;
//                                                     } else {
//                                                       isSelectedItem.value =
//                                                           true;
//                                                     }
//                                                     for (var r
//                                                         in selectedItemsList)
//                                                       hintTxt.value = hintTxt
//                                                               .value +
//                                                           itemsShowSelectItem(
//                                                               r, column);
//
//                                                     for (var r
//                                                         in selectedItemsList)
//                                                       selectedId.add(r['_id']);
//
//                                                     ViewController.request[
//                                                             column.name] =
//                                                         selectedId;
//                                                   }
//                                                 });
//                                           })),
//                                     ),
//                                     Txt(itemsShowSelectItem(item, column),
//                                         color: MainController.isLightMode.value
//                                             ? whiteColor
//                                             : primaryDark),
//                                   ],
//                                 );
//                               }))
//                       ],
//                       hintText: hintTxt.value != '' && hintTxt.value != null
//                           ? hintTxt.value
//                           : '${AppController.of(Get.context!)!.value('choice')}',
//                       selectedItems: selectedItemsList,
//                       isSelectedItem: isSelectedItem,
//                       // onChanged: (selectedList){
//                       //       selectedItemsList.value = selectedList;
//                       //   hintTxt.value = hintTxt.value;
//                       //       ViewController.request= requestMultiSelect;
//                       // },
//                       column: column,
//                     );
//                   }),
//                 ],
//               )
//             : new Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Obx(() {
//                     return Txt(
//                       '${column.title}',
//                       color: MainController.isLightMode.value == true
//                           ? whiteColor
//                           : color2,
//                     );
//                   }),
//                   Obx(() {
//                     return MultiSelectDropdown(
//                       items: [
//                         for (var item in items)
//                           DropdownMenuItem(
//                               value: item['value'],
//                               child: Obx(() {
//                                 return Row(
//                                   children: [
//                                     Container(
//                                       height: 100,
//                                       child: SizedBox(
//                                           width: 50,
//                                           height: 50,
//                                           child: Obx(() {
//                                             return Checkbox(
//                                                 activeColor: colorBtn,
//                                                 value: selectedItemsList.any(
//                                                     (map) =>
//                                                         mapEquals(map, item)),
//                                                 onChanged: (isChecked) {
//                                                   if (isChecked != null) {
//                                                     hintTxt.value = '';
//                                                     if (!selectedItemsList.any(
//                                                         (map) => mapEquals(
//                                                             map, item))) {
//                                                       selectedId = [];
//                                                       requestMultiSelect = item;
//                                                       selectedItemsList
//                                                           .add(item);
//                                                     } else {
//                                                       selectedId = [];
//                                                       requestMultiSelect
//                                                           .removeWhere(
//                                                               (key, value) =>
//                                                                   value ==
//                                                                   ['value']);
//                                                       var index =
//                                                           selectedItemsList
//                                                               .indexWhere(
//                                                                   (map) =>
//                                                                       mapEquals(
//                                                                           map,
//                                                                           item));
//
//                                                       selectedItemsList
//                                                           .removeAt(index);
//                                                     }
//
//                                                     if (selectedItemsList
//                                                             .value.length ==
//                                                         0) {
//                                                       isSelectedItem.value =
//                                                           false;
//                                                     } else {
//                                                       isSelectedItem.value =
//                                                           true;
//                                                     }
//                                                     for (var r
//                                                         in selectedItemsList)
//                                                       hintTxt.value =
//                                                           hintTxt.value +
//                                                               r['title'];
//
//                                                     for (var r
//                                                         in selectedItemsList)
//                                                       selectedId
//                                                           .add(r['value']);
//
//                                                     ViewController.request[
//                                                             column.name] =
//                                                         selectedId;
//                                                   }
//                                                 });
//                                           })),
//                                     ),
//                                     Txt(item['title'],
//                                         color: MainController.isLightMode.value
//                                             ? whiteColor
//                                             : primaryDark),
//                                   ],
//                                 );
//                               }))
//                       ],
//                       hintText: hintTxt.value != '' && hintTxt.value != null
//                           ? hintTxt.value
//                           : '${AppController.of(Get.context!)!.value('choice')}',
//                       selectedItems: selectedItemsList,
//                       isSelectedItem: isSelectedItem,
//                       // onChanged: (selectedList){
//                       //       selectedItemsList.value = selectedList;
//                       //   hintTxt.value = hintTxt.value;
//                       //       ViewController.request= requestMultiSelect;
//                       // },
//                       column: column,
//                     );
//                   }),
//                 ],
//               )
//         : Container();
//   }
//
//   static Widget generateFormColorBox(
//       {var column, Color? selectedColor, var data, Function? onChange}) {
//     Rx<bool> isSeletedColor = data == null || data == '' ? false.obs : true.obs;
//     Color colorChanged;
//     return new Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Obx(() {
//           return Txt(
//             '${column.title}',
//             color:
//                 MainController.isLightMode.value == true ? whiteColor : color2,
//           );
//         }),
//         SizedBox(
//           height: 10,
//         ),
//         Container(
//           child: ColorPickerBox(
//             selectedColor: selectedColor != null ? selectedColor : appColor,
//             isSeletedColor: isSeletedColor,
//             onChanged: (color) {
//               if (onChange != null) {
//                 onChange(color);
//               } else {
//                 colorChanged = color;
//                 String hexColor = '0x${colorChanged.value.toRadixString(16).padLeft(8, '0')}';
//                 // dataJson[columnName] = hexColor;
//                 ViewController.request[column.name] = hexColor;
//               }
//             },
//             column: column,
//           ),
//         ),
//       ],
//     );
//   }
//
//   static Widget generateCellFileBox(int indexColumn, int indexRow,
//       {var tableData}) {
//     String name;
//     String type;
//     if (tableData == null) {
//       name = MainController.infoSchema.value.columns[indexColumn].name;
//       type = MainController.infoSchema.value.columns[indexColumn].type;
//     } else {
//       name = tableData['columns'][indexColumn]['name'];
//       type = tableData['columns'][indexColumn]['type'];
//     }
//     var dataModel = MainController.dataRecord[indexRow]['${name}'];
//     print('dataModel iiii>>>${dataModel}');
//     return dataModel != null && dataModel.length != 0
//         ? Column(
//             children: [
//               Center(
//                   child: Image.network(
//                 type == 'file'
//                     ? '${baseUrl}' + '${dataModel}'
//                     : '${baseUrlPvFile}' + '${dataModel}',
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.fill,
//                 errorBuilder: (BuildContext context, Object error,
//                     StackTrace? stackTrace) {
//                   return Image.asset(
//                     fileImage,
//                     width: 60,
//                     height: 60,
//                   ); // عکس جایگزین
//                 },
//               )
//                   // Img('${ dataModel}',width: 70,height: 70,isNetwork: true,),
//
//                   ),
//             ],
//           )
//         : Container();
//   }
//
//   static Widget generateCellMultiFileBox(int indexColumn, int indexRow,
//       {var tableData}) {
//     String name;
//     String type;
//     if (tableData == null) {
//       name = MainController.infoSchema.value.columns[indexColumn].name;
//       type = MainController.infoSchema.value.columns[indexColumn].type;
//     } else {
//       name = tableData['columns'][indexColumn]['name'];
//       type = tableData['columns'][indexColumn]['type'];
//     }
//     var dataModel = MainController.dataRecord[indexRow]['${name}_multi'];
//     return dataModel != null && dataModel.length != 0
//         ? Container(
//             width: 150,
//             child: Wrap(
//               children: [
//                 for (var data in dataModel)
//                   Center(
//                       child: Image.network(
//                     type == 'multiFile'
//                         ? baseUrl + '${data['path']}'
//                         : baseUrlPvFile + '${data['path']}',
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.fill,
//                     errorBuilder: (BuildContext context, Object error,
//                         StackTrace? stackTrace) {
//                       return Image.asset(
//                         fileImage,
//                         width: 70,
//                         height: 40,
//                       );
//                     },
//                   )
//                       // Img('${ dataModel}',width: 70,height: 70,isNetwork: true,),
//
//                       ),
//               ],
//             ),
//           )
//         : Container();
//   }
//
//   static Widget generateFileBox({var selecetdFiles=null, var column,
//       Function? onChange}) {
//     final RxBool isSelectedFile =
//         (selecetdFiles != null && selecetdFiles!='').obs;
//     Map<String, List<dynamic>> selectedFilesMap = {};
//     if (selectedFilesMap['${column.name}'] == null) {
//       selectedFilesMap['${column.name}'] = [];
//     }
//     List<dynamic> filesSelectedList = [];
//     RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;
//     return new Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Obx(() {
//           return Txt(
//             '${column.title}',
//             color:
//                 MainController.isLightMode.value == true ? whiteColor : color2,
//           );
//         }),
//         SizedBox(
//           height: 10,
//         ),
//         FormFile(
//           columnName: column.title,
//           onChanged: (file) {
//             // dataJson[columnName] = selecetdFiles;
//             if (column.type == 'file' || column.type == 'file_pv') {
//               if (onChange != null) {
//                 onChange(file);
//               } else {
//                 ViewController.request[column.name] = file;
//               }
//             } else {
//               if (onChange != null) {
//                 onChange(filesSelectedList);
//               } else {
//                 filesSelectedList.add(file);
//                 ViewController.request[column.name] = filesSelectedList;
//               }
//             }
//           },
//           filesSelected: selectedFilesMap,
//           selectedFilesTxt:
//               column.type == 'file' || column.type == 'file_pv'
//                   ? selecetdFiles
//                   : filesSelectedList,
//           isSeletedFile: isSelectedFile,
//           column: column,
//           fileInfo: fileInfo,
//         ),
//       ],
//     );
//   }
//
//   static Widget generateEditFileBox(var data, var column,
//       {Function? onChange}) {
//     final RxBool isSelectedFile = (data != null && data!.isNotEmpty).obs;
//
//     String name = column.name;
//     String type = column.type;
//     RxString file =
//         data != null && data[name] != null ? '${data[name]}'.obs : ''.obs;
//
//     Map<String, List<dynamic>> selectedFilesMap = {};
//     if (selectedFilesMap['${column.name}'] == null) {
//       selectedFilesMap['${column.name}'] = [];
//     }
//     ViewController.request[name] = data != null && data[name + '_name'] != null
//         ? '${data[name + '_name']}'
//         : '';
//     List<dynamic> filesSelectedList = [];
//     RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;
//     return Obx(() {
//       return new Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Txt(
//             '${column.title}',
//             color:
//                 MainController.isLightMode.value == true ? whiteColor : color2,
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           file.value != ''
//               ? IntrinsicWidth(
//                   child: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           color: MainController.isLightMode.value == true
//                               ? whiteColor
//                               : background,
//                           width: 0.5),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Stack(
//                       children: [
//                         Center(
//                             child: Column(
//                           children: [
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Image.network(
//                               type == 'file'
//                                   ? baseUrl + '${file}'
//                                   : baseUrlPvFile + '${file}',
//                               width: 40,
//                               height: 40,
//                               fit: BoxFit.fill,
//                               errorBuilder: (BuildContext context, Object error,
//                                   StackTrace? stackTrace) {
//                                 return Image.asset(
//                                   fileImage,
//                                   width: 40,
//                                   height: 40,
//                                 ); // عکس جایگزین
//                               },
//                             ),
//                             Txt(
//                               '${data[name + '_name']}',
//                               color: MainController.isLightMode.value == true
//                                   ? whiteColor
//                                   : color2,
//                             ),
//                           ],
//                         )),
//                         Positioned(
//                             top: 0,
//                             left: 0,
//                             child: IconButton(
//                               color: redColor,
//                               onPressed: () async {
//                                 widgetDeletePopup(onChange: () async {
//                                   var status =
//                                       await MainController.deleteFileInChunks(
//                                           data[name + '_name'],
//                                           recordId: data['_id'],
//                                           record: json
//                                               .encode({name: null}).toString());
//                                   if (status == true) {
//                                     file.value = '';
//                                     Navigator.pop(Get.context!);
//                                   }
//                                 });
//                               },
//                               icon: Icon(
//                                 Icons.delete,
//                                 size: 25,
//                                 color: redColor,
//                               ),
//                             ))
//                       ],
//                     ),
//                   ),
//                 )
//               : FormFile(
//                   columnName: column.title,
//                   onChanged: (selecetdFiles) {
//                     if (onChange != null) {
//                       onChange(filesSelectedList);
//                     } else {
//                       ViewController.request[name] = selecetdFiles;
//                     }
//                   },
//                   filesSelected: selectedFilesMap,
//                   // selectedFilesTxt: column['type'] == 'file' ? selecetdFiles:filesSelectedList,
//                   selectedFilesTxt: '',
//                   isSeletedFile: isSelectedFile,
//                   column: column,
//                   fileInfo: fileInfo,
//                 ),
//         ],
//       );
//     });
//   }
//
//   static Widget generateEditMultiFileBox(var data, var column,
//       {Function? onChange}) {
//     final RxBool isSelectedFile = (data != null && data!.isNotEmpty).obs;
//     ViewController.request[column.name] = [];
//     String name = column.name;
//     String type = column['type'];
//     Map<String, List<dynamic>> selectedFilesMap = {};
//     if (selectedFilesMap['${column.name}'] == null) {
//       selectedFilesMap['${column.name}'] = [];
//     }
//     RxList<String> filesSelectedList = <String>[].obs;
//     RxList<dynamic> filesList = [].obs;
//
//     if (data != null && data.length != 0) {
//       if (data[name + '_name'] != null && data[name + '_name'].length != 0) {
//         ViewController.request[column.name].add(data[name + '_name']);
//       }
//       if (data[name] != null && data[name].length != 0) {
//         filesList.addAll(data[name + '_multi']);
//
//         for (var file in data[name]) {
//           filesSelectedList.add('${file}');
//         }
//       }
//     }
//     RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;
//     return Obx(() {
//       return new Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Txt(
//             '${column.title}',
//             color:
//                 MainController.isLightMode.value == true ? whiteColor : color2,
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           data != null && data.length != 0
//               ? IntrinsicWidth(
//                   child: Container(
//                     padding: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           color: MainController.isLightMode.value == true
//                               ? whiteColor
//                               : background,
//                           width: 0.5),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       children: [
//                         FormFile(
//                           columnName: column.title,
//                           onChanged: (selecetdFiles) {
//                             filesSelectedList.add(selecetdFiles);
//                             ViewController.request[column.name] =
//                                 filesSelectedList;
//                           },
//                           filesSelected: selectedFilesMap,
//                           selectedFilesTxt: filesSelectedList,
//                           // selectedFilesTxt:  '',
//                           isSeletedFile: isSelectedFile,
//                           column: column,
//                           fileInfo: fileInfo,
//                         ),
//                         Row(
//                           children: [
//                             for (var file in filesList)
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Stack(
//                                   children: [
//                                     Center(
//                                         child: Column(
//                                       children: [
//                                         Image.network(
//                                           type == 'multiFile'
//                                               ? baseUrl + '${file['path']}'
//                                               : baseUrlPvFile +
//                                                   '${file['path']}',
//                                           width: 70,
//                                           height: 70,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (BuildContext context,
//                                               Object error,
//                                               StackTrace? stackTrace) {
//                                             return Image.asset(
//                                               fileImage,
//                                               width: 70,
//                                               height: 70,
//                                             );
//                                           },
//                                         ),
//                                         Txt(
//                                           '${file['name']}',
//                                           color: MainController
//                                                       .isLightMode.value ==
//                                                   true
//                                               ? whiteColor
//                                               : color2,
//                                         ),
//                                       ],
//                                     )),
//                                     Positioned(
//                                         top: 0,
//                                         left: 0,
//                                         child: IconButton(
//                                           color: redColor,
//                                           onPressed: () async {
//                                             widgetDeletePopup(
//                                                 onChange: () async {
//                                               if (data[name] != null) {
//                                                 data[name].removeWhere(
//                                                     (element) =>
//                                                         element ==
//                                                         file['name']);
//                                               }
//                                               var status = await MainController
//                                                   .deleteFileInChunks(
//                                                       file['name'],
//                                                       recordId: data['_id'],
//                                                       record: json.encode({
//                                                         name: data[name]
//                                                       }).toString());
//                                               if (status == true) {
//                                                 filesSelectedList.removeWhere(
//                                                     (element) =>
//                                                         element ==
//                                                         file['name']);
//                                                 filesList.removeWhere(
//                                                     (element) =>
//                                                         element['path'] ==
//                                                         file['path']);
//                                                 filesList.removeWhere(
//                                                     (element) =>
//                                                         element['name'] ==
//                                                         file['name']);
//                                                 if (ViewController.request[
//                                                         column.name] !=
//                                                     null)
//                                                   ViewController
//                                                       .request[column.name]
//                                                       .removeWhere((element) =>
//                                                           element ==
//                                                           file['name']);
//                                                 Navigator.pop(Get.context!);
//                                               }
//                                             });
//                                           },
//                                           icon: Icon(
//                                             Icons.delete,
//                                             size: 25,
//                                             color: redColor,
//                                           ),
//                                         ))
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               : Container()
//         ],
//       );
//     });
//   }
//
//   static Widget generateSelectFileBox(
//       String type,
//       RxList<String> fileSelectedList,
//       RxMap<String, List<dynamic>> fileInfo,
//       var index) {
//     return Obx(() {
//       var fileData = fileInfo[fileSelectedList[index]];
//       var totalChunks = 1;
//       var currentChunk = 0;
//       RxMap<String, dynamic>? chunkName = <String, dynamic>{}.obs;
//       if (fileInfo[fileSelectedList[index]] != null) {
//         totalChunks = fileData?[0] ?? 1;
//         currentChunk = fileData?[1] ?? 0;
//         chunkName.value = fileData!.length > 2
//             ? fileData[2] != null
//                 ? fileData[2]
//                 : {}
//             : fileSelectedList[index];
//       }
//       return Container(
//         margin: EdgeInsets.only(bottom: 10),
//         child: Row(
//           children: [
//             chunkName.isNotEmpty
//                 ? Image.network(
//                     type.endsWith('pv')
//                         ? baseUrlPvFile + '${chunkName['path']}'
//                         : baseUrl + '${chunkName['path']}',
//                     width: 70,
//                     height: 70,
//                     fit: BoxFit.fill,
//                     errorBuilder: (BuildContext context, Object error,
//                         StackTrace? stackTrace) {
//                       return Img(
//                         fileImage,
//                         width: 70,
//                         height: 70,
//                       );
//                     },
//                   )
//                 : Img(
//                     fileImage,
//                     width: 70,
//                     height: 70,
//                   ),
//             SizedBox(
//               width: 5,
//             ),
//             fileInfo[fileSelectedList[index]] != null
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: 210,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Txt(
//                               totalChunks == currentChunk
//                                   ? '${chunkName.isNotEmpty ? chunkName['name'] != null ? chunkName['name'] : '' : ''}'
//                                   : '',
//                               fontSize: 16,
//                               color: totalChunks == currentChunk
//                                   ? Colors.white
//                                   : Colors.grey,
//                             ),
//                             if (totalChunks == currentChunk)
//                               IconButton(
//                                 icon: Icon(Icons.delete),
//                                 color: Colors.red,
//                                 onPressed: () {
//                                   ViewController.widgetDeletePopup(
//                                       onChange: () async {
//                                     await MainController.deleteFileInChunks(
//                                         chunkName['name']!);
//                                     fileSelectedList.removeAt(index);
//                                     Navigator.pop(Get.context!);
//                                   });
//                                 },
//                               )
//                           ],
//                         ),
//                       ),
//                       currentChunk != 0
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(50),
//                               child: SizedBox(
//                                 width: 200,
//                                 child: LinearProgressIndicator(
//                                   value: totalChunks > 0
//                                       ? currentChunk / totalChunks
//                                       : 0,
//                                   backgroundColor: Colors.grey,
//                                   minHeight: 5,
//                                   color: totalChunks == currentChunk
//                                       ? Colors.green
//                                       : Colors.red,
//                                 ),
//                               ),
//                             )
//                           : Container(),
//                     ],
//                   )
//                 : Container()
//           ],
//         ),
//       );
//     });
//   }
//
//   static Widget generateFormTimeBox(
//       {var column, TimeOfDay? selectedTime, var data,Function?onChange}) {
//     selectedTime=selectedTime==null? TimeOfDay.now():selectedTime;
//     Rx<bool>isSeletedTime=data==null||data==''?false.obs:true.obs;
//     return new Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Obx(() {
//           return Txt(
//             '${column.title}',
//             color:
//                 MainController.isLightMode.value == true ? whiteColor : color2,
//           );
//         }),
//         SizedBox(
//           height: 10,
//         ),
//         TimePickerBox(
//           column: column,
//           selectedTime: selectedTime,
//           isSeletedTime: isSeletedTime,
//           onTimeChanged: (time) {
//             if(onChange!=null){
//               onChange(time);
//             }else{
//               ViewController.request[column.name] = time;
//
//             }
//           },
//         ),
//       ],
//     );
//   }
//
//   static Future<String> getTitleSelectedItem(
//       String tableName, String selectedId, var column) async {
//     String selectedTitle = '';
//     var sourceItem = column['sourceItems'];
//     if (sourceItem != 'custom') {
//       if (selectedId != '') {
//         List<dynamic> itemSelect = [];
//         var object =
//             (await DB(tableName).where('_id', '\$eq', selectedId).getRecords());
//         if (object.length == 0) {
//           selectedTitle =
//               '${AppController.of(Get.context!)!.value('Uncertain')}';
//         } else {
//           var objectItem = object.first;
//           List<dynamic> items = column['items'];
//           for (var item in items) {
//             itemSelect.add(objectItem[item]);
//           }
//           selectedTitle = itemSelect.join('%');
//         }
//       } else {
//         selectedTitle = '';
//       }
//     } else {
//       if (selectedId != '') {
//         Map<String, dynamic> selectedItem = column['items'].firstWhere(
//             (element) => element['value'] == selectedId,
//             orElse: () => {'error': ''});
//         if (selectedItem['title'] != null) {
//           selectedTitle = selectedItem['title'];
//         } else {
//           selectedTitle = selectedItem['error'];
//         }
//       } else {
//         selectedTitle = '';
//       }
//     }
//     return selectedTitle;
//   }
//
//   static Future<List<dynamic>> getTitleMultiSelectedItem(
//       String tableName, List<dynamic> selectedId, var column) async {
//     List<dynamic> multiSelectedTitleList = [];
//     var sourceItem = column['sourceItems'];
//     for (var i = 0; i < selectedId.length; i++) {
//       if (sourceItem != 'custom') {
//         var object = await DB(tableName)
//             .where('_id', '\$eq', selectedId[i])
//             .getRecords();
//         if (object.length != 0) {
//           var objectItem = object.first;
//           List<dynamic> items = column['items'];
//           for (var item in items) {
//             multiSelectedTitleList.add(objectItem['${item}']);
//           }
//         } else {
//           multiSelectedTitleList = [''];
//         }
//       } else {
//         Map<String, dynamic> selectedItem = column['items'].firstWhere(
//             (element) => element['value'] == selectedId[i],
//             orElse: () => {'error': ''});
//         if (selectedItem['title'] != null) {
//           multiSelectedTitleList.add(selectedItem['title']);
//         }
//       }
//     }
//     return multiSelectedTitleList;
//   }
//
//   static String itemsShowSelectItem(var listItems, ColumnModel column) {
//     var items = column.items;
//     List<dynamic> a = [];
//     if (listItems is List) {
//       if (listItems.length == 0) {
//         return "${AppController.of(Get.context!)!.value('not selected')}";
//       }
//       for (int i = 0; i < listItems.length; i++) {
//         if (listItems[i] is String) {
//           a.add(listItems[i]);
//         } else {
//           if (column.sourceItems == 'table') {
//             List<dynamic> empty = [];
//             for (var field in items) {
//               empty.add(listItems[i][field['name']]);
//             }
//             a.add(empty.join('%'));
//           } else {
//             a.add(listItems[i]['title']);
//           }
//         }
//       }
//     } else {
//       if (listItems is String) {
//         a.add(listItems);
//       } else {
//         if (listItems['_id'] == '') {
//           return "${AppController.of(Get.context!)!.value('not selected')}";
//         }
//         if (column.sourceItems == 'table') {
//           List<dynamic> empty = [];
//           for (var field in items) {
//             empty.add(listItems[field['name']]);
//           }
//           a.add(empty.join('%'));
//         } else {
//           a.add(listItems['title']);
//         }
//       }
//     }
//     return a.join(' , ');
//   }
//
//   static Future<List> itemsList(ColumnModel column, {var dataModel}) async {
//     var type = column.sourceItems;
//     var tableName = column.sourceTable;
//     List<dynamic> dropDownListItems = [];
//     if (type != 'custom') {
//       if (dataModel == null || dataModel.isEmpty) {
//         print('ViewController.itemsList>>>${tableName}');
//         // Future.delayed(Duration.zero, () async {
//         List<dynamic> data = await DB('${tableName}').getRecords();
//         data.removeWhere((element) => element['sync'] != null);
//         dropDownListItems = data;
//         for (int i = 0; i < dropDownListItems.length; i++) {
//           List<dynamic> a = [];
//           for (var field in column.items) {
//             a.add(dropDownListItems[i][field]);
//           }
//         }
//       } else {
//         if (dataModel[column.name] == null) {
//           dropDownListItems = [];
//         } else {
//           dataModel[column.name]
//               .removeWhere((element) => element['sync'] != null);
//           List<dynamic> a = [];
//           for (int i = 0; i < dataModel[column.name].length; i++) {
//             a.add(dataModel[column.name][i]);
//           }
//           ;
//           dropDownListItems = a;
//         }
//       }
//     } else {
//       List<dynamic> itemss = [];
//       if (dataModel == null || dataModel.isEmpty) {
//         itemss = column.items;
//       } else {
//         if (dataModel[column.name] == null ||
//             dataModel[column.name] == '') {
//           itemss = [];
//         } else {
//           for (var item in dataModel[column.name]) {
//             itemss.add(item);
//           }
//         }
//       }
//       dropDownListItems = itemss;
//     }
//     return dropDownListItems;
//   }
//
//   static String hintMultiSelectBox(List<dynamic> items, List<dynamic> ListsId) {
//     List<String> titles = [];
//     for (var id in ListsId) {
//       var selectedItem = items.firstWhere((element) => element['value'] == id,
//           orElse: () => null);
//       if (selectedItem != null) {
//         titles.add(selectedItem['title']);
//       }
//     }
//     return titles.join(',');
//   }
//
//   static widgetDeletePopup({Function? onChange}) {
//     showDialog(
//         context: Get.context!,
//         builder: (BuildContext context) {
//           return Dialog(
//               child: Container(
//             width: 150,
//             height: 150,
//             padding: EdgeInsets.all(15),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//             ),
//             child: Column(
//               children: [
//                 Txt('${AppController.of(context)!.value('Do you want this item to be removed?')}'),
//                 Spacer(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(15),
//                         width: 52,
//                         height: 52,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(10)),
//                             color: redColor),
//                         child: Center(
//                             child: Txt(
//                           '${AppController.of(context)!.value('no')}',
//                           color: whiteColor,
//                         )),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     InkWell(
//                       onTap: () async {
//                         if (onChange != null) {
//                           onChange();
//                         }
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(15),
//                         width: 52,
//                         height: 52,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(10)),
//                             color: successColor),
//                         child: Center(
//                             child: Txt(
//                           '${AppController.of(context)!.value('yes')}',
//                           color: whiteColor,
//                         )),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ));
//         });
//   }
//
// }
