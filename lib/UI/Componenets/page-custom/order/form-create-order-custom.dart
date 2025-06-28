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
import 'package:finance/UI/Componenets/Items/Form/form-time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../../Logic/Controllers/app-controller.dart';

class FormCreateOrderCustom extends StatefulWidget {

  FormCreateOrderCustom();

  @override
  State<FormCreateOrderCustom> createState() => _FormCreateOrderCustomState();
}

class _FormCreateOrderCustomState extends State<FormCreateOrderCustom> {
  Color? colorChanged;
  // Map<String, Future<Map<String, dynamic>>>  _future={};
  Map<String , dynamic> dataJson = {};
  late Future<Widget> _future;

  void initState() {
    super.initState();
    // _loadData();
    _future = ViewCustomController.generateStoreFormOrderView(MainController.tableInfo['columns']);
  }
  // void _loadData() {
  //   for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
  //     String columnName = MainController.tableInfo['columns'][j]['title'];
  //     if (MainController.tableInfo['columns'][j]['type'] == 'select' ||
  //         MainController.tableInfo['columns'][j]['type'] == 'radiobutton') {
  //       _future['${columnName}'] = ViewCustomController.getSelectBoxData(MainController.tableInfo['columns'][j]);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    Rx<bool> isHoverBtnBack = false.obs;
    return  Container(
      width: size.width,
      child: Column(
        children: [
          SizedBox(height: 20,),
          Container(
            width: size.width,
            padding: EdgeInsets.all(20),
            decoration:  BoxDecoration(
                border: Border.all(width: 2,color: MainController.isLightMode.value == true ? whiteColor:primaryDark),
              borderRadius:  BorderRadius.circular(10),

            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              // child: Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   // runSpacing: 5,
              //   // spacing: 20,
              //   children: [
              //   for (var j = 0; j < MainController.tableInfo['columns'].length; j++)
              //     if(MainController.tableInfo['columns'][j]['is-show-store'] == true)
              //       if (MainController.tableInfo['columns'][j]['type'] == 'string' ||
              //           MainController.tableInfo['columns'][j]['type'] == 'Number int' || MainController.tableInfo['columns'][j]['type'] == 'Number double' ||
              //           MainController.tableInfo['columns'][j]['type'] == 'mobile'||
              //           MainController.tableInfo['columns'][j]['type'] == 'email'
              //
              //       )
              //         Row(
              //           children: [
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Obx(() {
              //                   return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
              //                 }),
              //                 SizedBox(height: 10,),
              //                 Container(
              //                   width: 80,
              //                   // height: 100,
              //                   child: FormTextField(
              //                     name: '${MainController.tableInfo['columns'][j]['title']}',
              //                     hint: '${MainController.tableInfo['columns'][j]['title']}',
              //                     lable: '',
              //                     initValue: '${ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] != null ?
              //                     ViewController.request['${MainController.tableInfo['columns'][j]['name']}']:
              //                     ''}',
              //                     isNumberInt:MainController.tableInfo['columns'][j]['type'] == 'Number int' ? true : false ,
              //                     isNumberDouble:MainController.tableInfo['columns'][j]['type'] == 'Number double' ? true : false ,
              //                     isEmail:MainController.tableInfo['columns'][j]['type'] == 'email' ? true:false,
              //                     isMobile: MainController.tableInfo['columns'][j]['type'] == 'mobile' ? true : false,
              //                     onChange: (text) {
              //                       ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = text;
              //                     },
              //                     column: MainController.tableInfo['columns'][j],
              //                   ),
              //                 )
              //               ],
              //             ),
              //             SizedBox(width: 20),
              //           ],
              //         )
              //       else if(MainController.tableInfo['columns'][j]['type'] == 'checkbox')
              //         Row(
              //           children: [
              //             Container(
              //               width: 150,
              //               child: CheckBox(
              //                 checkBoxName: '${MainController.tableInfo['columns'][j]['title']}',
              //                 checkBoxTitle: '${MainController.tableInfo['columns'][j]['title']}',
              //                 defaultValue: ViewController.request['${MainController.tableInfo['columns'][j]['name']}'],
              //                 isClickedBtn:ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] == null ? false.obs : true.obs,
              //                 onChange: (text) {
              //                   ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = text;
              //                 },
              //                 column: MainController.tableInfo['columns'][j],
              //
              //               ),
              //             ),
              //             SizedBox(width: 20,),
              //           ],
              //         )
              //       else if(MainController.tableInfo['columns'][j]['type'] == 'color')
              //           Row(
              //             children: [
              //               Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Obx(() {
              //                     return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
              //                   }),
              //                   SizedBox(height: 10,),
              //                   Container(
              //                     child: ColorPickerBox(
              //                       selectedColor: ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] != null
              //                           ? Color(int.parse('${ViewController.request['${MainController.tableInfo['columns'][j]['name']}']}'))
              //                           : Colors.blue,
              //                       isSeletedColor: ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] == null ? false.obs : true.obs,
              //                       onChanged: (color) {
              //                         colorChanged = color;
              //                         String hexColor =
              //                             '0x${colorChanged!.value.toRadixString(16).padLeft(8, '0')}';
              //                         // dataJson[columnName] = hexColor;
              //                         ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = hexColor;
              //                       },
              //                       column: MainController.tableInfo['columns'][j],
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //               SizedBox(width: 20,)
              //             ],
              //           )
              //       else if(MainController.tableInfo['columns'][j]['type'] == 'date')
              //           Row(
              //             children: [
              //               Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Obx(() {
              //                     return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
              //                   }),
              //                   SizedBox(height: 10,),
              //                   Container(
              //                     width: 120,
              //                   child:DateBox(
              //                       selectedDate:ViewController.request['${MainController.tableInfo['columns'][j]['name']}']!= null ?  ViewCustomController.parseDate(ViewController.request['${MainController.tableInfo['columns'][j]['name']}']):Jalali.now(),
              //                       isSeletedDate:ViewController.request['${MainController.tableInfo['columns'][j]['name']}']== null || ViewController.request['${MainController.tableInfo['columns'][j]['name']}']== '' ? false.obs : true.obs,
              //                       onDateChanged: (date) {
              //                         ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = date;
              //                       },
              //                       column: MainController.tableInfo['columns'][j],
              //                     )
              //                   )
              //                 ],
              //               ),
              //               SizedBox(width: 20,)
              //             ],
              //           )
              //       else if(MainController.tableInfo['columns'][j]['type'] == 'select')
              //           Row(
              //                 children: [
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       FutureBuilder(
              //                         future: _future[MainController.tableInfo['columns'][j]['name']],
              //                         builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              //                           if (snapshot.connectionState == ConnectionState.waiting) {
              //                             return CircularProgressIndicator();
              //                           } else if (snapshot.hasError) {
              //                             if (snapshot.data != null) {
              //                               return Txt('${AppController.of(context)!.value('error')}');
              //                             } else {
              //                               return Container();
              //                             }
              //                           } else {
              //                             if (snapshot.hasData) {
              //                               var data = snapshot.data!;
              //                               // Check if data['items'] exists and is not empty
              //                               if (data['items'] != null && data['items'].isNotEmpty) {
              //                                 return Column(
              //                                   crossAxisAlignment: CrossAxisAlignment.start,
              //                                   children: [
              //                                     Container(
              //                                       width: MainController.tableInfo['columns'][j]['name'] == 'مشتری'  ? 150:100,
              //                                       // height: 100,
              //                                       child:ViewController.generateStoreFormSelectBox(MainController.tableInfo['columns'][j],data['items'],'', '' ,ViewController.request[MainController.tableInfo['columns'][j]['name']] == null || ViewController.request[MainController.tableInfo['columns'][j]['name']] == '' ? false.obs : true.obs),
              //                                     ),
              //                                   ],
              //                                 );
              //                               } else {
              //                                 // Return an empty container if data['items'] is empty or null
              //                                 return Container();
              //                               }
              //                             } else {
              //                               return Container();
              //                             }
              //                           }
              //                         },
              //                       ),
              //                     ],
              //                   ),
              //                   SizedBox(width: 20,)
              //                 ],
              //               )
              //       // else if(MainController.tableInfo['columns'][j]['type'] == 'multiSelect')
              //       //      Row(
              //       //        children: [
              //       //          Column(
              //       //            crossAxisAlignment: CrossAxisAlignment.start,
              //       //            children: [
              //       //              Obx(() {
              //       //                return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
              //       //              }),
              //       //              SizedBox(height: 10,),
              //       //              FutureBuilder(
              //       //                future: _future[MainController.tableInfo['columns'][j]['title']],
              //       //                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              //       //                  if (snapshot.connectionState == ConnectionState.waiting) {
              //       //                    return CircularProgressIndicator();
              //       //                  } else if (snapshot.hasError) {
              //       //                    if(snapshot.data != null){
              //       //                      return Txt('${AppController.of(context)!.value('error')}');
              //       //                    }
              //       //                    else{
              //       //                      return Container();
              //       //                    }
              //       //
              //       //                  } else {
              //       //                    var data = snapshot.data!;
              //       //                    return data['items'].length != 0 ? Obx(() {
              //       //                      return Container(
              //       //                        width: 250,
              //       //                        // child: MultiSelectDropdown(
              //       //                        //   items: [
              //       //                        //     for (var item in data['items'])
              //       //                        //       DropdownMenuItem(
              //       //                        //         value: item['value'],
              //       //                        //         child: Obx(() {
              //       //                        //           return Row(
              //       //                        //             children: [
              //       //                        //               Container(
              //       //                        //                 height: 100,
              //       //                        //                 child: SizedBox(
              //       //                        //                   width: 50,
              //       //                        //                   height: 50,
              //       //                        //                   child: Checkbox(
              //       //                        //                     activeColor: colorBtn,
              //       //                        //                     value: data['selectedItemsList'].contains(item['value']),
              //       //                        //                     onChanged: (isChecked) {
              //       //                        //                       if (isChecked != null) {
              //       //                        //                         if (!data['selectedItemsList'].contains(item['value'])) {
              //       //                        //                           data['selectedItemsList'].add(item['value']);
              //       //                        //                         } else {
              //       //                        //                           data['selectedItemsList'].remove(item['value']);
              //       //                        //                         }
              //       //                        //                         if (item['value'] == '-1') {
              //       //                        //                           data['selectedItemsList'].remove(item['value']);
              //       //                        //                         }
              //       //                        //                         if (data['selectedItemsList'].isEmpty) {
              //       //                        //                           data['isSelectedItem'].value = false;
              //       //                        //                         } else {
              //       //                        //                           data['isSelectedItem'].value = true;
              //       //                        //                         }
              //       //                        //                         data['hintTxt'].value = ViewController.hintMultiSelectBox(data['items'], data['selectedItemsList']);
              //       //                        //                         ViewController.request[MainController.tableInfo['columns'][j]['name']] = data['selectedItemsList'];
              //       //                        //                       }
              //       //                        //                     },
              //       //                        //                   ),
              //       //                        //                 ),
              //       //                        //               ),
              //       //                        //               Txt(item['title'], color: MainController.isLightMode.value ? whiteColor : primaryDark),
              //       //                        //             ],
              //       //                        //           );
              //       //                        //         }),
              //       //                        //       ),
              //       //                        //   ],
              //       //                        //   hintText: data['hintTxt'].value.isNotEmpty ? data['hintTxt'].value : data['items'][0]['title'],
              //       //                        //   selectedItems: data['selectedItemsList'],
              //       //                        //   isSelectedItem: data['isSelectedItem'],
              //       //                        //   onChanged: (selectedList) {
              //       //                        //     data['selectedItemsList'].value = selectedList;
              //       //                        //     ViewController.request[MainController.tableInfo['columns'][j]['name']] = selectedList;
              //       //                        //     data['hintTxt'].value = ViewController.hintMultiSelectBox(data['items'], selectedList);
              //       //                        //   },
              //       //                        //   column: MainController.tableInfo['columns'][j],
              //       //                        // ),
              //       //                        child: ViewController.genarateStoreFormMuiltiSelectBox(MainController.tableInfo['columns'][j],data['items'],
              //       //                            '',
              //       //                            '' ,
              //       //                            ViewController.request[MainController.tableInfo['columns'][j]['name']] == null ||
              //       //                                ViewController.request[MainController.tableInfo['columns'][j]['name']] == '' ? false.obs : true.obs),
              //       //                      );
              //       //                    }) : Container();
              //       //                  }
              //       //                },
              //       //              )
              //       //            ],
              //       //          ),
              //       //          SizedBox(width: 20,)
              //       //        ],
              //       //      )
              //       else if(MainController.tableInfo['columns'][j]['type'] == 'multiSelect')
              //            Row(
              //                   children: [
              //                     Container(
              //                       width: 400,
              //                       child: FutureBuilder<Widget>(
              //                         future: ViewController.genarateStoreFormMuiltiSelectBox(
              //                             MainController.tableInfo['columns'][j],
              //                              RxString(''), <dynamic>[].obs, false.obs
              //                         ),
              //                         builder: (context, snapshot) {
              //                           if (snapshot.connectionState == ConnectionState.waiting) {
              //                             return CircularProgressIndicator();
              //                           } else if (snapshot.hasError) {
              //                             return Text('Error loading multi-select');
              //                           } else {
              //                             return snapshot.data ?? Container();
              //                           }
              //                         },
              //                       ),
              //                     ),
              //                     SizedBox(width: 20)
              //                   ],
              //                 )
              //       else if(MainController.tableInfo['columns'][j]['type'] == 'radiobutton')
              //            Container(
              //                     width: 400,
              //                     height: 150,
              //                     child: Row(
              //                       children: [
              //                         Expanded(
              //                           child: Column(
              //                             crossAxisAlignment: CrossAxisAlignment.start,
              //                             children: [
              //                               Obx(() {
              //                                 return Txt(
              //                                   '${MainController.tableInfo['columns'][j]['title']}',
              //                                   color: MainController.isLightMode.value ? whiteColor : color2,
              //                                 );
              //                               }),
              //                               SizedBox(height: 10),
              //                               FutureBuilder(
              //                                 future: _future[MainController.tableInfo['columns'][j]['title']],
              //                                 builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              //                                   if (snapshot.connectionState == ConnectionState.waiting) {
              //                                     return SizedBox(
              //                                       width: 200,
              //                                       height: 50,
              //                                       child: CircularProgressIndicator(),
              //                                     );
              //                                   } else if (snapshot.hasError) {
              //                                     return snapshot.data != null
              //                                         ? Txt('${AppController.of(context)!.value('error')}')
              //                                         : Container();
              //                                   } else {
              //                                     var data = snapshot.data!;
              //                                     return ConstrainedBox(
              //                                       constraints: BoxConstraints(
              //                                         minWidth: 300,
              //                                         minHeight: 60,
              //                                       ),
              //                                       child: RadioButton(
              //                                         name: '',
              //                                         radioButtonItems: [
              //                                           for (var radioButtonItem in data['items'])
              //                                             FormBuilderChipOption(
              //                                               value: '${radioButtonItem['value']}',
              //                                               child: Obx(() {
              //                                                 return Txt(
              //                                                   '${radioButtonItem['title']}',
              //                                                   color: MainController.isLightMode.value
              //                                                       ? whiteColor
              //                                                       : primaryDark,
              //                                                 );
              //                                               }),
              //                                             ),
              //                                         ],
              //                                         onChanged: (text) {
              //                                           ViewController.request[MainController.tableInfo['columns'][j]['name']] = text;
              //                                         },
              //                                         initalValue: data['initValue'],
              //                                         column: MainController.tableInfo['columns'][j],
              //                                         isSelectedItem: ViewController.request[MainController.tableInfo['columns'][j]['name']] == '' ||
              //                                             ViewController.request[MainController.tableInfo['columns'][j]['name']] == null
              //                                             ? false.obs
              //                                             : true.obs,
              //                                       ),
              //                                     );
              //                                   }
              //                                 },
              //                               ),
              //                             ],
              //                           ),
              //                         ),
              //                         SizedBox(width: 20),
              //                       ],
              //                     ),
              //                   )
              //       else if(MainController.tableInfo['columns'][j]['type'] == 'file')
              //            Row(
              //              children: [
              //                Column(
              //                  crossAxisAlignment: CrossAxisAlignment.start,
              //                  children: [
              //                    Obx(() {
              //                      return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
              //                    }),
              //                    SizedBox(height: 10,),
              //                    Container(
              //                      width: 300,
              //                      child: FormFile(
              //                        columnName: MainController.tableInfo['columns'][j]['name'],
              //                        onChanged: (selecetdFiles) {
              //                          ViewController.request[MainController.tableInfo['columns'][j]['name']] = selecetdFiles;
              //                        },
              //                        filesSelected: ViewCustomController.getselectedFilesMap(MainController.tableInfo['columns'][j]),
              //                        isSeletedFile: ViewController.request[MainController.tableInfo['columns'][j]['name']] == null ? false.obs : true.obs,
              //                        selectedFilesTxt: ViewController.request[MainController.tableInfo['columns'][j]['name']],
              //                        column: MainController.tableInfo['columns'][j],
              //                      ),
              //                    ),
              //                  ],
              //                ),
              //                SizedBox(width: 20,)
              //              ],
              //            )
              //       else if(MainController.tableInfo['columns'][j]['type'] == 'time')
              //            Row(
              //                         children: [
              //                           Column(
              //                             crossAxisAlignment: CrossAxisAlignment.start,
              //                             children: [
              //                               Obx(() {
              //                                 return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
              //                               }),
              //                               SizedBox(height: 10,),
              //                               Container(
              //                                 width: 100,
              //                                 child: TimePickerBox(
              //                                   column: MainController.tableInfo['columns'][j] ,
              //                                   selectedTime: ViewController.request['${MainController.tableInfo['columns'][j]['name']}']!= null ?  ViewCustomController.parseTime(ViewController.request['${MainController.tableInfo['columns'][j]['name']}']):TimeOfDay.now(),
              //                                   isSeletedTime: ViewController.request['${MainController.tableInfo['columns'][j]['name']}']== null || ViewController.request['${MainController.tableInfo['columns'][j]['name']}']== '' ? false.obs : true.obs,
              //                                   onTimeChanged: (time) {
              //                                     ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = time;
              //                                   },
              //                                 ),
              //                               )
              //                             ],
              //                           ),
              //                           SizedBox(width: 20),
              //                         ],
              //                       )
              //
              //   ],
              // ),
              child: Container(
                  child: FutureBuilder<Widget>(
                    future: _future,
                    builder: (BuildContext context,
                        AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Txt(
                            '${AppController.of(context)!.value('error')}: ${snapshot.requireData}');
                      } else {
                        return snapshot.data ?? Container();
                      }
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
