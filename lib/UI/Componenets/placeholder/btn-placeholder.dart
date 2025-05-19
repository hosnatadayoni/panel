import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/placeholder/content-placeholder.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
    return IgnorePointer(
      ignoring: true,
      child: _buildAnimatedPlaceholder(
        width: this.width ??size.width,
        height: this.height ?? 40,
        animationType: this.animationType,
        baseColor: this.baseColor != null ? this.baseColor : color37,
        highlightColor:this.highlightColor != null ? this.highlightColor! : Colors.grey[100]!,
      ),
    );
  }
   Widget _buildAnimatedPlaceholder({
     double? width,
     double? height,
     PlaceholderAnimationType? animationType,
     Color? baseColor,
     Color? highlightColor,
   }) {
     switch (animationType) {
       case PlaceholderAnimationType.glow:
         return Shimmer.fromColors(
           baseColor: baseColor!,
           highlightColor: highlightColor!,
           period: const Duration(milliseconds: 1500),
           child: box(width! , height! , baseColor),
         );
       case PlaceholderAnimationType.wave:
         return Shimmer(
           gradient: LinearGradient(
             colors: [
               baseColor!,
               highlightColor!,
               baseColor,
             ],
             stops: const [0.1, 0.5, 0.9],
           ),
           period: const Duration(milliseconds: 2000),
           child: box(width! , height! , baseColor),
         );
       default:
         return box(width! , height! , baseColor!);
     }
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