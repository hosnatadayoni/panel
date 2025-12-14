import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/Logic/Models/order-item.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';

class FormCreateOrderItemCustom extends StatefulWidget {
  List<dynamic> productItems;
  FormCreateOrderItemCustom(this.productItems);

  @override
  State<FormCreateOrderItemCustom> createState() => _FormCreateOrderItemCustomState();
}

class _FormCreateOrderItemCustomState extends State<FormCreateOrderItemCustom> {

  void initState() {
  }
  // Map<String, Widget> containers = {};

  // void _addContainer() {
  //   setState(() {
  //     var Id = Uuid().v4();
  //     String newKey = Id;
  //     containers[newKey] = buildContainer(newKey);
  //     OrderItem.orderItemsList[newKey] = {...ViewCustomController.orderItem};
  //   });
  // }
  // void _removeContainer(String key) {
  //   setState(() {
  //     containers.remove(key);
  //     OrderItem.orderItemsList.remove(key);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(MainController.selectedSubItem.value != -1)
          if(MainController.SubMenuList[MainController.selectedSubItem.value]['table-name'] != 'Orders')
            SizedBox(height: 20,),
        Obx((){
          return Container(
            padding: EdgeInsets.all(20),
            decoration:  BoxDecoration(
                border: Border.all(width: 2,color: MainController.isLightMode.value == true ? whiteColor:primaryDark),
                borderRadius:  BorderRadius.circular(10)
            ),
            child: ColumnScroll(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: (){
                        ViewCustomController.addContainer(context , widget.productItems);
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 20 , left: 20 , top: 10,bottom: 10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.orange,),
                        child: Center(child: Txt('${AppController.of(context)!.value('surcharge')} (F4)')),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),

                Container(
                  child: Column(
                    children: [
                      for (var key in ViewCustomController.containers.keys)
                        ViewCustomController.containers[key]!,
                    ],
                  ),
                ),
              ],
            ),
          );
        })
      ],
    );
  }
  // Widget buildContainer(String key) {
  //   var size = MediaQuery.of(context).size;
  //   return Container(
  //     key: ValueKey(key),
  //     width: size.width,
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Obx(() {
  //                 return Txt(
  //                   'نام کالا',
  //                   color: MainController.isLightMode.value == true
  //                       ? whiteColor
  //                       : color2,
  //                 );
  //               }),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 width: 250,
  //                 child: SelectBox(
  //                     name: 'نام کالا',
  //                     maxHeight: 38,
  //                     column: MainController.getDetailsOfField('Order_Details' , 'Product'),
  //                     items: [
  //                       DropdownMenuItem(
  //                           child: Obx(() {
  //                             return Txt(
  //                               '${AppController.of(Get.context!)!.value('not selected')}',
  //                               color: MainController.isLightMode.value == true
  //                                   ? whiteColor
  //                                   : primaryDark,
  //                               fontSize: 13,
  //                             );
  //                           }),
  //                           value: ''),
  //                       for (var item in widget.productItems)
  //                         DropdownMenuItem(
  //                             child: Obx(() {
  //                               return Txt(
  //                                 '${ViewController.itemsShowSelectItem(item, MainController.getDetailsOfField('Order_Details' , 'Product_Name'))}',
  //                                 color:
  //                                 MainController.isLightMode.value == true
  //                                     ? whiteColor
  //                                     : primaryDark,
  //                               );
  //                             }),
  //                             value: item['_id'].toString()),
  //                     ],
  //                     initalValue: '',
  //                     onChanged: (value) async {
  //                       if (value != '') {
  //                         OrderItem.orderItemsList[key]!['Product_Name'] = value;
  //                       } else {
  //                         OrderItem.orderItemsList[key]!['Product_Name'] = '';
  //                       }
  //                     },
  //                     hintText: '',
  //                     isSeleted: false.obs,
  //                     selectedValue: ''),
  //               ),
  //             ],
  //           ),
  //           SizedBox(width: 10,),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Obx(() {
  //                 return Txt(
  //                   'قیمت',
  //                   color:
  //                   MainController.isLightMode.value == true ? whiteColor : color2,
  //                 );
  //               }),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 width: 100,
  //                 child: FormTextField(
  //                   name: 'قیمت',
  //                   hint: 'قیمت',
  //                   lable: '',
  //                   isNumberDouble:true,
  //                   height: 40,
  //                   column: MainController.getDetailsOfField('Order_Details' , 'Price'),
  //                   onChange: (text) {
  //                     if (text != null && text != '') {
  //                       OrderItem.orderItemsList[key]!['Price'] = double.parse('${text}');
  //                     } else {
  //                       OrderItem.orderItemsList[key]!['Price']= 0.0;
  //
  //                     }
  //                     OrderItem.orderItemsList.refresh();
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(width: 10,),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Obx(() {
  //                 return Txt(
  //                   'بعد اول',
  //                   color:
  //                   MainController.isLightMode.value == true ? whiteColor : color2,
  //                 );
  //               }),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 width: 60,
  //                 child: FormTextField(
  //                   name: 'بعد اول',
  //                   hint: 'بعد اول',
  //                   lable: '',
  //                   height: 40,
  //                   isNumberDouble:true,
  //                   column: MainController.getDetailsOfField('Order_Details' , 'First_Dimension'),
  //                   onChange: (text) {
  //                     if (text != null && text != '') {
  //                       OrderItem.orderItemsList[key]!['First_Dimension'] = double.parse('${text}');
  //                     } else {
  //                       OrderItem.orderItemsList[key]!['First_Dimension']= 0.0;
  //                     }
  //                     OrderItem.orderItemsList.refresh();
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(width: 10,),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Obx(() {
  //                 return Txt(
  //                   'بعد دوم',
  //                   color:
  //                   MainController.isLightMode.value == true ? whiteColor : color2,
  //                 );
  //               }),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 width: 60,
  //                 child: FormTextField(
  //                   name: 'بعد دوم',
  //                   hint: 'بعد دوم',
  //                   lable: '',
  //                   height: 40,
  //                   isNumberDouble:true,
  //                   column: MainController.getDetailsOfField('Order_Details' , 'Second_Dimension'),
  //                   onChange: (text) {
  //                     if (text != null && text != '') {
  //                       OrderItem.orderItemsList[key]!['Second_Dimension'] = double.parse('${text}');
  //                     } else {
  //                       OrderItem.orderItemsList[key]!['Second_Dimension']= 0.0;
  //                     }
  //                     OrderItem.orderItemsList.refresh();
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(width: 10,),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Obx(() {
  //                 return Txt(
  //                   'جمع متراژ',
  //                   color:
  //                   MainController.isLightMode.value == true ? whiteColor : color2,
  //                 );
  //               }),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 width: 70,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                    Obx((){
  //                      return Txt('${ViewCustomController.getCalculateTotalArea(OrderItem.orderItemsList[key]?['First_Dimension'] ?? 0,
  //                          OrderItem.orderItemsList[key]?['Second_Dimension'] ?? 0)}',
  //                        color: MainController.isLightMode.value == true ? whiteColor : color2,);
  //                    })
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(width: 10,),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Obx(() {
  //                 return Txt(
  //                   'تعداد',
  //                   color:
  //                   MainController.isLightMode.value == true ? whiteColor : color2,
  //                 );
  //               }),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 width: 60,
  //                 child: FormTextField(
  //                   name: 'تعداد',
  //                   hint: 'تعداد',
  //                   lable: '',
  //                   height: 40,
  //                   isNumberInt:true,
  //                   column: MainController.getDetailsOfField('Order_Details' , 'Quantity'),
  //                   onChange: (text) {
  //                     if (text != null && text != '') {
  //                       OrderItem.orderItemsList[key]!['Quantity'] = int.parse('${text}');
  //                     } else {
  //                       OrderItem.orderItemsList[key]!['Quantity']= 0;
  //                     }
  //                     OrderItem.orderItemsList.refresh();
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(width: 10,),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Obx(() {
  //                 return Txt(
  //                   'الگوی بری',
  //                   color: MainController.isLightMode.value == true
  //                       ? whiteColor
  //                       : color2,
  //                 );
  //               }),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 width: 40,
  //                 child: SelectBox(
  //                     name: 'الگوی بری',
  //                     maxHeight: 38,
  //                     column: MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern'),
  //                     items: [
  //                       for (var item in MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern')['items'])
  //                         DropdownMenuItem(
  //                             child: Obx(() {
  //                               return Txt(
  //                                 '${item['title']}',
  //                                 color:
  //                                 MainController.isLightMode.value == true
  //                                     ? whiteColor
  //                                     : primaryDark,
  //                                 fontSize: 13,
  //                               );
  //                             }),
  //                             value: item['value']),
  //                     ],
  //                     initalValue: '${MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern')['items'].first['value']}',
  //                     onChanged: (value) async {
  //                       print('value aaaa>>>${value}');
  //                       if (value != '') {
  //                         OrderItem.orderItemsList[key]!['Cut_Pattern'] = value;
  //                       } else {
  //                         OrderItem.orderItemsList[key]!['Cut_Pattern'] = '';
  //                       }
  //                     },
  //                     hintText: '',
  //                     isSeleted: false.obs,
  //                     selectedValue: ''),
  //               )
  //             ],
  //           ),
  //           SizedBox(width: 10,),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Obx(() {
  //                 return Txt(
  //                   'سختی تولید',
  //                   color: MainController.isLightMode.value == true
  //                       ? whiteColor
  //                       : color2,
  //                 );
  //               }),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 width: 40,
  //                 child: SelectBox(
  //                     name: 'سختی تولید',
  //                     maxHeight: 38,
  //                     column: MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty'),
  //                     items: [
  //                       for (var item in MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty')['items'])
  //                         DropdownMenuItem(
  //                             child: Obx(() {
  //                               return Txt(
  //                                 '${item['title']}',
  //                                 color:
  //                                 MainController.isLightMode.value == true
  //                                     ? whiteColor
  //                                     : primaryDark,
  //                                 fontSize: 13,
  //                               );
  //                             }),
  //                             value: item['value']),
  //                     ],
  //                     initalValue: '${MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty')['items'].first['value']}',
  //                     onChanged: (value) async {
  //                       print('value aaaa>>>${value}');
  //                       if (value != '') {
  //                         OrderItem.orderItemsList[key]!['Manufacturing_Difficulty'] = value;
  //                       } else {
  //                         OrderItem.orderItemsList[key]!['Manufacturing_Difficulty'] = '';
  //                       }
  //                     },
  //                     hintText: '',
  //                     isSeleted: false.obs,
  //                     selectedValue: ''),
  //               )
  //             ],
  //           ),
  //           SizedBox(width: 10,),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Obx(() {
  //                 return Txt(
  //                   'بلوک',
  //                   color:
  //                   MainController.isLightMode.value == true ? whiteColor : color2,
  //                 );
  //               }),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 width: 60,
  //                 child: FormTextField(
  //                   name: 'بلوک',
  //                   hint: 'بلوک',
  //                   lable: '',
  //                   height: 40,
  //                   isNumberInt:true,
  //                   column: MainController.getDetailsOfField('Order_Details' , 'Block'),
  //                   onChange: (text) {
  //                     // dataJson[columnName] = text;
  //                     if (text != null && text != '') {
  //                       OrderItem.orderItemsList[key]!['Block'] = int.parse('${text}');
  //                     } else {
  //                       OrderItem.orderItemsList[key]!['Block']= '';
  //
  //                     }
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(width: 10,),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Obx(() {
  //                 return Txt(
  //                   'طبقه',
  //                   color:
  //                   MainController.isLightMode.value == true ? whiteColor : color2,
  //                 );
  //               }),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 width: 60,
  //                 child: FormTextField(
  //                   name: 'طبقه',
  //                   hint: 'طبقه',
  //                   lable: '',
  //                   height: 40,
  //                   isNumberInt:true,
  //                   column: MainController.getDetailsOfField('Order_Details' , 'Level'),
  //                   onChange: (text) {
  //                     if (text != null && text != '') {
  //                       OrderItem.orderItemsList[key]!['Level'] = int.parse('${text}');
  //                     } else {
  //                       OrderItem.orderItemsList[key]!['Level']= '';
  //
  //                     }
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(width: 10,),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Obx(() {
  //                 return Txt(
  //                   'واحد',
  //                   color:
  //                   MainController.isLightMode.value == true ? whiteColor : color2,
  //                 );
  //               }),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 width: 60,
  //                 child: FormTextField(
  //                   name: 'واحد',
  //                   hint: 'واحد',
  //                   lable: '',
  //                   isNumberInt:true,
  //                   height: 40,
  //                   column: MainController.getDetailsOfField('Order_Details' , 'Unit'),
  //                   onChange: (text) {
  //                     if (text != null && text != '') {
  //                       OrderItem.orderItemsList[key]!['Unit'] = int.parse('${text}');
  //                     } else {
  //                       OrderItem.orderItemsList[key]!['Unit']= '';
  //                     }
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(width: 10,),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Obx(() {
  //                 return Txt(
  //                   'جمع مبلغ',
  //                   color:
  //                   MainController.isLightMode.value == true ? whiteColor : color2,
  //                 );
  //               }),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 width: 80,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Obx((){
  //                       return Txt('${ViewCustomController.getCalculateTotalPrice(OrderItem.orderItemsList[key]?['Price'] ?? 0 ,
  //                           OrderItem.orderItemsList[key]?['First_Dimension'] ?? 0,
  //                           OrderItem.orderItemsList[key]?['Second_Dimension'] ?? 0,
  //                           OrderItem.orderItemsList[key]?['Quantity'] ?? 0
  //                       )}', color: MainController.isLightMode.value == true ? whiteColor : color2,);
  //                     })
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(width: 10,),
  //           Column(
  //             children: [
  //               Obx((){
  //                 return Txt('${AppController.of(context)!.value('remove')}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
  //               }),
  //               SizedBox(height: 20,),
  //               InkWell(
  //                 onTap: (){
  //                   _removeContainer(key);
  //                 },
  //                 child: Container(
  //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.pinkAccent,),
  //                   padding: EdgeInsets.only(right: 20 , left: 20 , top: 10,bottom: 10),
  //                   child: Txt('${AppController.of(context)!.value('remove')} '),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       )
  //     ),
  //   );
  // }
}