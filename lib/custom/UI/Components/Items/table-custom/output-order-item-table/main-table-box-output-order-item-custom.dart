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
import 'package:get/get.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';


class MainTableBoxOutPutOrderItemCustom extends StatefulWidget {
  MainTableBoxOutPutOrderItemCustom();

  @override
  State<MainTableBoxOutPutOrderItemCustom> createState() => _MainTableBoxOutPutOrderItemCustomState();
}

class _MainTableBoxOutPutOrderItemCustomState extends State<MainTableBoxOutPutOrderItemCustom> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Rx<bool> isSend= false.obs;
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
              TableBoxOrderItemOutPutCustom(),
              SizedBox(
                height: 20,
              ),
              // TableFooterOutPutOrderItem(),
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
                                      const Text(
                                        'مشخصات و تاریخ خروج',
                                        style: TextStyle(fontWeight: FontWeight.bold),
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
                                    child: ColumnScroll(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                            Container(
                                              width: 400,
                                              child: FormTextField(
                                                name: 'شماره فاکتور خروج',
                                                hint: 'شماره فاکتور خروج',
                                                lable: '',
                                                initValue: '',
                                                column:MainController.getDetailsOfField(
                                                    'Order_Detail_OutPut', 'DispatcherNumber') ,
                                                onChange: (text) {},
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                              child: FormTextField(
                                                name: 'مشخصات خارج کننده',
                                                hint: 'مشخصات خارج کننده',
                                                lable: '',
                                                column: MainController.getDetailsOfField(
                                                    'Order_Detail_OutPut', 'Dispatcher'),
                                                onChange: (text) {
                                                  ViewCustomController.outPut['Dispatcher'] =  text;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
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
                                              child: DateBox(
                                                selectedDate: Jalali.now(),
                                                isSeletedDate: false.obs,
                                                column: MainController.getDetailsOfField(
                                                    'Order_Detail_OutPut', 'ExitDate'),
                                                onDateChanged: (date) {
                                                  ViewCustomController.outPut['ExitDate'] =  date;
                                                },

                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
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
                                                  child: TimePickerBox(
                                                    column: MainController.getDetailsOfField(
                                                        'Order_Detail_OutPut', 'ExitTime'),
                                                    selectedTime: TimeOfDay.now(),
                                                    isSeletedTime: false.obs,
                                                    onTimeChanged: (time) {
                                                      ViewCustomController.outPut['ExitTime'] =  time;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Column(
                                          children: [
                                            CheckBox(
                                              defaultValue: false,
                                              checkBoxTitle: 'ارسال پیام کوتاه',
                                              onChange: (text) async {
                                                isSend.value = text;
                                              },
                                            ),
                                            Container(
                                              width: double.infinity,
                                              child: TextField(
                                                onChanged: (text) {
                                                  if(isSend.value){
                                                    ViewCustomController.outPut['sms'] =  text;
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
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child:  Txt('انصراف'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await DB('Order_Detail_OutPut').storeRecord(ViewCustomController.outPut);
                                        // await ViewCustomController.registerCheckout();
                                        // await ViewCustomController.getStatusOutPutOrders(MainController.dataRecord.value);
                                        // Navigator.push(
                                        //     Get.context!, MaterialPageRoute(builder: (context) => TablePageOutPutOrderCustom()));
                                      },
                                      child:  Txt('ذخیره'),
                                    ),
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
