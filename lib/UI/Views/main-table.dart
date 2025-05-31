import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/column-scroll.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Header/header.dart';
import 'package:finance/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/UI/Componenets/Items/Table/main-table-box.dart';
import 'package:finance/UI/Componenets/Items/Table/main-table-header.dart';
import 'package:finance/UI/Componenets/Items/Table/table-footer.dart';
import 'package:finance/UI/Componenets/Items/Table/table-header.dart';
import 'package:finance/UI/Componenets/Items/Table/table.dart';
import 'package:finance/UI/Views/create.dart';
import 'package:finance/UI/Views/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class MainTable extends StatefulWidget {

   MainTable();

  @override
  State<MainTable> createState() => _MainTableState();
}

class _MainTableState extends State<MainTable> {

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
                    right: size.width > 800 ? MainController.isClickedItem.value == true ? 300 :50 : 50,
                    child: Container(
                      height: size.height,
                      width:size.width > 800 ? MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50 : (size.width) - 50,
                      padding: EdgeInsets.all(size.width > 800 ? 15 : 0),
                      color: MainController.isLightMode.value == false ? color6 :color9,
                      child: ColumnScroll(
                        children: [
                          SizedBox(height: 80,),
                          MainTableHeader(),
                          SizedBox(height: 25,),
                          MainTableBox(),
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