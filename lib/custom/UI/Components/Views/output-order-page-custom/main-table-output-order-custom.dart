import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/order-table/main-table-box-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/output-order-table/main-table-box-output-order-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-header/table-output-header.dart';
import 'package:finance/custom/UI/Components/Views/output-order-item-page-custom/table-output-order-item-page-custom.dart';
import 'package:finance/custom/UI/Components/Views/output-order-page-custom/table-output-order-page-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class MainTableOutPutOrderCustom extends StatefulWidget {
  MainTableOutPutOrderCustom();


  @override
  State<MainTableOutPutOrderCustom> createState() => _MainTableOutPutOrderCustomState();
}

class _MainTableOutPutOrderCustomState extends State<MainTableOutPutOrderCustom> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    RxInt count = RxInt(MainController.infoSchema.value.schema.countShowRow);
    return Obx((){
      return Scaffold(
          body: Container(
              width: size.width,
              height: size.height,
              child:  Stack(
                children: [
                  Positioned(
                    right: Directionality.of(context) == TextDirection.rtl ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                    left: Directionality.of(context) == TextDirection.ltr ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                    child: Container(
                      height: size.height,
                      width:size.width > 800 ? MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50 : (size.width) - 50,
                      padding: EdgeInsets.all(size.width > 800 ? 15 : 0),
                      color: MainController.isLightMode.value == false ? color6 :color9,
                      child: ColumnScroll(
                        children: [
                          SizedBox(height: 80,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Txt('${AppController.of(context)!.value('order list')}',
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: MainController.isLightMode.value == true
                                    ? whiteColor
                                    : primaryDark,
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          InkWell(
                            onTap: () async {
                              if(ViewCustomController.ordersSelected.length != 0){
                                for(var OrderDetailsSelected in ViewCustomController.ordersSelected.entries){
                                  for(var orderDetailSelected in OrderDetailsSelected.value){
                                    ViewCustomController.statusOrderDetails[orderDetailSelected['_id']] =  await ViewCustomController.getStatusOrderDetail(orderDetailSelected['_id']);
                                  }
                                }

                                ViewCustomController.isClickedBtnRegister.value = true;


                                await HelperController.pageInateFunction();
                                Navigator.push(
                                    Get.context!, MaterialPageRoute(builder: (context) => TablePageOutPutOrderItemCustom()));
                              }
                              else{
                                showSnackbar(snackTypes.error, 'سفارشی انتخاب نشده');
                              }
                              },

                            child: Container(
                              width: size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 20 , left: 20 , top: 10,bottom: 10),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.orange,),
                                    child: Center(child: Txt('${AppController.of(context)!.value('register selected orders for checkout')}')),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          TableOutPutHeader(),
                          SizedBox(height: 25,),
                          MainTableBoxOutPutOrderCustom(),
                        ],
                      ),
                    ),
                  ),
                  Header(),
                  MenuBox(),
                ],
              )
          )
      );
    });
  }
}
