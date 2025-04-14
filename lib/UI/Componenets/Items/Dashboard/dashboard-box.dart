import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
class DashboardBox extends StatelessWidget {
   DashboardBox({required this.icon , required this.count ,this.text , required this.index});
   IconData icon;
   int count;
   var text;
   int index;


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx((){
      final isHovered = MainController.hoveredIndex.value == index;

      return InkWell(
        onTap: (){
          MainController.hoveredIndex.value = this.index;
        },
        child: MouseRegion(
          onEnter: (_){
            MainController.hoveredIndex.value = this.index;
          },
          onExit: (_){
            MainController.hoveredIndex.value = -1;
          },
          child: Obx((){
            return Container(
              padding: EdgeInsets.all(30),
              width:  size.width > 800 ? size.width /3: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color:MainController.isLightMode.value == true ?background : whiteColor,
                boxShadow: shadow
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: isHovered ? primary:color11,
                    ),
                    child: Icon(this.icon , color: whiteColor,size: 32,),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Txt('${this.count}' , fontSize: 30 , fontWeight: FontWeight.w500, color: MainController.isLightMode.value == true ?whiteColor : color1,),
                      SizedBox(height: 5,),
                      Txt('${this.text}' , fontSize: 16 , fontWeight: FontWeight.w200, color: MainController.isLightMode.value == true ?whiteColor : color1,),
                    ],
                  )
                ],
              ),
            );
          }),
        ),
      );
    });

  }
}
