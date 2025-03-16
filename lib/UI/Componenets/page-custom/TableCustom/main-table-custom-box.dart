import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/column-scroll.dart';
import 'package:finance/UI/Componenets/Items/Table/table-footer.dart';
import 'package:finance/UI/Componenets/Items/Table/table-header.dart';
import 'package:finance/UI/Componenets/Items/Table/table.dart';
import 'package:finance/UI/Componenets/page-custom/TableCustom/table-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class MainTableCustomBox extends StatelessWidget {
  MainTableCustomBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MainController.isLightMode.value == true ? background :whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: MainController.isLightMode.value == true ?background:dark2 )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColumnScroll(
            children: [
              TableHeader(),
              SizedBox(height: 10,),
              TableCustomBox(),
              SizedBox(height: 20,),
              TableFooter(),
            ],
          ),
        ],
      ),
    );
  }
}