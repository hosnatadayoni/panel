import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/img.dart';
import 'package:finance/Admin/UI/Componenets/General/myDivider.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'btn.dart';
// class CustomCard extends StatelessWidget {
//   final Widget child;
//   final Color backgroundColor;
//   final double elevation;
//   final double borderRadius;
//   final EdgeInsetsGeometry padding;
//   Color? borderColor;
//
//
//    CustomCard({
//     required this.child,
//     this.backgroundColor = Colors.transparent,
//     this.elevation = 2,
//     this.borderRadius = 8,
//     this.padding = const EdgeInsets.all(16),
//     this.borderColor,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(borderRadius),
//         border: Border.all(color: borderColor! , width: 1),
//         // boxShadow: [
//         //   BoxShadow(
//         //     color: Colors.black.withOpacity(0.1 * elevation),
//         //     blurRadius: elevation * 3,
//         //     spreadRadius: elevation * 0.5,
//         //     offset: Offset(0, elevation),
//         //   ),
//         // ],
//       ),
//       child: Padding(
//         padding: padding,
//         child: child,
//       ),
//     );
//   }
// }


// class CustomCard extends StatelessWidget {
//   final Widget? child;
//   final Widget? cardText; // متن با استایل خاص
//   final Widget? cardImgTop; // تصویر بالایی
//   final Widget? cardImgBottom; // تصویر پایینی
//   final Color backgroundColor;
//   final double elevation;
//   final double borderRadius;
//   final EdgeInsetsGeometry padding;
//   final Color? borderColor;
//   final bool clipTopImage; // آیا تصویر بالایی گوشه‌های گرد داشته باشد؟
//   final bool clipBottomImage; // آیا تصویر پایینی گوشه‌های گرد داشته باشد?
//
//   const CustomCard({
//     this.child,
//     this.cardText,
//     this.cardImgTop,
//     this.cardImgBottom,
//     this.backgroundColor = Colors.transparent,
//     this.elevation = 2,
//     this.borderRadius = 8,
//     this.padding = const EdgeInsets.all(16),
//     this.borderColor,
//     this.clipTopImage = true,
//     this.clipBottomImage = true,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(borderRadius),
//         border: borderColor != null
//             ? Border.all(color: borderColor!, width: 1)
//             : null,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // تصویر بالایی با گوشه‌های گرد
//           if (cardImgTop != null)
//             clipTopImage
//                 ? ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(borderRadius),
//                 topRight: Radius.circular(borderRadius),
//               ),
//               child: cardImgTop!,
//             )
//                 : cardImgTop!,
//
//           // محتوای اصلی
//           Padding(
//             padding: padding,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (child != null) child!,
//                 if (cardText != null)
//                   DefaultTextStyle(
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.black87,
//                       height: 1.5,
//                     ),
//                     child: cardText!,
//                   ),
//               ],
//             ),
//           ),
//
//           // تصویر پایینی با گوشه‌های گرد
//           if (cardImgBottom != null)
//             clipBottomImage
//                 ? ClipRRect(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(borderRadius),
//                 bottomRight: Radius.circular(borderRadius),
//               ),
//               child: cardImgBottom!,
//             )
//                 : cardImgBottom!,
//         ],
//       ),
//     );
//   }
// }

import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/img.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
enum directionCard{
  left,
  right,
  center
}
class CustomCard extends StatelessWidget {
  Color? colorBox;
  Color? borderColorBox;
  Widget? body;
  // Img? imageTop;
  // Img? imageBottom;
  String? cardHeader;
  String? cardFooter;
  double? width;
  Color? headerOrFooterBackgroundColor;
  Color? cardHeaderOrFooterColor;
  Color? cardHeaderOrFooterBorderColor;
  directionCard d;
  bool? imageOverlay;
  String? imgUrl;
  // bool? horizental;
  // int? flexRight;
  // int? flexLeft;
  double? hieght;
  double? padding;

  CustomCard({
    this.colorBox ,
    this.borderColorBox = Colors.grey ,
    this.body,
    // this.imageTop,
    // this.imageBottom,
    this.cardHeader,
    this.cardFooter,
    this.width,
    this.headerOrFooterBackgroundColor =color38,
    this.cardHeaderOrFooterColor,
    this.cardHeaderOrFooterBorderColor = itemColor25,
    this.d = directionCard.right,
    this.imageOverlay = false,
    this.imgUrl,
    // this.horizental = false,
    // this.flexRight =  4,
    // this.flexLeft =  6,
    this.hieght,
    this.padding=  16,
  });
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        width: this.width != null ? this.width : size.width,
        height: this.hieght != null ? this.hieght : null,
        decoration: BoxDecoration(
          color:this.colorBox,
          border: Border.all(color: this.borderColorBox! , width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children:[
            if(this.cardHeader != null)
              Positioned(
                top:0,
                right: 0,
                left: 0,
                child:  ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                  child: Container(
                    width:this.width != null ? this.width : size.width,
                    padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: this.cardHeaderOrFooterBorderColor != null ?this.cardHeaderOrFooterBorderColor!: Colors.transparent,
                          width: 1,
                        ),
                      ),

                      color: this.headerOrFooterBackgroundColor,
                    ),
                    child: this.d == directionCard.center ? Center(
                      child: Container(
                          child: Txt(this.cardHeader! , color: this.cardHeaderOrFooterColor, fontSize: 16,)),
                    ):Container(
                        child: Txt(this.cardHeader! , color: this.cardHeaderOrFooterColor, fontSize: 16,)),
                  ),
                ),),
            if(this.cardFooter != null)
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child:  ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  child: Container(
                    width:this.width != null ? this.width : size.width,
                    padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: this.cardHeaderOrFooterBorderColor != null ?this.cardHeaderOrFooterBorderColor!: Colors.transparent,
                          width: 1,
                        ),
                      ),
                      color: this.headerOrFooterBackgroundColor,
                    ),
                    child: this.d == directionCard.center ? Center(
                      child: Container(
                          child: Txt(this.cardFooter! , color: this.cardHeaderOrFooterColor, fontSize: 16,)),
                    ):Container(
                        child: Txt(this.cardFooter! , color: this.cardHeaderOrFooterColor, fontSize: 16,)),
                  ),
                ),),
            this.imageOverlay! ?
            Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1 , color: this.borderColorBox!)
                    ),
                    width: this.width,
                    child: Img(this.imgUrl!,width: this.width != null ? this.width : size.width, height: this.hieght != null ? this.hieght : 300 ,radius: 5,)),
                Box(context),
              ],
            ) : Box(context),
          ],
        )
    );
  }
  Widget Box(context){
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: this.cardHeader != null ? 40 : 0, bottom: this.cardFooter != null ? 40 : 0),
      width: this.width != null ? this.width : size.width,
      padding: EdgeInsets.all(this.padding!),
      child: this.d == directionCard.center ? Center(child: this.body!,) : this.body!,
    );
  }
// Widget ColumnBox(context){
//   var size = MediaQuery.of(context).size;
//   return Column(
//     children: [
//       // if (this.imageTop != null)
//       //   Container(
//       //     width: this.width != null ? this.width : size.width,
//       //     decoration: BoxDecoration(
//       //       borderRadius: BorderRadius.only(
//       //         topLeft: Radius.circular(15),
//       //         topRight: Radius.circular(15),
//       //         bottomLeft: Radius.circular(0),
//       //         bottomRight: Radius.circular(0),
//       //
//       //       ),
//       //       color: Colors.blueGrey,
//       //
//       //     ),
//       //     child: Center(child: this.imageTop!),),
//       if(this.cardHeader != null)
//         SizedBox(height: 40,),
//       Container(
//         width: this.width != null ? this.width : size.width,
//         padding: EdgeInsets.all(16),
//         child: this.d == directionCard.center ? Center(child: this.body!,) : this.body!,
//       ),
//       if(this.cardFooter != null)
//         SizedBox(height: 40,),
//       // if (imageBottom != null)
//       //   Container(
//       //     width: this.width != null ? this.width : size.width,
//       //     decoration: BoxDecoration(
//       //       borderRadius: BorderRadius.only(
//       //         topLeft: Radius.circular(0),
//       //         topRight: Radius.circular(0),
//       //         bottomLeft: Radius.circular(15),
//       //         bottomRight: Radius.circular(15),
//       //
//       //       ),
//       //       color: Colors.blueGrey,
//       //
//       //     ),
//       //     child: this.imageBottom!,),
//     ],
//   );
// }
}

