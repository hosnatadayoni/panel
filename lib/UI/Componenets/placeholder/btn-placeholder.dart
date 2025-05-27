import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/placeholder/content-placeholder.dart';
import 'package:flutter/material.dart';

class ButtonPlaceholder extends StatelessWidget {
   double? width;
   double? height;
   Color? baseColor;
   Color? highlightColor;
   PlaceholderAnimationType? animationType;


   ButtonPlaceholder({
    this.width,
    this.baseColor,
     this.height,
     this.animationType,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container();
  }

   Widget box(double width , double height , Color baseColor){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: baseColor,
      ),
      width: width,
      height: height,
    );
   }
}