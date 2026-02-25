import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-footer.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/order-table/table-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/output-order-table/table-order-output-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:get/get.dart';

class MainTableBoxOutPutOrderCustom extends StatefulWidget {
  MainTableBoxOutPutOrderCustom();


  @override
  State<MainTableBoxOutPutOrderCustom> createState() => _MainTableBoxOutPutOrderCustomState();
}

class _MainTableBoxOutPutOrderCustomState extends State<MainTableBoxOutPutOrderCustom> {
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
              TableBoxOrderOutPutCustom(),
              SizedBox(
                height: 20,
              ),
              TableFooter(index:MainController.menuList.value.indexWhere((element) => element.schema.name=="Orders")),
            ],
          ),
        ],
      ),
    );
  }
}
