import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/Admin/Logic/Models/order-item.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-checkBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-color.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-date.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-file.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-radio-button.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';

class FormEditOrderItemCustom extends StatefulWidget {

  FormEditOrderItemCustom(this.productItems);
  List<dynamic> productItems;


  @override
  State<FormEditOrderItemCustom> createState() => _FormEditOrderItemCustomState();
}

class _FormEditOrderItemCustomState extends State<FormEditOrderItemCustom> {
  Color? colorChanged;
  Map<String, Future<Map<String, dynamic>>>  _future={};
  Map<String, Future<Map<String, dynamic>>>  _future2={};

  var getDataTable = ViewCustomController.getDataTable('Order_Details');


  void initState() {
    super.initState();
    for (var j = 0; j < getDataTable['columns'].length; j++) {
      // _loadData(getDataTable['columns'][j]);
    }
    // for (var j = 0; j < getDataTable['columns'].length; j++) {
    //   _loadDataRequest();
    // }
  }
  void _loadData(var column) {
    String columnName = column['name'];
    for(var item in OrderItem.orderItemsList.values.toList()){
      String uniqueKey = '${columnName}_${item['id']}';
      if (column['type'] == 'select' ||
          column['type'] == 'radiobutton') {
        _future[uniqueKey] = ViewCustomController.getSelectBoxOrderItemData(column,item);
      }else if(column['type'] == 'multiSelect'){
        _future['${columnName}'] = ViewCustomController.getMultiSelectBoxOrderItemData(column , item);
      }
    }
  }
  void _loadDataRequest() {
    if(getDataTable['columns'].length!=0)
      for (var j = 0; j < getDataTable['columns'].length; j++) {
        String columnName = getDataTable['columns'][j]['title'];
        if (getDataTable['columns'][j]['type'] == 'select' ||
            getDataTable['columns'][j]['type'] == 'radiobutton') {
          _future2['${columnName}'] = ViewCustomController.getSelectBoxOrderItemData(getDataTable['columns'][j] , null);
        }
        else if(getDataTable['columns'][j]['type'] == 'multiSelect'){
          _future2['${columnName}'] = ViewCustomController.getMultiSelectBoxOrderItemData(getDataTable['columns'][j] , null);

        }
      }
  }

  Map<String, Widget> containers = {};

  void _addContainer() {
    setState(() {
      var Id = Uuid().v4();
      String newKey = Id;
      containers[newKey] = buildContainer(newKey);
      OrderItem.orderItemsList2[newKey] = {};
    });
  }

  void _removeContainer(String key) {
    setState(() {
      if(OrderItem.orderItemsList.containsKey(key)){
        OrderItem.orderItemsList.remove(key);
      }
      containers.remove(key);
      OrderItem.orderItemsList2.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration:  BoxDecoration(
              border: Border.all(width: 2,color: MainController.isLightMode.value == true ? whiteColor:primaryDark),
              borderRadius:  BorderRadius.circular(10)
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      _addContainer();
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 20 , left: 20 , top: 10,bottom: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.orange,),
                      child: Center(child: Txt('${AppController.of(context)!.value('surcharge')}')),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Column(
                children: [
                  for(int i=0;i<OrderItem.orderItemsList.values.toList().length;i++)
                    Container(
                      width: size.width,
                      key: ValueKey(OrderItem.orderItemsList.values.toList()[i]['_id']),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     for (var j = 0; j < getDataTable['columns'].length; j++)
                        //       if(getDataTable['columns'][j]['is_show_edit'] == true)
                        //         if (getDataTable['columns'][j]['type'] == 'string' ||
                        //             getDataTable['columns'][j]['type'] == 'Number double' ||
                        //             getDataTable['columns'][j]['type'] == 'Number int' ||
                        //             getDataTable['columns'][j]['type'] == 'mobile' ||
                        //             getDataTable['columns'][j]['type'] == 'email')
                        //           Row(
                        //             children: [
                        //               Container(
                        //                 width: 150,
                        //                 child: Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Obx(() {
                        //                       return Txt(
                        //                         '${getDataTable['columns'][j]['title']}',
                        //                         color: MainController.isLightMode.value == true ? whiteColor : color2,
                        //                       );
                        //                     }),
                        //                     SizedBox(height: 10),
                        //                     Container(
                        //                       width: 80,
                        //                       child: FormTextField(
                        //                         name: '${getDataTable['columns'][j]['title']}',
                        //                         hint: '${getDataTable['columns'][j]['title']}',
                        //                         lable: '',
                        //                         initValue: '${OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] != null ? OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] : ''}',
                        //                         isNumberInt: getDataTable['columns'][j]['type'] == 'Number int' ? true : false,
                        //                         isNumberDouble: getDataTable['columns'][j]['type'] == 'Number double' ? true : false,
                        //                         isEmail: getDataTable['columns'][j]['type'] == 'email' ? true : false,
                        //                         isMobile: getDataTable['columns'][j]['type'] == 'mobile' ? true : false,
                        //                         onChange: (text) {
                        //                           // ViewController.request2['${getDataTable['columns'][j]['name']}'] = text;
                        //                           // print('getDataTable>>>${ViewController.request2['${getDataTable['columns'][j]['name']}']}');
                        //                           // OrderItem.orderItemsList[item['id']] ??= {};
                        //                           OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] = text;
                        //                           print('OrderItem.orderItemsList[item>>>${ OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}']}');
                        //                         },
                        //                         column: getDataTable['columns'][j],
                        //                       ),
                        //                     )
                        //                   ],
                        //                 ),
                        //               ),
                        //               SizedBox(width: 20,)
                        //             ],
                        //           )
                        //         else if (getDataTable['columns'][j]['type'] == 'checkbox')
                        //           Row(
                        //             children: [
                        //               Container(
                        //                 width: 150,
                        //                 child: CheckBox(
                        //                   checkBoxName: '${getDataTable['columns'][j]['title']}',
                        //                   checkBoxTitle: '${getDataTable['columns'][j]['title']}',
                        //                   defaultValue: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'],
                        //                   isClickedBtn: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] == null || OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] == '' ? false.obs : true.obs,
                        //                   onChange: (text) {
                        //                     // ViewController.request2['${getDataTable['columns'][j]['name']}'] = text;
                        //                     // OrderItem.orderItemsList[item['id']] ??= {};
                        //                     OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] = text;
                        //                   },
                        //                   column: getDataTable['columns'][j],
                        //                 ),
                        //               ),
                        //               SizedBox(width: 20,)
                        //             ],
                        //           )
                        //         else if (getDataTable['columns'][j]['type'] == 'color')
                        //             Row(
                        //               children: [
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Obx(() {
                        //                       return Txt(
                        //                         '${getDataTable['columns'][j]['title']}',
                        //                         color: MainController.isLightMode.value == true ? whiteColor : color2,
                        //                       );
                        //                     }),
                        //                     SizedBox(height: 10),
                        //                     Container(
                        //                       child: ColorPickerBox(
                        //                         selectedColor: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] != null
                        //                             ? Color(int.parse('${OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}']}'))
                        //                             : Colors.blue,
                        //                         onChanged: (color) {
                        //                           colorChanged = color;
                        //                           String hexColor = '0x${colorChanged!.value.toRadixString(16).padLeft(8, '0')}';
                        //                           // ViewController.request2['${getDataTable['columns'][j]['name']}'] = hexColor;
                        //                           // OrderItem.orderItemsList[item['id']] ??= {};
                        //                           OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] = hexColor;
                        //                         },
                        //                         column: getDataTable['columns'][j],
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 SizedBox(width: 20,)
                        //               ],
                        //             )
                        //           else if (getDataTable['columns'][j]['type'] == 'date')
                        //               Row(
                        //                 children: [
                        //                   Container(
                        //                     width: 120,
                        //                     child: Column(
                        //                       crossAxisAlignment: CrossAxisAlignment.start,
                        //                       children: [
                        //                         Obx(() {
                        //                           return Txt(
                        //                             '${getDataTable['columns'][j]['title']}',
                        //                             color: MainController.isLightMode.value == true ? whiteColor : color2,
                        //                           );
                        //                         }),
                        //                         SizedBox(height: 10),
                        //                         DateBox(
                        //                           selectedDate: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] != null || OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] != '' ? ViewCustomController.parseDate(OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}']):Jalali.now(),
                        //                           isSeletedDate: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] != null || OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] != '' ? true.obs : false.obs,
                        //                           onDateChanged: (date) {
                        //                             // ViewController.request2['${getDataTable['columns'][j]['name']}'] = date;
                        //                             // OrderItem.orderItemsList[item['id']] ??= {};
                        //                             OrderItem.orderItemsList.values.toList()[i]!['${getDataTable['columns'][j]['name']}'] = date;
                        //                           },
                        //                           column: getDataTable['columns'][j],
                        //                         )
                        //                       ],
                        //                     ),
                        //                   ),
                        //                   SizedBox(width: 20,)
                        //                 ],
                        //               )
                        //             else if (getDataTable['columns'][j]['type'] == 'select')
                        //                 Row(
                        //                   children: [
                        //                     FutureBuilder(
                        //                       future: _future['${getDataTable['columns'][j]['title']}_${OrderItem.orderItemsList.values.toList()[i]['id']}'],
                        //                       builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        //                         if (snapshot.connectionState == ConnectionState.waiting) {
                        //                           return CircularProgressIndicator();
                        //                         } else if (snapshot.hasError) {
                        //                           if (snapshot.data != null) {
                        //                             return Txt('${AppController.of(context)!.value('error')}');
                        //                           } else {
                        //                             return Container();
                        //                           }
                        //                         } else {
                        //                           if (snapshot.hasData) {
                        //                             var data = snapshot.data!;
                        //                             if (data['items'] == null || data['items'].isEmpty) {
                        //                               return Container();
                        //                             } else {
                        //                               return Container(
                        //                                 width:getDataTable['columns'][j]['name'] == 'نام کالا'  ? 150:80,
                        //                                 // width: 150,
                        //                                 // height: 100,
                        //                                 child: Column(
                        //                                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                                   children: [
                        //                                     Obx(() {
                        //                                       return Txt(
                        //                                         '${getDataTable['columns'][j]['title']}',
                        //                                         color: MainController.isLightMode.value == true ? whiteColor : color2,
                        //                                       );
                        //                                     }),
                        //                                     SizedBox(height: 10),
                        //                                     SelectBox(
                        //                                       name: '${getDataTable['columns'][j]['title']}',
                        //                                       column: getDataTable['columns'][j],
                        //                                       items: data['items'].map<DropdownMenuItem<String>>((item) {
                        //                                         return DropdownMenuItem<String>(
                        //                                           value: item['value'].toString(),
                        //                                           child: Obx(() {
                        //                                             return Txt(
                        //                                               '${item['title']}',
                        //                                               color: MainController.isLightMode.value == true ? whiteColor : primaryDark,
                        //                                             );
                        //                                           }),
                        //                                         );
                        //                                       }).toList(),
                        //                                       initalValue: data['initValue'],
                        //                                       onChanged: (value) async {
                        //                                         // OrderItem.orderItemsList[item['id']] ??= {};
                        //                                         for (var item in data['items']) {
                        //                                           if (item['title'] == value) {
                        //                                             if (item['value'] == '-1') {
                        //                                               value = null;
                        //                                             }
                        //                                           }
                        //                                         }
                        //                                         if (value != '-1') {
                        //                                           OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] = value;
                        //                                         } else {
                        //                                           OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] = '';
                        //                                         }
                        //                                       },
                        //                                       hintText: data['hint'],
                        //                                       isSeleted: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] == '' ||OrderItem.orderItemsList.values.toList()[i]!['${getDataTable['columns'][j]['name']}'] == null ? false.obs : true.obs,
                        //                                       selectedValue: '',
                        //                                     ),
                        //                                   ],
                        //                                 ),
                        //                               );
                        //                             }
                        //                           } else {
                        //                             return Container();
                        //                           }
                        //                         }
                        //                       },
                        //                     ),
                        //                     SizedBox(width: 20,)
                        //                   ],
                        //                 )
                        //               else if (getDataTable['columns'][j]['type'] == 'multiSelect')
                        //                   Row(
                        //                     children: [
                        //                       Column(
                        //                         crossAxisAlignment: CrossAxisAlignment.start,
                        //                         children: [
                        //                           Obx(() {
                        //                             return Txt(
                        //                               '${getDataTable['columns'][j]['title']}',
                        //                               color: MainController.isLightMode.value == true ? whiteColor : color2,
                        //                             );
                        //                           }),
                        //                           SizedBox(height: 10),
                        //                           Container(
                        //                             width: 250,
                        //                             child: FutureBuilder(
                        //                               future: _future[getDataTable['columns'][j]['title']],
                        //                               builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        //                                 if (snapshot.connectionState == ConnectionState.waiting) {
                        //                                   return CircularProgressIndicator();
                        //                                 } else if (snapshot.hasError) {
                        //                                   if (snapshot.data != null) {
                        //                                     return Txt('${AppController.of(context)!.value('error')}');
                        //                                   } else {
                        //                                     return Container();
                        //                                   }
                        //                                 } else {
                        //                                   var data = snapshot.data!;
                        //                                   return data['items'].length != 0
                        //                                       ? Obx(() {
                        //                                     return Container(
                        //                                       width: 250,
                        //                                       child: MultiSelectDropdown(
                        //                                         items: [
                        //                                           for (var item in data['items'])
                        //                                             DropdownMenuItem(
                        //                                               value: item['value'],
                        //                                               child: Obx(() {
                        //                                                 return Row(
                        //                                                   children: [
                        //                                                     Container(
                        //                                                       height: 100,
                        //                                                       child: SizedBox(
                        //                                                         width: 50,
                        //                                                         height: 50,
                        //                                                         child: Checkbox(
                        //                                                           activeColor: colorBtn,
                        //                                                           value: data['selectedItemsList'].contains(item['value']),
                        //                                                           onChanged: (isChecked) {
                        //                                                             if (isChecked != null) {
                        //                                                               if (!data['selectedItemsList'].contains(item['value'])) {
                        //                                                                 data['selectedItemsList'].add(item['value']);
                        //                                                               } else {
                        //                                                                 data['selectedItemsList'].remove(item['value']);
                        //                                                               }
                        //                                                               if (item['value'] == '-1') {
                        //                                                                 data['selectedItemsList'].remove(item['value']);
                        //                                                               }
                        //                                                               if (data['selectedItemsList'].isEmpty) {
                        //                                                                 data['isSelectedItem'].value = false;
                        //                                                               } else {
                        //                                                                 data['isSelectedItem'].value = true;
                        //                                                               }
                        //                                                               data['hintTxt'].value = ViewController.hintMultiSelectBox(data['items'], data['selectedItemsList']);
                        //                                                               OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] = data['selectedItemsList'];
                        //                                                             }
                        //                                                           },
                        //                                                         ),
                        //                                                       ),
                        //                                                     ),
                        //                                                     Txt(item['title'], color: MainController.isLightMode.value ? whiteColor : primaryDark),
                        //                                                   ],
                        //                                                 );
                        //                                               }),
                        //                                             ),
                        //                                         ],
                        //                                         hintText: data['hintTxt'].value.isNotEmpty ? data['hintTxt'].value : data['items'][0]['title'],
                        //                                         selectedItems: data['selectedItemsList'],
                        //                                         isSelectedItem: data['isSelectedItem'],
                        //                                         onChanged: (selectedList) {
                        //                                           data['selectedItemsList'].value = selectedList;
                        //                                           // OrderItem.orderItemsList[item['id']] ??= {};
                        //                                           OrderItem.orderItemsList.values.toList()[i]![getDataTable['columns'][j]['name']] = selectedList;
                        //                                           data['hintTxt'].value = ViewController.hintMultiSelectBox(data['items'], selectedList);
                        //                                         },
                        //                                         column: getDataTable['columns'][j],
                        //                                       ),
                        //                                     );
                        //                                   })
                        //                                       : Container();
                        //                                 }
                        //                               },
                        //                             ),
                        //                           )
                        //                         ],
                        //                       ),
                        //                       SizedBox(width: 20,)
                        //                     ],
                        //                   )
                        //                 else if (getDataTable['columns'][j]['type'] == 'radiobutton')
                        //                     Row(
                        //                       children: [
                        //                         FutureBuilder(
                        //                           future: _future[getDataTable['columns'][j]['title']],
                        //                           builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        //                             if (snapshot.connectionState == ConnectionState.waiting) {
                        //                               return CircularProgressIndicator();
                        //                             } else if (snapshot.hasError) {
                        //                               if (snapshot.data != null) {
                        //                                 return Txt('${AppController.of(context)!.value('error')}');
                        //                               } else {
                        //                                 return Container();
                        //                               }
                        //                             } else {
                        //                               var data = snapshot.data!;
                        //                               return Column(
                        //                                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                                 children: [
                        //                                   Obx(() {
                        //                                     return Txt(
                        //                                       '${getDataTable['columns'][j]['title']}',
                        //                                       color: MainController.isLightMode.value == true ? whiteColor : color2,
                        //                                     );
                        //                                   }),
                        //                                   SizedBox(height: 10),
                        //                                   Container(
                        //                                     width:150,
                        //                                     child: RadioButton(
                        //                                       name: '',
                        //                                       radioButtonItems: [
                        //                                         for (var radioButtonItem in data['items'])
                        //                                           FormBuilderChipOption(
                        //                                             value: '${radioButtonItem['value']}',
                        //                                             child: Obx(() {
                        //                                               return Txt(
                        //                                                 '${radioButtonItem['title']}',
                        //                                                 color: MainController.isLightMode.value ? whiteColor : primaryDark,
                        //                                               );
                        //                                             }),
                        //                                           ),
                        //                                       ],
                        //                                       onChanged: (text) {
                        //                                         OrderItem.orderItemsList.values.toList()[i]!['${getDataTable['columns'][j]['name']}'] = text;
                        //                                       },
                        //                                       initalValue: data['initValue'],
                        //                                       column: getDataTable['columns'][j],
                        //                                       isSelectedItem: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] == '' ? false.obs : true.obs,
                        //                                     ),
                        //                                   ),
                        //                                 ],
                        //                               );
                        //                             }
                        //                           },
                        //                         ),
                        //                         SizedBox(width: 20,)
                        //                       ],
                        //                     )
                        //                   else if (getDataTable['columns'][j]['type'] == 'file')
                        //                       Row(
                        //                         children: [
                        //                           Column(
                        //                             crossAxisAlignment: CrossAxisAlignment.start,
                        //                             children: [
                        //                               Obx(() {
                        //                                 return Txt(
                        //                                   '${getDataTable['columns'][j]['title']}',
                        //                                   color: MainController.isLightMode.value == true ? whiteColor : color2,
                        //                                 );
                        //                               }),
                        //                               SizedBox(height: 10),
                        //                               Container(
                        //                                 width: 500,
                        //                                 child: FormFile(
                        //                                   fileInfo: <String, List<dynamic>>{}.obs,
                        //                                   columnName: getDataTable['columns'][j]['title'],
                        //                                   onChanged: (selecetdFiles) {
                        //                                     OrderItem.orderItemsList.values.toList()[i]!['${getDataTable['columns'][j]['name']}'] = selecetdFiles;
                        //                                   },
                        //                                   filesSelected: ViewCustomController.getselectedFilesMap(getDataTable['columns'][j]),
                        //                                   isSeletedFile: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] == null || OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] == '' ? false.obs : true.obs,
                        //                                   selectedFilesTxt: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'],
                        //                                   column: getDataTable['columns'][j],
                        //                                 ),
                        //                               ),
                        //                             ],
                        //                           ),
                        //                           SizedBox(width: 20,)
                        //                         ],
                        //                       ),
                        //     Column(
                        //       children: [
                        //         Obx((){
                        //           return Txt('${AppController.of(context)!.value('remove')}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
                        //         }),
                        //         SizedBox(height: 20,),
                        //         InkWell(
                        //           onTap: (){
                        //             print('item delete>>>${OrderItem.orderItemsList.values.toList()[i]}');
                        //             _removeContainer(OrderItem.orderItemsList.values.toList()[i]['id']);
                        //           },
                        //           child: Container(
                        //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.pinkAccent,),
                        //             padding: EdgeInsets.only(right: 20 , left: 20 , top: 10,bottom: 10),
                        //             child: Txt('${AppController.of(context)!.value('remove')}'),
                        //           ),
                        //         ),
                        //       ],
                        //     )
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   child: FutureBuilder<Widget>(
                            //     future: _futureWidget2,
                            //     builder: (BuildContext context,
                            //         snapshot) {
                            //       if (snapshot.connectionState ==
                            //           ConnectionState.waiting) {
                            //         return CircularProgressIndicator();
                            //       } else if (snapshot.hasError) {
                            //         return Txt(
                            //             '${AppController.of(context)!.value('error')}: ${snapshot.requireData}');
                            //       } else {
                            //         return snapshot.data ?? Container();
                            //       }
                            //     },
                            //   ),
                            // ),
                            // FutureBuilder<Widget>(
                            //   future: ViewCustomController.generateStoreFormOrderItemView(getDataTable['columns'] , key),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.connectionState == ConnectionState.waiting) {
                            //       return SizedBox(
                            //         width: 200,
                            //         child: Center(child: CircularProgressIndicator()),
                            //       );
                            //     } else if (snapshot.hasError) {
                            //       return Txt('${AppController.of(context)!.value('error')}');
                            //     } else {
                            //       return snapshot.data ?? Container();
                            //     }
                            //   },
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Txt(
                                    'نام کالا',
                                    color: MainController.isLightMode.value == true
                                        ? whiteColor
                                        : color2,
                                  );
                                }),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 250,
                                  child: SelectBox(
                                      name: 'نام کالا',
                                      maxHeight: 30,
                                      column: MainController.getDetailsOfField('Order_Details' , 'Product'),
                                      items: [
                                        DropdownMenuItem(
                                            child: Obx(() {
                                              return Txt(
                                                '${AppController.of(Get.context!)!.value('not selected')}',
                                                color: MainController.isLightMode.value == true
                                                    ? whiteColor
                                                    : primaryDark,
                                                fontSize: 13,
                                              );
                                            }),
                                            value: ''),
                                        for (var item in widget.productItems)
                                          DropdownMenuItem(
                                              child: Obx(() {
                                                return Txt(
                                                  '${ViewController.itemsShowSelectItem(item, MainController.getDetailsOfField('Order_Details' , 'Product_Name'))}',
                                                  color:
                                                  MainController.isLightMode.value == true
                                                      ? whiteColor
                                                      : primaryDark,
                                                );
                                              }),
                                              value: item['_id'].toString()),
                                      ],
                                      initalValue: '${OrderItem.orderItemsList.values.toList()[i]['Product_Name'] != null  ? OrderItem.orderItemsList.values.toList()[i]['Product_Name'] : ''}',
                                      onChanged: (value) async {
                                        print('value aaaa>>>${value}');
                                        if (value != '') {
                                          // OrderItem.orderItemsList[key]!['Product_Name'] = value;
                                          OrderItem.orderItemsList.values.toList()[i]['Product_Name']  = value;
                                        } else {
                                          // OrderItem.orderItemsList[key]!['Product_Name'] = '';
                                          OrderItem.orderItemsList.values.toList()[i]['Product_Name']  = '';
                                        }
                                        // print('request of custom select>>>${OrderItem.orderItemsList[key]!['Product']}');
                                      },
                                      hintText: '',
                                      isSeleted: false.obs,
                                      selectedValue: ''),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Txt(
                                    'قیمت',
                                    color:
                                    MainController.isLightMode.value == true ? whiteColor : color2,
                                  );
                                }),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 100,
                                  child: FormTextField(
                                    name: 'قیمت',
                                    hint: 'قیمت',
                                    lable: '',
                                    initValue: '${OrderItem.orderItemsList.values.toList()[i]['Price']}',
                                    isNumberDouble:true,
                                    height: 40,
                                    column: MainController.getDetailsOfField('Order_Details' , 'Price'),
                                    onChange: (text) {
                                      // dataJson[columnName] = text;
                                      if (text != null && text != '') {
                                        // OrderItem.orderItemsList[key]!['Price'] = double.parse('${text}');
                                        OrderItem.orderItemsList.values.toList()[i]['Price']  = double.parse('${text}');
                                      } else {
                                        // OrderItem.orderItemsList[key]!['Price']= '';
                                        OrderItem.orderItemsList.values.toList()[i]['Price']  = '';
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Txt(
                                    'بعد اول',
                                    color:
                                    MainController.isLightMode.value == true ? whiteColor : color2,
                                  );
                                }),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 60,
                                  child: FormTextField(
                                    name: 'بعد اول',
                                    hint: 'بعد اول',
                                    lable: '',
                                    height: 40,
                                    initValue: '${OrderItem.orderItemsList.values.toList()[i]['First_Dimension'] != null ?
                                    OrderItem.orderItemsList.values.toList()[i]['First_Dimension']:''}',
                                    isNumberInt:true,
                                    column: MainController.getDetailsOfField('Order_Details' , 'First_Dimension'),
                                    onChange: (text) {
                                      // dataJson[columnName] = text;
                                      if (text != null && text != '') {
                                        // OrderItem.orderItemsList[key]!['First_Dimension'] = double.parse('${text}');
                                        OrderItem.orderItemsList.values.toList()[i]['First_Dimension'] = double.parse('${text}');
                                      } else {
                                        // OrderItem.orderItemsList[key]!['First_Dimension']= '';
                                        OrderItem.orderItemsList.values.toList()[i]['First_Dimension'] = '';
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Txt(
                                    'بعد دوم',
                                    color:
                                    MainController.isLightMode.value == true ? whiteColor : color2,
                                  );
                                }),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 60,
                                  child: FormTextField(
                                    name: 'بعد دوم',
                                    hint: 'بعد دوم',
                                    lable: '',
                                    height: 40,
                                    isNumberInt:true,
                                    initValue: '${OrderItem.orderItemsList.values.toList()[i]['Second_Dimension'] != null ?
                                    OrderItem.orderItemsList.values.toList()[i]['Second_Dimension']:''}',
                                    column: MainController.getDetailsOfField('Order_Details' , 'Second_Dimension'),
                                    onChange: (text) {
                                      // dataJson[columnName] = text;
                                      if (text != null && text != '') {
                                        // OrderItem.orderItemsList[key]!['Second_Dimension'] = double.parse('${text}');
                                        OrderItem.orderItemsList.values.toList()[i]['Second_Dimension'] = double.parse('${text}');
                                      } else {
                                        // OrderItem.orderItemsList[key]!['Second_Dimension']= '';
                                        OrderItem.orderItemsList.values.toList()[i]['Second_Dimension'] = '';

                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Txt(
                                    'جمع متراژ',
                                    color:
                                    MainController.isLightMode.value == true ? whiteColor : color2,
                                  );
                                }),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 70,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Txt('0', color: MainController.isLightMode.value == true ? whiteColor : color2,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Txt(
                                    'تعداد',
                                    color:
                                    MainController.isLightMode.value == true ? whiteColor : color2,
                                  );
                                }),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 60,
                                  child: FormTextField(
                                    name: 'تعداد',
                                    hint: 'تعداد',
                                    lable: '',
                                    height: 40,
                                    isNumberInt:true,
                                    column: MainController.getDetailsOfField('Order_Details' , 'Quantity'),
                                    initValue: OrderItem.orderItemsList.values.toList()[i]['Quantity'].toString() != null ?
                                    OrderItem.orderItemsList.values.toList()[i]['Quantity'].toString() : '',
                                    onChange: (text) {
                                      // dataJson[columnName] = text;
                                      if (text != null && text != '') {
                                        // OrderItem.orderItemsList[key]!['Quantity'] = int.parse('${text}');
                                        OrderItem.orderItemsList.values.toList()[i]['Quantity'] = int.parse('${text}');
                                      } else {
                                        // OrderItem.orderItemsList[key]!['Quantity']= '';
                                        OrderItem.orderItemsList.values.toList()[i]['Quantity'] = '';

                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Txt(
                                    'الگوی بری',
                                    color: MainController.isLightMode.value == true
                                        ? whiteColor
                                        : color2,
                                  );
                                }),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 40,
                                  child: SelectBox(
                                      name: 'الگوی بری',
                                      maxHeight: 30,
                                      column: MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern'),
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
                                        for (var item in MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern')['items'])
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
                                      initalValue: '${OrderItem.orderItemsList.values.toList()[i]['Cut_Pattern'] != null ?
                                      OrderItem.orderItemsList.values.toList()[i]['Cut_Pattern'] : ''}',
                                      onChanged: (value) async {
                                        print('value aaaa>>>${value}');
                                        if (value != '') {
                                          // ViewController.request['Cut_Pattern'] = value;
                                          OrderItem.orderItemsList.values.toList()[i]['Cut_Pattern'] = value;
                                        } else {
                                          // ViewController.request['Cut_Pattern'] = '';
                                          OrderItem.orderItemsList.values.toList()[i]['Cut_Pattern'] = '';
                                        }
                                      },
                                      hintText: '',
                                      isSeleted: false.obs,
                                      selectedValue: ''),
                                )
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Txt(
                                    'سختی تولید',
                                    color: MainController.isLightMode.value == true
                                        ? whiteColor
                                        : color2,
                                  );
                                }),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 40,
                                  child: SelectBox(
                                      name: 'سختی تولید',
                                      maxHeight: 30,
                                      column: MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty'),
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
                                        for (var item in MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty')['items'])
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
                                      initalValue: '${OrderItem.orderItemsList.values.toList()[i]['Manufacturing_Difficulty'] != null ?
                                      OrderItem.orderItemsList.values.toList()[i]['Manufacturing_Difficulty']:''}',
                                      onChanged: (value) async {
                                        print('value aaaa>>>${value}');
                                        if (value != '') {
                                          // ViewController.request['Manufacturing_Difficulty'] = value;
                                          OrderItem.orderItemsList.values.toList()[i]['Manufacturing_Difficulty'] = value;
                                        } else {
                                          // ViewController.request['Manufacturing_Difficulty'] = '';
                                          OrderItem.orderItemsList.values.toList()[i]['Manufacturing_Difficulty'] = '';
                                        }
                                      },
                                      hintText: '',
                                      isSeleted: false.obs,
                                      selectedValue: ''),
                                )
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Txt(
                                    'بلوک',
                                    color:
                                    MainController.isLightMode.value == true ? whiteColor : color2,
                                  );
                                }),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 70,
                                  child: FormTextField(
                                    name: 'بلوک',
                                    hint: 'بلوک',
                                    lable: '',
                                    height: 40,
                                    isNumberInt:true,
                                    initValue: '${OrderItem.orderItemsList.values.toList()[i]['Block'] != null ?
                                    OrderItem.orderItemsList.values.toList()[i]['Block']:''}',
                                    column: MainController.getDetailsOfField('Order_Details' , 'Block'),
                                    onChange: (text) {
                                      // dataJson[columnName] = text;
                                      if (text != null && text != '') {
                                        // OrderItem.orderItemsList[key]!['Block'] = int.parse('${text}');
                                      } else {
                                        // OrderItem.orderItemsList[key]!['Block']= '';

                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Txt(
                                    'طبقه',
                                    color:
                                    MainController.isLightMode.value == true ? whiteColor : color2,
                                  );
                                }),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 70,
                                  child: FormTextField(
                                    name: 'طبقه',
                                    hint: 'طبقه',
                                    lable: '',
                                    height: 40,
                                    isNumberInt:true,
                                    initValue: '${OrderItem.orderItemsList.values.toList()[i]['Level'] != null ?
                                    OrderItem.orderItemsList.values.toList()[i]['Level']:''}',
                                    column: MainController.getDetailsOfField('Order_Details' , 'Level'),
                                    onChange: (text) {
                                      if (text != null && text != '') {
                                        // OrderItem.orderItemsList[key]!['Level'] = int.parse('${text}');
                                        OrderItem.orderItemsList.values.toList()[i]['Level'] = int.parse('${text}');
                                      } else {
                                        // OrderItem.orderItemsList[key]!['Level']= '';
                                        OrderItem.orderItemsList.values.toList()[i]['Level'] = '';

                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Txt(
                                    'واحد',
                                    color:
                                    MainController.isLightMode.value == true ? whiteColor : color2,
                                  );
                                }),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 70,
                                  child: FormTextField(
                                    name: 'واحد',
                                    hint: 'واحد',
                                    lable: '',
                                    isNumberInt:true,
                                    initValue: '${OrderItem.orderItemsList.values.toList()[i]['Unit'] != null ?
                                    OrderItem.orderItemsList.values.toList()[i]['Unit']:''}',
                                    height: 40,
                                    column: MainController.getDetailsOfField('Order_Details' , 'Unit'),
                                    onChange: (text) {
                                      if (text != null && text != '') {
                                        // OrderItem.orderItemsList[key]!['Unit'] = int.parse('${text}');
                                        OrderItem.orderItemsList.values.toList()[i]['Unit'] = int.parse('${text}');
                                      } else {
                                        // OrderItem.orderItemsList[key]!['Unit']= '';
                                        OrderItem.orderItemsList.values.toList()[i]['Unit'] = '';
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Txt(
                                    'جمع مبلغ',
                                    color:
                                    MainController.isLightMode.value == true ? whiteColor : color2,
                                  );
                                }),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Txt('0', color: MainController.isLightMode.value == true ? whiteColor : color2,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              children: [
                                Obx((){
                                  return Txt('${AppController.of(context)!.value('remove')}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
                                }),
                                SizedBox(height: 20,),
                                InkWell(
                                  onTap: (){
                                    // _removeContainer(key);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.pinkAccent,),
                                    padding: EdgeInsets.only(right: 20 , left: 20 , top: 10,bottom: 10),
                                    child: Txt('${AppController.of(context)!.value('remove')} '),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        )
                      ),
                    ),
                ],
              ),
              Container(
                child: Column(
                  children: [
                    for (var key in containers.keys)
                      containers[key]!,
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget buildContainer(String key) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      key: ValueKey(key),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'نام کالا',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 250,
                  child: SelectBox(
                      name: 'نام کالا',
                      maxHeight: 30,
                      column: MainController.getDetailsOfField('Order_Details' , 'Product'),
                      items: [
                        DropdownMenuItem(
                            child: Obx(() {
                              return Txt(
                                '${AppController.of(Get.context!)!.value('not selected')}',
                                color: MainController.isLightMode.value == true
                                    ? whiteColor
                                    : primaryDark,
                                fontSize: 13,
                              );
                            }),
                            value: ''),
                        for (var item in widget.productItems)
                          DropdownMenuItem(
                              child: Obx(() {
                                return Txt(
                                  '${ViewController.itemsShowSelectItem(item, MainController.getDetailsOfField('Order_Details' , 'Product_Name'))}',
                                  color:
                                  MainController.isLightMode.value == true
                                      ? whiteColor
                                      : primaryDark,
                                );
                              }),
                              value: item['_id'].toString()),
                      ],
                      initalValue: '${OrderItem.orderItemsList2[key]?['Product_Name'] ?? ''}',
                      onChanged: (value) async {
                        print('value aaaa>>>${value}');
                        if (value != '') {
                          // OrderItem.orderItemsList[key]!['Product_Name'] = value;

                          OrderItem.orderItemsList2[key]?['Product_Name']  = value;
                        } else {
                          // OrderItem.orderItemsList[key]!['Product_Name'] = '';
                          OrderItem.orderItemsList2[key]?['Product_Name']  = '';
                        }
                        // print('request of custom select>>>${OrderItem.orderItemsList[key]!['Product']}');
                      },
                      hintText: '',
                      isSeleted: false.obs,
                      selectedValue: ''),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'قیمت',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 100,
                  child: FormTextField(
                    name: 'قیمت',
                    hint: 'قیمت',
                    lable: '',
                    initValue: '${OrderItem.orderItemsList2[key]?['Price'] ?? ''}',
                    isNumberDouble:true,
                    height: 40,
                    column: MainController.getDetailsOfField('Order_Details' , 'Price'),
                    onChange: (text) {
                      // dataJson[columnName] = text;
                      if (text != null && text != '') {
                        // OrderItem.orderItemsList[key]!['Price'] = double.parse('${text}');
                        OrderItem.orderItemsList2[key]?['Price']  = double.parse('${text}');
                      } else {
                        // OrderItem.orderItemsList[key]!['Price']= '';
                        OrderItem.orderItemsList2[key]?['Price']  = '';
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'بعد اول',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 60,
                  child: FormTextField(
                    name: 'بعد اول',
                    hint: 'بعد اول',
                    lable: '',
                    height: 40,
                    initValue: '${OrderItem.orderItemsList2[key]?['First_Dimension'] ?? ''}',
                    isNumberInt:true,
                    column: MainController.getDetailsOfField('Order_Details' , 'First_Dimension'),
                    onChange: (text) {
                      // dataJson[columnName] = text;
                      if (text != null && text != '') {
                        // OrderItem.orderItemsList[key]!['First_Dimension'] = double.parse('${text}');
                        OrderItem.orderItemsList2[key]?['First_Dimension'] = double.parse('${text}');
                      } else {
                        // OrderItem.orderItemsList[key]!['First_Dimension']= '';
                        OrderItem.orderItemsList2[key]?['First_Dimension'] = '';
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'بعد دوم',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 60,
                  child: FormTextField(
                    name: 'بعد دوم',
                    hint: 'بعد دوم',
                    lable: '',
                    height: 40,
                    isNumberInt:true,
                    initValue: '${OrderItem.orderItemsList2[key]?['Second_Dimension'] ?? ''}',
                    column: MainController.getDetailsOfField('Order_Details' , 'Second_Dimension'),
                    onChange: (text) {
                      // dataJson[columnName] = text;
                      if (text != null && text != '') {
                        // OrderItem.orderItemsList[key]!['Second_Dimension'] = double.parse('${text}');
                        OrderItem.orderItemsList2[key]?['Second_Dimension'] = double.parse('${text}');
                      } else {
                        // OrderItem.orderItemsList[key]!['Second_Dimension']= '';
                        OrderItem.orderItemsList2[key]?['Second_Dimension'] = '';

                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'جمع متراژ',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Txt('0', color: MainController.isLightMode.value == true ? whiteColor : color2,),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'تعداد',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 60,
                  child: FormTextField(
                    name: 'تعداد',
                    hint: 'تعداد',
                    lable: '',
                    height: 40,
                    isNumberInt:true,
                    column: MainController.getDetailsOfField('Order_Details' , 'Quantity'),
                    initValue: '${OrderItem.orderItemsList2[key]?['Quantity'] ?? ''}',
                    onChange: (text) {
                      // dataJson[columnName] = text;
                      if (text != null && text != '') {
                        // OrderItem.orderItemsList[key]!['Quantity'] = int.parse('${text}');
                        OrderItem.orderItemsList2[key]?['Quantity'] = int.parse('${text}');
                      } else {
                        // OrderItem.orderItemsList[key]!['Quantity']= '';
                        OrderItem.orderItemsList2[key]?['Quantity'] = '';

                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'الگوی بری',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 40,
                  child: SelectBox(
                      name: 'الگوی بری',
                      maxHeight: 30,
                      column: MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern'),
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
                        for (var item in MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern')['items'])
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
                      initalValue: '${OrderItem.orderItemsList2[key]?['Cut_Pattern'] ?? ''}',
                      onChanged: (value) async {
                        print('value aaaa>>>${value}');
                        if (value != '') {
                          // ViewController.request['Cut_Pattern'] = value;
                          OrderItem.orderItemsList2[key]?['Cut_Pattern'] = value;
                        } else {
                          // ViewController.request['Cut_Pattern'] = '';
                          OrderItem.orderItemsList2[key]?['Cut_Pattern'] = '';
                        }
                      },
                      hintText: '',
                      isSeleted: false.obs,
                      selectedValue: ''),
                )
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'سختی تولید',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 40,
                  child: SelectBox(
                      name: 'سختی تولید',
                      maxHeight: 30,
                      column: MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty'),
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
                        for (var item in MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty')['items'])
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
                      initalValue: '${OrderItem.orderItemsList2[key]?['Manufacturing_Difficulty'] ?? ''}',
                      onChanged: (value) async {
                        print('value aaaa>>>${value}');
                        if (value != '') {
                          // ViewController.request['Manufacturing_Difficulty'] = value;
                          OrderItem.orderItemsList2[key]?['Manufacturing_Difficulty'] = value;
                        } else {
                          // ViewController.request['Manufacturing_Difficulty'] = '';
                          OrderItem.orderItemsList2[key]?['Manufacturing_Difficulty'] = '';
                        }
                      },
                      hintText: '',
                      isSeleted: false.obs,
                      selectedValue: ''),
                )
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'بلوک',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 70,
                  child: FormTextField(
                    name: 'بلوک',
                    hint: 'بلوک',
                    lable: '',
                    height: 40,
                    isNumberInt:true,
                    initValue: '${OrderItem.orderItemsList2[key]?['Block'] ?? ''}',
                    column: MainController.getDetailsOfField('Order_Details' , 'Block'),
                    onChange: (text) {
                      // dataJson[columnName] = text;
                      if (text != null && text != '') {
                        // OrderItem.orderItemsList[key]!['Block'] = int.parse('${text}');
                        OrderItem.orderItemsList2[key]?['Block'] = int.parse('${text}');
                      } else {
                        // OrderItem.orderItemsList[key]!['Block']= '';
                        OrderItem.orderItemsList2[key]?['Block'] = '';

                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'طبقه',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 70,
                  child: FormTextField(
                    name: 'طبقه',
                    hint: 'طبقه',
                    lable: '',
                    height: 40,
                    isNumberInt:true,
                    initValue: '${OrderItem.orderItemsList2[key]?['Level'] ?? ''}',
                    column: MainController.getDetailsOfField('Order_Details' , 'Level'),
                    onChange: (text) {
                      if (text != null && text != '') {
                        // OrderItem.orderItemsList[key]!['Level'] = int.parse('${text}');
                        OrderItem.orderItemsList2[key]?['Level'] = int.parse('${text}');
                      } else {
                        // OrderItem.orderItemsList[key]!['Level']= '';
                        OrderItem.orderItemsList2[key]?['Level'] = '';

                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'واحد',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 70,
                  child: FormTextField(
                    name: 'واحد',
                    hint: 'واحد',
                    lable: '',
                    isNumberInt:true,
                    initValue: '${OrderItem.orderItemsList2[key]?['Unit'] ?? ''}',
                    height: 40,
                    column: MainController.getDetailsOfField('Order_Details' , 'Unit'),
                    onChange: (text) {
                      if (text != null && text != '') {
                        // OrderItem.orderItemsList[key]!['Unit'] = int.parse('${text}');
                        OrderItem.orderItemsList2[key]?['Unit'] = int.parse('${text}');
                      } else {
                        // OrderItem.orderItemsList[key]!['Unit']= '';
                        OrderItem.orderItemsList2[key]?['Unit'] = '';
                      }
                    },
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'جمع مبلغ',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Txt('0', color: MainController.isLightMode.value == true ? whiteColor : color2,),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              children: [
                Obx((){
                  return Txt('${AppController.of(context)!.value('remove')}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
                }),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    // _removeContainer(key);
                  },
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.pinkAccent,),
                    padding: EdgeInsets.only(right: 20 , left: 20 , top: 10,bottom: 10),
                    child: Txt('${AppController.of(context)!.value('remove')} '),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
