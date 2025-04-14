import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardInfo3 extends StatelessWidget {
   DashboardInfo3({required this.icon , required this.count , required this.description , required this.color});
   IconData icon;
   String count;
   String description;
   Color color;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width:size.width > 800 ?  size.width / 7: size.width,
      color: this.color,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(this.icon, size: 50,),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Txt('${this.count}' , color: whiteColor, fontSize: 20,fontWeight: FontWeight.w700,),
                    SizedBox(height: 10,),
                    Txt('${this.description}' , color: whiteColor, fontSize: 16,fontWeight: FontWeight.w200,),

                  ],
                ))
              ],
            ),
          ),
          SizedBox(height: 30,),
          InkWell(
            onTap: (){},
            child: Container(
              color: color13.withOpacity(0.2),
              padding: EdgeInsets.only(top: 10,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width:20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: whiteColor,
                    ),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Icon(
                        Icons.arrow_forward,
                        size: 20,
                        color: this.color,
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Txt('More Info', fontSize: 16,fontWeight: FontWeight.w200, color: whiteColor,),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
