import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/Admin/UI/Views/main-table.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/order-detail-table/main-table-box-order-detail.dart';
import 'package:finance/custom/UI/Components/Views/order-detail-page-custom/main-table-orderdetail-custom.dart';
import 'package:finance/custom/UI/Components/Views/order-page-custom/main-table-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TablePageOrderDetailCustom extends StatelessWidget {
  TablePageOrderDetailCustom(this.schema);
  var schema;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Obx((){
          return Container(
            width: size.width,
            height: size.height,
            color: MainController.isLightMode.value == false ? primary :primaryDark,
            child: Stack(
              children: [
                Header(),
                MenuBox(),
                if(MainController.selectedSubItem.value != -1)
                  MainTableOrderDetailCustom(this.schema)
              ],
            ),
          );
        })
    );
  }
}
