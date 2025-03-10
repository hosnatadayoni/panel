import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Form/form-checkBox.dart';
import 'package:finance/UI/Componenets/Items/Form/form-color.dart';
import 'package:finance/UI/Componenets/Items/Form/form-date.dart';
import 'package:finance/UI/Componenets/Items/Form/form-file.dart';
import 'package:finance/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:finance/UI/Componenets/Items/Form/form-radio-button.dart';
import 'package:finance/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../Logic/Controllers/app-controller.dart';

class FormCustom extends StatefulWidget {

  FormCustom();

  @override
  State<FormCustom> createState() => _FormCustomState();
}

class _FormCustomState extends State<FormCustom> {
  Color? colorChanged;
  Map<String, Future<Map<String, dynamic>>>  _future={};

  void initState() {
    super.initState();
    _loadData();
  }
  void _loadData() {
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      String columnName = MainController.tableInfo['columns'][j]['name'];
      if (MainController.tableInfo['columns'][j]['type'] == 'select' ||
          MainController.tableInfo['columns'][j]['type'] == 'radiobutton') {
        _future['${columnName}'] = ViewCustomController.getSelectBoxData(MainController.tableInfo['columns'][j]);
      }
      else if(MainController.tableInfo['columns'][j]['type'] == 'multiSelect'){
        _future['${columnName}'] = ViewCustomController.getMultiSelectBoxData(MainController.tableInfo['columns'][j]);

      }
    }
  }


  @override
  Widget build(BuildContext context){

    return  Column(
      children: [
        SizedBox(height: 20,),
        for (var j = 0; j < MainController.tableInfo['columns'].length; j++)
          if (MainController.tableInfo['columns'][j]['is-show-edit'] == true)
            if (MainController.tableInfo['columns'][j]['type'] == 'string' ||
                MainController.tableInfo['columns'][j]['type'] == 'number' ||
                MainController.tableInfo['columns'][j]['type'] == 'mobile'||
                MainController.tableInfo['columns'][j]['type'] == 'email'

            )
              Column(
                children: [
                  FormTextField(
                    name: '${MainController.tableInfo['columns'][j]['name']}',
                    hint: '${MainController.tableInfo['columns'][j]['name']}',
                    lable: '${MainController.tableInfo['columns'][j]['name']}',
                    initValue: '${ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] != null ?
                    ViewController.request['${MainController.tableInfo['columns'][j]['name']}']:
                    ''}',
                    isNumber:MainController.tableInfo['columns'][j]['type'] == 'number' ? true : false ,
                    isEmail:MainController.tableInfo['columns'][j]['type'] == 'email' ? true:false,
                    isMobile: MainController.tableInfo['columns'][j]['type'] == 'mobile' ? true : false,
                    onChange: (text) {
                      ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = text;
                    },
                    column: MainController.tableInfo['columns'][j],
                  ),
                  SizedBox(height: 20),
                ],
              )

            else if(MainController.tableInfo['columns'][j]['type'] == 'checkbox')
                 Column(
                children: [
                  CheckBox(
                    checkBoxName: '${MainController.tableInfo['columns'][j]['name']}',
                    checkBoxTitle: '${MainController.tableInfo['columns'][j]['name']}',
                    defaultValue: ViewController.request['${MainController.tableInfo['columns'][j]['name']}'],
                    onChange: (text) {
                      ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = text;
                    },
                    column: MainController.tableInfo['columns'][j],

                  ),
                  SizedBox(height: 20),
                ],
              )

            else if(MainController.tableInfo['columns'][j]['type'] == 'color')
                Column(
                  children: [
                    Container(
                      child: ColorPickerBox(
                        selectedColor: ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] != null
                            ? Color(int.parse('${ViewController.request['${MainController.tableInfo['columns'][j]['name']}']}'))
                            : Colors.blue,
                        onChanged: (color) {
                          colorChanged = color;
                          String hexColor =
                              '0x${colorChanged!.value.toRadixString(16).padLeft(8, '0')}';
                          // dataJson[columnName] = hexColor;
                          ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = hexColor;
                        },
                        column: MainController.tableInfo['columns'][j],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                )
            else if(MainController.tableInfo['columns'][j]['type'] == 'date')
                  Column(
                    children: [
                      if (ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] != null)
                        DateBox(
                          selectedDate: ViewCustomController.parseDate(ViewController.request['${MainController.tableInfo['columns'][j]['name']}']),
                          onDateChanged: (date) {
                            ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = date;
                          },
                          column: MainController.tableInfo['columns'][j],
                        )
                      else
                        DateBox(
                          selectedDate: Jalali.now(),
                          onDateChanged: (date) {
                            ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = date;
                          },
                          column: MainController.tableInfo['columns'][j],
                        ),
                      SizedBox(height: 20),
                    ],
                  )
            else if(MainController.tableInfo['columns'][j]['type'] == 'select')
                  FutureBuilder(
                      future: _future[MainController.tableInfo['columns'][j]['name']],
                      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting) {
                         return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          if(snapshot.data != null){
                            return Txt('${AppController.of(context)!.value('error')}');
                          }
                          else{
                            return Container();
                          }
                        }
                        else{
                          var data = snapshot.data!;
                          return Column(
                            children: [
                              SelectBox(
                                name: '${MainController.tableInfo['columns'][j]['name']}',
                                column: MainController.tableInfo['columns'][j],
                                items: data['items'].map<DropdownMenuItem<String>>((item) {

                                  return DropdownMenuItem<String>(
                                    value: item['value'].toString(),
                                    child: Obx(() {
                                      return Txt(
                                        '${item['title']}',
                                        color: MainController.isLightMode.value == true
                                            ? whiteColor
                                            : primaryDark,
                                      );
                                    }),
                                  );
                                }).toList(),
                                initalValue: data['initValue'],
                                onChanged: (value) async {
                                  print('selected item ${value}');
                                  for (var item in data['items']) {
                                    if (item['title'] == value) {
                                      if (item['value'] == '-1') {
                                        value = null;
                                      }
                                    }
                                  }
                                  if (value != '-1') {
                                    ViewController.request[MainController.tableInfo['columns'][j]['name']] = value;
                                  } else {
                                    ViewController.request[MainController.tableInfo['columns'][j]['name']] = '';
                                  }
                                },
                                hintText: data['hint'],
                                isSeleted: ViewController.request[MainController.tableInfo['columns'][j]['name']] == '' || ViewController.request[MainController.tableInfo['columns'][j]['name']] == null ? false.obs : true.obs,
                                selectedValue: '',
                              ),
                              SizedBox(height: 20),
                            ],
                          );
                        }
                      }
                  )
            else if(MainController.tableInfo['columns'][j]['type'] == 'multiSelect')
                  FutureBuilder(
    future: _future[MainController.tableInfo['columns'][j]['name']],
    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return CircularProgressIndicator();
    } else if (snapshot.hasError) {
    if(snapshot.data != null){
    return Txt('${AppController.of(context)!.value('error')}');
    }
    else{
    return Container();
    }

    } else {
    var data = snapshot.data!;
    return data['items'].length != 0 ? Obx(() {
    return Column(
    children: [
    MultiSelectDropdown(
    items: [
    for (var item in data['items'])
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
    child: Checkbox(
    activeColor: colorBtn,
    value: data['selectedItemsList'].contains(item['value']),
    onChanged: (isChecked) {
    if (isChecked != null) {
    if (!data['selectedItemsList'].contains(item['value'])) {
    data['selectedItemsList'].add(item['value']); // اضافه کردن آیتم به لیست
    } else {
    data['selectedItemsList'].remove(item['value']); // حذف آیتم از لیست
    }
    if (item['value'] == '-1') {
    data['selectedItemsList'].remove(item['value']); // حذف آیتم نامعتبر
    }
    if (data['selectedItemsList'].isEmpty) {
    data['isSelectedItem'].value = false;
    } else {
    data['isSelectedItem'].value = true;
    }
    data['hintTxt'].value = ViewController.hintMultiSelectBox(data['items'], data['selectedItemsList']);
    ViewController.request[MainController.tableInfo['columns'][j]['name']] = data['selectedItemsList'];
    }
    },
    ),
    ),
    ),
    Txt(item['title'], color: MainController.isLightMode.value ? whiteColor : primaryDark),
    ],
    );
    }),
    ),
    ],
    hintText: data['hintTxt'].value.isNotEmpty ? data['hintTxt'].value : data['items'][0]['title'],
    selectedItems: data['selectedItemsList'],
    isSelectedItem: data['isSelectedItem'],
    onChanged: (selectedList) {
    data['selectedItemsList'].value = selectedList;
    ViewController.request[MainController.tableInfo['columns'][j]['name']] = selectedList;
    data['hintTxt'].value = ViewController.hintMultiSelectBox(data['items'], selectedList);
    },
    column: MainController.tableInfo['columns'][j],
    ),
    SizedBox(height: 20),
    ],
    );
    }) : Container();
    }
    },
    )
            else if(MainController.tableInfo['columns'][j]['type'] == 'radiobutton')
                  FutureBuilder(
                      future: _future[MainController.tableInfo['columns'][j]['name']],
                      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          if(snapshot.data != null){
                            return Txt('${AppController.of(context)!.value('error')}');
                          }
                          else{
                            return Container();
                          }
                        }
                        else{
                          var data = snapshot.data!;
                          return Column(
                            children: [
                              RadioButton(
                                name: '',
                                radioButtonItems: [
                                  for (var radioButtonItem in data['items'])
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
                                  ViewController.request[MainController.tableInfo['columns'][j]['name']] = text;
                                  // dataJson[columnName] = selectedRadioButton.value;
                                },
                                initalValue: data['initValue'],
                                column: MainController.tableInfo['columns'][j],
                                isSelectedItem: ViewController.request[MainController.tableInfo['columns'][j]['name']] == '' ? false.obs : true.obs,
                              ),
                              SizedBox(height: 20),
                            ],
                          );
                        }
                      }
                  )
            else if(MainController.tableInfo['columns'][j]['type'] == 'file')
                  Column(
                    children: [
                      FormFile(
                        columnName: MainController.tableInfo['columns'][j]['name'],
                        onChanged: (selecetdFiles) {
                          ViewController.request[MainController.tableInfo['columns'][j]['name']] = selecetdFiles;
                        },
                        filesSelected: ViewCustomController.getselectedFilesMap(MainController.tableInfo['columns'][j]),
                        selectedFilesTxt: ViewController.request[MainController.tableInfo['columns'][j]['name']],
                        column: MainController.tableInfo['columns'][j],
                      ),
                      SizedBox(height: 20,),
                    ],
                  )

      ],
    );
  }
}
