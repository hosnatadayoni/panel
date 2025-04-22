import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
   Widget? child;
   String value;
   Color color;
   double size;
   Color colorText;
   double? borderRadius;
   double? top;
   double? bottom;
   double? left;
   double? right;

   CustomBadge({
    this.child,
    required this.value,
    this.color = Colors.transparent,
    this.size = 14,
    this.colorText = whiteColor,
    this.borderRadius,
     this.bottom,
     this.top,
     this.left,
     this.right,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget Box = IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
        ),
        child: Center(
          child: Txt(
            value,
            color:colorText ,
            fontSize: size,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ) ;
    if(child == null){
      return Box;
    }
    return Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
        child!,
        Positioned(
        right: this.right,
        top: this.top,
        bottom: this.bottom,
        left: this.left,
        child: Box,
        ),
        ],
    );
    }
}
