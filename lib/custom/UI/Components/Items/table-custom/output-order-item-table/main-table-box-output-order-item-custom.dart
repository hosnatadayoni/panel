import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-footer.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/UI/Components/Items/btn/btn-output-order-item.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/output-order-item-table/table-order-item-output-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/output-order-table/table-order-output-custom.dart';
import 'package:finance/custom/UI/Components/Views/output-order-item-page-custom/table-footer-output-order-item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MainTableBoxOutPutOrderItemCustom extends StatefulWidget {
  MainTableBoxOutPutOrderItemCustom(this.orderList);
  List<dynamic> orderList;

  @override
  State<MainTableBoxOutPutOrderItemCustom> createState() => _MainTableBoxOutPutOrderItemCustomState();
}

class _MainTableBoxOutPutOrderItemCustomState extends State<MainTableBoxOutPutOrderItemCustom> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
              TableBoxOrderItemOutPutCustom(widget.orderList),
              SizedBox(
                height: 20,
              ),
              TableFooterOutPutOrderItem(),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 100 , right: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ActionButton(
                      title: 'ثبت خروجی',
                      backgroundColor: notCheckedOutBtnColor,
                      textColor: whiteColor,
                      onTap: () async {
                        await ViewCustomController.registerCheckout();


                      },
                    ),
                    ActionButton(
                      title: 'برگشت خروجی',
                      backgroundColor: outPutBackBtnColor,
                      textColor: blackColor,
                      onTap: () {},
                    ),
                    ActionButton(
                      title: 'انصراف',
                      backgroundColor: cancelBtnColor,
                      textColor: whiteColor,
                      onTap: () {},
                    ),
                    ActionButton(
                      title: 'پیش ‌نمایش',
                      backgroundColor: previewBtnColor,
                      textColor: whiteColor,
                      onTap: () {},
                    ),
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
