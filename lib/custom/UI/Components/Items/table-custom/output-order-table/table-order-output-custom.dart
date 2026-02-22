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
  TableBoxOrderOutPutCustom();



  @override
  State<TableBoxOrderOutPutCustom> createState() =>
      _TableBoxOrderOutPutCustomState();
}

class _TableBoxOrderOutPutCustomState extends State<TableBoxOrderOutPutCustom> {
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
    return Obx(() {
      return Container(
        color:
            MainController.isLightMode.value == true ? background : whiteColor,
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
                    Center(child: Txt('#' , fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color:
                      MainController.isLightMode.value == true ? whiteColor : color2,
                      textAlign: TextAlign.center,)),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Txt(
                          '${AppController.of(context)!.value('select')}',
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
                          '${AppController.of(context)!.value('input code')}',
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
                          '${AppController.of(context)!.value('customer')}',
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
                          '${AppController.of(context)!.value('entry date')}',
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
                          '${AppController.of(context)!.value('plan number')}',
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
                          '${AppController.of(context)!.value('customer order')}',
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
                if (MainController.dataRecord.value.length != 0)
                  for (var i = 0; i < MainController.dataRecord.value.length; i++)
                    TableRow(children: [
                      Center(
                        child: Txt(
                          '${i+1}',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                          MainController.isLightMode.value == true ? whiteColor : color2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Center(child: Obx(() {
                        String orderId = MainController.dataRecord[i]['_id'];
                        Rx<bool> isChecked = RxBool(ViewCustomController.status.value[orderId] != null
                            ? ViewCustomController.status.value[orderId]!
                                ? true
                                : false
                            : false);
                        return ViewCustomController.status.value[orderId] !=null?
                        FormBuilderCheckbox(
                          key: Key('${orderId}'),
                          decoration: InputDecoration(border: InputBorder.none,),
                          activeColor: colorBtn,
                          // initialValue:ViewCustomController.status.value[orderId]  ,
                          initialValue:ViewCustomController.status.value[orderId] == true ? ViewCustomController.status.value[orderId] : ViewCustomController.ordersSelected.containsKey(orderId),
                          enabled: ViewCustomController.status.value[orderId] != null
                              ? ViewCustomController.status.value[orderId]!
                                  ? false
                                  : true
                              : true,
                          side: BorderSide(
                              color: MainController.isLightMode.value ? whiteColor : primaryDark,
                              width: 1.5,
                              strokeAlign: 2.5),
                          onChanged: (checked) async {
                            if (checked == true) {
                              var orderDetailSelected = await ViewCustomController
                                  .getDataOrderDetailList(orderId);
                              for(var orderDetail in orderDetailSelected){
                                orderDetail['Drawing_Number'] = await ViewCustomController.getDrawingNumberOrder(orderId);
                              }
                              ViewCustomController.ordersSelected[orderId] = orderDetailSelected;
                              ViewCustomController.allOrdersSelected.add(MainController.dataRecord[i]);

                            } else {
                              ViewCustomController.ordersSelected.remove(orderId);
                              ViewCustomController.allOrdersSelected.remove(MainController.dataRecord[i]);
                            }
                            ViewCustomController.ordersSelected.refresh();
                            ViewCustomController.allOrdersSelected.refresh();
                            HelperController.pageInateFunction();
                          },
                          name: '',
                          title: Txt(''),
                        ):
                        Container();
                      })),
                      Obx(() {
                        return Center(
                          child: Txt(
                            '${MainController.dataRecord[i]['Input_Code']}',
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
                            '${MainController.dataRecord[i]['Customer'] != null ? MainController.dataRecord[i]['Customer']['Name_and_lastName'] : ""}',
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
                            '${MainController.dataRecord[i]['Date']}',
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
                            '${MainController.dataRecord[i]['Drawing_Number']}',
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
                            '${MainController.dataRecord[i]['Drawing_Number(customer)']}',
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
                        String orderId = MainController.dataRecord[i]['_id'];
                        return Center(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ViewCustomController.status.value[orderId] != null
                                      ? ViewCustomController.status.value[orderId]!
                                          ? checkedOutBtnColor
                                          : notCheckedOutBtnColor
                                      : notCheckedOutBtnColor,
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: ViewCustomController.status.value[orderId] != null
                                  ? ViewCustomController.status.value[orderId]!
                                      ? checkedOutBtnColor
                                      : notCheckedOutBtnColor
                                  : notCheckedOutBtnColor,
                            ),
                            child: Txt(
                              '${ViewCustomController.status.value[orderId] != null ? ViewCustomController.status.value[orderId]! ? '${AppController.of(context)!.value('out')}' : '${AppController.of(context)!.value('unbroken')}' : '${AppController.of(context)!.value('unbroken')}'}',
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
