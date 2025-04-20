import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';

// class BadgeCustom extends StatelessWidget {
//   final Widget child;
//   final String value;
//   final Color? color;
//   final double? fontSize;
//
//   BadgeCustom({
//     Key? key,
//     required this.child,
//     required this.value,
//     this.color,
//     this.fontSize,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         child,
//         Positioned(
//           right: 0,
//           top: 0,
//           child: Container(
//             padding: EdgeInsets.all(2),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: color ?? Theme.of(context).colorScheme.secondary,
//             ),
//             constraints: BoxConstraints(
//               minWidth: 16,
//               minHeight: 16,
//             ),
//             child: Text(
//               value,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: fontSize ?? 10,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

// class AdvancedBadge extends StatelessWidget {
//   final Widget child;
//   final String? text;
//   final Widget? badgeContent;
//   final Color? color;
//   final Color? textColor;
//   final double? size;
//   final bool showBadge;
//   final BadgeShape shape;
//   final BadgePosition position;
//   final EdgeInsets? padding;
//   final double? borderRadius;
//   final VoidCallback? onTap;
//   final bool isDot;
//   final double offsetX;
//   final double offsetY;
//
//   const AdvancedBadge({
//     Key? key,
//     required this.child,
//     this.text,
//     this.badgeContent,
//     this.color,
//     this.textColor,
//     this.size,
//     this.showBadge = true,
//     this.shape = BadgeShape.circular,
//     this.position = BadgePosition.topEnd,
//     this.padding,
//     this.borderRadius,
//     this.onTap,
//     this.isDot = false,
//     this.offsetX = 0,
//     this.offsetY = 0,
//   })  : assert(text == null || badgeContent == null,
//   'Cannot provide both text and badgeContent'),
//         super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if (!showBadge || (text == null && badgeContent == null && !isDot)) {
//       return child;
//     }
//
//     final badgeColor = color;
//     final badgeTextColor = textColor;
//     final badgeSize = size ?? (Theme.of(context).textTheme.labelSmall?.fontSize ?? 12);
//     final badgePadding = padding ?? EdgeInsets.symmetric(horizontal: 4, vertical: 2);
//
//     Widget? content;
//     if (isDot) {
//       content = null;
//     } else if (badgeContent != null) {
//       content = badgeContent;
//     } else {
//       content = Center(
//         child: Txt(
//           text!,
//           color: badgeTextColor,
//           fontSize: badgeSize,
//           fontWeight: FontWeight.bold,
//           textAlign: TextAlign.center,
//         ),
//       );
//     }
//
//     final badgeWidget = GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: badgePadding,
//         decoration: BoxDecoration(
//           color: badgeColor,
//           borderRadius: shape == BadgeShape.circular
//               ? BorderRadius.circular(borderRadius ?? badgeSize * 2)
//               : BorderRadius.circular(borderRadius ?? 4),
//         ),
//         constraints: BoxConstraints(
//           minWidth: (isDot ? badgeSize : badgeSize * 1.5) + badgePadding.horizontal,
//           minHeight: (isDot ? badgeSize : badgeSize * 1.5) + badgePadding.vertical,
//         ),
//         child: content,
//       ),
//     );
//
//     final effectiveSize = (isDot ? badgeSize : badgeSize * 1.5) +
//         (position == BadgePosition.center ? 0 : badgeSize / 2);
//
//     double top = 0;
//     double bottom = 0;
//     double left = 0;
//     double right = 0;
//
//     switch (position) {
//       case BadgePosition.topStart:
//         top = -effectiveSize / 2 + offsetY - badgePadding.top;
//         left = -effectiveSize / 2 + offsetX - badgePadding.left;
//         break;
//       case BadgePosition.topEnd:
//         top = -effectiveSize / 2 + offsetY - badgePadding.top;
//         right = -effectiveSize / 2 + offsetX - badgePadding.right;
//         break;
//       case BadgePosition.bottomStart:
//         bottom = -effectiveSize / 2 + offsetY - badgePadding.bottom;
//         left = -effectiveSize / 2 + offsetX - badgePadding.left;
//         break;
//       case BadgePosition.bottomEnd:
//         bottom = -effectiveSize / 2 + offsetY - badgePadding.bottom;
//         right = -effectiveSize / 2 + offsetX - badgePadding.right;
//         break;
//       case BadgePosition.center:
//         break;
//     }
//
//
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         child,
//         Positioned(
//           top: top,
//           bottom: bottom,
//           left: left,
//           right: right,
//           child: badgeWidget,
//         ),
//       ],
//     );
//   }
// }
//
// enum BadgeShape { circular, rectangular }
// enum BadgePosition { topStart, topEnd, bottomStart, bottomEnd, center }


import 'package:flutter/material.dart';

class AdvancedBadge extends StatelessWidget {
  final Widget child;
  final String? text;
  final Widget? badgeContent;
  final Color? color;
  final Color? textColor;
  final double? size;
  final bool showBadge;
  final BadgeShape shape;
  final BadgePosition position;
  final EdgeInsets? padding;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool isDot;
  final double offsetX;
  final double offsetY;
  final bool isInteractive; // افزودن قابلیت تعاملی بودن

  const AdvancedBadge({
    Key? key,
    required this.child,
    this.text,
    this.badgeContent,
    this.color,
    this.textColor,
    this.size,
    this.showBadge = true,
    this.shape = BadgeShape.circular,
    this.position = BadgePosition.topEnd,
    this.padding,
    this.borderRadius,
    this.onTap,
    this.isDot = false,
    this.offsetX = 0,
    this.offsetY = 0,
    this.isInteractive = false, // حالت پیش‌فرض غیرتعاملی
  })  : assert(text == null || badgeContent == null,
  'Cannot provide both text and badgeContent'),
        super(key: key);

  @override
  // Widget build(BuildContext context) {
  //   // محتوای اصلی که ممکن است دکمه یا لینک باشد
  //   final interactiveChild = isInteractive
  //       ? Material(
  //       color: Colors.transparent,
  //       child: InkWell(
  //         onTap: onTap,
  //         customBorder: shape == BadgeShape.circular
  //             ? CircleBorder()
  //             : RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(borderRadius ?? 4),
  //           child: child,
  //         ),
  //       )
  //           : child;
  //
  //   if (!showBadge || (text == null && badgeContent == null && !isDot)) {
  //   return interactiveChild;
  //   }
  //
  //   final badgeColor = color ?? Theme.of(context).colorScheme.error;
  //   final badgeTextColor = textColor ?? Theme.of(context).colorScheme.onError;
  //   final badgeSize = size ?? (Theme.of(context).textTheme.labelSmall?.fontSize ?? 12;
  //   final badgePadding = padding ?? EdgeInsets.symmetric(horizontal: 4, vertical: 2);
  //
  //   Widget? content;
  //   if (isDot) {
  //   content = null;
  //   } else if (badgeContent != null) {
  //   content = badgeContent;
  //   } else {
  //   content = Text(
  //   text!,
  //   style: TextStyle(
  //   color: badgeTextColor,
  //   fontSize: badgeSize,
  //   fontWeight: FontWeight.bold,
  //   ),
  //   textAlign: TextAlign.center,
  //   );
  //   }
  //
  //   final badgeWidget = Container(
  //   padding: badgePadding,
  //   decoration: BoxDecoration(
  //   color: badgeColor,
  //   borderRadius: shape == BadgeShape.circular
  //   ? BorderRadius.circular(borderRadius ?? badgeSize * 2)
  //       : BorderRadius.circular(borderRadius ?? 4),
  //   ),
  //   constraints: BoxConstraints(
  //   minWidth: (isDot ? badgeSize : badgeSize * 1.5) + badgePadding.horizontal,
  //   minHeight: (isDot ? badgeSize : badgeSize * 1.5) + badgePadding.vertical,
  //   ),
  //   child: content,
  //   );
  //
  //   final effectiveSize = (isDot ? badgeSize : badgeSize * 1.5) +
  //   (position == BadgePosition.center ? 0 : badgeSize / 2);
  //
  //   double top = 0;
  //   double bottom = 0;
  //   double left = 0;
  //   double right = 0;
  //
  //   switch (position) {
  //   case BadgePosition.topStart:
  //   top = -effectiveSize / 2 + offsetY - badgePadding.top;
  //   left = -effectiveSize / 2 + offsetX - badgePadding.left;
  //   break;
  //   case BadgePosition.topEnd:
  //   top = -effectiveSize / 2 + offsetY - badgePadding.top;
  //   right = -effectiveSize / 2 + offsetX - badgePadding.right;
  //   break;
  //   case BadgePosition.bottomStart:
  //   bottom = -effectiveSize / 2 + offsetY - badgePadding.bottom;
  //   left = -effectiveSize / 2 + offsetX - badgePadding.left;
  //   break;
  //   case BadgePosition.bottomEnd:
  //   bottom = -effectiveSize / 2 + offsetY - badgePadding.bottom;
  //   right = -effectiveSize / 2 + offsetX - badgePadding.right;
  //   break;
  //   case BadgePosition.center:
  //   break;
  //   }
  //
  //   return Stack(
  //   clipBehavior: Clip.none,
  //   children: [
  //   interactiveChild,
  //   if (showBadge && (text != null || badgeContent != null || isDot))
  //   Positioned(
  //   top: top,
  //   bottom: bottom,
  //   left: left,
  //   right: right,
  //   child: badgeWidget,
  //   ),
  //   ],
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    // محتوای اصلی که ممکن است دکمه یا لینک باشد
    final interactiveChild = isInteractive
        ? Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: shape == BadgeShape.circular
            ? CircleBorder()
            : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 4)),
        child: child,
      ),
    )
        : child;

    if (!showBadge || (text == null && badgeContent == null && !isDot)) {
      return interactiveChild;
    }

    final badgeColor = color ?? Theme.of(context).colorScheme.error;
    final badgeTextColor = textColor ?? Theme.of(context).colorScheme.onError;
    final badgeSize = size ?? (Theme.of(context).textTheme.labelSmall?.fontSize ?? 12);
    final badgePadding = padding ?? EdgeInsets.symmetric(horizontal: 4, vertical: 2);

    Widget? content;
    if (isDot) {
      content = null;
    } else if (badgeContent != null) {
      content = badgeContent;
    } else {
      content = Text(
        text!,
        style: TextStyle(
          color: badgeTextColor,
          fontSize: badgeSize,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );
    }

    final badgeWidget = Container(
      padding: badgePadding,
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: shape == BadgeShape.circular
            ? BorderRadius.circular(borderRadius ?? badgeSize * 2)
            : BorderRadius.circular(borderRadius ?? 4),
      ),
      constraints: BoxConstraints(
        minWidth: (isDot ? badgeSize : badgeSize * 1.5) + badgePadding.horizontal,
        minHeight: (isDot ? badgeSize : badgeSize * 1.5) + badgePadding.vertical,
      ),
      child: content,
    );

    final effectiveSize = (isDot ? badgeSize : badgeSize * 1.5) +
        (position == BadgePosition.center ? 0 : badgeSize / 2);

    double top = 0;
    double bottom = 0;
    double left = 0;
    double right = 0;

    switch (position) {
      case BadgePosition.topStart:
        top = -effectiveSize / 2 + offsetY - badgePadding.top;
        left = -effectiveSize / 2 + offsetX - badgePadding.left;
        break;
      case BadgePosition.topEnd:
        top = -effectiveSize / 2 + offsetY - badgePadding.top;
        right = -effectiveSize / 2 + offsetX - badgePadding.right;
        break;
      case BadgePosition.bottomStart:
        bottom = -effectiveSize / 2 + offsetY - badgePadding.bottom;
        left = -effectiveSize / 2 + offsetX - badgePadding.left;
        break;
      case BadgePosition.bottomEnd:
        bottom = -effectiveSize / 2 + offsetY - badgePadding.bottom;
        right = -effectiveSize / 2 + offsetX - badgePadding.right;
        break;
      case BadgePosition.center:
        break;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        interactiveChild,
        if (showBadge && (text != null || badgeContent != null || isDot))
          Positioned(
            top: top,
            bottom: bottom,
            left: left,
            right: right,
            child: badgeWidget,
          ),
      ],
    );
  }
}

enum BadgeShape { circular, rectangular }
enum BadgePosition { topStart, topEnd, bottomStart, bottomEnd, center }