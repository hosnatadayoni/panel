import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/placeholder/content-placeholder.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class ImgPlaceholder extends StatelessWidget {
   double? width;
   double? height;
   Color? baseColor;
   Color? highlightColor;
   Color? boxColor;
   double? borderRadius;
   PlaceholderAnimationType? animationType;
   ImgPlaceholder({this.width ,
     this.height,
     this.baseColor ,
     this.highlightColor ,
     this.boxColor = whiteColor,
     this.borderRadius = 10,
     this.animationType,
   });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return _buildAnimatedPlaceholder(
      width: this.width ??size.width,
      height: this.height ?? 50,
      animationType: this.animationType,
      baseColor: this.baseColor != null ? this.baseColor! : Colors.grey[300]!,
      highlightColor:this.highlightColor != null ? this.highlightColor! : Colors.grey[100]!,
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
           child: Container(
             decoration: BoxDecoration(
               color: this.boxColor,
               borderRadius: BorderRadius.circular(this.borderRadius!)
             ),
             width: width,
             height: height,

           ),
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
           child: Container(
             decoration: BoxDecoration(
                 color: this.boxColor,
                 borderRadius: BorderRadius.circular(this.borderRadius!)
             ),
             width: width,
             height: height,
           ),
         );
       default:
         return Container(
           width: width,
           height: height,
           decoration: BoxDecoration(
               color: baseColor,
               borderRadius: BorderRadius.circular(this.borderRadius!)
           ),
         );
     }
   }
}
