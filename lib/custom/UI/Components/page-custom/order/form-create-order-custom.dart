import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-date.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/custom/UI/Components/Items/Forms/Order/form-select-box-search.dart';
import 'package:finance/custom/UI/Components/Items/Forms/Order/form-text-field-custom.dart';
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
  Widget file = ViewCustomController.generateFileBox('', MainController.getDetailsOfField('Orders', 'Picture2'));
  late Future<int> _orderCodeFuture;
  late Future<int> _drawingNumberFuture;

  void initState() {
    super.initState();
    _orderCodeFuture = ViewCustomController.generateOrderCode(Jalali.now())
        .then((value) => value);
    _drawingNumberFuture = ViewCustomController.generateDrawingNumber()
        .then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;


    return FocusScope(
        autofocus: true,
        child: Container(
      width: size.width,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            width: size.width,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: MainController.isLightMode.value == true
                      ? whiteColor
                      : primaryDark),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'کد ورودی',
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                          );
                        }),
                        const SizedBox(height: 10),
                        FutureBuilder<int>(
                          future: _orderCodeFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Txt('خطا در تولید کد سفارش',
                                    color: errorColor),
                              );
                            }

                            final int orderCode = snapshot.data!;
                            return Container(
                              width: 100,
                              child: FormTextField(
                                name: 'کد ورودی',
                                hint: 'کد ورودی',
                                lable: '',
                                initValue: orderCode.toString(),
                                column: MainController.getDetailsOfField(
                                    'Orders', 'Input_Code'),
                                onChange: (text) {
                                  ViewCustomController.order['Input_Code'] =
                                      int.tryParse(text);
                                },
                                isNumberInt: true,
                              ),
                            );
                          },
                        ),

                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'شماره نقشه',
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        FutureBuilder<int>(
                            future: _drawingNumberFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Txt('خطا در تولید کد سفارش',
                                      color: errorColor),
                                );
                              }

                              final int drawingNumber = snapshot.data!;
                              return Container(
                                width: 80,
                                child: FormTextFieldCustom(
                                  name: 'شماره نقشه',
                                  hint: 'شماره نقشه',
                                  lable: '',
                                  column: MainController.getDetailsOfField(
                                      'Orders', 'Drawing_Number'),
                                  initValue: drawingNumber.toString(),
                                  onChange: (text) {
                                    if (text != null || text != '') {
                                      ViewCustomController
                                          .order['Drawing_Number'] =
                                          int.tryParse(text);
                                    }
                                  },
                                  isNumberInt: true,
                                ),
                              );
                            })
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'شماره نقشه(مشتری)',
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
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
                            column: MainController.getDetailsOfField(
                                'Orders', 'Drawing_Number(customer)'),
                            lable: '',
                            onChange: (text) {
                              if (text != null || text != '') {
                                ViewCustomController
                                    .order['Drawing_Number(customer)'] =
                                    int.tryParse(text);
                              } else {
                                ViewCustomController
                                    .order['Drawing_Number(customer)'] = null;
                              }
                            },
                            isNumberInt: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
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
                              column: MainController.getDetailsOfField(
                                  'Orders', 'Type'),
                              items: [
                                for (var item
                                in MainController.getDetailsOfField(
                                    'Orders', 'Type')
                                    .items)
                                  DropdownMenuItem(
                                      child: Obx(() {
                                        return Txt(
                                          '${item['title']}',
                                          color: MainController
                                              .isLightMode.value ==
                                              true
                                              ? whiteColor
                                              : primaryDark,
                                        );
                                      }),
                                      value: item['value']),
                              ],
                              initalValue:
                              '${MainController.getDetailsOfField('Orders', 'Type').items.first['value']}',
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
                    SizedBox(
                      width: 20,
                    ),
                    file,
                    SizedBox(
                      width: 20,
                    ),
                    if (widget.customerItems.length != 0)
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
                              child: SelectBoxSearch(
                                  name: 'مشتری',
                                  column: MainController.getDetailsOfField(
                                      'Orders', 'Customer'),
                                  items: [
                                    {'_id': '__hint__', 'Name_and_lastName':'لطفا یکی از موارد زیر را انتخاب کنید'},
                                    ...widget.customerItems,
                                  ],
                                  initalValue:
                                  '',
                                  onChanged: (value) async {
                                    if (value != '') {
                                      ViewCustomController.order['Customer'] =
                                          value;
                                    } else {
                                      ViewCustomController.order['Customer'] =
                                      '';
                                    }
                                    ViewCustomController.isShowAlert.value = await ViewCustomController.showAlret();
                                  },
                                  hintText: '',
                                  isSeleted: false.obs,
                                  selectedValue: '',
                              )
                          ),
                        ],
                      ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'تاریخ',
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
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
                            column: MainController.getDetailsOfField(
                                'Orders', 'Date'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
