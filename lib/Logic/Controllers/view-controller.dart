import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Models/dataModel.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Form/form-checkBox.dart';
import 'package:finance/UI/Componenets/Items/Form/form-color.dart';
import 'package:finance/UI/Componenets/Items/Form/form-date.dart';
import 'package:finance/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:finance/UI/Componenets/Items/Form/form-radio-button.dart';
import 'package:finance/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/boxes.dart';
import 'package:flutter/cupertino.dart';
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
  static Rx<bool> isClickedCreateBtn = false.obs;
  static Map<String, List<int>> fileSizeList = {};
  static Map<String, dynamic> request = {};

  static Future<Widget> generateStoreFormView(
      Map<String, dynamic> dataJson) async {
    var children = <Widget>[];
    var textField;
    var selectBox;
    var checkBox;
    var radioButtonBox;
    var dateBox;
    var multiSelectBox;
    var colorBox;
    var fileBox;

    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      if (MainController.tableInfo['columns'][j]['is-show-store'] == true) {
        var column = MainController.tableInfo['columns'][j];
        print('column table>>>${column}');
        var type = column['type'];
        String name = column['name'];
        var defaultValue = column['default_value'];
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
        if (type == 'string' || type == 'int' || type == 'number') {
          textField =
              generateFormTextField(_fbKey, column, dataJson, type, '');
          children.add(SizedBox(
            height: 20,
          ));
          children.add(textField);
        }
        if (type == 'select') {
          // List<dynamic> items =[];
          // var selectedItem;
          // // print('fvghjk>>>${ViewController.itemsList (column)}');
          // for(var item in await ViewController.itemsList (column , column['sourceItems'])){
          //   print('the item select box>>>${item}');
          // }

          // for(var subMenu in MainController.SubMenuList){
          //   if(column['sourceItems'] != 'custom'){
          //     if(column['sourceTable'] == subMenu['table-name']){
          //       print('column[sourceTable]>>>${column['sourceTable']}');
          //       print('subMenu[columns]>>>${subMenu['columns']}');
          //       List<DataModel> dropDownListItems = await getRowTable(column['sourceTable']);
          //       for(var i=0;i<dropDownListItems.length;i++){
          //         print('id data:${dropDownListItems[i].id}');
          //         items.add({'title': dropDownListItems[i].data['title'], 'value': dropDownListItems[i].id});
          //       }
          //       // initValue = items.length!=0 ?items.first.entries.first.value:"";
          //       initValue = items.length!=0 ? items[0]['value']:"";
          //     }
          //   }
          //   else{
          //     items = column['items'];
          //     selectedItem = items.firstWhere(
          //           (item) => item['is_selected'] == true,
          //       orElse: () => items.first,);
          //     initValue = selectedItem['value'];
          //     // initValue = selectedItem['title'];
          //   }
          // }
          var initValue;

          List<dynamic> items = await itemsList(column);
          initValue = await getInitValue(
              column,items);
          selectBox = await generateFormSelectBox(
               column,items, dataJson, '', '${initValue}');
          children.add(SizedBox(
            height: 20,
          ));
          children.add(selectBox);
        } else if (type == 'checkbox') {
          checkBox = generateFormCheckBox(column, defaultValue, dataJson);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(checkBox);
        } else if (type == 'radiobutton') {
          var radioButtonItems = column['items'];
          var selectedItem = radioButtonItems.firstWhere(
            (item) => item['is_selected'] == true,
            orElse: () => radioButtonItems.first,
          );
          radioButtonBox = generateFormRadioButton(
               column, dataJson, selectedItem['title']);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(radioButtonBox);
        } else if (type == 'date') {
          dateBox = generateFormDateBox(column, dataJson, Jalali.now());
          children.add(SizedBox(
            height: 20,
          ));
          children.add(dateBox);
        } else if (type == 'multiSelect') {
          multiSelectBox = await genarateFormMuiltiSelectBox(
              column,
              dataJson,
              '${AppController.of(Get.context!)!.value('has been selected')}');
          children.add(SizedBox(
            height: 20,
          ));
          children.add(multiSelectBox);
        } else if (type == 'color') {
          colorBox = generateFormColorBox(column, dataJson, Colors.blue);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(colorBox);
        } else if (type == 'file') {
          fileBox = generateFileBox(dataJson, '', column);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(fileBox);
        }
      }
    }
    return Column(children: children);
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
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      if (MainController.tableInfo['columns'][j]['is-show-edit'] == true) {
        var column = MainController.tableInfo['columns'][j];
        var type = column['type'];
        var name = column['name'];
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
            type == 'number' ||
            type == 'email') {
          GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
          textField = generateFormTextField(
              _fbKey,
              column,
              dataModel,
              type,
              '${dataModel['${name}'] != null ? dataModel['${name}'] : ''}');
          // textField = new FormTextField(
          //   name: '${name}',
          //   hint: '${name}',
          //   fbKey: _fbKey,
          //   lable: '${name}',
          //   column:column ,
          //   initValue:
          //   '${dataModel.data['${name}'] != null ? dataModel.data['${name}'] : ''}',
          //   onChange: (text) {
          //     dataModel.data['${name}'] = text;
          //   },
          //   isMobile: type == 'mobile' ? true : false,
          //   isNumber: type == 'number' ? true : false,
          // );
          children.add(SizedBox(
            height: 20,
          ));
          children.add(textField);
        } else if (type == 'select') {
          // for(var subMenu in MainController.SubMenuList){
          //   if(column['sourceItems'] != 'custom'){
          //     if(column['sourceTable'] == subMenu['table-name']){
          //       print('column[sourceTable]>>>${column['sourceTable']}');
          //       print('subMenu[columns]>>>${subMenu['columns']}');
          //       List<DataModel> dropDownListItems = await getRowTable(column['sourceTable']);
          //       for(var i=0;i<dropDownListItems.length;i++){
          //         items.add({'title': dropDownListItems[i].data['title'], 'value': dropDownListItems[i].id});
          //       }
          //     }
          //   }
          //   else{
          //     items = column['items'];
          //   }
          // }
          List<dynamic> items = await ViewController.itemsList(
              column);
          Map<String, dynamic> selectedItem = items.firstWhere(
              (element) => element['value'] == dataModel['${name}'],
              orElse: () => items.first);
          selectBox = await generateFormSelectBox(
              column,
              items,
              dataModel,
              '${selectedItem['item'] != null ? selectedItem['item'] : ''}',
              '${selectedItem['value'] != null ? selectedItem['value'] : '${selectedItem}'}');
             // var items = column['items'];
          // selectBox = SelectBox(
          //     name: 'option1',
          //     column: column,
          //     items: [
          //       for (var item in items)
          //         DropdownMenuItem(
          //             child: Txt(
          //               '${item['title']}',
          //               color: MainController.isLightMode.value == true
          //                   ? whiteColor
          //                   : primaryDark,
          //             ),
          //             value: item['title']),
          //     ],
          //     onChanged: (value) {
          //       print('selected item ${value}');
          //       for(var item in items){
          //         if(item['title'] == value){
          //           if(item['value'] == '-1'){
          //             value = null;
          //           }
          //         }
          //       }
          //       if(value != null){
          //         MainController.selectedItemList.value = value!.toString();
          //       }
          //       else{
          //         MainController.selectedItemList.value = '';
          //       }
          //       dataModel['${name}'] =
          //           MainController.selectedItemList.value;
          //       print('MainController.selectedItemList.value>>>${MainController.selectedItemList.value}');
          //     },
          //     hintText:
          //     '${dataModel['${name}'] != null ? dataModel['${name}'] : ''}',
          //     selectedValue: MainController.selectedItemList.value.obs);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(selectBox);
        } else if (type == 'checkbox') {
          checkBox = generateFormCheckBox(
              column, dataModel['${name}'], dataModel);
          // print('type checkBox');
          // print('dataModel.data[name]3>>>${dataModel['${name}']}');
          // checkBox = new CheckBox(checkBoxName: '${name}',checkBoxTitle: '${name}' ,defaultValue: dataModel['${name}'],onChange: (text) {
          //   dataModel['${name}'] = text;
          // },);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(checkBox);
        } else if (type == 'radiobutton') {
          radioButtonBox =
              generateFormRadioButton(column, dataModel, dataModel[name]);
          // var radioButtonItems = column['items'];
          // var selectedItem = radioButtonItems.firstWhere(
          //         (item) => item['title'] == dataModel[name],
          //     orElse: () => radioButtonItems.firstWhere(
          //           (item) => item['is_selected'] == true,
          //       orElse: () => radioButtonItems.first,));
          // radioButtonBox = new RadioButton(name: '',radioButtonItems: [
          //   for (var radioButtonItem in radioButtonItems)
          //     FormBuilderChipOption(
          //       value: '${radioButtonItem['title']}',
          //       child: Txt('${radioButtonItem['title']}' , color: MainController.isLightMode.value ? whiteColor : primaryDark,),
          //     ),
          // ],
          //   onChanged: (text){
          //     selectedRadioButton.value= text!;
          //     ViewController. selectedRadioButton.value = text;
          //     dataModel[name] = ViewController. selectedRadioButton.value;
          //   },
          //   initalValue:  dataModel[name],
          // );
          children.add(SizedBox(
            height: 20,
          ));
          children.add(radioButtonBox);
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
             column, dataModel, Jalali(year, month, day));
          // List<String>? dateParts;
          // int year=Jalali.now().year;
          // int month=Jalali.now().month;
          // int day=Jalali.now().day;
          // if(dataModel['${name}'] != null){
          //   dateParts = dataModel['${name}'].split('/');
          //   year = int.parse('${dateParts![0]}');
          //   month = int.parse('${dateParts[1]}');
          //   day = int.parse('${dateParts[2]}');
          // }
          // dateBox = new DateBox(
          //     selectedDate:Jalali(year,month,day) ,
          //     onDateChanged: (date){
          //       dataModel[name] =  date;
          //       // Jalali? picked = await showPersianDatePicker(
          //       //   context: Get.context!,
          //       //   initialDate: Jalali.now(),
          //       //   firstDate: Jalali(1385 , 8),
          //       //   lastDate: Jalali(1450 , 9),
          //       // );
          //       // if(picked != null){
          //       //   print('picked>>>${picked}');
          //       //   MainController.selectedDate!.value= picked;
          //       //   print('MainController.selectedDate!.value>>>${MainController.selectedDate!.value}');
          //       //   String date = '${MainController.selectedDate!.value.year.obs}${'/'}${MainController.selectedDate!.value.month.obs}${'/'}${MainController.selectedDate!.value.day.obs}';
          //       //   dataJson[name] =  date;
          //       // }
          //     });
          children.add(SizedBox(
            height: 20,
          ));
          children.add(dateBox);
        } else if (type == 'multiSelect') {
          var items = column['items'];
          List<String> titleList = [];
          for (var item in items) {
            titleList.add(item['title']);
          }
          List<String> dataModelList = [];
          if (dataModel['${name}'] != null) {
            dataModelList = dataModel['${name}'].split(', ');
          }
          String hint = '';
          List<String> hintLists = [];
          for (var data in dataModelList) {
            if (titleList.contains(data)) {
              if (dataModel[name] != null) {
                hint = data;
              } else {
                hint =
                    '${AppController.of(Get.context!)!.value('has been selected')}';
              }
            } else {
              hint = '';
            }
            if (hint != '') {
              hintLists.add(hint);
            }
          }
          String hintString = hintLists.join(', ');
          if (hintString == '') {
            hintString =
                '${AppController.of(Get.context!)!.value('has been selected')}';
          }
          multiSelectBox = await genarateFormMuiltiSelectBox(
             column, dataModel, '${hintString}');
          children.add(SizedBox(
            height: 20,
          ));
          children.add(multiSelectBox);
        } else if (type == 'color') {
          // if(dataModel[name] != null){
          //   ViewController.selectedColor = Color(int.parse('${dataModel[name]}'));
          // }
          colorBox = generateFormColorBox(
              column,
              dataModel,
              dataModel[name] != null
                  ? Color(int.parse('${dataModel[name]}'))
                  : Colors.blue);
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
          fileBox = generateFileBox(dataModel,
              '${dataModel[name] != null ? dataModel[name] : ''}', column);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(fileBox);
        }
      }
    }
    return Column(children: children);
  }

  static Future<Widget> generateDataColumn(
      int indexColumn, int indexRow) async {
    var size = MediaQuery.of(Get.context!).size;
    DataModel dataModel = MainController.tableData.value[indexRow];

    String type = MainController.tableInfo['columns'][indexColumn]['type'];
    String name = MainController.tableInfo['columns'][indexColumn]['name'];
    var child;
    if (type == 'checkbox') {
      print('row generate data cell:${dataModel.id}');
      print('type:${type}');
      print('name:${name}');
      print('index:${indexRow}');
      print('data:${dataModel.data['${name}']}');
      print('-------------------');
      child = generateCheckBox(indexColumn, indexRow);
    } else if (type == 'color') {
      child = generateColor(indexColumn, indexRow);
    } else if (type == 'select') {
      child = FutureBuilder<Widget>(
        future: generateSelectBox(indexColumn, indexRow),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Txt('${AppController.of(context)!.value('error')}: ${snapshot.error}');
          } else {
            return snapshot.data ?? Container();
          }
        },
      );
      // child = await generateSelectBox(indexColumn , indexRow);
    } else {
      child = generateData(indexColumn, indexRow);
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

  static Widget generateCheckBox(int indexColumn, int indexRow) {
    DataModel dataModel = MainController.tableData.value[indexRow];
    String name = MainController.tableInfo['columns'][indexColumn]['name'];
    if (dataModel.data['${name}'] == null) {
      dataModel.data['${name}'] = false;
    }
    return CheckBox(
      defaultValue: dataModel.data['${name}'],
      checkBoxTitle: '',
      onChange: (text) async {
        dataModel.data['${name}'] = text;
        final data = DataModel(
          id: dataModel.id,
          data: dataModel.data,
        );
        dataController.allData.value[indexRow] = data;
        await box.putAt(indexRow, data);
      },
      index: indexRow,
      column: MainController.tableInfo['columns'][indexColumn],
    );
  }

  static Widget generateColor(int indexColumn, int indexRow) {
    DataModel dataModel = MainController.tableData.value[indexRow];
    String name = MainController.tableInfo['columns'][indexColumn]['name'];
    return Center(
      child: dataModel.data['${name}'] != null
          ? Container(
              width: 50,
              height: 50,
              color: Color(int.parse('${dataModel.data['${name}']}')),
            )
          : Container(),
    );
  }

  static Future<Widget> generateSelectBox(int indexColumn, int indexRow) async {
    DataModel dataModel = MainController.tableData.value[indexRow];
    var column = MainController.tableInfo['columns'][indexColumn];
    String name = MainController.tableInfo['columns'][indexColumn]['name'];
    String tableName = '';
    // for (var subMenu in MainController.SubMenuList) {
      if (column['sourceItems'] != 'custom') {
        // if (column['sourceTable'] == subMenu['table-name']) {
          tableName = column['sourceTable'];
        // }
      }
    // }
    String titleSelect = await getTitleSelectedItem('${tableName}',
        dataModel.data['${name}'] , column);
    return Txt(
      '${titleSelect}',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: MainController.isLightMode.value == true ? whiteColor : color2,
      textAlign: TextAlign.center,
    );
  }

  static Widget generateData(int indexColumn, int indexRow) {
    DataModel dataModel = MainController.tableData.value[indexRow];
    String name = MainController.tableInfo['columns'][indexColumn]['name'];
    return Obx(() {
      return Center(
        child: Txt(
          '${dataModel.data['${name}'] != null ? dataModel.data['${name}'] : ''}',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: MainController.isLightMode.value == true ? whiteColor : color2,
          textAlign: TextAlign.center,
        ),
      );
    });
  }

  static Widget generateFormTextField(
      GlobalKey<FormBuilderState> _fbKey,
      var column,
      Map dataJson,
      var type,
      String initValue) {
    return new FormTextField(
      name: '${column['name']}',
      fbKey: _fbKey,
      hint: '${column['name']}',
      lable: '${column['name']}',
      column: column,
      initValue: initValue,
      onChange: (text) {
        // dataJson[columnName] = text;
        ViewController.request[column['name']] = text;
      },
      isMobile: type == 'mobile' ? true : false,
      isNumber: type == 'number' ? true : false,
      isEmail: type == 'email' ? true : false,
    );
  }

  static Future<Widget> generateFormSelectBox(var column,List<dynamic> items,
      Map dataJson, String hintText, String initailValue) async {
    // List<dynamic> items =[];
    // var selectedItem;
    // var initValue;
    // List<dynamic> items = await ViewController.itemsList(
    //     column, column['sourceItems'], column['sourceTable']);
    // for(var subMenu in MainController.SubMenuList){
    //   if(column['sourceItems'] != 'custom'){
    //     if(column['sourceTable'] == subMenu['table-name']){
    //       List<DataModel> dropDownListItems = await getRowTable(column['sourceTable']);
    //
    //       for(var i=0;i<dropDownListItems.length;i++){
    //         items.add({'title':dropDownListItems[i].data['${subMenu['columns'].first['name']}'], 'value': dropDownListItems[i].id});
    //       }
    //       if(ViewController.request == {}){
    //         initValue = items.length!=0 ? items[0]['value']:"";
    //       }
    //       else{
    //         initValue = initailValue;
    //       }
    //     }
    //   }
    //   else{
    //     items = column['items'];
    //     selectedItem = items.firstWhere(
    //           (item) => item['is_selected'] == true,
    //       orElse: () => items.first,);
    //     // initailValue = selectedItem['title'];
    //     if(dataJson == {}){
    //       initValue = selectedItem['value'];
    //     }
    //     else{
    //       initValue = initailValue;
    //     }
    //   }
    // }
    return items.length != 0
        ? new SelectBox(
            name: '${column['name']}',
            column: column,
            items: [
              for (var item in items)
                DropdownMenuItem(
                    child: Obx(() {
                      return Txt(
                        '${item['title']}',
                        color: MainController.isLightMode.value == true
                            ? whiteColor
                            : primaryDark,
                      );
                    }),
                    value: item['value']),
            ],
            initalValue: initailValue != null ? initailValue : '',
            onChanged: (value) async {
              print('selected item ${value}');
              for (var item in items) {
                if (item['title'] == value) {
                  if (item['value'] == '-1') {
                    value = null;
                  }
                }
              }
              ViewController.request[column['name']] = value;
            },
            hintText: hintText,
            selectedValue: '')
        : Container();
  }

  static Widget generateFormCheckBox(
       var column, var defaultValue, Map dataJson) {
    return new CheckBox(
      checkBoxName: '${column['name']}',
      checkBoxTitle: '${column['name']}',
      defaultValue: defaultValue,
      onChange: (text) {
        ViewController.request[column['name']] = text;
        // dataJson[columnName] = text;
      },
      column: column,
    );
  }

  static Widget generateFormRadioButton(
      var column, Map dataJson, String initalValue) {
    var radioButtonItems = column['items'];

    var selectedItem = radioButtonItems.firstWhere(
      (item) => item['is_selected'] == true,
      orElse: () => radioButtonItems.first,
    );

    return new RadioButton(
      name: '',
      radioButtonItems: [
        for (var radioButtonItem in radioButtonItems)
          FormBuilderChipOption(
              value: '${radioButtonItem['title']}',
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
        selectedRadioButton.value = text!;
        ViewController.request[column['name']] = text;
        // dataJson[columnName] = selectedRadioButton.value;
      },
      initalValue: initalValue,
      column: column,
    );
  }

  static Widget generateFormDateBox(
      var column, Map dataJson, Jalali selectedDate) {
    if (ViewController.request[column['name']] == null) {
      ViewController.request[column['name']] =
          '${selectedDate.year}${'/'}${selectedDate.month}${'/'}${selectedDate.day}';
    }
    return new DateBox(
      selectedDate: selectedDate,
      onDateChanged: (date) {
        // dataJson[columnName] =  date;
        ViewController.request[column['name']] = date;
      },
      column: column,
    );
  }

  static Future<Widget> genarateFormMuiltiSelectBox(
       var column, Map dataJson, String hintText) async {
    List<dynamic> items = [];
    items = column['items'];
    Map<String, List<String>> selectedItemsMap = {};
    if (selectedItemsMap['${column['name']}'] == null) {
      selectedItemsMap['${column['name']}'] = [];
    }
    List<dynamic> dataList;
    if (ViewController.request[column['name']] != null) {
      List<String> titleList = [];
      for (var item in items) {
        titleList.add(item['title']);
      }
      dataList = ViewController.request[column['name']]
          .split(', ')
          .map((item) => item.trim())
          .toList();
      dataList.removeWhere((selectedItem) => !titleList.contains(selectedItem));
      for (var data in dataList) {
        selectedItemsMap['${column['name']}']!.add(data);
      }
    }
    return items.length != 0
        ? new MultiSelectDropdown(
            selectedItemsMap: selectedItemsMap,
            items: [
              for (var item in items)
                // DropdownMenuItem(
                //   value: item['title'],
                //   child: Row(
                //     children: [
                //       SizedBox(
                //           width: 50,
                //           height: 50,
                //           child: Obx((){
                //             return Checkbox(
                //               activeColor: colorBtn,
                //               value: selectedItems.value.contains(item['title']),
                //               // defaultValue:MainController.isSelectedItem.value ,
                //               onChanged: (bool? text){
                //                 if(text == true){
                //                   if(!selectedItems.value.contains(item['title'])){
                //                     selectedItems.value.add(item['title']);
                //                   }
                //                 }
                //                 else{
                //                   selectedItems.value.remove(item['title']);
                //                 }
                //                 if(selectedItems.value.isEmpty){
                //                   MainController.hintText.value = "Select Options";
                //                 }
                //                 else{
                //                   MainController.hintText.value = '${selectedItems.value.join(', ')}';
                //                 }
                //                 dataJson[name] = selectedItems.value.join(', ');
                //               },
                //             );
                //           })
                //       ),
                //       SizedBox(width: 5),
                //       Txt(
                //         '${item['title']}',
                //         color: MainController.isLightMode.value ? whiteColor : primaryDark,
                //       ),
                //     ],
                //   ),
                // ),
                item['title']
            ],
            hintText: hintText,
            selectName: column['name'],
            onSelectChanged: (selectedItems) {
              // dataJson[columnName] = selectedItems.join(', ');
              ViewController.request[column['name']] = selectedItems.join(', ');
            },
            column: column,
          )
        : Container();
  }

  static Widget generateFormColorBox(
      var column, Map dataJson, Color selectedColor) {
    Color colorChanged;
    return new Container(
      child: ColorPickerBox(
        selectedColor: selectedColor,
        onChanged: (color) {
          colorChanged = color;
          String hexColor =
              '0x${colorChanged.value.toRadixString(16).padLeft(8, '0')}';
          // dataJson[columnName] = hexColor;
          ViewController.request[column['name']] = hexColor;
        },
        column: column,
      ),
    );
  }

  static Widget generateFileBox(
       Map dataJson, String selecetdFiles, var column) {
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
    return new FormFile(
      columnName: column['name'],
      onChanged: (selecetdFiles) {
        // dataJson[columnName] = selecetdFiles;
        ViewController.request[column['name']] = selecetdFiles;
      },
      filesSelected: selectedFilesMap,
      selectedFilesTxt: selecetdFiles,
      column: column,
    );
  }

  // static Future<List<dynamic>>  getInfoTable(String tableName) async{
  //   List<dynamic> rowList=[];
  //   List<dynamic> tableData = [];
  //   Box box2;
  //   box2 = await Hive.openBox<DataModel>('${tableName}');
  //   tableData = box2.values.toList();
  //   for(var row in tableData){
  //     rowList.add(row.data);
  //   }
  //   for(var row in tableData){
  //     print('ffff67>>>${row.id}');
  //   }
  //   print('rowList>>>${rowList}');
  //   return rowList;
  //
  // }
  static Future<List<DataModel>> getRowTable(String tableName) async {
    List<DataModel> rowList = [];
    List<dynamic> tableData = [];
    Box box2;
    box2 = await Hive.openBox<DataModel>('${tableName}');
    tableData = box2.values.toList();
    for (var row in tableData) {
      var dataRow = new DataModel(id: row.id, data: row.data);
      rowList.add(dataRow);
    }
    return rowList;
  }

  static Future<String> getTitleSelectedItem(String tableName,
      String selectedId, var column) async {
    String selectedTitle = '';
    var sourceItem =column['sourceItems'];
    if (sourceItem != 'custom') {
      List<DataModel> objectItem = await getRowTable(tableName);
      DataModel objectTitleSelected = objectItem.firstWhere(
          (element) => element.id == selectedId,
          orElse: () => DataModel(
              id: 'not_found', data: {'error': '${AppController.of(Get.context!)!.value('The corresponding item has been deleted')}'}));
      selectedTitle = objectTitleSelected.data.values.first;
    } else {
      Map<String, dynamic> selectedItem = column['items'].firstWhere(
          (element) => element['value'] == selectedId,
          orElse: () => {'error': '${AppController.of(Get.context!)!.value('The corresponding item has been deleted')}'});
      if (selectedItem['title'] != null) {
        selectedTitle = selectedItem['title'];
      } else {
        selectedTitle = selectedItem['error'];
      }
    }
    return selectedTitle;
  }

  static Future<List> itemsList(var column) async {
    List<dynamic> items = [];
    var type=column['sourceItems'];
    var tableName=column['sourceTable'];
    if (type != 'custom') {
      List<DataModel> dropDownListItems =
      await getRowTable(tableName);
      //list column ye table ro az json begire
      List columnList = getColumnList(tableName);
      for (var i = 0; i < dropDownListItems.length; i++) {
        print('id data:${dropDownListItems[i].id}');
        items.add({
          'title': dropDownListItems[i]
              .data[columnList.first['name']],
          'value': dropDownListItems[i].id
        });
      }
    } else {
      items = column['items'];
    }
    return items;
  }

  //dehdar edit
  static Future<String> getInitValue(
      var column, List<dynamic> items) async {
      String initValue = '';
      var type=column['sourceItems'];
      var tableName=column['sourceTable'];
      var selectedItem;
    // List<dynamic> items = await itemsList(column, type, tableName);
    // for (var subMenu in MainController.SubMenuList) {
      if (type != 'custom') {
        // if (tableName == subMenu['table-name']) {
          initValue = items.length != 0 ? items[0]['value'] : "";
        // }
      } else {
        selectedItem = items.firstWhere(
          (item) => item['is_selected'] == true,
          orElse: () => items.first,
        );
        initValue = selectedItem['value'];
      }
    // }
    return initValue;
  }

  static List<dynamic> getColumnList(String tableName){
    List<dynamic> columns=[];
    for(var table in MainController.SubMenuList){
      if(table['table-name'] == tableName){
        columns= table['columns'];
      }
    }
    return columns;
  }
}
