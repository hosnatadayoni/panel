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
  static Rx<bool> isClickedBtn = false.obs;
  static Rx<bool> isClickedEditBtn = false.obs;
  static Map<String, List<int>> fileSizeList = {};
  static Map<String, dynamic> request = {};
  static Map<String, dynamic> request2 = {};

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
        String name = column['title'];
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
        if (type == 'string' || type == 'int' || type == 'number'|| type == 'email' ||  type == 'mobile') {
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
          print('items 200>>>${items}');
          selectBox = await generateFormSelectBox(
               column,items, dataJson, '', '${initValue}' , false.obs);
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
          var initValue;
          List<dynamic> items = await itemsList(column);
          initValue = await getInitValue(
              column,items);
          // var radioButtonItems = column['items'];
          // var selectedItem = radioButtonItems.firstWhere(
          //   (item) => item['is_selected'] == true,
          //   orElse: () => radioButtonItems.first,
          // );
          radioButtonBox = generateFormRadioButton(
               column,items, dataJson, '${initValue}' , false.obs);
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
          List<dynamic> items = await itemsList(column);
          if(items.length != 0){
            multiSelectBox = await genarateFormMuiltiSelectBox(
                column,
                items,
                dataJson,RxString('${items[0]['title']}'),<String>[].obs ,false.obs);

            children.add(SizedBox(
              height: 20,
            ));
            children.add(multiSelectBox);
          }

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: children);
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
            type == 'number' ||
            type == 'email' || type == 'mobile') {
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
        }
        else if (type == 'select') {
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
          if(items.length != 0){
           //  if(dataModel['${name}'] == 'آیتم مربوطه یافت نشد'){
           //   dataModel['${name}'] = '';
           // }
            Map<String, dynamic> selectedItem = items.firstWhere(
                    (element) => element['value'] == dataModel['${name}'],
                orElse: () => items.first);
            if(selectedItem['value'] != dataModel[name]){
              dataModel[name] = '';
            }
            selectBox = await generateFormSelectBox(
                column,
                items,
                dataModel,
                '${selectedItem['item'] != null ? selectedItem['item'] : ''}',
                '${selectedItem['value'] != null ? selectedItem['value'] : '${selectedItem}'}',
                dataModel[name] == '' ? false.obs : true.obs
            );
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
          }

        }
        else if (type == 'checkbox') {
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
        }
        else if (type == 'radiobutton') {
          List<dynamic> items = await itemsList(column);

         if(items.length != 0){
           // if(dataModel['${name}'] == 'آیتم مربوطه یافت نشد'){
           //   dataModel['${name}'] = '';
           // }
           Map<String, dynamic> selectedRadioButton = items.firstWhere(
                   (element) => element['value'] == dataModel['${name}'],
               orElse: () => items.first);
           if(dataModel[name] != selectedRadioButton['value']){
             dataModel[name] = '';
           }
           radioButtonBox =
               generateFormRadioButton(column,items, dataModel, selectedRadioButton['value'] , dataModel[name] == '' ? false.obs : true.obs);
           children.add(SizedBox(
             height: 20,
           ));
           children.add(radioButtonBox);
         }

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

        }
        else if (type == 'date') {
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
        }
        else if (type == 'multiSelect') {
          // var items = column['items'];
          // List<String> titleList = [];
          // for (var item in items) {
          //   titleList.add(item['title']);
          // }
          // List<String> dataModelList = [];
          // if (dataModel['${name}'] != null) {
          //   dataModelList = dataModel['${name}'].split(', ');
          // }
          // String hint = '';
          // List<String> hintLists = [];
          // for (var data in dataModelList) {
          //   if (titleList.contains(data)) {
          //     if (dataModel[name] != null) {
          //       hint = data;
          //     } else {
          //       hint =
          //           '${AppController.of(Get.context!)!.value('has been selected')}';
          //     }
          //   } else {
          //     hint = '';
          //   }
          //   if (hint != '') {
          //     hintLists.add(hint);
          //   }
          // }
          // String hintString = hintLists.join(', ');
          // if (hintString == '') {
          //   hintString =
          //       '${AppController.of(Get.context!)!.value('has been selected')}';
          // }
          List<dynamic> items = await ViewController.itemsList(
              column);
          if(items.length != 0){
            List<String> multiSelectedItemList = [];
            if(dataModel['${name}'] != null){
              for (var id in dataModel['${name}']) {
                var selectedItem = items.firstWhere(
                      (element) => element['value'] == id,
                  orElse: () => null,
                );
                if(selectedItem != null){
                  multiSelectedItemList.add(selectedItem['title']);
                }
                // else {
                //   if(dataModel['${name}'].length == 1){
                //     dataModel['${name}'] = <String>[];
                //   }
                //
                // }



                // var selectedItem = items.firstWhere(
                //       (element) => element['value'] == id,
                //   orElse: () => null,
                // );
                // print('selected item title>>>${selectedItem['title']}');
              }
            }
            // if(dataModel['${name}'].length == 1 && dataModel['${name}'].contains('آیتم مربوطه یافت نشد')){
            //   dataModel['${name}'] = <String>[];
            // }
            multiSelectBox = await genarateFormMuiltiSelectBox(
                column, items, dataModel,multiSelectedItemList.length != 0 ? RxString(multiSelectedItemList.join(',')):RxString('${items[0]['title']}'),dataModel['${name}'] != null ? RxList(dataModel['${name}']):<String>[].obs,false.obs);

            children.add(SizedBox(
              height: 20,
            ));
            children.add(multiSelectBox);
          }

        }
        else if (type == 'color') {
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
        }
        else if (type == 'file') {
          print('dataModel[name] file box>>>${dataModel[name]} ${dataModel[name].runtimeType}');
          fileBox = generateFileBox(dataModel,
              '${dataModel[name] != null ? dataModel[name] : []}', column);
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
      int indexColumn, int indexRow , {var table}) async {
    var size = MediaQuery.of(Get.context!).size;
    String name='';
    name = MainController.tableInfo['columns'][indexColumn]['name'];
    print('MainController.tableData.value[indexRow]>>>${MainController.tableData.value[indexRow]}');
    // print('MainController.tableData.value[indexRow]2>>>${MainController.tableData.value[indexRow]['${name}']} ${name} ${MainController.tableData.value[indexRow].runtimeType}');
    // DataModel dataModel = MainController.tableData.value[indexRow];
    var dataModel = MainController.tableData.value[indexRow]['${name}'];
    // print('dataModel.id 2>>>${dataModel.id}');
    print('dataModel>>>${dataModel} ${dataModel.runtimeType}');

    String type='';
    if(table == null){
       type = MainController.tableInfo['columns'][indexColumn]['type'];
       name = MainController.tableInfo['columns'][indexColumn]['name'];
    }
    else{
      type = table['columns'][indexColumn]['type'];
      name = table['columns'][indexColumn]['name'];
    }

    var child;
    if (type == 'checkbox') {
      // print('row generate data cell:${dataModel.id}');
      print('type:${type}');
      print('name:${name}');
      print('index:${indexRow}');
      // print('data:${dataModel.data['${name}']}');
      print('-------------------');
      child = generateCheckBox(indexColumn, indexRow , tableData: table);
    } else if (type == 'color') {
      child = generateColor(indexColumn, indexRow , tableData: table);
    } else if (type == 'select' || type == 'radiobutton') {
      child = FutureBuilder<Widget>(
        future: generateSelectBox(indexColumn, indexRow , tableData: table),
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
    }
    else if(type == 'multiSelect'){
      child = FutureBuilder<Widget>(
        future: generateMultiSelectBox(indexColumn, indexRow , tableData: table),
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
    }
    else if(type =='file'){
      child = generateCellFileBox(indexColumn, indexRow , tableData: table);
    }
    else {
      child = generateData(indexColumn, indexRow , tableData: table );
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

  static Widget generateCheckBox(int indexColumn, int indexRow , {var tableData}) {
    // DataModel dataModel = MainController.tableData.value[indexRow];
    String name='';
    if(tableData == null){
       name = MainController.tableInfo['columns'][indexColumn]['name'];
    }
    else{
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
        MainController.tableData.value[indexRow]['${name}'] = dataModel;
        final data = DataModel(
          id: MainController.tableData.value[indexRow]['id'],
          data: MainController.tableData.value[indexRow],
        );
        dataController.allData.value[indexRow] = data;
        await box.putAt(indexRow, data);
      },
      index: indexRow,
      column: tableData == null ? MainController.tableInfo['columns'][indexColumn]:tableData['columns'][indexColumn],
    );
  }

  static Widget generateColor(int indexColumn, int indexRow , {var tableData}) {
    // DataModel dataModel = MainController.tableData.value[indexRow];
    String name;
    if(tableData == null){
       name = MainController.tableInfo['columns'][indexColumn]['name'];
    }
    else{
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

  static Future<Widget> generateSelectBox(int indexColumn, int indexRow , {var tableData}) async {
    // DataModel dataModel = MainController.tableData.value[indexRow];
    var column;
    String name;
    if(tableData == null){
       column = MainController.tableInfo['columns'][indexColumn];
       name = MainController.tableInfo['columns'][indexColumn]['name'];
    }
    else{
      column = tableData['columns'][indexColumn];
      name = tableData['columns'][indexColumn]['name'];
    }
    var dataModel = MainController.tableData.value[indexRow]['${name}'];

    String tableName = '';
      if (column['sourceItems'] != 'custom') {
          tableName = column['sourceTable'];

      }

    String titleSelect='';
    if(dataModel != null){
      titleSelect = await getTitleSelectedItem('${tableName}',
          dataModel , column);
    }

    return Txt(
      '${titleSelect}',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: MainController.isLightMode.value == true ? whiteColor : color2,
      textAlign: TextAlign.center,
    );
  }

  static Future<Widget> generateMultiSelectBox(int indexColumn, int indexRow ,{var tableData}) async {
    // DataModel dataModel = MainController.tableData.value[indexRow];
    var column;
    String name;
    if(tableData == null){
       column = MainController.tableInfo['columns'][indexColumn];
       name = MainController.tableInfo['columns'][indexColumn]['name'];
    }
    else{
      column = tableData['columns'][indexColumn];
      name = tableData['columns'][indexColumn]['name'];
    }
    var dataModel = MainController.tableData.value[indexRow]['${name}'];

    String tableName = '';
    // for (var subMenu in MainController.SubMenuList) {
    if (column['sourceItems'] != 'custom') {
      // if (column['sourceTable'] == subMenu['table-name']) {
      tableName = column['sourceTable'];
      // }
    }
    // }
    List<String> titleMultiSelectList=[];
    if(dataModel != null){
    titleMultiSelectList = await getTitleMultiSelectedItem('${tableName}',
          dataModel , column);
    }

    return Txt(
      '${titleMultiSelectList.join(',')}',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: MainController.isLightMode.value == true ? whiteColor : color2,
      textAlign: TextAlign.center,
    );
  }

  static Widget generateCellFileBox(int indexColumn, int indexRow , {var tableData}){
    // DataModel dataModel = MainController.tableData.value[indexRow];
    String name;
    if(tableData == null){
       name = MainController.tableInfo['columns'][indexColumn]['name'];
    }
    else{
      name = tableData['columns'][indexColumn]['name'];
    }
    var dataModel = MainController.tableData.value[indexRow]['${name}'];

    return Obx(() {
      return Center(
        child: Txt(
          '${dataModel != null ? dataModel.length != 0 ? dataModel : '':''}',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: MainController.isLightMode.value == true ? whiteColor : color2,
          textAlign: TextAlign.center,
        ),
      );
    });

  }

  static Widget generateData(int indexColumn, int indexRow , {var tableData}) {
    // DataModel dataModel = MainController.tableData.value[indexRow];


    String name;
    if(tableData == null){
       name = MainController.tableInfo['columns'][indexColumn]['name'];
    }
    else{
      name = tableData['columns'][indexColumn]['name'];
    }
    var dataModel = MainController.tableData.value[indexRow]['${name}'];

    return Obx(() {
      return Center(
        child: Txt(
          '${dataModel != null ?  dataModel : ''}',
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
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt('${column['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
        }),
        SizedBox(height: 10,),
        FormTextField(
          name: '${column['title']}',
          fbKey: _fbKey,
          hint: '${column['title']}',
          lable: '',
          column: column,
          initValue: initValue,
          onChange: (text) {
            // dataJson[columnName] = text;
            ViewController.request[column['name']] = text;
          },
          isMobile: type == 'mobile' ? true : false,
          isNumber: type == 'number' ? true : false,
          isEmail: type == 'email' ? true : false,

        ),
      ],
    );
  }

  static Future<Widget> generateFormSelectBox(var column,List<dynamic> items,
      Map dataJson, String hintText, String initailValue , Rx<bool> isSeleted) async {
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
        ? new Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Obx(() {
             return Txt('${column['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
           }),
           SizedBox(height: 10,),
           SelectBox(
               name: '${column['title']}',
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
               initalValue: initailValue != '' ? initailValue : '',
               onChanged: (value) async {
                 print('selected item ${value}');
                 for (var item in items) {
                   if (item['title'] == value) {
                     if (item['value'] == '-1') {
                       value = null;
                     }
                   }
                 }
                 if(value != '-1'){
                   ViewController.request[column['name']] = value;
                 }
                 else{
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

  static Widget generateFormCheckBox(
       var column, var defaultValue, Map dataJson) {
    return new CheckBox(
      checkBoxName: '${column['title']}',
      checkBoxTitle: '${column['title']}',
      defaultValue: defaultValue,
      onChange: (text) {
        ViewController.request[column['name']] = text;
        // dataJson[columnName] = text;
      },
      column: column,
    );
  }

  static Widget generateFormRadioButton(
      var column , List<dynamic> items, Map dataJson, String initalValue , Rx<bool> isSelectedItem) {
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
          return Txt('${column['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
        }),
        SizedBox(height: 10,),
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

  static Widget generateFormDateBox(
      var column, Map dataJson, Jalali selectedDate) {
    // if (ViewController.request[column['name']] == null) {
    //   ViewController.request[column['name']] =
    //       '${selectedDate.year}${'/'}${selectedDate.month}${'/'}${selectedDate.day}';
    // }
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt('${column['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
        }),
        SizedBox(height: 10,),
        DateBox(
          selectedDate: selectedDate,
          onDateChanged: (date) {
            // dataJson[columnName] =  date;
            ViewController.request[column['name']] = date;
          },
          column: column,
        ),
      ],
    );
  }

  static Future<Widget> genarateFormMuiltiSelectBox(
       var column,List<dynamic> items, Map dataJson , Rx<String> hintTxt , RxList<String> selectedItemsList , Rx<bool> isSelectedItem) async {

    return items.length != 0
        ? new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return Txt('${column['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
          }),
        Obx(() {
          return MultiSelectDropdown(
            items: [
              for (var item in items)
                DropdownMenuItem(
                    value: item['value'],
                    child: Obx((){
                      return Row(
                        children: [
                          Container(
                            height: 100,
                            child: SizedBox(
                                width: 50,
                                height: 50,
                                child:Obx((){
                                  return Checkbox(
                                    activeColor: colorBtn,
                                    value: selectedItemsList.contains(item['value']),
                                    onChanged: (isChecked) {
                                      if (isChecked != null) {
                                        if (!selectedItemsList.contains(item['value'])) {
                                          selectedItemsList.add(item['value']);
                                        } else {
                                          selectedItemsList.remove(item['value']);
                                        }
                                        if(item['value'] == '-1'){
                                          selectedItemsList.value.remove(item['value']);
                                        }
                                        if(selectedItemsList.value.length == 0){
                                          isSelectedItem.value = false;
                                        }
                                        else{
                                          isSelectedItem.value = true;
                                        }
                                        print('isSelectedItem.value clcick check box>>>${isSelectedItem.value}');
                                        print('selectedItemsList.value.length clcick check box>>>${selectedItemsList.value.length}');

                                        hintTxt.value = hintMultiSelectBox(items, selectedItemsList.value);
                                        ViewController.request[column['name']] = selectedItemsList.value;
                                      }
                                    },
                                  );
                                })
                            ),
                          ),
                          Txt(item['title'], color: MainController.isLightMode.value ? whiteColor : primaryDark),
                        ],
                      );
                    })
                )
            ],
            hintText: hintTxt.value != '' ? hintTxt.value:items[0]['title'],
            selectedItems: selectedItemsList,
            isSelectedItem:isSelectedItem ,
            onChanged: (selectedList){
              selectedItemsList.value = selectedList;
              hintTxt.value = hintMultiSelectBox(items , selectedItemsList.value);
              ViewController.request[column['name']] = selectedItemsList.value;
            },
            column: column,
          );
        }),
      ],
    )
        : Container();
  }

  static Widget generateFormColorBox(
      var column, Map dataJson, Color selectedColor) {
    Color colorChanged;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt('${column['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
        }),
        SizedBox(height: 10,),
        Container(
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
        ),
      ],
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
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt('${column['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
        }),
        SizedBox(height: 10,),
        FormFile(
          columnName: column['title'],
          onChanged: (selecetdFiles) {
            // dataJson[columnName] = selecetdFiles;
            ViewController.request[column['name']] = selecetdFiles;
          },
          filesSelected: selectedFilesMap,
          selectedFilesTxt: selecetdFiles,
          column: column,
        ),
      ],
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

      if(selectedId != ''){
        DataModel objectTitleSelected = objectItem.firstWhere(
                (element) => element.id == selectedId,
            orElse: () => DataModel(
                id: 'not_found', data: {'error': ''}));
        selectedTitle = objectTitleSelected.id.toString();
      }
      else{
        selectedTitle = '';
      }

    } else {
      if(selectedId != ''){
        Map<String, dynamic> selectedItem = column['items'].firstWhere(
                (element) => element['value'] == selectedId,
            orElse: () => {'error': ''});
        if (selectedItem['title'] != null) {
          selectedTitle = selectedItem['title'];
        } else {
          selectedTitle = selectedItem['error'];
        }
      }
      else{
        selectedTitle = '';
      }

    }
    return selectedTitle;
  }

  static Future<List<String>> getTitleMultiSelectedItem(String tableName,
      List<String> selectedId, var column) async {
    List<String> multiSelectedTitleList = [];
    var sourceItem =column['sourceItems'];
    print('selectedId.length>>>${selectedId}');
    for(var i =0;i<selectedId.length;i++) {
      if (sourceItem != 'custom') {
        List<DataModel> objectItem = await getRowTable(tableName);

        // DataModel objectTitleSelected = objectItem.firstWhere(
        //         (element) => element.id == selectedId[i],
        //     orElse: () =>
        //         DataModel(
        //             id: 'not_found',
        //             data: {
        //               'error': '${AppController.of(Get.context!)!.value(
        //                   'The corresponding item has been deleted')}'
        //             }));
        DataModel objectTitleSelected = objectItem.firstWhere(
                (element) => element.id == selectedId[i],
            orElse: () =>
                DataModel(
                    id: 'not_found',
                    data: {
                      'error': ''
                    }));
        if(objectTitleSelected.data.values.first != ''){
          multiSelectedTitleList.add(objectTitleSelected.data.values.first);
        }

      }
      else {
        // Map<String, dynamic> selectedItem = column['items'].firstWhere(
        //         (element) => element['value'] == selectedId[i],
        //     orElse: () => {
        //       'error': '${AppController.of(Get.context!)!.value(
        //           'The corresponding item has been deleted')}'
        //     });
        Map<String, dynamic> selectedItem = column['items'].firstWhere(
                (element) => element['value'] == selectedId[i],
            orElse: () => {
              'error': ''
            });
        if (selectedItem['title'] != null) {
          multiSelectedTitleList.add(selectedItem['title']);
          // selectedTitleList = selectedItem['title'];
        }
        // else {
        //   multiSelectedTitleList.add(selectedItem['error']);
        //   // selectedTitleList = selectedItem['error'];
        // }
      }
    }
    return multiSelectedTitleList;
  }

  static Future<List> itemsList(var column) async {
    List<dynamic> items = [];
    var type=column['sourceItems'];
    var tableName=column['sourceTable'];
    print('column excel>>>${column}');
    print('tableName>>>${tableName}');
    if (type != 'custom') {
      List<DataModel> dropDownListItems =
      await getRowTable(tableName);
      //list column ye table ro az json begire
      List columnList = getColumnList(tableName);
      for (var i = 0; i < dropDownListItems.length; i++) {
        print('id data:${dropDownListItems[i].id}');
        items.add({
          'title': dropDownListItems[i].data[columnList.first['name']],
          'value': dropDownListItems[i].id
        });

      }
    }
    else {
      items = column['items'];
    }
    return items;
  }

  static Future<String> getInitValue(
      var column, List<dynamic> items) async {
      String initValue = '';
      var type=column['sourceItems'];
      var selectedItem;
    // List<dynamic> items = await itemsList(column, type, tableName);
    // for (var subMenu in MainController.SubMenuList) {
      if (type != 'custom') {
          initValue = items.length != 0 ? items[0]['value'] : "";
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

  // static String hintMultiSelectBox(List<dynamic> items , List<dynamic> ListsId){
  //   String hint='';
  //   Map<String, dynamic> selectedItem={};
  //   for(var i=0;i<ListsId.length;i++){
  //     selectedItem  = items.firstWhere(
  //             (element) => element['value'] == ListsId[i],
  //         orElse: () => items.first);
  //      hint =selectedItem['title'];
  //
  //
  //   }
  //
  //
  //
  //   return hint;
  // }
  static String hintMultiSelectBox(List<dynamic> items, List<dynamic> ListsId) {
    List<String> titles = [];
    for (var id in ListsId) {
      var selectedItem = items.firstWhere(
            (element) => element['value'] == id,
        orElse: () =>  null
      );
      if (selectedItem != null) {
        titles.add(selectedItem['title']);
      }
    }
    return titles.join(',');
  }

  static getBox(String tableName) async {
    Box box;
    box = await Hive.openBox<DataModel>('${tableName}');
    return box;
  }

}
