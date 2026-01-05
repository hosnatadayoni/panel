import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-footer.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/output-order-item-table/table-order-item-output-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/output-order-table/table-order-output-custom.dart';
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
              TableFooter(),
            ],
          ),
        ],
      ),
    );
  }
}
