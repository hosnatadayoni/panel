import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
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
import 'package:finance/Admin/UI/Componenets/Items/Form/form-time.dart';
import 'package:finance/Admin/UI/Views/table-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';

class FormEditOrderCustom extends StatefulWidget {

  FormEditOrderCustom({this.data});
  var data;

  @override
  State<FormEditOrderCustom> createState() => _FormEditOrderCustomState();
}

class _FormEditOrderCustomState extends State<FormEditOrderCustom> {
  Color? colorChanged;
  // Map<String, Future<Map<String, dynamic>>>  _future={};
  Map<String , dynamic> dataJson = {};
  late Future<Widget> _future;


  void initState() {
    super.initState();
    // _loadData();
    print('widget.data>>>${widget.data}');
    _future = ViewCustomController.generateEditFormOrderView(widget.data);
  }
  // Future<void> _loadData() async {
  //   for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
  //     String columnName = MainController.tableInfo['columns'][j]['name'];
  //     if (MainController.tableInfo['columns'][j]['type'] == 'select' ||
  //         MainController.tableInfo['columns'][j]['type'] == 'radiobutton') {
  //       _future[columnName] = ViewCustomController.getSelectBoxData(MainController.tableInfo['columns'][j]);
  //     }
  //     if (MainController.tableInfo['columns'][j]['type'] == 'multiSelect') {
  //       // ذخیره Future در متغیر
  //       final multiSelectFuture = ViewCustomController.getMultiSelectBoxData(
  //           MainController.tableInfo['columns'][j],
  //           dataModel: widget.data
  //       );
  //
  //       // اختصاص Future به map
  //       _future[columnName] = multiSelectFuture;
  //
  //       // چاپ نتیجه پس از resolve شدن Future
  //       final result = await multiSelectFuture;
  //       print('csdfffgga>>>${result['items']}');
  //     }
  //   }
  // }


  @override
  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    Rx<bool> isHoverBtnBack = false.obs;
    print('form edit order custom');
    print('this.data d>>>${widget.data}');
    return  Container(
      width: size.width,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(10),
              width: size.width,
              child: Wrap(
                // mainAxisAlignment: MainAxisAlignment.end,
                alignment: WrapAlignment.end,
                children: [
                  MouseRegion(
                    onEnter: (_){
                      isHoverBtnBack.value = true;
                    },
                    onExit: (_){
                      isHoverBtnBack.value = false;
                    },
                    child: InkWell(
                      onTap: (){
                        MainController.isClickedItem.value = true;
                        Get.to(() => TablePage());
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: colorBtn , width: 1),
                          color: isHoverBtnBack.value == false ? Colors.transparent : colorBtn,
                        ),
                        child: Txt('${AppController.of(context)!.value('back')}' , color:isHoverBtnBack.value == false ? colorBtn : whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  InkWell(
                    onTap: ()async{
                      // await DB('order').where('id', '\$eq', '${widget.data!['id']}').updateRecord(ViewController.request);

                      // var orderItems=await DB('order-itemss').where('parent_id', '\$eq', '${widget.data!['id']}').getRecords();
                      var orderItems=await DB('itemsOrder2').where('parent_id', '\$eq', '${widget.data!['_id']}').getRecords();
                      for(var orderItem in  orderItems){
                        if(OrderItem.orderItemsList.containsKey(orderItem['_id'])){
                            // DB('order-itemss').where('id', '\$eq', '${orderItem['id']}').updateRecord(OrderItem.orderItemsList[orderItem['id']]);
                          DB('itemsOrder2').where('id', '\$eq', '${orderItem['_id']}').updateRecord(OrderItem.orderItemsList[orderItem['_id']]);
                        }
                        else{
                          // DB('order-itemss').where('id', '\$eq', '${orderItem['id']}').deleteRecord();
                          DB('itemsOrder2').where('id', '\$eq', '${orderItem['_id']}').deleteRecord();
                        }
                      }
                      if (OrderItem.orderItemsList2.values.length != 0) {
                          for (var list in OrderItem.orderItemsList2.values) {
                            if(list.isNotEmpty){
                            // await DB('order-itemss').parent(parentId:'${widget.data['id']}' ,parentTable: 'order').storeRecord(list);
                              await DB('itemsOrder2').parent(parentId:'${widget.data['_id']}' ,parentTable: 'order3').storeRecord(list);

                            }
                          }
                        }
                      await MainController.loadData(tableData:ViewCustomController.getDataTable('order3') );
                      // MainController.renderPagination();
                      // MainController.goToTablePage();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: colorBtn,
                      ),
                      child: Txt('${AppController.of(context)!.value('edit')}' , color:whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
                    ),
                  ),
                ],
              )
          ),
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
              // child: Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   // runSpacing: 5,
              //   // spacing: 20,
              //   children: [
              //     for (var j = 0; j < MainController.tableInfo['columns'].length; j++)
              //        if (MainController.tableInfo['columns'][j]['type'] == 'string' ||
              //           MainController.tableInfo['columns'][j]['type'] == 'number' ||
              //           MainController.tableInfo['columns'][j]['type'] == 'mobile'||
              //           MainController.tableInfo['columns'][j]['type'] == 'email'
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
              //                   // width: 150,
              //                   // height: 100,
              //                   child: FormTextField(
              //                     name: '${MainController.tableInfo['columns'][j]['title']}',
              //                     hint: '${MainController.tableInfo['columns'][j]['title']}',
              //                     lable: '',
              //                     initValue: '${ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] != null ?
              //                     ViewController.request['${MainController.tableInfo['columns'][j]['name']}']:
              //                     ''}',
              //                     isNumberInt:MainController.tableInfo['columns'][j]['type'] == 'Number int' ? true : false ,
              //                     isNumberDouble:MainController.tableInfo['columns'][j]['type'] == 'Number Number double' ? true : false ,
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
              //             SizedBox(width: 20,),
              //           ],
              //         )
              //        else if(MainController.tableInfo['columns'][j]['type'] == 'checkbox')
              //            Row(
              //           children: [
              //             Container(
              //               width: 150,
              //               child: CheckBox(
              //                 checkBoxName: '${MainController.tableInfo['columns'][j]['title']}',
              //                 checkBoxTitle: '${MainController.tableInfo['columns'][j]['title']}',
              //                 defaultValue: ViewController.request['${MainController.tableInfo['columns'][j]['name']}'],
              //                 isClickedBtn: ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] == null || ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] == '' ? false.obs:true.obs,
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
              //        else if(MainController.tableInfo['columns'][j]['type'] == 'color')
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
              //                      child: ColorPickerBox(
              //                        selectedColor: ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] != null
              //                            ? Color(int.parse('${ViewController.request['${MainController.tableInfo['columns'][j]['name']}']}'))
              //                            : Colors.blue,
              //                        isSeletedColor: ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] == null || ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] == '' ? false.obs : true.obs,
              //                        onChanged: (color) {
              //                          colorChanged = color;
              //                          String hexColor =
              //                              '0x${colorChanged!.value.toRadixString(16).padLeft(8, '0')}';
              //                          // dataJson[columnName] = hexColor;
              //                          ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = hexColor;
              //                        },
              //                        column: MainController.tableInfo['columns'][j],
              //                      ),
              //                    ),
              //                  ],
              //                ),
              //                SizedBox(width: 20,),
              //              ],
              //            )
              //        else if(MainController.tableInfo['columns'][j]['type'] == 'date')
              //             Row(
              //               children: [
              //                 Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Obx(() {
              //                       return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
              //                     }),
              //                     SizedBox(height: 10,),
              //                     Container(
              //                       width: 120,
              //                       child:
              //                       DateBox(
              //                         selectedDate:ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] == null || ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] == ''?Jalali.now() : ViewCustomController.parseDate(ViewController.request['${MainController.tableInfo['columns'][j]['name']}']),
              //                         isSeletedDate:ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] == null || ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] == '' ? false.obs : true.obs,
              //                         onDateChanged: (date) {
              //                           ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = date;
              //                         },
              //                         column: MainController.tableInfo['columns'][j],
              //                       )
              //                     )
              //                   ],
              //                 ),
              //                 SizedBox(width: 20,)
              //               ],
              //             )
              //        else if(MainController.tableInfo['columns'][j]['type'] == 'select')
              //             Row(
              //               children: [
              //                 Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Obx(() {
              //                       return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
              //                     }),
              //                     SizedBox(height: 10,),
              //                     FutureBuilder(
              //                         future: _future[MainController.tableInfo['columns'][j]['title']],
              //                         builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
              //                           if (snapshot.connectionState == ConnectionState.waiting) {
              //                             return CircularProgressIndicator();
              //                           } else if (snapshot.hasError) {
              //                             if(snapshot.data != null){
              //                               return Txt('${AppController.of(context)!.value('error')}');
              //                             }
              //                             else{
              //                               return Container();
              //                             }
              //                           }
              //                           else{
              //                             if (snapshot.hasData){
              //                               var data = snapshot.data!;
              //                               return Container(
              //                                 width: MainController.tableInfo['columns'][j]['name'] == 'مشتری'  ? 150:100,
              //                                 // width: 150,
              //                                 // height: 100,
              //                                 child: SelectBox(
              //                                   name: '${MainController.tableInfo['columns'][j]['title']}',
              //                                   column: MainController.tableInfo['columns'][j],
              //                                   items: data['items'].map<DropdownMenuItem<String>>((item) {
              //
              //                                     return DropdownMenuItem<String>(
              //                                       value: item['value'].toString(),
              //                                       child: Obx(() {
              //                                         return Txt(
              //                                           '${item['title']}',
              //                                           color: MainController.isLightMode.value == true
              //                                               ? whiteColor
              //                                               : primaryDark,
              //                                         );
              //                                       }),
              //                                     );
              //                                   }).toList(),
              //                                   initalValue: data['initValue'],
              //                                   onChanged: (value) async {
              //                                     for (var item in data['items']) {
              //                                       if (item['title'] == value) {
              //                                         if (item['value'] == '-1') {
              //                                           value = null;
              //                                         }
              //                                       }
              //                                     }
              //                                     if (value != '-1') {
              //                                       ViewController.request[MainController.tableInfo['columns'][j]['name']] = value;
              //                                     } else {
              //                                       ViewController.request[MainController.tableInfo['columns'][j]['name']] = '';
              //                                     }
              //                                   },
              //                                   hintText: data['hint'],
              //                                   isSeleted: ViewController.request[MainController.tableInfo['columns'][j]['name']] == '' || ViewController.request[MainController.tableInfo['columns'][j]['name']] == null ? false.obs : true.obs,
              //                                   selectedValue: '',
              //                                 ),
              //                               );
              //                             }
              //                             else{
              //                               return Container();
              //                             }
              //                           }
              //                         }
              //                     )
              //                   ],
              //                 ),
              //                 SizedBox(width: 20,)
              //               ],
              //             )
              //        else if(MainController.tableInfo['columns'][j]['type'] == 'multiSelect')
              //              // Row(
              //              //   children: [
              //              //     Column(
              //              //       crossAxisAlignment: CrossAxisAlignment.start,
              //              //       children: [
              //              //         Obx(() {
              //              //           return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
              //              //         }),
              //              //         SizedBox(height: 10,),
              //              //         FutureBuilder(
              //              //           future: _future[MainController.tableInfo['columns'][j]['title']],
              //              //           builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              //              //             if (snapshot.connectionState == ConnectionState.waiting) {
              //              //               return CircularProgressIndicator();
              //              //             } else if (snapshot.hasError) {
              //              //               if(snapshot.data != null){
              //              //                 return Txt('${AppController.of(context)!.value('error')}');
              //              //               }
              //              //               else{
              //              //                 return Container();
              //              //               }
              //              //
              //              //             } else {
              //              //               var data = snapshot.data!;
              //              //               return data['items'].length != 0 ? Obx(() {
              //              //                 return Container(
              //              //                   width: 250,
              //              //                   child: MultiSelectDropdown(
              //              //                     items: [
              //              //                       for (var item in data['items'])
              //              //                         DropdownMenuItem(
              //              //                           value: item['value'],
              //              //                           child: Obx(() {
              //              //                             return Row(
              //              //                               children: [
              //              //                                 Container(
              //              //                                   height: 100,
              //              //                                   child: SizedBox(
              //              //                                     width: 50,
              //              //                                     height: 50,
              //              //                                     child: Checkbox(
              //              //                                       activeColor: colorBtn,
              //              //                                       value: data['selectedItemsList'].contains(item['value']),
              //              //                                       onChanged: (isChecked) {
              //              //                                         if (isChecked != null) {
              //              //                                           if (!data['selectedItemsList'].contains(item['value'])) {
              //              //                                             data['selectedItemsList'].add(item['value']); // اضافه کردن آیتم به لیست
              //              //                                           } else {
              //              //                                             data['selectedItemsList'].remove(item['value']); // حذف آیتم از لیست
              //              //                                           }
              //              //                                           if (item['value'] == '-1') {
              //              //                                             data['selectedItemsList'].remove(item['value']); // حذف آیتم نامعتبر
              //              //                                           }
              //              //                                           if (data['selectedItemsList'].isEmpty) {
              //              //                                             data['isSelectedItem'].value = false;
              //              //                                           } else {
              //              //                                             data['isSelectedItem'].value = true;
              //              //                                           }
              //              //                                           data['hintTxt'].value = ViewController.hintMultiSelectBox(data['items'], data['selectedItemsList']);
              //              //                                           ViewController.request[MainController.tableInfo['columns'][j]['name']] = data['selectedItemsList'];
              //              //                                         }
              //              //                                       },
              //              //                                     ),
              //              //                                   ),
              //              //                                 ),
              //              //                                 Txt(item['title'], color: MainController.isLightMode.value ? whiteColor : primaryDark),
              //              //                               ],
              //              //                             );
              //              //                           }),
              //              //                         ),
              //              //                     ],
              //              //                     hintText: data['hintTxt'].value.isNotEmpty ? data['hintTxt'].value : data['items'][0]['title'],
              //              //                     selectedItems: data['selectedItemsList'],
              //              //                     isSelectedItem: data['isSelectedItem'],
              //              //                     onChanged: (selectedList) {
              //              //                       data['selectedItemsList'].value = selectedList;
              //              //                       ViewController.request[MainController.tableInfo['columns'][j]['name']] = selectedList;
              //              //                       data['hintTxt'].value = ViewController.hintMultiSelectBox(data['items'], selectedList);
              //              //                     },
              //              //                     column: MainController.tableInfo['columns'][j],
              //              //                   ),
              //              //                 );
              //              //               }) : Container();
              //              //             }
              //              //           },
              //              //         )
              //              //       ],
              //              //     ),
              //              //     SizedBox(width: 20,),
              //              //   ],
              //              // )
              //              //     Row(
              //              //       children: [
              //              //         Container(
              //              //           width: 400,
              //              //           child: FutureBuilder<Widget>(
              //              //             future: ViewController.genarateEditFormMuiltiSelectBox(
              //              //                 MainController.tableInfo['columns'][j],
              //              //                 _future[MainController.tableInfo['columns'][j]['name']]?['selectedItemsList']?.isNotEmpty == true
              //              //                     ? RxString(_future[MainController.tableInfo['columns'][j]['name']]?['selectedItemsList']?.join(' , ') ?? '')
              //              //                     : RxString(''),
              //              //                 _future[MainController.tableInfo['columns'][j]['name']]?['items']?.isNotEmpty == true
              //              //                     ? RxList(_future[MainController.tableInfo['columns'][j]['name']]?['items'] ?? [])
              //              //                     : RxList<dynamic>([]),
              //              //                 false.obs
              //              //             ),
              //              //             builder: (context, snapshot) {
              //              //               if (snapshot.connectionState == ConnectionState.waiting) {
              //              //                 return CircularProgressIndicator();
              //              //               } else if (snapshot.hasError) {
              //              //                 return Text('Error loading multi-select');
              //              //               } else {
              //              //                 return snapshot.data ?? Container();
              //              //               }
              //              //             },
              //              //           ),
              //              //         ),
              //              //         SizedBox(width: 20)
              //              //       ],
              //              //     )
              //                  Row(
              //                    children: [
              //                      Column(
              //                        crossAxisAlignment: CrossAxisAlignment.start,
              //                        children: [
              //                          FutureBuilder(
              //                            future: _future[MainController.tableInfo['columns'][j]['name']],
              //                            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              //                              if (snapshot.connectionState == ConnectionState.waiting) {
              //                                return CircularProgressIndicator();
              //                              } else if (snapshot.hasError) {
              //                                if (snapshot.data != null) {
              //                                  return Txt('${AppController.of(context)!.value('error')}');
              //                                } else {
              //                                  return Container();
              //                                }
              //                              } else {
              //                                if (snapshot.hasData) {
              //                                  var data = snapshot.data!;
              //                                  // Check if data['items'] exists and is not empty
              //                                  if (data['items'] != null && data['items'].isNotEmpty) {
              //                                    return Column(
              //                                      crossAxisAlignment: CrossAxisAlignment.start,
              //                                      children: [
              //                                        Container(
              //                                          width: 400,
              //                                          // height: 100,
              //                                          child:Column(
              //                                            crossAxisAlignment: CrossAxisAlignment.start,
              //                                            children: [
              //                                              Obx(() {
              //                                                return Txt(
              //                                                  '${column['title']}',
              //                                                  color: MainController.isLightMode.value == true
              //                                                      ? whiteColor
              //                                                      : color2,
              //                                                );
              //                                              }),
              //                                              Obx(() {
              //                                                return MultiSelectDropdown(
              //                                                  items: [
              //                                                    for (var item in data['items'])
              //                                                      DropdownMenuItem(
              //                                                          value: item['_id'],
              //                                                          child: Obx(() {
              //                                                            return Row(
              //                                                              children: [
              //                                                                Container(
              //                                                                  height: 100,
              //                                                                  child: SizedBox(
              //                                                                      width: 50,
              //                                                                      height: 50,
              //                                                                      child: Obx(() {
              //                                                                        return Checkbox(
              //                                                                            activeColor: colorBtn,
              //                                                                            value: selectedItemId.contains(item['_id']),
              //                                                                            onChanged: (isChecked) {
              //                                                                              if (isChecked != null) {
              //
              //                                                                                data['hintTxt'].value = '';
              //                                                                                if (!data['selectedItemsList'].any((element) => element['_id']==item['_id'])) {
              //                                                                                  requestMultiSelect = item;
              //                                                                                  selectedItemsList.add(item);
              //                                                                                  selectedItemId.add(item['_id']);
              //                                                                                } else {
              //                                                                                  requestMultiSelect.removeWhere((key, value) => value == ['_id']);
              //                                                                                  selectedItemsList.removeWhere( (element) => element['_id']==item['_id']);
              //                                                                                  selectedItemId.remove(item['_id']);
              //                                                                                }
              //                                                                                if (item['_id'] == '') {
              //                                                                                  selectedItemId.value.remove(item['_id']);
              //                                                                                }
              //                                                                                if (selectedItemId.value.length == 0) {
              //                                                                                  isSelectedItem.value = false;
              //                                                                                } else {
              //                                                                                  isSelectedItem.value = true;
              //                                                                                }
              //                                                                                for (var r in selectedItemsList)
              //                                                                                  hintTxt.value = hintTxt.value + itemsShowSelectItem(r, column);
              //                                                                                ViewController.request[column['name']]= selectedItemId;
              //                                                                              }
              //                                                                            });
              //                                                                      })),
              //                                                                ),
              //                                                                Txt(itemsShowSelectItem(item, column),
              //                                                                    color: MainController.isLightMode.value
              //                                                                        ? whiteColor
              //                                                                        : primaryDark),
              //                                                              ],
              //                                                            );
              //                                                          }))
              //                                                  ],
              //                                                  hintText: hintTxt.value != '' || hintTxt.value != null
              //                                                      ? hintTxt.value
              //                                                      : '${AppController.of(Get.context!)!.value('choice')}',
              //                                                  selectedItems: selectedItemsList,
              //                                                  isSelectedItem: isSelectedItem,
              //                                                  column: column,
              //                                                );
              //                                              }),
              //                                            ],
              //                                          ),
              //                                        ),
              //                                      ],
              //                                    );
              //                                  } else {
              //                                    // Return an empty container if data['items'] is empty or null
              //                                    return Container();
              //                                  }
              //                                } else {
              //                                  return Container();
              //                                }
              //                              }
              //                            },
              //                          ),
              //                        ],
              //                      ),
              //                      SizedBox(width: 20,)
              //                    ],
              //                  )
              //        else if(MainController.tableInfo['columns'][j]['type'] == 'radiobutton')
              //              Row(
              //                children: [
              //                  Column(
              //                    crossAxisAlignment: CrossAxisAlignment.start,
              //                    children: [
              //                      Obx(() {
              //                        return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
              //                      }),
              //                      SizedBox(height: 10,),
              //                      FutureBuilder(
              //                          future: _future[MainController.tableInfo['columns'][j]['title']],
              //                          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
              //                            if (snapshot.connectionState == ConnectionState.waiting) {
              //                              return CircularProgressIndicator();
              //                            } else if (snapshot.hasError) {
              //                              if(snapshot.data != null){
              //                                return Txt('${AppController.of(context)!.value('error')}');
              //                              }
              //                              else{
              //                                return Container();
              //                              }
              //                            }
              //                            else{
              //                              var data = snapshot.data!;
              //                              return Column(
              //                                children: [
              //                                  RadioButton(
              //                                    name: '',
              //                                    radioButtonItems: [
              //                                      for (var radioButtonItem in data['items'])
              //                                        FormBuilderChipOption(
              //                                            value: '${radioButtonItem['value']}',
              //                                            child: Obx(() {
              //                                              return Txt(
              //                                                '${radioButtonItem['title']}',
              //                                                color: MainController.isLightMode.value
              //                                                    ? whiteColor
              //                                                    : primaryDark,
              //                                              );
              //                                            })),
              //                                    ],
              //                                    onChanged: (text) {
              //                                      ViewController.request[MainController.tableInfo['columns'][j]['name']] = text;
              //                                      // dataJson[columnName] = selectedRadioButton.value;
              //                                    },
              //                                    initalValue: data['initValue'],
              //                                    column: MainController.tableInfo['columns'][j],
              //                                    isSelectedItem: ViewController.request[MainController.tableInfo['columns'][j]['name']] == '' ? false.obs : true.obs,
              //                                  ),
              //                                  SizedBox(height: 20),
              //                                ],
              //                              );
              //                            }
              //                          }
              //                      )
              //                    ],
              //                  ),
              //                  SizedBox(width: 20,)
              //                ],
              //              )
              //        else if(MainController.tableInfo['columns'][j]['type'] == 'file')
              //               Row(
              //                 children: [
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Obx(() {
              //                         return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
              //                       }),
              //                       SizedBox(height: 10,),
              //                       Container(
              //                         width: 300,
              //                         child: FormFile(
              //                           columnName: MainController.tableInfo['columns'][j]['title'],
              //                           onChanged: (selecetdFiles) {
              //                             ViewController.request[MainController.tableInfo['columns'][j]['name']] = selecetdFiles;
              //                           },
              //                           filesSelected: ViewCustomController.getselectedFilesMap(MainController.tableInfo['columns'][j]),
              //                           selectedFilesTxt: ViewController.request[MainController.tableInfo['columns'][j]['name']],
              //                           isSeletedFile: ViewController.request[MainController.tableInfo['columns'][j]['name']] == null || ViewController.request[MainController.tableInfo['columns'][j]['name']] == ''? false.obs : true.obs,
              //                           column: MainController.tableInfo['columns'][j],
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   SizedBox(width: 20,)
              //                 ],
              //               )
              //        else if(MainController.tableInfo['columns'][j]['type'] == 'time')
              //               Row(
              //                          children: [
              //                            Column(
              //                              crossAxisAlignment: CrossAxisAlignment.start,
              //                              children: [
              //                                Obx(() {
              //                                  return Txt('${MainController.tableInfo['columns'][j]['title']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
              //                                }),
              //                                SizedBox(height: 10,),
              //                                Container(
              //                                  width: 100,
              //                                  child: TimePickerBox(
              //                                    column: MainController.tableInfo['columns'][j] ,
              //                                    selectedTime: ViewController.request['${MainController.tableInfo['columns'][j]['name']}']!= null ?  ViewCustomController.parseTime(ViewController.request['${MainController.tableInfo['columns'][j]['name']}']):TimeOfDay.now(),
              //                                    isSeletedTime: ViewController.request['${MainController.tableInfo['columns'][j]['name']}']== null || ViewController.request['${MainController.tableInfo['columns'][j]['name']}']== '' ? false.obs : true.obs,
              //                                    onTimeChanged: (time) {
              //                                      ViewController.request['${MainController.tableInfo['columns'][j]['name']}'] = time;
              //                                    },
              //                                  ),
              //                                )
              //                              ],
              //                            ),
              //                            SizedBox(width: 20),
              //                          ],
              //                        )
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
                        return Txt('${AppController.of(context)!.value('error')}: ${snapshot.requireData}');
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