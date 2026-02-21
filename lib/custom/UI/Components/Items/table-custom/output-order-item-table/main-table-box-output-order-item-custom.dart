import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
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


class MainTableBoxOutPutOrderItemCustom extends StatefulWidget {
  MainTableBoxOutPutOrderItemCustom();

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
                          await ViewCustomController.registerCheckout();
                          await ViewCustomController.getStatusOutPutOrders(MainController.dataRecord.value);
                          Navigator.push(
                              Get.context!, MaterialPageRoute(builder: (context) => TablePageOutPutOrderCustom()));
                        },
                      ),
                    ),
                    Container(
                      width: 120,
                      child: ActionButton(
                        title: '${AppController.of(context)!.value('back outPut')}',
                        backgroundColor: outPutBackBtnColor,
                        textColor: blackColor,
                        onTap: () {},
                      ),
                    ),
                    Container(
                      width: 80,
                      child: ActionButton(
                        title: '${AppController.of(context)!.value('cancel')}',
                        backgroundColor: cancelBtnColor,
                        textColor: whiteColor,
                        onTap: () {},
                      ),
                    ),
                    Container(
                      width: 110,
                      child: ActionButton(
                        title: '${AppController.of(context)!.value('preview')}',
                        backgroundColor: previewBtnColor,
                        textColor: whiteColor,
                        onTap: () {},
                      ),
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
