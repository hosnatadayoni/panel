import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/dataModel.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-checkBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-date.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/Admin/UI/Componenets/page-custom/orderItem/form-edit-orderItem-custom.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../Public/styles.dart';
import '../../UI/Componenets/General/txt.dart';
import '../../UI/Componenets/Items/Form/form-color.dart';
import '../../UI/Componenets/Items/Form/form-file.dart';
import '../../UI/Componenets/Items/Form/form-radio-button.dart';
import '../../UI/Componenets/Items/Form/form-time.dart';
import '../Models/db.dart';
import '../Models/order-item.dart';

class ViewCustomController extends GetxController{
  static Map<String, dynamic> requestMultiSelect = <String, dynamic>{};
  // the function form custom page and show table

  static Jalali parseDate(String dateString) {
    List<String> dateParts = dateString.split('/');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    return Jalali(year, month, day);
  }
  static TimeOfDay parseTime(String dateString){
    List<String>? TimeParts;
    int hour = TimeOfDay.now().hour;
    int minute = TimeOfDay.now().minute;
    TimeParts = dateString.split(':');
    hour = int.parse('${TimeParts![0]}');
    minute = int.parse('${TimeParts[1]}');

    return TimeOfDay(hour: hour, minute: minute);
  }

  // select order
  static Future<Map<String, dynamic>> getSelectBoxData(Map<String, dynamic> column) async {
    List<dynamic> items=[];
    var initValue;
    // Map<String, dynamic> selectedItem={};
    String selectedItem='';
    if(column['type'] == 'select' || column['type'] == 'radiobutton'){

      items = await ViewController.itemsList(column);
      // initValue = await ViewController.getInitValue(column, items);
      if(column['type'] == 'radiobutton'){
      }
      if(items.length != 0){
        for(var item in items){
          selectedItem = ViewController.itemsShowSelectItem(item, column);
        }
        // selectedItem = items.firstWhere(
        //         (element) => element['value'] == ViewController.request[column['name']],
        //     orElse: () => items.first);

        // if(selectedItem['value'] != null){
        //   initValue = selectedItem['value'];
        // }
      }
    }

    return {
      'items': items,
      'initValue': '',
      'hint' :selectedItem
    };
  }

  //multi select order
  static Future<Map<String, dynamic>> getMultiSelectBoxData(Map<String, dynamic> column , {var dataModel}) async {
    List<dynamic> items = await ViewController.itemsList(column,dataModel: dataModel);
    List<dynamic> multiSelectedItemList = [];
    String hint = '';
    if (items.length != 0) {
      if (column['sourceTable'] != null) {
        for (var selectedItem in items) {
          multiSelectedItemList.add(ViewController.itemsShowSelectItem(selectedItem, column));
        }
      } else {
        for (var selectedItem in items) {
          multiSelectedItemList.add(selectedItem['title']);
        }
      }
    }

    return {
      'hint':hint,
      'selectedItemsList':multiSelectedItemList,
      'items':items,
    };
  }


  // select order item
  static Future<Map<String, dynamic>> getSelectBoxOrderItemData(Map<String, dynamic> column , var data) async {
    List<dynamic> items=[];
    var initValue;
    Map<String, dynamic> selectedItem={};
    if(column['type'] == 'select' || column['type'] == 'radiobutton'){
      items = await ViewController.itemsList(column);
      // initValue = await ViewController.getInitValue(column, items);
      if(items.length != 0){
        if(data != null){
          selectedItem = items.firstWhere(
                  (element) => element['value'] == data[column['name']],
              orElse: () => items.first);
        }
        else{
          selectedItem = items.first;
        }

        if(selectedItem['value'] != null){
          initValue = selectedItem['value'];
        }
      }

    }
    return {
      'items': items,
      'initValue': '',
      'hint' :selectedItem['title']
    };
  }

  //show table
  static Future<String> getTitleSelectBoxFormCustom (var column , DataModel dataModel) async {
    String tableName = '';
    if (column['sourceItems'] != 'custom') {
      tableName = column['sourceTable'];
    }
    String titleSelect='';

    if(dataModel.data['${column['name']}'] != null){
      titleSelect = await ViewController.getTitleSelectedItem('${tableName}',
          dataModel.data['${column['name']}'] , column);
    }

    else{
      titleSelect = dataModel.id!;
    }
    return titleSelect;
  }

  // multi select order
  // static Future<Map<String, dynamic>> getMultiSelectBoxData(Map<String, dynamic> column) async{
  //
  //   List<dynamic> items=[];
  //
  //   var initValue;
  //   Map<String, dynamic> selectedItem={};
  //
  //   String tableName= '';
  //   List<dynamic> multiSelectedTitleList = [];
  //   Rx<bool> isSelectedItem = false.obs;
  //   Rx<String> hintTxt=''.obs;
  //   RxList<String> selectedItemsList = <String>[].obs;
  //
  //   if(column['type'] == 'multiSelect'){
  //
  //     items = await ViewController.itemsList(column);
  //     // if (column['sourceItems'] != 'custom'){
  //     //   if(column['sourceTable'] != null){
  //     //     tableName = column['sourceTable'];
  //     //   }
  //     // }
  //     // if(ViewController.request[column['name']] != null){
  //     //   multiSelectedTitleList = await ViewController.getTitleMultiSelectedItem(tableName, ViewController.request[column['name']], column);
  //     // }
  //     // else{
  //     //   multiSelectedTitleList = await ViewController.getTitleMultiSelectedItem(tableName, [], column);
  //     // }
  //     //
  //     // if(multiSelectedTitleList.length != 0){
  //     //   hintTxt = RxString(multiSelectedTitleList.join(','));
  //     //   selectedItemsList.value = ViewController.request[column['name']];
  //     // }
  //     // else{
  //     //   hintTxt = RxString('${items[0]['title']}');
  //     // }
  //   }
  //
  //
  //   // return {
  //   //   'items': items,
  //   //   'multiSelectedTitleList': multiSelectedTitleList,
  //   //   'isSelectedItem':isSelectedItem,
  //   //   'hintTxt':hintTxt,
  //   //   'selectedItemsList': selectedItemsList,
  //   // };
  //   return {
  //     'items':items,
  //   };
  //
  // }

  // multi select order item
  static Future<Map<String, dynamic>> getMultiSelectBoxOrderItemData(Map<String, dynamic> column ,var data) async{

    List<dynamic> items=[];

    var initValue;
    Map<String, dynamic> selectedItem={};

    String tableName= '';
    List<dynamic> multiSelectedTitleList = [];
    Rx<bool> isSelectedItem = false.obs;
    Rx<String> hintTxt=''.obs;
    RxList<String> selectedItemsList = <String>[].obs;

    if(column['type'] == 'multiSelect'){
      items = await ViewController.itemsList(column);
      if (column['sourceItems'] != 'custom'){
        if(column['sourceTable'] != null){
          tableName = column['sourceTable'];
        }
      }
      if(data != null){
        if(data[column['name']] != null){
          multiSelectedTitleList = await ViewController.getTitleMultiSelectedItem(tableName, data[column['name']], column);
        }
        else{
          multiSelectedTitleList = await ViewController.getTitleMultiSelectedItem(tableName, [], column);
        }
      }
      else{
        multiSelectedTitleList = await ViewController.getTitleMultiSelectedItem(tableName, [], column);
      }

      if(multiSelectedTitleList.length != 0){
        hintTxt = RxString(multiSelectedTitleList.join(','));
        selectedItemsList.value = data[column['name']];
      }
      else{
        hintTxt = RxString('${items[0]['title']}');
      }
    }

    return {
      'items': items,
      'multiSelectedTitleList': multiSelectedTitleList,
      'isSelectedItem':isSelectedItem,
      'hintTxt':hintTxt,
      'selectedItemsList': selectedItemsList,
    };

  }

  static Future<String> getTitleMultiSelctBoxFormCustom(var column , DataModel dataModel) async {
    String tableName = '';
    if (column['sourceItems'] != 'custom') {
      tableName = column['sourceTable'];
    }
    List<dynamic> titleMultiSelectList=[];
    if(dataModel.data['${column['name']}'] != null){
      titleMultiSelectList = await ViewController.getTitleMultiSelectedItem('${tableName}', dataModel.data['${column['name']}'] , column);
    }
    return titleMultiSelectList.join(',');
  }

  static Map<String, List<dynamic>> getselectedFilesMap (var column){
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
    return selectedFilesMap;

  }

  static Map<String,dynamic> getDataTable(String tableName){
    Map<String,dynamic> dataTableName={};
    for(var subMenu in MainController.SubMenuList){
      if(subMenu['table-name'] == tableName){
        dataTableName = subMenu;
      }
    }
    return dataTableName;
  }

  // create order page
  static Future<Widget> generateStoreFormOrderView(var columns) async {
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
      if (columns[j]['is-show-store'] == true) {
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
            width: 20,
          ));
          children.add(textField);
        }
        if (type == 'select') {
          var initValue;
          List<dynamic> items = await ViewController.itemsList(column);
          selectBox = await generateStoreFormSelectBox(
              column, items, '', '', false.obs);
          children.add(SizedBox(
            width: 20,
          ));
          children.add(selectBox);
        } else if (type == 'checkbox') {
          checkBox = generateFormCheckBox(column, false.obs);
          children.add(SizedBox(
            width: 20,
          ));
          children.add(checkBox);
        }
        else if (type == 'radiobutton') {
          var initValue;
          List<dynamic> items = await ViewController.itemsList(column);
          radioButtonBox = generateFormRadioButton(column, items, '', false.obs);
          children.add(SizedBox(width: 20,));
          children.add(radioButtonBox);
        }
        else if (type == 'date') {
          dateBox = generateFormDateBox(column, Jalali.now(), false.obs);
          children.add(SizedBox(
            width: 20,
          ));
          children.add(dateBox);
        }
        else if (type == 'multiSelect') {

          multiSelectBox = await genarateStoreFormMuiltiSelectBox(column, RxString(''), <dynamic>[].obs, false.obs);
          children.add(SizedBox(
            width: 20,
          ));
          children.add(multiSelectBox);

        } else if (type == 'color') {
          colorBox = generateFormColorBox(column, Colors.blue, false.obs);
          children.add(SizedBox(
            width: 20,
          ));
          children.add(colorBox);
        } else if (type == 'file') {
          fileBox = generateFileBox('', column, false.obs);
          children.add(SizedBox(
            width: 20,
          ));
          children.add(fileBox);
        } else if (type == 'time') {
          timeBox = generateFormTimeBox(column, TimeOfDay.now(), false.obs);
          children.add(SizedBox(
            width: 20,
          ));
          children.add(timeBox);
        }
      }
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.start, children: children);
  }
  static Widget generateStoreFormSelectBox(var column, List<dynamic> items,
      String hintText, String initailValue, Rx<bool> isSeleted) {
    if (initailValue == '' || initailValue == null) {
      ViewController.request[column['name']] = null;
    }
    print('items klmn>>>${items}');

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
        column['sourceItems'] != 'custom' ?
        Container(
          width: column['name'] == 'مشتری'  ? 150:100,
          child: SelectBox(
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
                          '${ViewController.itemsShowSelectItem(item, column)}',
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
              selectedValue: ''),
        )
            : Container(
          width: column['name'] == 'مشتری'  ? 150:100,
          child: SelectBox(
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
        ),
      ],
    ) : Container();
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
        Container(
          width: 80,
          child: FormTextField(
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
        ),
      ],
    );
  }
  static Widget generateFormCheckBox(var column, Rx<bool>? isClickedBtn,
      {var defultValue}) {
    ViewController.request[column['name']] =
        defultValue ?? column['default_value'];

    return Container(
      width: 150,
      child: new CheckBox(
        checkBoxName: '${column['title']}',
        checkBoxTitle: '${column['title']}',
        isClickedBtn: isClickedBtn,
        defaultValue: defultValue ?? column['default_value'],
        onChange: (text) {
          ViewController.request[column['name']] = text;
          // dataJson[columnName] = text;
        },
        column: column,
      ),
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
        column['sourceItems'] != 'custom' ?
        Container(
          width: 400,
          height: 150,
          child: RadioButton(
            name: '',
            radioButtonItems: [
              for (var item in items)
                FormBuilderChipOption(
                    value: item['_id'].toString(),
                    child: Obx(() {
                      return Txt(
                        '${ViewController.itemsShowSelectItem(item, column)}',
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
          ),
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
        Container(
          width: 120,
          child: DateBox(
            selectedDate: selectedDate,
            isSeletedDate: isSeletedDate,
            onDateChanged: (date) {
              // dataJson[columnName] =  date;
              ViewController.request[column['name']] = date;
            },
            column: column,
          ),
        ),
      ],
    );
  }
  static Future<Widget> genarateStoreFormMuiltiSelectBox(var column, Rx<String> hintTxt, RxList<dynamic> selectedItemsList, Rx<bool> isSelectedItem) async {
    List<dynamic> items = [];
    items = await ViewController.itemsList(column);
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
          return Container(
            width: 250,
            child: MultiSelectDropdown(
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
                                                  ViewController.itemsShowSelectItem(r,
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
                                ViewController.itemsShowSelectItem(
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
            ),
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
        Container(
          width: 300,
          child: FormFile(
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
        Container(
          width: 100,
          child: TimePickerBox(
            column: column,
            selectedTime: selectedTime,
            isSeletedTime: isSeletedTime,
            onTimeChanged: (time) {
              ViewController.request[column['name']] = time;
            },
          ),
        ),
      ],
    );
  }

  //end create order page


  //edit order page
  static Future<Widget> generateEditFormOrderView(Map<String, dynamic> dataModel) async {
    var children = <Widget>[];
    var textField;
    var selectBox;
    var checkBox;
    var dateBox;
    var multiSelectBox;
    var colorBox;
    var fileBox;
    var timeBox;
    var radioButtonBox;
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
            width: 20,
          ));
          children.add(textField);
        }
        else if (type == 'select') {
          Map<String, dynamic> selectedItem = <String, dynamic>{};
          List<dynamic> items = await ViewController.itemsList(column);
          print('items a>>>${items} ${column['name']}');
          if (items.length != 0) {
            if (column['sourceItems'] != 'custom') {
              if (dataModel[name] != null && dataModel[name] != ''){

                selectedItem = items.firstWhere((element) => element['_id'] == dataModel[name]['_id']);
                print('selectedItemd>>>${selectedItem}');

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
              width: 20,
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
            width: 20,
          ));
          children.add(checkBox);
        }
        else if (type == 'radiobutton') {
          Map<String, dynamic> selectedItem = <String, dynamic>{};
          var items = await ViewController.itemsList(column);
          if (items.length != 0) {
            if (column['sourceItems'] != 'custom') {
              if (dataModel[name] != null && dataModel[name] != '')
                selectedItem = items
                    .firstWhere((element) => element['_id'] == dataModel[name].first['_id']);
              radioButtonBox = await generateFormRadioButton(
                  column,
                  items,
                  '${selectedItem.isNotEmpty ? selectedItem['_id'] != null
                      ? selectedItem['_id']
                      : '' : ''}',
                  dataModel[name] == '' ? false.obs : true.obs);
            } else {
              if (dataModel[name] != null && dataModel[name] != '')
                selectedItem = items.firstWhere(
                        (element) => element['value'] == dataModel[name]['value']);
              radioButtonBox = await generateFormRadioButton(
                  column,
                  items,
                  '${selectedItem.isNotEmpty ? selectedItem['value'] != null
                      ? selectedItem['value']
                      : '' : ''}',
                  dataModel[name] == '' ? false.obs : true.obs);
            }
            children.add(SizedBox(
              width: 20,
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
          List<dynamic> items = await ViewController.itemsList(column,dataModel: dataModel);
          List<dynamic> multiSelectedItemList = [];
          if (items.length != 0) {
            if (column['sourceTable'] != null) {
              for (var selectedItem in items) {
                multiSelectedItemList.add(ViewController.itemsShowSelectItem(selectedItem, column));
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
          fileBox = generateFileBox(
              '${dataModel[name] != null && dataModel[name] != ''? dataModel[name] : []}',
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
    return Row(mainAxisAlignment:MainAxisAlignment.start,children: children);
  }
  static Future<Widget> genarateEditFormMuiltiSelectBox(var column, Rx<String> hintTxt, RxList<dynamic> selectedItemsList, Rx<bool> isSelectedItem) async {
    RxList<String> selectedItemId = <String>[].obs;
    List<dynamic> items =[];
    List<dynamic> selectedId = [];


    if (column['sourceItems'] != 'custom') {
      items = await DB('${column['sourceTable']}').getRecords();

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
            return Container(
              width: 250,
              child: MultiSelectDropdown(
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
                                                hintTxt.value = hintTxt.value + ViewController.itemsShowSelectItem(r, column);
                                              ViewController.request[column['name']]= selectedItemId;
                                            }
                                          });
                                    })),
                              ),
                              Txt(ViewController.itemsShowSelectItem(item, column),
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
              ),
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
  //end edit order page

  static Future<Widget> getOrderItems(var data) async {
    // List<dynamic>items=await DB('order-itemss').parent(parentId:  "${data['id']}",parentTable: 'order').getRecords();
    List<dynamic>items=await DB('itemsOrder2').parent(parentId:  "${data['_id']}",parentTable: 'order3').getRecords();
    print('items as>>>${items}');
    for(var item in items){
      OrderItem.orderItemsList[item['_id']]=item;

    }
    return Column(
      children: [
        FormEditOrderItemCustom(),
      ],
    );
  }

}