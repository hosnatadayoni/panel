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

class TableBoxOrderItemOutPutCustom extends StatefulWidget {
  TableBoxOrderItemOutPutCustom();

  @override
  State<TableBoxOrderItemOutPutCustom> createState() => _TableBoxOrderItemOutPutCustomState();
}

class _TableBoxOrderItemOutPutCustomState extends State<TableBoxOrderItemOutPutCustom> {
  late ScrollController _scrollController;



  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

    });

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
                (MainController.infoSchema.value.columns.length > 8
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
                          'نام کالا',
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
                          'قیمت',
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
                          'بعد اول',
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
                          'بعد دوم',
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
                          'جمع متراژ',
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
                          'تعداد جام',
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
                          'الگوی بری',
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
                          'سختی تولید',
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
                          'بلوک',
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
                          'طبقه',
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
                          'واحد',
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
                          'جمع مبلغ',
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
                if (ViewCustomController.ordersSelected.length != 0)
                  // for (var orderSelected in ViewCustomController.ordersSelected.entries)
                  //   for(var orderDetail in ViewCustomController.filteredData.value)
                  for (var orderDetail in MainController.dataRecord.value)
                    if(orderDetail != null)
                         TableRow(children: [
                      Obx(() {
                        return Center(
                          child: Txt(
                            '${orderDetail['Drawing_Number']}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      Center(child: Obx((){
                        String orderDetailId = orderDetail['_id'];
                        RxBool isChecked =  RxBool(ViewCustomController.orderDetailsSelected[orderDetailId] != null ? true:
                        ViewCustomController.statusOrderDetails[orderDetailId] != null ?
                        ViewCustomController.statusOrderDetails[orderDetailId]! : false);

                        return FormBuilderCheckbox(
                          key: Key('${orderDetailId}_${isChecked.value ? "1" : "0"}'),
                          decoration: InputDecoration(border: InputBorder.none),
                          enabled: ViewCustomController.statusOrderDetails.value[orderDetailId] == true ? false : true,
                          activeColor: colorBtn,
                          initialValue: isChecked.value,
                          side:  BorderSide(
                              color: MainController.isLightMode.value ? whiteColor : primaryDark,
                              width: 1.5,
                              strokeAlign: 2.5
                          ),
                          onChanged: (isChecked) async {
                            if(isChecked ==  true){
                              ViewCustomController.orderDetailsSelected[orderDetailId] = orderDetail;
                            }
                            else{
                              ViewCustomController.orderDetailsSelected.remove(orderDetailId);
                            }
                            ViewCustomController.orderDetailsSelected.refresh();
                          }, name: '', title: Txt(''),

                        );
                      })),
                      Obx(() {
                        return Center(
                          child: Txt(
                            '${orderDetail['Product_Name']['Title']}',
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
                            '${orderDetail['Product_Name']['Price']}',
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
                            '${orderDetail['First_Dimension']}',
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
                            '${orderDetail['Second_Dimension']}',
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
                            '${ViewCustomController.calculateTotalAreaOrderDetail(orderDetail['First_Dimension'] , orderDetail['Second_Dimension'])}',
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
                            '${orderDetail['Quantity']}',
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
                            '${orderDetail['Cut_Pattern'] != null ? orderDetail['Cut_Pattern']['title']:''}',
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
                            '${orderDetail['Manufacturing_Difficulty'] != null ? orderDetail['Manufacturing_Difficulty']['title']:''}',
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
                            '${orderDetail['Block'] != null ? orderDetail['Block']:''}',
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
                            '${orderDetail['Level'] != null ? orderDetail['Level']:''}',
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
                            '${orderDetail['Unit'] != null ? orderDetail['Unit']:''}',
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
                            '${ViewCustomController.
                            calculateTotalPriceOrderDetail(orderDetail['First_Dimension'] ,
                                orderDetail['Second_Dimension'] , orderDetail['Quantity'] , orderDetail['Product_Name']['Price'])}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                     Obx((){
                       String orderDetailId = orderDetail['_id'];
                       return  Center(
                         child: Container(
                           padding: EdgeInsets.only(left: 10 , right: 10 , top: 5 , bottom: 5),
                           decoration: BoxDecoration(
                             border: Border.all(color:ViewCustomController.statusOrderDetails.value[orderDetailId] != null ? ViewCustomController.statusOrderDetails.value[orderDetailId] == true ?  checkedOutBtnColor : notCheckedOutBtnColor  : notCheckedOutBtnColor, width: 1),
                             borderRadius:
                             BorderRadius.all(Radius.circular(20)),
                             color: ViewCustomController.statusOrderDetails.value[orderDetailId] != null ? ViewCustomController.statusOrderDetails.value[orderDetailId] == true ?  checkedOutBtnColor : notCheckedOutBtnColor :notCheckedOutBtnColor,
                           ),
                           child: Txt(
                             '${ViewCustomController.statusOrderDetails.value[orderDetailId] != null  ? ViewCustomController.statusOrderDetails.value[orderDetailId] == true ? '${AppController.of(context)!.value('out')}' : '${AppController.of(context)!.value('unbroken')}' : '${AppController.of(context)!.value('unbroken')}'}',
                             fontSize: 13,
                             fontWeight: FontWeight.w400,
                             color: whiteColor,
                           ),
                         ),
                       );
                     })
                    ])
              ],
            ),
          ),
        ),
      );
    });
  }
}
