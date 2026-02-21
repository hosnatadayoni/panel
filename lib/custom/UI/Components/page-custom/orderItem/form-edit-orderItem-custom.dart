import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/Logic/Models/order-item.dart';
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
import 'package:finance/custom/UI/Components/Items/Forms/OrderItem/form-text-field-order-item-custom.dart';
import 'package:finance/custom/UI/Components/page-custom/order/form-txt-price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';

import '../../../../../Admin/Logic/Models/db.dart';

class FormEditOrderItemCustom extends StatefulWidget {

  FormEditOrderItemCustom(this.productItems , this.orderDetailItems , this.data);
  List<dynamic> productItems;
  List<dynamic> orderDetailItems;
  var data;


  @override
  State<FormEditOrderItemCustom> createState() => _FormEditOrderItemCustomState();
}

class _FormEditOrderItemCustomState extends State<FormEditOrderItemCustom> {
  Color? colorChanged;
  final Map<String, TextEditingController> priceControllers = {};
  final formatter = NumberFormat('#,###');
  RxBool isExistsOrder =  false.obs;



  void initState() {
    super.initState();
    _initPriceControllers();
    _loadIsExsitsOrder();

  }

  void _initPriceControllers() {
    for (var item in widget.orderDetailItems) {
      final id = item['_id'];

      final price = ViewCustomController.getProductPrice(
        widget.productItems,
        item['Product_Name']?['_id'],
      ) ??
          0;

      priceControllers[id] = TextEditingController(
        text: formatter.format(price),
      );

      item['Price'] = price;
    }
  }
  _loadIsExsitsOrder() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isExistsOrder.value = await ViewCustomController.getStatusOrders(widget.data['_id']);
    });

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final TextEditingController _controller = TextEditingController();

    return FocusScope(
      autofocus: true,
      child: Column(
        children: [
          Obx((){
            return Container(
              padding: EdgeInsets.all(20),
              decoration:  BoxDecoration(
                  border: Border.all(width: 2,color: MainController.isLightMode.value == true ? whiteColor:primaryDark),
                  borderRadius:  BorderRadius.circular(10)
              ),
              child: ColumnScroll(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Txt('لیست سفارش ها',
                        color: MainController.isLightMode.value == true
                            ? whiteColor
                            : primaryDark)
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: ViewCustomController.isShowAlert.value
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.end,
                    children: [
                      if (ViewCustomController.isShowAlert.value)
                        Txt(
                          'میزان سفارش از سقف مجاز مشتری بیشتر است',
                          color: errorColor,
                          fontSize: 16,
                        ),
                      InkWell(
                        onTap: () async {
                          await ViewCustomController.checkEditOrder(
                              context, widget.productItems , data: widget.data);
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              right: 20, left: 20, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.orange,
                          ),
                          child: Center(
                              child: Txt(
                                  '${AppController.of(context)!.value('surcharge')} (F4)')),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(height: 20,),
                  Column(
                    children: [
                      for(int i=0;i<widget.orderDetailItems.length;i++)
                        Container(
                          width: size.width,
                          key: ValueKey(widget.orderDetailItems[i]['_id']),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child:
                              Row(
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
                                            maxHeight: 38,
                                            column: MainController.getDetailsOfField('Order_Details' , 'Product_Name'),
                                            items: [
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
                                            initalValue: '${widget.orderDetailItems[i]['Product_Name']['_id'] != null  ? widget.orderDetailItems[i]['Product_Name']['_id'] : ''}',
                                            onChanged: (value) async {
                                              setState(() {
                                                if (value != '') {
                                                  widget.orderDetailItems[i]['Product_Name']['_id']  = value;
                                                  final newPrice = ViewCustomController.getProductPrice(widget.productItems, widget.orderDetailItems[i]['Product_Name']['_id']) ?? 0;
                                                  priceControllers['${widget.orderDetailItems[i]['_id']}']!.text = formatter.format(newPrice);
                                                } else {
                                                  widget.orderDetailItems[i]['Product_Name']  = '';
                                                }
                                              });
                                            },
                                            hintText: '',
                                            isSeleted: true.obs,
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
                                        child: FormPriceTextField(
                                          name: 'قیمت',
                                          hint: 'قیمت',
                                          lable: '',
                                          controller: priceControllers['${widget.orderDetailItems[i]['_id']}']!,
                                          height: 40,
                                          column: MainController.getDetailsOfField('Order_Details' , 'Price'),
                                          onChange: (text) {
                                            if (text != null && text != '') {
                                              String cleanText = text.replaceAll(',', '');
                                              int value = int.tryParse(cleanText) ?? 0;
                                              widget.orderDetailItems[i]['Price'] = value;
                                              String formatted = formatter.format(value);
                                              if (formatted != text) {
                                                _controller.value = TextEditingValue(
                                                  text: formatted,
                                                  selection: TextSelection.collapsed(offset: formatted.length),
                                                );
                                              }
                                            }
                                            OrderItem.orderItemsList.refresh();
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
                                        child: FormTextFieldOrderItemCustom(
                                          name: 'بعد اول',
                                          hint: 'بعد اول',
                                          lable: '',
                                          height: 40,
                                          initValue: '${widget.orderDetailItems[i]['First_Dimension'] != null ?
                                          widget.orderDetailItems[i]['First_Dimension']:''}',
                                          isNumberDouble:true,
                                          keyOrderItem: widget.orderDetailItems[i]['_id'],
                                          column: MainController.getDetailsOfField('Order_Details' , 'First_Dimension'),
                                          onChange: (text) {
                                            setState(() {
                                              if (text != null && text != '') {
                                                widget.orderDetailItems[i]['First_Dimension'] = double.tryParse('${text}');
                                              } else {
                                                widget.orderDetailItems[i]['First_Dimension'] = null;
                                              }
                                            });
                                            // OrderItem.orderItemsList.refresh();
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
                                        child: FormTextFieldOrderItemCustom(
                                          name: 'بعد دوم',
                                          hint: 'بعد دوم',
                                          lable: '',
                                          height: 40,
                                          isNumberDouble:true,
                                          keyOrderItem: widget.orderDetailItems[i]['_id'],
                                          initValue: '${widget.orderDetailItems[i]['Second_Dimension'] != null ?
                                          widget.orderDetailItems[i]['Second_Dimension']:''}',
                                          column: MainController.getDetailsOfField('Order_Details' , 'Second_Dimension'),
                                          onChange: (text) {
                                            setState(() {
                                              if (text != null && text != '') {
                                                widget.orderDetailItems[i]['Second_Dimension'] = double.tryParse('${text}');
                                              } else {
                                                widget.orderDetailItems[i]['Second_Dimension'] = null;

                                              }
                                            });
                                            // OrderItem.orderItemsList.refresh();
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
                                            Obx((){
                                              return Txt('${ViewCustomController.getCalculateTotalArea((widget.orderDetailItems[i]['First_Dimension'] as num?)?.toDouble() ?? 0.0,
                                                (widget.orderDetailItems[i]['Second_Dimension'] as num?)?.toDouble() ?? 0.0,)}',
                                                color: MainController.isLightMode.value == true ? whiteColor : color2,);
                                            })
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
                                          initValue: widget.orderDetailItems[i]['Quantity'].toString() != null ?
                                          widget.orderDetailItems[i]['Quantity'].toString() : '0',
                                          onChange: (text) {
                                            setState(() {
                                              if (text != null && text != '') {
                                                widget.orderDetailItems[i]['Quantity'] = int.tryParse('${text}');
                                              }
                                              else{
                                                widget.orderDetailItems[i]['Quantity'] = 0;
                                              }
                                            });
                                            // OrderItem.orderItemsList.refresh();
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
                                            maxHeight: 38,
                                            column: MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern'),
                                            items: [
                                              for (var item in MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern').items)
                                                DropdownMenuItem(
                                                    child: Obx(() {
                                                      return Txt(
                                                        '${item['title']}',
                                                        color:
                                                        MainController.isLightMode.value == true
                                                            ? whiteColor
                                                            : primaryDark,
                                                        fontSize: 13,
                                                      );
                                                    }),
                                                    value: item['value']),
                                            ],
                                            initalValue: '${widget.orderDetailItems[i]['Cut_Pattern'] != null ?widget.orderDetailItems[i]['Cut_Pattern']['value'] != null ?
                                            widget.orderDetailItems[i]['Cut_Pattern']['value'] : '':'${MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern').items.first['value']}'}',
                                            onChanged: (value) async {
                                              if (value != '') {
                                                widget.orderDetailItems[i]['Cut_Pattern'] = value;
                                              } else {
                                                widget.orderDetailItems[i]['Cut_Pattern'] = '';
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
                                            maxHeight: 38,
                                            column: MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty'),
                                            items: [
                                              for (var item in MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty').items)
                                                DropdownMenuItem(
                                                    child: Obx(() {
                                                      return Txt(
                                                        '${item['title']}',
                                                        color:
                                                        MainController.isLightMode.value == true
                                                            ? whiteColor
                                                            : primaryDark,
                                                        fontSize: 13,
                                                      );
                                                    }),
                                                    value: item['value']),
                                            ],
                                            initalValue: '${widget.orderDetailItems[i]['Manufacturing_Difficulty'] != null ? widget.orderDetailItems[i]['Manufacturing_Difficulty']['value'] != null ?
                                            widget.orderDetailItems[i]['Manufacturing_Difficulty']['value']:'':'${MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty').items.first['value']}'}',
                                            onChanged: (value) async {
                                              if (value != '') {
                                                widget.orderDetailItems[i]['Manufacturing_Difficulty']['value'] = value;
                                              } else {
                                                widget.orderDetailItems[i]['Manufacturing_Difficulty']['value'] = '';
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
                                        width: 60,
                                        child: FormTextField(
                                          name: 'بلوک',
                                          hint: 'بلوک',
                                          lable: '',
                                          height: 40,
                                          isNumberInt:true,
                                          initValue: '${widget.orderDetailItems[i]['Block'] != null ?
                                          widget.orderDetailItems[i]['Block']:''}',
                                          column: MainController.getDetailsOfField('Order_Details' , 'Block'),
                                          onChange: (text) {
                                            if (text != null && text != '') {
                                              widget.orderDetailItems[i]['Block'] = int.parse('${text}');
                                            } else {
                                              widget.orderDetailItems[i]['Block']= '';

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
                                        width: 60,
                                        child: FormTextField(
                                          name: 'طبقه',
                                          hint: 'طبقه',
                                          lable: '',
                                          height: 40,
                                          isNumberInt:true,
                                          initValue: '${widget.orderDetailItems[i]['Level'] != null ?
                                          widget.orderDetailItems[i]['Level']:''}',
                                          column: MainController.getDetailsOfField('Order_Details' , 'Level'),
                                          onChange: (text) {
                                            if (text != null && text != '') {
                                              widget.orderDetailItems[i]['Level'] = int.parse('${text}');
                                            } else {
                                              widget.orderDetailItems[i]['Level'] = '';

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
                                        width: 60,
                                        child: FormTextField(
                                          name: 'واحد',
                                          hint: 'واحد',
                                          lable: '',
                                          isNumberInt:true,
                                          initValue: '${widget.orderDetailItems[i]['Unit'] != null ?
                                          widget.orderDetailItems[i]['Unit']:''}',
                                          height: 40,
                                          column: MainController.getDetailsOfField('Order_Details' , 'Unit'),
                                          onChange: (text) {
                                            if (text != null && text != '') {
                                              widget.orderDetailItems[i]['Unit'] = int.parse('${text}');
                                            } else {
                                              widget.orderDetailItems[i]['Unit'] = '';
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
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Obx((){
                                                return Txt('${ViewCustomController.getCalculateTotalPrice(ViewCustomController.getProductPrice(
                                                  widget.productItems, widget.orderDetailItems[i]['Product_Name']['_id'] ?? widget.productItems.first['_id'],) ,
                                                    (widget.orderDetailItems[i]['First_Dimension'] as num?)?.toDouble() ?? 0.0,
                                                    (widget.orderDetailItems[i]['Second_Dimension'] as num?)?.toDouble() ?? 0.0,
                                                    widget.orderDetailItems[i]['Quantity'] ?? 1
                                                )}', color: MainController.isLightMode.value == true ? whiteColor : color2,);
                                              })
                                            ],
                                          ),
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
                                        onTap: isExistsOrder.value == false ? () async {
                                          if(widget.orderDetailItems.length != 0){
                                            int index = widget.orderDetailItems.indexWhere((e) => e['_id'] == widget.orderDetailItems[i]['_id']);
                                            String id = widget.orderDetailItems[index]['_id'];
                                            ViewCustomController.removeEditContainer(id);
                                            ViewCustomController.isShowAlert.value = await ViewCustomController.showAlretEditOrder(ViewCustomController.order['Customer'] == null ? widget.data['Customer']['_id'] : ViewCustomController.order['Customer']);
                                            widget.orderDetailItems.removeWhere((e) => e['_id'] == id);
                                            }
                                        }:null,
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
                        for (var container in ViewCustomController.editContainers.value.entries)
                          ViewCustomController.editContainers.value['${container.key}']!,
                      ],
                    ),
                  ),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}
