import 'package:file_picker/file_picker.dart';
import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
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
  static Rx<bool> isShowMessage=false.obs;
  static Map<String , List<int>> fileSizeList={};


  static Widget generateStoreFormView(Map dataJson) {

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
        if(column['validators'] != null){
          maxValidator = column['validators'].firstWhere((validator) => validator['type'] == 'max', orElse: () => null);
          minValidator = column['validators'].firstWhere((validator) => validator['type'] == 'min', orElse: () => null);
        }
        if (type == 'string' || type == 'int' || type == 'number') {
          textField = generateFormTextField(name , _fbKey , column , dataJson , type , '');
          children.add(SizedBox(
            height: 20,
          ));
          children.add(textField);
        }
        if (type == 'select') {
          var items;
          var selectedItem;
          var initailValue;
          for(var subMenu in MainController.SubMenuList){
            if(column['sourceItems'] != 'custom'){
              if(column['sourceTable'] == subMenu['table-name']){
                items = [];
                print('d44>>>>${subMenu['columns']}');
                for(var i = 0;i<subMenu['columns'].length;i++){
                  for(var j=0;j<MainController.tableData.value.length;j++){
                    print('k89>>>${MainController.tableData.value[j].data['${subMenu['columns'][i]}']}');
                    print('ssss78>>>${MainController.tableData.value[j].data['${subMenu['columns'][i]}']}');

                    // items =  subMenu['columns'][i];
                    items.add({'title': subMenu['columns'][i]['name'] , 'value': i});
                    print('g4>>>${subMenu['columns'][i]}');
                  }

                }
                print('items 4>>>${items}');
                print('items.first>>>${items.first}');
                initailValue = items.first['title'];
              }


            }
            else{
              items = column['items'];
              print('c1>>>${items}');
              print('c2>>>${column['items']}');
              selectedItem = items.firstWhere(
                    (item) => item['is_selected'] == true,
                orElse: () => items.first,);
              initailValue = selectedItem['title'];
            }
          }
          selectBox = generateFormSelectBox(name, column , dataJson , '', '${initailValue}');
          children.add(SizedBox(
            height: 20,
          ));
          children.add(selectBox);
        }
        else if(type == 'checkbox'){
          checkBox = generateFormCheckBox(name ,column, defaultValue , dataJson);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(checkBox);
        }
        else if(type == 'radiobutton'){
          var radioButtonItems = column['items'];
          var selectedItem = radioButtonItems.firstWhere(
                (item) => item['is_selected'] == true,
            orElse: () => radioButtonItems.first,);
          radioButtonBox = generateFormRadioButton(name , column , dataJson , selectedItem['title']);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(radioButtonBox);
        }
        else if(type == 'date'){
          dateBox = generateFormDateBox(name ,  column , dataJson , Jalali.now());
          children.add(SizedBox(
            height: 20,
          ));
          children.add(dateBox);
        }
        else if(type == 'multiSelect'){
          multiSelectBox = genarateFormMuiltiSelectBox(name , column ,  dataJson , '${AppController.of(Get.context!)!.value('has been selected')}');
          children.add(SizedBox(
            height: 20,
          ));
          children.add(multiSelectBox);
        }
        else if(type == 'color'){
          colorBox = generateFormColorBox(name ,column,  dataJson , Colors.blue);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(colorBox);
        }
        else if(type == 'file'){
          fileBox=generateFileBox(name , dataJson , '' , column);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(fileBox);


        }
      }
    }
    return Column(children: children);
  }

  static Widget generateEditFormView(Map dataModel) {
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
        // var defaultValue = column['default_value'];
        // GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
        var maxValidator;
        var minValidator;

        if(column['validators'] != null){
          maxValidator = column['validators'].firstWhere((validator) => validator['type'] == 'max', orElse: () => null);
          minValidator = column['validators'].firstWhere((validator) => validator['type'] == 'min', orElse: () => null);
        }
        if (type == 'string' || type == 'int' || type == 'number' || type == 'email') {
          print('dataModel>>>${dataModel}');
          GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
          textField = generateFormTextField(name , _fbKey , column , dataModel , type , '${dataModel['${name}'] != null ? dataModel['${name}'] : ''}');
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
          selectBox = generateFormSelectBox(name , column , dataModel , '${dataModel['${name}'] != null ? dataModel['${name}'] : ''}' , '${dataModel['${name}'] != null ? dataModel['${name}'] : ''}');
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
        else if(type == 'checkbox'){
          checkBox = generateFormCheckBox(name , column , dataModel['${name}'] , dataModel);
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
        else if(type == 'radiobutton'){
          radioButtonBox = generateFormRadioButton(name , column , dataModel , dataModel[name]);
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


        }
        else if(type == 'date'){
          List<String>? dateParts;
          int year=Jalali.now().year;
          int month=Jalali.now().month;
          int day=Jalali.now().day;
          if(dataModel['${name}'] != null){
            dateParts = dataModel['${name}'].split('/');
            year = int.parse('${dateParts![0]}');
            month = int.parse('${dateParts[1]}');
            day = int.parse('${dateParts[2]}');
          }
          dateBox = generateFormDateBox(name ,  column , dataModel , Jalali(year,month,day));
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
        // else if(type == 'date'){
        //   List<String> dateParts = dataModel.data['${name}'].split('/');
        //   RxInt year = int.parse('${dateParts[0]}').obs;
        //   RxInt month = int.parse('${dateParts[1]}').obs;
        //   RxInt day = int.parse('${dateParts[2]}').obs;
        //   List<String> dateUpdate = [];
        //   String? date;
        //
        //   dateBox = Obx((){
        //     return new DateBox(onTap: ()async{
        //       print('MainController.selectedDate!.value>>>${MainController.selectedDate!.value}');
        //       print('dataModel.data[name]5>>>${dataModel.data['${name}']}');
        //       Jalali? picked = await showPersianDatePicker(
        //         context: Get.context!,
        //         initialDate:  Jalali(year.value , month.value , day.value),
        //         firstDate: Jalali(1385 , 8),
        //         lastDate: Jalali(1450 , 9),
        //       );
        //       if(picked != null){
        //         MainController.selectedDate!.value= picked;
        //         date = '${MainController.selectedDate!.value.year}${'/'}${MainController.selectedDate!.value.month}${'/'}${MainController.selectedDate!.value.day}';
        //         dateUpdate = date!.split('/');
        //         dataModel.data['${name}'] =  date;
        //       }
        //
        //     },selectedDate: '${MainController.selectedDate!.value == Jalali.now() ?  dataModel.data['${name}'] : date}');
        //   });
        //   children.add(SizedBox(
        //     height: 20,
        //   ));
        //   children.add(dateBox);
        // }
        // else if(type == 'multiSelect'){
        //   var items = column['items'];
        //
        //   RxList<String> selectedItems = <String>[].obs;
        //   List<dynamic>? titles;
        //   if(dataModel.data['${name}'] != null){
        //     titles= dataModel.data['${name}'].split(',').map((title) => title.trim()).toList();
        //     for(String title in titles!){
        //       selectedItems.add(title);
        //     }
        //     // MainController.hintText.value = '${dataModel.data['${name}']}';
        //   }
        //   else{
        //     // MainController.hintText.value = 'Select Options';
        //   }
        //   multiSelectBox = MultiSelectDropdown(
        //     items: [
        //       for (var item in items)
        //         DropdownMenuItem(
        //           value: item['title'],
        //           child: Row(
        //             children: [
        //               SizedBox(
        //                   width: 50,
        //                   height: 50,
        //                   child: Obx((){
        //                     return Checkbox(
        //                       activeColor: colorBtn,
        //                       value: selectedItems.value.contains(item['title']),
        //                       // defaultValue:MainController.isSelectedItem.value ,
        //                       onChanged: (bool? text){
        //                         if(text == true){
        //                           if(!selectedItems.value.contains(item['title'])){
        //                             selectedItems.value.add(item['title']);
        //                           }
        //                         }
        //                         else{
        //                           selectedItems.value.remove(item['title']);
        //                         }
        //                         if(selectedItems.value.isEmpty){
        //                           MainController.hintText.value = "Select Options";
        //                         }
        //                         else{
        //                           MainController.hintText.value = '${selectedItems.value}';
        //                         }
        //                         dataModel.data['${name}'] = selectedItems.value.join(', ');
        //                       },
        //                     );
        //                   })
        //               ),
        //               SizedBox(width: 5),
        //               Txt(
        //                 '${item['title']}',
        //                 color: MainController.isLightMode.value ? whiteColor : primaryDark,
        //               ),
        //             ],
        //           ),
        //         ),
        //     ],
        //   );
        //   children.add(SizedBox(
        //     height: 20,
        //   ));
        //   children.add(multiSelectBox);
        // }
        else if(type == 'multiSelect'){
          var items = column['items'];

          multiSelectBox = genarateFormMuiltiSelectBox(name , column ,  dataModel, '${dataModel[name] != null ? dataModel[name]:'${AppController.of(Get.context!)!.value('has been selected')}'}');
          // multiSelectBox = MultiSelectDropdown(
          //   selectedItemsMap: selectedItemsMap,
          //   items: [
          //     for (var item in items)
          //     // DropdownMenuItem(
          //     //   value: item['title'],
          //     //   child: Row(
          //     //     children: [
          //     //       SizedBox(
          //     //           width: 50,
          //     //           height: 50,
          //     //           child: Obx((){
          //     //             return Checkbox(
          //     //               activeColor: colorBtn,
          //     //               value: selectedItems.value.contains(item['title']),
          //     //               // defaultValue:MainController.isSelectedItem.value ,
          //     //               onChanged: (bool? text){
          //     //                 if(text == true){
          //     //                   if(!selectedItems.value.contains(item['title'])){
          //     //                     selectedItems.value.add(item['title']);
          //     //                   }
          //     //                 }
          //     //                 else{
          //     //                   selectedItems.value.remove(item['title']);
          //     //                 }
          //     //                 if(selectedItems.value.isEmpty){
          //     //                   MainController.hintText.value = "Select Options";
          //     //                 }
          //     //                 else{
          //     //                   MainController.hintText.value = '${selectedItems.value.join(', ')}';
          //     //                 }
          //     //                 dataJson[name] = selectedItems.value.join(', ');
          //     //               },
          //     //             );
          //     //           })
          //     //       ),
          //     //       SizedBox(width: 5),
          //     //       Txt(
          //     //         '${item['title']}',
          //     //         color: MainController.isLightMode.value ? whiteColor : primaryDark,
          //     //       ),
          //     //     ],
          //     //   ),
          //     // ),
          //       item['title']
          //   ],
          //   hintText: '${dataModel[name] != null ? dataModel[name]:'Select Options'}',
          //   selectName: name,
          //   onSelectChanged: (selectedItems){
          //     dataModel[name] = selectedItems.join(', ');
          //   },
          // );
          children.add(SizedBox(
            height: 20,
          ));
          children.add(multiSelectBox);
        }
        else if(type == 'color'){
          // if(dataModel[name] != null){
          //   ViewController.selectedColor = Color(int.parse('${dataModel[name]}'));
          // }
          colorBox = generateFormColorBox(name ,column,  dataModel , dataModel[name] != null ? Color(int.parse('${dataModel[name]}')):Colors.blue);
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
        else if(type == 'file'){
          fileBox=generateFileBox(name , dataModel , '${dataModel[name] != null ? dataModel[name]:''}' , column);
          children.add(SizedBox(
            height: 20,
          ));
          children.add(fileBox);
        }

      }
    }
    return Column(children: children);
  }

  static Widget generateDataColumn(int indexColumn , int indexRow){
    var size = MediaQuery.of(Get.context!).size;
    DataModel dataModel=MainController.tableData.value[indexRow];
    // DataModel dataModel = indexRow;
    String type=MainController.tableInfo['columns'][indexColumn]['type'];
    String name=MainController.tableInfo['columns'][indexColumn]['name'];
    var child;
    if(type=='checkbox'){
      print('row generate data cell:${dataModel.id}');
      print('type:${type}');
      print('name:${name}');
      print('index:${indexRow}');
      print('data:${dataModel.data['${name}']}');
      print('-------------------');
      child=generateCheckBox(indexColumn , indexRow);
    }
    else if(type=='color'){
      child=generateColor(indexColumn , indexRow);
    }
    else{
      child=generateData(indexColumn , indexRow);
    }
    return Obx(() {
      return Center(
        child: Container(
          width: size.width/5,
            decoration: BoxDecoration(
              color: MainController.isLightMode.value == true ? background :whiteColor,
            ),
            padding: EdgeInsets.all(5),
            child: child
        ),
      );
    });
  }

  static Widget generateCheckBox(int indexColumn, int indexRow) {
    DataModel dataModel=MainController.tableData.value[indexRow];
    String name=MainController.tableInfo['columns'][indexColumn]['name'];
    if(dataModel.data['${name}'] == null){
      dataModel.data['${name}'] = false;
    }

    print('generate check box :${dataModel.data['${name}']}');
    return CheckBox(defaultValue:dataModel.data['${name}'] ,checkBoxTitle: '',onChange: (text) async {
      dataModel.data['${name}'] = text;
      print('dataModel.data[name]>>>${dataModel}');
      final data = DataModel(
        id: dataModel.id,
        data: dataModel.data,
      );
      dataController.allData.value[indexRow] =  data;
      await box.putAt(indexRow,data);
    } , index: indexRow ,column: MainController.tableInfo['columns'][indexColumn],);

  }

  static Widget generateColor(int indexColumn, int indexRow){
    DataModel dataModel=MainController.tableData.value[indexRow];
    String name=MainController.tableInfo['columns'][indexColumn]['name'];
    return Center(
      child:dataModel.data['${name}'] != null ? Container(
        width: 50,
        height: 50,
        color: Color(int.parse('${dataModel.data['${name}']}')),
      ):Container(),
    );
  }

  static Widget generateData(int indexColumn, int indexRow){
    DataModel dataModel=MainController.tableData.value[indexRow];
    String name=MainController.tableInfo['columns'][indexColumn]['name'];
    return Obx((){
      return Center(
        child: Txt(
          '${dataModel.data['${name}'] != null ? dataModel.data['${name}']:''}',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: MainController.isLightMode.value == true ? whiteColor : color2,
          textAlign: TextAlign.center,
        ),
      );
    });
  }

  static Widget generateFormTextField(String ColumnName , GlobalKey<FormBuilderState> _fbKey , var column , Map dataJson , var type , String initValue){

    return new FormTextField(
      name: '${ColumnName}',
      fbKey: _fbKey,
      hint: '${ColumnName}',
      lable: '${ColumnName}',
      column:column ,
      initValue: initValue,
      onChange: (text) {
        dataJson[ColumnName] = text;

        // if(type == 'number'){
        //
        //   if(text < minValidator['value'] || text > maxValidator['value']){
        //
        //   }
        //   else{
        //     dataJson[name] = text;
        //   }
        //
        //
        // }
        // else{
        //   dataJson[name] = text;
        // }
      },
      isMobile: type == 'mobile' ? true : false,
      isNumber: type == 'number' ? true : false,
      isEmail: type == 'email' ? true : false,
    );
  }

  static Widget generateFormSelectBox(String ColumnName , var column , Map dataJson , String hintText , String initalValue)  {
    var items;
    var selectedItem;
    var initailValue;

    for(var subMenu in MainController.SubMenuList){
      if(column['sourceItems'] != 'custom'){
        if(column['sourceTable'] == subMenu['table-name']){
          print('column[sourceTable]>>>${column['sourceTable']}');
          print('subMenu[columns]>>>${subMenu['columns']}');
          items = [];
          items = getInfoTable(column['sourceTable']);
           // for(var i in  getInfoTable(column['sourceTable'])){
           //
           // }


          for(var i = 0;i<subMenu['columns'].length;i++){
            ColumnName = subMenu['columns'][i]['name'];
            print('ColumnName 6>>>${ColumnName}');
            // items =  subMenu['columns'][i];
            print('xxx5>>>${dataJson[ColumnName]}');
            items.add({'title': subMenu['columns'][i]['name'], 'value': i});
          }
          initailValue = items.first['title'];
        }
      }
      else{
        items = column['items'];
        print('c1>>>${items}');
        print('c2>>>${column['items']}');
        selectedItem = items.firstWhere(
              (item) => item['is_selected'] == true,
          orElse: () => items.first,);
        initailValue = selectedItem['title'];
      }
    }
    // var items = column['items'];
    // var selectedItem = items.firstWhere(
    //       (item) => item['is_selected'] == true,
    //   orElse: () => items.first,);
    print('selectedItemSelected>>>${selectedItem}');

    return new SelectBox(
        name: '${ColumnName}',
        column: column,
        items: [
          for (var item in items)
            DropdownMenuItem(
                child: Txt(
                  '${item['title']}',
                  color: MainController.isLightMode.value == true
                      ? whiteColor
                      : primaryDark,
                ),
                value: item['title']),
        ],
        initalValue: initalValue != '' ? initalValue:initailValue,
        onChanged: (value) {
          print('selected item ${value}');
          for(var item in items){
            if(item['title'] == value){
              if(item['value'] == '-1'){
                value = null;
              }
            }
          }
          if(value != null){
            MainController.selectedItemList.value = value!.toString();
          }
          else{
            MainController.selectedItemList.value = '';
          }
          dataJson[ColumnName] = MainController.selectedItemList.value;
        },
        hintText: hintText,
        selectedValue: MainController.selectedItemList.value.obs);
  }

  static Widget generateFormCheckBox(String ColumnName ,var column, var defaultValue , Map dataJson){

    return new CheckBox(checkBoxName: '${ColumnName}',checkBoxTitle: '${ColumnName}' ,defaultValue: defaultValue,onChange: (text) {
      dataJson[ColumnName] = text;
    },
      column: column,
    );

  }

  static Widget generateFormRadioButton(String ColumnName , var column , Map dataJson , String initalValue){
    var radioButtonItems = column['items'];

    var selectedItem = radioButtonItems.firstWhere(
          (item) => item['is_selected'] == true,
      orElse: () => radioButtonItems.first,);
    print('selectedItem>>>${selectedItem}');

    return new RadioButton(name: '',radioButtonItems: [
      for (var radioButtonItem in radioButtonItems)
        FormBuilderChipOption(
          value: '${radioButtonItem['title']}',
          child: Txt('${radioButtonItem['title']}' , color: MainController.isLightMode.value ? whiteColor : primaryDark,),
        ),
    ],
      onChanged: (text){
        selectedRadioButton.value= text!;
        dataJson[ColumnName] = selectedRadioButton.value;
      },
      initalValue: initalValue,
      column: column,
    );
  }

  static Widget generateFormDateBox(String ColumnName,var column , Map dataJson , Jalali selectedDate){

    if(dataJson[ColumnName] == null){
      dataJson[ColumnName] = '${selectedDate.year}${'/'}${selectedDate.month}${'/'}${
          selectedDate.day}';
    }
    return new DateBox(
        selectedDate: selectedDate,
        onDateChanged: (date){
          dataJson[ColumnName] =  date;
          // Jalali? picked = await showPersianDatePicker(
          //   context: Get.context!,
          //   initialDate: Jalali.now(),
          //   firstDate: Jalali(1385 , 8),
          //   lastDate: Jalali(1450 , 9),
          // );
          // if(picked != null){
          //   print('picked>>>${picked}');
          //   MainController.selectedDate!.value= picked;
          //   print('MainController.selectedDate!.value>>>${MainController.selectedDate!.value}');
          //   String date = '${MainController.selectedDate!.value.year.obs}${'/'}${MainController.selectedDate!.value.month.obs}${'/'}${MainController.selectedDate!.value.day.obs}';
          //   dataJson[name] =  date;
          // }
        },
      column: column,
    );
  }

  static Widget genarateFormMuiltiSelectBox(String ColumnName , var column , Map dataJson , String hintText){
    var items = column['items'];
    Map<String, List<String>> selectedItemsMap = {};
    if(selectedItemsMap['${ColumnName}'] == null){
      selectedItemsMap['${ColumnName}']=[];
    }
    List<dynamic> dataList;
    if(dataJson[ColumnName] != null){
      dataList = dataJson[ColumnName].split(', ').map((item) => item.trim()).toList();
      for(var data in dataList){
        selectedItemsMap['${ColumnName}']!.add(data);
      }
    }
    return MultiSelectDropdown(
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
      selectName: ColumnName,
      onSelectChanged: (selectedItems){
        print('selectedItem2>>>${selectedItems}');
        dataJson[ColumnName] = selectedItems.join(', ');
      },
      column: column,
    );
  }

  static Widget generateFormColorBox(String ColumnName ,var column, Map dataJson , Color selectedColor){
    Color colorChanged;
    return new Container(
      child: ColorPickerBox(
        selectedColor: selectedColor,
        onChanged: (color){
          colorChanged = color;
          String hexColor = '0x${colorChanged.value.toRadixString(16).padLeft(8, '0')}';
          dataJson[ColumnName] = hexColor;
        },
        column: column,
      ),
    );
  }

  static Widget  generateFileBox(String columnName ,  Map dataJson , String selecetdFiles , var column){
    Map<String,  List<dynamic>> selectedFilesMap = {};
    if(selectedFilesMap['${columnName}'] == null){
      selectedFilesMap['${columnName}']=[];
    }
    List<dynamic> filesSelectedList;
    if(dataJson[columnName] != null){
      filesSelectedList = dataJson[columnName];
      print('aaaaaaaa2>>>${selectedFilesMap['${columnName}']}');
      print('dataJson[columnName]>>>${dataJson[columnName]}');
      for(var data in filesSelectedList){
        selectedFilesMap['${columnName}']!.add(data);
      }
    }

    return new FormFile(
     columnName: columnName,
      onChanged: (selecetdFiles){
       print('selecetdFiles>>>>${selecetdFiles}');
        dataJson[columnName] = selecetdFiles;
      },
      filesSelected: selectedFilesMap,
      selectedFilesTxt: selecetdFiles,
      column: column,
    ) ;
  }

  static Future<List<dynamic>>  getInfoTable(String tableName) async{
    List<dynamic> rowList=[];
    List<dynamic> tableData = [];
    box = await Hive.openBox<DataModel>('${tableName}');
    tableData = box.values.toList();
    // for(var subMenu in MainController.SubMenuList){
    //   if(subMenu['table-name'] == tableName){
    //
    //    // for(var sub in subMenu['columns']){
    //    //   print('gggggggggg>>>${sub['name']}');
    //    // }
    //   }
    // }
    for(var row in tableData){
      print('tableData>>>${row.data}');
      rowList.add(row.data);
    }
    print('rowList>>>${rowList}');
    for(var i in rowList){
      print('${i['item 1']}');
    }

    return rowList;

  }
}