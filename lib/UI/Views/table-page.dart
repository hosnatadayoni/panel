import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/Items/Header/header.dart';
import 'package:finance/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/UI/Componenets/page-custom/TableCustom/table-custom-page.dart';
import 'package:finance/UI/Views/main-table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
class TablePage extends StatelessWidget {
   TablePage();

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
                Header(title: ''),
                MenuBox(),
                if(MainController.selectedSubItem.value != -1)
                  MainTable()
              ],
            ),
          );
        })
    );
  }
}
