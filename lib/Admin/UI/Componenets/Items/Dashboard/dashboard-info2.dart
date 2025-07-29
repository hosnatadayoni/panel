import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:panel/Admin/UI/Componenets/Items/Dashboard/circle-progress-bar.dart';
import 'package:flutter/material.dart';
class DashboardInfo2 extends StatelessWidget {
   DashboardInfo2({required this.title , required this.color , required this.num});
   String title;
   Color color;
   double num;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(30),
      // width: 200,
      decoration: BoxDecoration(
          boxShadow: shadow,
         color: whiteColor,
      ),
      width:size.width > 600 ?  size.width / 4: size.width,
      child: Column(
        children: [
          Txt('${this.title}' , fontSize: 16 , fontWeight: FontWeight.w200, color: color1),
          SizedBox(height: 15,),
          CircleProgressBar(color: this.color,num: this.num,)
        ],
      ),
    );
  }
}
