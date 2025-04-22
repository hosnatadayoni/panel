import 'package:flutter/material.dart';
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
class CustomCard extends StatelessWidget {
  final Widget? child;
  final Widget? cardText; // متن با استایل خاص
  final Widget? cardImgTop; // تصویر بالایی
  final Widget? cardImgBottom; // تصویر پایینی
  final Color backgroundColor;
  final double elevation;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final bool clipTopImage; // آیا تصویر بالایی گوشه‌های گرد داشته باشد؟
  final bool clipBottomImage; // آیا تصویر پایینی گوشه‌های گرد داشته باشد?

  const CustomCard({
    this.child,
    this.cardText,
    this.cardImgTop,
    this.cardImgBottom,
    this.backgroundColor = Colors.transparent,
    this.elevation = 2,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.all(16),
    this.borderColor,
    this.clipTopImage = true,
    this.clipBottomImage = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // تصویر بالایی با گوشه‌های گرد
          if (cardImgTop != null)
            clipTopImage
                ? ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
              child: cardImgTop!,
            )
                : cardImgTop!,

          // محتوای اصلی
          Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (child != null) child!,
                if (cardText != null)
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    child: cardText!,
                  ),
              ],
            ),
          ),

          // تصویر پایینی با گوشه‌های گرد
          if (cardImgBottom != null)
            clipBottomImage
                ? ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
              ),
              child: cardImgBottom!,
            )
                : cardImgBottom!,
        ],
      ),
    );
  }
}