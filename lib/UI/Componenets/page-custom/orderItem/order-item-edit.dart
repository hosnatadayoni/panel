import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Logic/Models/dataModel.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/column-scroll.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Header/header.dart';
import 'package:finance/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/UI/Componenets/page-custom/orderItem/form-edit-orderItem-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderItemEdit extends StatelessWidget {
  OrderItemEdit({this.data});
  var data;


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print('data2>>>${data}');
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
        ),
        child: Stack(
          children: [
            Obx((){
              return Positioned(
                right: size.width > 800 ? MainController.isClickedItem.value == true ? 300 :50 : 50,
                child: Container(
                  width:size.width > 800 ? MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50 : (size.width) - 50,
                  height: size.height,
                  padding: EdgeInsets.all(15),
                  // color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
                  color: MainController.isLightMode.value == false ? color6 :color9,
                  child:  ColumnScroll(
                    children: [
                      SizedBox(height: 80,),
                      // FormEditOrderItemCustom(data: data),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              );
            }),
            Header(),
            MenuBox(),
          ],
        ),
      ),
    );
  }
}
