import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardInfo3 extends StatelessWidget {
   DashboardInfo3({required this.icon , required this.count , required this.description});
   IconData icon;
   String count;
   String description;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(30),
      width:size.width > 800 ?  size.width / 7: size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(this.icon, size: 40,),
              Column(
                children: [
                  Txt('${this.count}' , color: whiteColor, fontSize: 16,fontWeight: FontWeight.w500,),
                  SizedBox(height: 20,),
                  Txt('${this.description}' , color: whiteColor, fontSize: 16,fontWeight: FontWeight.w200,),

                ],
              )

            ],
          ),
          SizedBox(height: 30,),
          Container(
            child: Row(
              children: [
                InkWell(

                  child: Container(
                    width:20,
                    height: 20,
                    color: whiteColor,
                    child: Center(child: Icon(Icons.arrow_forward , size: 20, color: Colors.transparent,)),
                  ),
                ),
                SizedBox(width: 5,),
                Txt('More Info', fontSize: 16,fontWeight: FontWeight.w200, color: whiteColor,),
              ],
            ),
          )
        ],
      )
    );
  }
}
