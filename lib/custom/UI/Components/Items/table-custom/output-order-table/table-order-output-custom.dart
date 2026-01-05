import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:finance/Admin/Logic/Models/db.dart';

class TableBoxOrderOutPutCustom extends StatefulWidget {
  TableBoxOrderOutPutCustom(this.ordersList);
  List<dynamic> ordersList;

  @override
  State<TableBoxOrderOutPutCustom> createState() => _TableBoxOrderOutPutCustomState();
}

class _TableBoxOrderOutPutCustomState extends State<TableBoxOrderOutPutCustom> {
  late ScrollController _scrollController;



  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx((){
      return Container(
        color: MainController.isLightMode.value == true ? background : whiteColor,
        padding: EdgeInsets.all(15),
        width: size.width,
        child: Scrollbar(
          isAlwaysShown: true,
          thickness: 10,
          controller: _scrollController,
          trackVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Table(
              defaultColumnWidth: FixedColumnWidth(
                (MainController.tableInfo['columns'].length > 8
                    ? 150.0
                    : size.width / 7),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(
                color: MainController.isLightMode.value == true
                    ? whiteColor
                    : color1,
              ),
              children: [
                TableRow(
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Txt(
                          'انتخاب',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : color2,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Txt(
                          'کد ورودی',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : color2,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Txt(
                          'مشتری',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : color2,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Txt(
                          'تاریخ ورود',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : color2,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Txt(
                          'شماره نقشه',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : color2,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Txt(
                          'سفارش مشتری',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : color2,
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Center(
                            child: Txt(
                                '${AppController.of(context)!.value('operation')}',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: MainController.isLightMode.value == true
                                    ? whiteColor
                                    : color2))),
                  ],
                ),
                if (widget.ordersList.length != 0)
                  for (var i=0;i<widget.ordersList.length;i++)
                    TableRow(children: [
                      Center(child: Obx((){
                        String orderId = widget.ordersList[i]['_id'];
                        bool isChecked = ViewCustomController.checkboxStatus[orderId] ?? false;
                        return FormBuilderCheckbox(
                          key: Key('${i}'),
                          decoration: InputDecoration(border: InputBorder.none),
                          activeColor: colorBtn,
                          initialValue: isChecked,
                          side:  BorderSide(
                              color: MainController.isLightMode.value ? whiteColor : primaryDark,
                              width: 1.5,
                              strokeAlign: 2.5
                          ),
                          onChanged: (checked) async {
                            var orderDetailSelected = await ViewCustomController.getDataOrderDetailList(widget.ordersList[i]['_id']);
                            print('orderDetailSelected>>>${orderDetailSelected}');
                            if(checked == true){
                              ViewCustomController.allOrderDetailsSelected.add(orderDetailSelected);
                              ViewCustomController.checkboxStatus[orderId] = true;
                            }
                            else{
                              ViewCustomController.allOrderDetailsSelected.removeWhere(
                                    (orderDetails) => orderDetails.any(
                                      (y) => y['parent_id'] == widget.ordersList[i]['_id'],
                                ),
                              );
                              ViewCustomController.checkboxStatus[orderId] = false;

                            }
                            ViewCustomController.checkboxStatus.refresh();
                          }, name: '', title: Txt(''),

                        );
                      })),
                      Obx(() {
                        return Center(
                          child: Txt(
                            '${widget.ordersList[i]['Input_Code']}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      Obx(() {
                        return Center(
                          child: Txt(
                            '${widget.ordersList[i]['Customer']['Name_and_lastName']}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      Obx(() {
                        return Center(
                          child: Txt(
                            '${widget.ordersList[i]['Date']}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      Obx(() {
                        return Center(
                          child: Txt(
                            '${widget.ordersList[i]['Drawing_Number']}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      Obx(() {
                        return Center(
                          child: Txt(
                            '${widget.ordersList[i]['Drawing_Number(customer)']}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(left: 10 , right: 10 , top: 5 , bottom: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: notCheckedOutBtnColor, width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(20)),
                            color: notCheckedOutBtnColor,
                          ),
                          child: Txt(
                            'خارج نشده',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: whiteColor,
                          ),
                        ),
                      )
                    ])
              ],
            ),
          ),
        ),
      );
    });
  }
}
