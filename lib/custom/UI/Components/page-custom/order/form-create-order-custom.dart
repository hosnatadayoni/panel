import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-date.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/custom/UI/Components/Items/Forms/form-text-field-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';

class FormCreateOrderCustom extends StatefulWidget {

  List<dynamic> customerItems;
  FormCreateOrderCustom(this.customerItems);

  @override
  State<FormCreateOrderCustom> createState() => _FormCreateOrderCustomState();
}

class _FormCreateOrderCustomState extends State<FormCreateOrderCustom> {

  void initState()  {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    return   Container(
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
              child:
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'کد ورودی',
                            color:
                            MainController.isLightMode.value == true ? whiteColor : color2,
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 80,
                          child: FormTextField(
                            name: 'کد ورودی',
                            hint: 'کد ورودی',
                            lable: '',
                            column: MainController.getDetailsOfField('Orders' , 'Input_Code'),
                            onChange: (text) {
                              ViewCustomController.order['Input_Code']= int.tryParse('${text}');
                            },
                            isNumberInt:true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'شماره نقشه',
                            color:
                            MainController.isLightMode.value == true ? whiteColor : color2,
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 80,
                          child: FormTextFieldCustom(
                            name: 'شماره نقشه',
                            hint: 'شماره نقشه',
                            lable: '',

                            column: MainController.getDetailsOfField('Orders' , 'Drawing_Number'),
                            onChange: (text) {
                              if(text != null || text != ''){
                                ViewCustomController.order['Drawing_Number']= int.tryParse(text);
                              }
                              // else{
                              //   ViewCustomController.order['Drawing_Number']= null;
                              // }

                            },
                            isNumberInt:true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'شماره نقشه(مشتری)',
                            color:
                            MainController.isLightMode.value == true ? whiteColor : color2,
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 80,
                          child: FormTextFieldCustom(
                            name: 'شماره نقشه(مشتری)',
                            hint: 'شماره نقشه(مشتری)',
                            column: MainController.getDetailsOfField('Orders' , 'Drawing_Number(customer)'),
                            lable: '',
                            onChange: (text) {
                              if(text != null || text != ''){
                                ViewCustomController.order['Drawing_Number(customer)']= int.tryParse(text);
                              }
                              else{
                                ViewCustomController.order['Drawing_Number(customer)']= null;
                              }
                            },
                            isNumberInt:true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'نوع',
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          child: SelectBox(
                              name: 'نوع',
                              column: MainController.getDetailsOfField('Orders' , 'Type'),
                              items: [
                                for (var item in MainController.getDetailsOfField('Orders' , 'Type')['items'])
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
                              initalValue: '${MainController.getDetailsOfField('Orders' , 'Type')['items'].first['value']}',
                              onChanged: (value) async {
                                if (value != '') {
                                  ViewCustomController.order['Type'] = value;
                                } else {
                                  ViewCustomController.order['Type'] = '';
                                }
                              },
                              hintText: '',
                              isSeleted: false.obs,
                              selectedValue: ''),
                        )
                      ],
                    ),
                    SizedBox(width: 20,),
                    ViewCustomController.generateFileBox('', MainController.getDetailsOfField('Orders' , 'Picture'), false.obs),
                    SizedBox(width: 20,),
                    if(widget.customerItems.length != 0)
                       Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'مشتری',
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
                              name: 'مشتری',
                              column: MainController.getDetailsOfField('Orders' , 'Customer'),
                              items: [
                                // DropdownMenuItem(
                                //     child: Obx(() {
                                //       return Txt(
                                //         '${AppController.of(Get.context!)!.value('not selected')}',
                                //         color: MainController.isLightMode.value == true
                                //             ? whiteColor
                                //             : primaryDark,
                                //       );
                                //     }),
                                //     value: ''),
                                for (var item in widget.customerItems)
                                  DropdownMenuItem(
                                      child: Obx(() {
                                        return Txt(
                                          '${ViewController.itemsShowSelectItem(item, MainController.getDetailsOfField('Orders' , 'Customer'))}',
                                          color:
                                          MainController.isLightMode.value == true
                                              ? whiteColor
                                              : primaryDark,
                                        );
                                      }),
                                      value: item['_id'].toString()),
                              ],
                              initalValue:'${widget.customerItems.first['_id']}',
                              onChanged: (value) async {
                                if (value != '') {
                                  ViewCustomController.order['Customer'] = value;
                                } else {
                                  ViewCustomController.order['Customer'] = '';
                                }
                              },
                              hintText: '',
                              isSeleted: true.obs,
                              selectedValue: ''),
                        ),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'تاریخ',
                            color:
                            MainController.isLightMode.value == true ? whiteColor : color2,
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 120,
                          child: DateBox(
                            selectedDate: Jalali.now(),
                            isSeletedDate: false.obs,
                            onDateChanged: (date) {
                              ViewCustomController.order['Date'] = date;
                            },
                            column:MainController.getDetailsOfField('Orders' , 'Date'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
