import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/main-table-box.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/main-table-header.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/lable-table/lable-detail-table/main-table-lable-detail-box-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/lable-table/main-table-lable-box-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/order-table/main-table-box-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class MainTableLableDetailCustom extends StatefulWidget {
  MainTableLableDetailCustom(this.index);
  String index;

  @override
  State<MainTableLableDetailCustom> createState() => _MainTableLableDetailCustomState();
}

class _MainTableLableDetailCustomState extends State<MainTableLableDetailCustom> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
                          // MainTableHeader(),
                          SizedBox(height: 25,),
                          MainTableLableDetailBoxCustom(widget.index),

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
