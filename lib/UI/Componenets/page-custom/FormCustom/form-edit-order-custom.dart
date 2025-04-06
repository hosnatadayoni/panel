import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/validator-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/Logic/Models/dataModel.dart';
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
import 'package:finance/UI/Views/table-page.dart';
import 'package:finance/boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/dataController.dart';

class FormEditOrderCustom extends StatefulWidget {

  FormEditOrderCustom({required this.index , this.data});
  DataModel? data;
  int index;

  @override
  State<FormEditOrderCustom> createState() => _FormEditOrderCustomState();
}

class _FormEditOrderCustomState extends State<FormEditOrderCustom> {
  Color? colorChanged;
  Map<String, Future<Map<String, dynamic>>>  _future={};
  Map<String , dynamic> dataJson = {};

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
    var size = MediaQuery.of(context).size;
    Rx<bool> isHoverBtnBack = false.obs;

    return  Container(
      width: size.width,
      child: Column(
        children: [
          // Container(
          //   padding: EdgeInsets.all(10),
          //   width: size.width,
          //   child:
          //   Wrap(
          //     alignment: WrapAlignment.end,
          //     children: [
          //       MouseRegion(
          //         onEnter: (_){
          //           isHoverBtnBack.value = true;
          //         },
          //         onExit: (_){
          //           isHoverBtnBack.value = false;
          //         },
          //         child: InkWell(
          //           onTap: (){
          //             print('widget.data!.data>>>${widget.data!.data}');
          //             MainController.isClickedItem.value = true;
          //             MainController.goToTablePage();
          //           },
          //           child: Container(
          //             padding: EdgeInsets.all(10),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(Radius.circular(10)),
          //               border: Border.all(color: colorBtn , width: 1),
          //               color: isHoverBtnBack.value == false ? Colors.transparent : colorBtn,
          //             ),
          //             child: Txt('${AppController.of(context)!.value('back')}' , color:isHoverBtnBack.value == false ? colorBtn : whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 5,),
          //       InkWell(
          //         onTap: ()async{
          //           ViewController.isClickedEditBtn.value = true;
          //           final data = DataModel(
          //             id: widget.data!.id,
          //             data: ViewController.request,
          //           );
          //           print('xxxx>>>${data.data}');
          //           bool isValidator;
          //           List<bool> isValidatorList=[];
          //           for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
          //             isValidator = await ValidatorController.checkInputValidation(j,data.data);
          //             isValidatorList.add(isValidator);
          //           }
          //           print('isValidatorList>>>${isValidatorList}');
          //           bool isExsistsValidation = isValidatorList.contains(false);
          //           print('isExsistsValidation>>>${isExsistsValidation}');
          //           if(isExsistsValidation){
          //             isValidatorList=[];
          //           }
          //           else{
          //             dataController.allData.value[widget.index] =  data;
          //             MainController.tableData.value[widget.index] = data;
          //
          //             Box orderBox = await ViewController.getBox('order');
          //             Box orderItemBox = await ViewController.getBox('order-items');
          //             await orderBox.putAt(widget.index,data);
          //             await orderItemBox.putAt(widget.index,data);
          //
          //             print('dataController.allData.value[widget.index]>>>${dataController.allData.value[widget.index].data}');
          //             print('MainController.tableData.value[widget.index]>>>>${MainController.tableData.value[widget.index]}');
          //             MainController.isClickedItem.value = true;
          //             ViewController.isClickedEditBtn.value = false;
          //             MainController.goToTablePage();
          //           }
          //         },
          //         child: Container(
          //           padding: EdgeInsets.all(10),
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.all(Radius.circular(10)),
          //             color: colorBtn,
          //           ),
          //           child: Txt('${AppController.of(context)!.value('edit')}' , color:whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 20,),
          Container(
            width: size.width,
            padding: EdgeInsets.all(20),
            decoration:  BoxDecoration(
                border: Border.all(width: 2,color: MainController.isLightMode.value == true ? whiteColor:primaryDark),
                borderRadius:  BorderRadius.circular(10)
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // runSpacing: 5,
                // spacing: 20,
                children: [
                  for (var j = 0; j < MainController.tableInfo['columns'].length; j++)
                     if (MainController.tableInfo['columns'][j]['type'] == 'string' ||
                        MainController.tableInfo['columns'][j]['type'] == 'number' ||
                        MainController.tableInfo['columns'][j]['type'] == 'mobile'||
                        MainController.tableInfo['columns'][j]['type'] == 'email'

                    )
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
                              }),
                              SizedBox(height: 10,),
                              Container(
                                width: 80,
                                // width: 150,
                                // height: 100,
                                child: FormTextField(
                                  name: '${MainController.tableInfo['columns'][j]['title']}',
                                  hint: '${MainController.tableInfo['columns'][j]['title']}',
                                  lable: '',
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
                              )
                            ],
                          ),
                          SizedBox(width: 20,),
                        ],
                      )
                     else if(MainController.tableInfo['columns'][j]['type'] == 'checkbox')
                         Row(
                        children: [
                          CheckBox(
                            checkBoxName: '${MainController.tableInfo['columns'][j]['title']}',
                            checkBoxTitle: '${MainController.tableInfo['columns'][j]['title']}',
                            defaultValue: ViewController.request['${MainController.tableInfo['columns'][j]['name']}'],
                            onChange: (text) {
                              ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = text;
                            },
                            column: MainController.tableInfo['columns'][j],

                          ),
                          SizedBox(width: 20,),
                        ],
                      )
                     else if(MainController.tableInfo['columns'][j]['type'] == 'color')
                         Row(
                           children: [
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Obx(() {
                                   return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
                                 }),
                                 SizedBox(height: 10,),
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
                               ],
                             ),
                             SizedBox(width: 20,),
                           ],
                         )
                     else if(MainController.tableInfo['columns'][j]['type'] == 'date')
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() {
                                    return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
                                  }),
                                  SizedBox(height: 10,),
                                  Container(
                                    width: 120,
                                    child:ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] != null ?  DateBox(
                                      selectedDate: ViewCustomController.parseDate(ViewController.request['${MainController.tableInfo['columns'][j]['name']}']),
                                      onDateChanged: (date) {
                                        ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = date;
                                      },
                                      column: MainController.tableInfo['columns'][j],
                                    ):DateBox(
                                      selectedDate: Jalali.now(),
                                      onDateChanged: (date) {
                                        ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = date;
                                      },
                                      column: MainController.tableInfo['columns'][j],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(width: 20,)
                            ],
                          )
                     else if(MainController.tableInfo['columns'][j]['type'] == 'select')
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() {
                                    return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
                                  }),
                                  SizedBox(height: 10,),
                                  FutureBuilder(
                                      future: _future[MainController.tableInfo['columns'][j]['title']],
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
                                          if (snapshot.hasData){
                                            var data = snapshot.data!;
                                            return Container(
                                              width: MainController.tableInfo['columns'][j]['name'] == 'مشتری'  ? 150:100,
                                              // width: 150,
                                              // height: 100,
                                              child: SelectBox(
                                                name: '${MainController.tableInfo['columns'][j]['title']}',
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
                                            );
                                          }
                                          else{
                                            return Container();
                                          }
                                        }
                                      }
                                  )
                                ],
                              ),
                              SizedBox(width: 20,)
                            ],
                          )
                     else if(MainController.tableInfo['columns'][j]['type'] == 'multiSelect')
                           Row(
                             children: [
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Obx(() {
                                     return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
                                   }),
                                   SizedBox(height: 10,),
                                   FutureBuilder(
                                     future: _future[MainController.tableInfo['columns'][j]['title']],
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
                                           return Container(
                                             width: 150,
                                             child: MultiSelectDropdown(
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
                                           );
                                         }) : Container();
                                       }
                                     },
                                   )
                                 ],
                               ),
                               SizedBox(width: 20,),
                             ],
                           )
                     else if(MainController.tableInfo['columns'][j]['type'] == 'radiobutton')
                           Row(
                             children: [
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Obx(() {
                                     return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
                                   }),
                                   SizedBox(height: 10,),
                                   FutureBuilder(
                                       future: _future[MainController.tableInfo['columns'][j]['title']],
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
                                 ],
                               ),
                               SizedBox(width: 20,)
                             ],
                           )
                     else if(MainController.tableInfo['columns'][j]['type'] == 'file')
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
                                    }),
                                    SizedBox(height: 10,),
                                    Container(
                                      width: 300,
                                      child: FormFile(
                                        columnName: MainController.tableInfo['columns'][j]['title'],
                                        onChanged: (selecetdFiles) {
                                          ViewController.request[MainController.tableInfo['columns'][j]['name']] = selecetdFiles;
                                        },
                                        filesSelected: ViewCustomController.getselectedFilesMap(MainController.tableInfo['columns'][j]),
                                        selectedFilesTxt: ViewController.request[MainController.tableInfo['columns'][j]['name']],
                                        column: MainController.tableInfo['columns'][j],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20,)
                              ],
                            )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}