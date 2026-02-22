import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/main-table-box.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/main-table-header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-header.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/order-table/main-table-box-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/output-order-item-table/main-table-box-output-order-item-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/output-order-table/main-table-box-output-order-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-header/table-order-item-output-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-header/table-output-header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class MainTableOutPutOrderItemCustom extends StatefulWidget {
  MainTableOutPutOrderItemCustom();

  @override
  State<MainTableOutPutOrderItemCustom> createState() =>
      _MainTableOutPutOrderItemCustomState();
}

class _MainTableOutPutOrderItemCustomState
    extends State<MainTableOutPutOrderItemCustom> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    RxInt count = RxInt(MainController.infoSchema.value.schema.countShowRow);

    return Obx(() {
      return Scaffold(
          body: Container(
              width: size.width,
              height: size.height,
              child: Stack(
                children: [
                  Positioned(
                    right: Directionality.of(context) == TextDirection.rtl
                        ? size.width > 800
                            ? MainController.isClickedItem.value == true
                                ? 300
                                : 50
                            : 50
                        : 0,
                    left: Directionality.of(context) == TextDirection.ltr
                        ? size.width > 800
                            ? MainController.isClickedItem.value == true
                                ? 300
                                : 50
                            : 50
                        : 0,
                    child: Container(
                      height: size.height,
                      width: size.width > 800
                          ? MainController.isClickedItem.value == true
                              ? (size.width) - 300
                              : (size.width) - 50
                          : (size.width) - 50,
                      padding: EdgeInsets.all(size.width > 800 ? 15 : 0),
                      color: MainController.isLightMode.value == false
                          ? color6
                          : color9,
                      child: ColumnScroll(
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Txt(
                                'لیست سفارش ها',
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: MainController.isLightMode.value == true
                                    ? whiteColor
                                    : primaryDark,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Obx(() {
                            RxBool isChecked = false.obs;
                            if (ViewCustomController.getOrderDetailsOrderSelectedList().length != 0) {
                              if (ViewCustomController.getOrderDetailsOrderSelectedList().length == ViewCustomController.orderDetailsSelected.value.length) {
                                isChecked.value = true;
                              } else {
                                isChecked.value = false;
                              }
                            }
                            bool hasAnyTrueInMapA = ViewCustomController.statusOrderDetails.values.any((value) => value == true);
                            return Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor:
                                          MainController.isLightMode.value
                                              ? whiteColor
                                              : primaryDark,
                                    ),
                                    child: Checkbox(
                                      value: isChecked.value,
                                      onChanged: hasAnyTrueInMapA ? null : (val) async {
                                        bool newValue = val ?? false;
                                        for (var allOrdersDetail
                                            in ViewCustomController.ordersSelected.entries) {
                                          for (var orderDetail
                                              in allOrdersDetail.value) {
                                            if (newValue == true) {
                                              if (await ViewCustomController.getStatusOrderDetail(orderDetail['_id']) == false) {
                                                ViewCustomController.orderDetailsSelected[orderDetail['_id']] = orderDetail;
                                              } else {
                                                ViewCustomController
                                                    .orderDetailsSelected
                                                    .remove(orderDetail['_id']);
                                              }
                                            } else {
                                              ViewCustomController
                                                  .orderDetailsSelected
                                                  .remove(orderDetail['_id']);
                                            }
                                          }
                                        }
                                        ViewCustomController
                                            .orderDetailsSelected
                                            .refresh();
                                        print('ViewCustomController.orderDetailsSelected UUU>>>${ViewCustomController.orderDetailsSelected}');
                                      },
                                      activeColor: colorBtn,
                                      checkColor: whiteColor,
                                      side: BorderSide(
                                          color:
                                              MainController.isLightMode.value
                                                  ? whiteColor
                                                  : primaryDark,
                                          width: 2),
                                      // border
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () async {
                                      bool newValue = !isChecked.value;
                                      for (var allOrdersDetail
                                          in ViewCustomController
                                              .ordersSelected.entries) {
                                        for (var orderDetail
                                            in allOrdersDetail.value) {
                                          if (newValue == true) {
                                            if (await ViewCustomController
                                                    .getStatusOrderDetail(
                                                        orderDetail['_id']) ==
                                                false) {
                                              ViewCustomController
                                                          .orderDetailsSelected[
                                                      orderDetail['_id']] =
                                                  orderDetail;
                                            } else {
                                              ViewCustomController
                                                  .orderDetailsSelected
                                                  .remove(orderDetail['_id']);
                                            }
                                          } else {
                                            ViewCustomController
                                                .orderDetailsSelected
                                                .remove(orderDetail['_id']);
                                          }
                                        }
                                      }


                                      ViewCustomController.orderDetailsSelected
                                          .refresh();
                                    },
                                    child: Txt(
                                      'همه موارد',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: MainController.isLightMode.value
                                          ? whiteColor
                                          : color2,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          TableHeader(),
                          SizedBox(
                            height: 25,
                          ),
                          MainTableBoxOutPutOrderItemCustom(),
                        ],
                      ),
                    ),
                  ),
                  Header(),
                  MenuBox(),
                ],
              )));
    });
  }
}
