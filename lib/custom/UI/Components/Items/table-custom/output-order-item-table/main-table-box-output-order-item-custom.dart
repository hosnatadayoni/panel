import 'dart:ffi';

import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-checkBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-date.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-time.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-footer.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/UI/Components/Items/btn/btn-output-order-item.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/output-order-item-table/table-order-item-output-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/output-order-table/table-order-output-custom.dart';
import 'package:finance/custom/UI/Components/Views/output-order-item-page-custom/table-footer-output-order-item.dart';
import 'package:finance/custom/UI/Components/Views/output-order-page-custom/table-output-order-page-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MainTableBoxOutPutOrderItemCustom extends StatefulWidget {
  MainTableBoxOutPutOrderItemCustom();

  @override
  State<MainTableBoxOutPutOrderItemCustom> createState() => _MainTableBoxOutPutOrderItemCustomState();
}

class _MainTableBoxOutPutOrderItemCustomState extends State<MainTableBoxOutPutOrderItemCustom> {
  RxString outboundInvoiceNumber = ''.obs;
  @override
  void initState() {
    super.initState();
    _initOutboundInvoiceNumber();
  }

  void _initOutboundInvoiceNumber() async {
    int generatedNumber = await ViewCustomController.generateOutboundInvoiceNumber(Jalali.now());
    outboundInvoiceNumber.value = generatedNumber.toString();
  }
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Rx<bool> isSend= false.obs;
    var dateSelected=Jalali.now();
    Rx<String> smsText = ''.obs;
    Rx<bool> isShowError = false.obs;



    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MainController.isLightMode.value == true
              ? background
              : whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
              color: MainController.isLightMode.value == true
                  ? background
                  : dark2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColumnScroll(
            children: [
              SizedBox(
                height: 10,
              ),
              if(MainController.tableName.value == 'Order_Output' && ViewCustomController.isClickedBtnRegister.value)
                TableBoxOrderItemOutPutCustom(),

              SizedBox(
                height: 20,
              ),
              TableFooter(index: MainController.menuList.value.indexWhere((element) => element.schema.name=="Order_Details")),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 1000,
                padding: EdgeInsets.only(left: 100 , right: 100),
                child: Wrap(
                  runSpacing: 10,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 110,
                      child: ActionButton(
                        title: '${AppController.of(context)!.value('outPut')}',
                        backgroundColor: notCheckedOutBtnColor,
                        textColor: whiteColor,
                        onTap: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  titlePadding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                       Txt(
                                        'مشخصات و تاریخ خروج',
                                           fontWeight: FontWeight.bold
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                  content: Container(
                                    height: 400,
                                    width: 600,
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Txt(
                                              'شماره فاکتور خروج',
                                              color:
                                              color2,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Obx((){
                                              return Container(
                                                width: 400,
                                                child: FormBuilder(
                                                  child: FormBuilderTextField(
                                                    initialValue: '${outboundInvoiceNumber.value}',
                                                    style: TextStyle(
                                                        color: primaryDark),
                                                    name: 'شماره فاکتور خروج',
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 12,
                                                      ),
                                                      labelStyle: TextStyle(
                                                          color: primaryDark),
                                                      border: OutlineInputBorder(),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: colorBtn, width: 2.0),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: color3, width: 1.0),
                                                      ),
                                                      // errorText: _errorText,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            })
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Txt(
                                              'مشخصات خارج کننده',
                                              color: color2,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 400,
                                              child: Column(
                                                children: [
                                                  FormBuilderTextField(
                                                    style: TextStyle(
                                                        color: primaryDark),
                                                    onChanged: (text) {
                                                      ViewCustomController.outPut['Dispatcher'] =  text;
                                                      if(ViewCustomController.outPut['Dispatcher'] == null){
                                                        isShowError.value = true;
                                                      }
                                                      else{
                                                        isShowError.value = false;
                                                      }
                                                    },
                                                    name: 'مشخصات خارج کننده',
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 12,
                                                      ),
                                                      border: OutlineInputBorder(),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: colorBtn, width: 2.0),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: color3, width: 1.0),
                                                      ),
                                                      // errorText: _errorText,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Txt(
                                                    '${isShowError.value ?'لطفا این آیتم را وارد کنید':''}',
                                                    color: errorColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Txt(
                                              'تاریخ خروج',
                                              color:  color2,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 120,
                                              child: Wrap(
                                                children: [
                                                  InkWell(
                                                      onTap: ()async {
                                                        Jalali? picked = await showPersianDatePicker(
                                                          context: context,
                                                          initialDate: dateSelected,
                                                          firstDate: Jalali(1385 , 8),
                                                          lastDate: Jalali(1450 , 9),
                                                        );
                                                        if(picked != null){
                                                          setState(() {
                                                            dateSelected = picked;
                                                          });
                                                          ViewCustomController.outPut['ExitDate'] = '${picked.year}/${picked.month}/${picked.day}';
                                                        }
                                                      },

                                                      child: Icon(Icons.date_range_outlined, color: color3, size: 30.0)),
                                                  SizedBox(width: 5,),
                                                  Txt('${dateSelected!.year}/${dateSelected!.month}/${dateSelected.day}', color: primaryDark ,),

                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Txt(
                                                  'ساعت خروج',
                                                  color:
                                                  color2,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 400,
                                                  // child: TimePickerBox(
                                                  //   column: MainController.getDetailsOfField(
                                                  //       'Order_Detail_OutPut', 'ExitTime'),
                                                  //   selectedTime: TimeOfDay.now(),
                                                  //   isSeletedTime: false.obs,
                                                  //   onTimeChanged: (time) {
                                                  //     ViewCustomController.outPut['ExitTime'] =  time;
                                                  //   },
                                                  // ),
                                                  child: FormBuilder(
                                                    child: FormBuilderDateTimePicker(
                                                      name: 'appointment_time',
                                                      inputType: InputType.time,
                                                      format: DateFormat.Hm(),
                                                      decoration: InputDecoration(
                                                        suffixIcon: Icon(Icons.access_time , color: color3,),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: color3),
                                                        ),
                                                        hintText: _formatTime(TimeOfDay.now()),
                                                        hintStyle: TextStyle(color: primaryDark),

                                                      ),
                                                      style: TextStyle(color: primaryDark),
                                                      initialTime: TimeOfDay.now(),
                                                      onChanged: (value) {
                                                        print('value of hhh>>>${value}');
                                                        if (value != null) {
                                                          final timeOfDay = TimeOfDay.fromDateTime(value);
                                                          ViewCustomController.outPut['ExitTime'] =  _formatTime(timeOfDay);
                                                        }
                                                        else{
                                                          ViewCustomController.outPut['ExitTime'] =  _formatTime(TimeOfDay.now());
                                                        }
                                                      },
                                                      validator: (value) {
                                                        if (value == null) {
                                                          return '${AppController.of(context)!.value('Please select a time')}';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Column(
                                          children: [
                                            FormBuilderCheckbox(
                                              name: '',
                                              decoration: InputDecoration(border: InputBorder.none),
                                              activeColor: colorBtn,
                                              title: Txt('ارسال پیام کوتاه', color: color2),
                                              initialValue: false,
                                              side:  BorderSide(
                                                  color: primaryDark,
                                                  width: 1.5,
                                                  strokeAlign: 2.5
                                              ),
                                              onChanged: (text){
                                                isSend.value = text!;
                                              },

                                            ),
                                            Container(
                                              width: double.infinity,
                                              child: TextField(
                                                onChanged: (text) {
                                                  smsText.value = text;
                                                  if(isSend.value){
                                                    ViewCustomController.outPut['sms'] =  smsText.value;
                                                  }
                                                  else{
                                                    ViewCustomController.outPut['sms'] =  '';
                                                  }
                                                },
                                                decoration: const InputDecoration(
                                                  hintText: 'متن پیام را وارد کنید...',
                                                  border: InputBorder.none,
                                                  enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.grey),
                                                  ),
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.blue, width: 2),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap:(){
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: previewBtnColor,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.all(10),
                                            child: Txt('انصراف' , color: whiteColor,),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        InkWell(
                                          onTap:()async{
                                            if(ViewCustomController.outPut['DispatcherNumber'] == null){
                                              ViewCustomController.outPut['DispatcherNumber'] = outboundInvoiceNumber.value;
                                            }
                                            if(ViewCustomController.outPut['ExitTime'] == null){
                                              ViewCustomController.outPut['ExitTime'] = _formatTime(TimeOfDay.now());
                                            }
                                            if(ViewCustomController.outPut['ExitDate'] == null){
                                              ViewCustomController.outPut['ExitDate'] = '${Jalali.now().year}/${Jalali.now().month}/${Jalali.now().day}';
                                            }
                                            if (isSend.value == true && smsText.trim().isNotEmpty) {
                                              ViewCustomController.outPut['sms'] = smsText.trim();
                                            } else {
                                              ViewCustomController.outPut['sms'] = null;
                                            }
                                            print('ViewCustomController.outPut>>>${ViewCustomController.outPut}');
                                            final result = await DB('Order_Detail_OutPut').storeRecord(ViewCustomController.outPut);
                                            String orderDetailOutPutId = result['_id'];
                                            Navigator.pop(context);

                                            await ViewCustomController.registerCheckout(orderDetailOutPutId);
                                            await ViewCustomController.getStatusOutPutOrders(MainController.dataRecord.value);
                                            ViewCustomController.outPut = {};
                                            Navigator.pushReplacement(
                                                Get.context!,
                                              MaterialPageRoute(
                                                builder: (context) => TablePageOutPutOrderCustom(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:cancelBtnColor,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.all(10),
                                            child:  Txt('ذخیره' , color: whiteColor,),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          );
                        },
                      ),
                    ),
                    // Container(
                    //   width: 120,
                    //   child: ActionButton(
                    //     title: '${AppController.of(context)!.value('back outPut')}',
                    //     backgroundColor: outPutBackBtnColor,
                    //     textColor: blackColor,
                    //     onTap: () {},
                    //   ),
                    // ),
                    // Container(
                    //   width: 80,
                    //   child: ActionButton(
                    //     title: '${AppController.of(context)!.value('cancel')}',
                    //     backgroundColor: cancelBtnColor,
                    //     textColor: whiteColor,
                    //     onTap: () {},
                    //   ),
                    // ),
                    // Container(
                    //   width: 110,
                    //   child: ActionButton(
                    //     title: '${AppController.of(context)!.value('preview')}',
                    //     backgroundColor: previewBtnColor,
                    //     textColor: whiteColor,
                    //     onTap: () {},
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
