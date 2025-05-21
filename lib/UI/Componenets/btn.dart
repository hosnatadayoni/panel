import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../Logic/Controllers/app-controller.dart';
import '../../../Public/styles.dart';

// enum btnType{
//   primary,
//   custom
// }
// enum ButtonSize {
//   small,
//   medium,
//   large
// }
//
//
// class Btn extends StatefulWidget {
//   final Function? onClick;
//   final btnType type;
//   final String? loadingTag;
//   final String? text;
//   final Widget? child;
//   final double? width;
//   final double? height;
//   final fontTypes fontType;
//   final Color? color;
//    Color? hoverColor;
//    Color? hoverPrimaryTypeColor;
//   final bool isLink;
//   final ButtonSize size;
//   final bool disabled;
//   final bool isBlock;
//   final bool responsive;
//   final double? responsiveBreakpoint;
//   final bool isToggle;
//
//
//   Btn(
//       this.type, {
//         this.text,
//         this.onClick,
//         this.width,
//         this.height,
//         this.fontType = fontTypes.heading4,
//         this.loadingTag,
//         this.child,
//         this.color,
//         this.hoverColor,
//         this.hoverPrimaryTypeColor,
//         this.isLink = false,
//         this.size = ButtonSize.medium,
//         this.disabled = false,
//         this.isBlock = false,
//         this.responsive = false,
//         this.responsiveBreakpoint = 768,
//         this.isToggle = false,
//
//       });
//
//   @override
//   _BtnState createState() => _BtnState();
// }
//
// class _BtnState extends State<Btn> {
//   bool _isHovered = false;
//   bool _isToggle = false;
//
//   EdgeInsets getButtonPadding() {
//     switch (widget.size) {
//       case ButtonSize.small:
//         return EdgeInsets.symmetric(vertical: 12, horizontal: 16);
//       case ButtonSize.large:
//         return EdgeInsets.symmetric(vertical: 24, horizontal: 32);
//       case ButtonSize.medium:
//       default:
//         return EdgeInsets.symmetric(vertical: 20, horizontal: 24);
//     }
//   }
//
//   double getFontSize() {
//     switch (widget.size) {
//       case ButtonSize.small:
//         return 12;
//       case ButtonSize.large:
//         return 16;
//       case ButtonSize.medium:
//       default:
//         return 14;
//     }
//   }
//
//   // Color getBackgroundColor() {
//   //   if (_isHovered && widget.hoverColor != null) {
//   //     return widget.hoverColor!;
//   //   }
//   //   switch (widget.type) {
//   //     case btnType.primary:
//   //       return _isHovered ? (widget.color ?? Colors.transparent) : Colors.transparent;
//   //     case btnType.custom:
//   //       return widget.color ?? Colors.transparent;
//   //     default:
//   //       return whiteColor;
//   //   }
//   // }
//   Color getBackgroundColor() {
//     if (widget.disabled) {
//       return widget.color?.withOpacity(0.65) ?? Colors.transparent;
//     }
//     if (_isHovered && widget.hoverColor != null) {
//       if (widget.type == btnType.primary) {
//         if(widget.isToggle){
//           widget.hoverColor = Colors.transparent;
//         }
//       }
//       return widget.hoverColor!;
//     }
//
//     switch (widget.type) {
//       case btnType.primary:
//         return _isHovered ? (widget.color ?? Colors.transparent) : Colors.transparent;
//       case btnType.custom:
//         return widget.color ?? Colors.transparent;
//       default:
//         return whiteColor;
//     }
//   }
//
//   Color getBorderColor() {
//     if (widget.type == btnType.primary) {
//       return _isHovered ? (widget.color ?? Colors.transparent) : (widget.color ?? Colors.transparent);
//     }
//     return Colors.transparent;
//   }
//
//   Color getTextColor() {
//     const defaultColor = whiteColor;
//     if (widget.isLink) {
//
//       if(widget.isToggle){
//         return widget.color ?? defaultColor;
//       }
//       else{
//         if(widget.disabled == false){
//           return Colors.blue;
//         }
//       }
//
//     }
//     if(widget.isToggle){
//       widget.hoverPrimaryTypeColor = widget.color;
//     }
//
//     if (widget.type == btnType.primary) {
//       if (_isHovered) {
//         return widget.hoverPrimaryTypeColor ?? widget.color ?? defaultColor;
//       }
//       return widget.color ?? defaultColor;
//     }
//
//     return widget.type == btnType.custom
//         ? whiteColor
//         : widget.color ?? defaultColor;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Center(
//       child: MouseRegion(
//         onEnter: (_) => setState(() => widget.disabled == false ? _isHovered = true : _isHovered = false),
//         onExit: (_) => setState(() => _isHovered = false),
//         child: IgnorePointer(
//           ignoring: widget.disabled,
//           child: Focus(
//             canRequestFocus: !widget.disabled,
//             child: Container(
//               // padding: EdgeInsets.only(top: 6, bottom: 6, left: 12, right: 12),
//               // width: widget.isBlock == true ? size.width : null,
//               width: widget.isBlock || (widget.responsive && size.width < widget.responsiveBreakpoint!)
//                   ? size.width
//                   : widget.width,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: _isToggle ? Colors.transparent : (getBorderColor() ?? Colors.transparent),
//                   width: borderSize,
//                 ),
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: ElevatedButton(
//                   onPressed: widget.disabled
//                       ? null
//                       : () async {
//                     if (widget.isToggle) {
//                       setState(() {
//                         _isToggle = !_isToggle;
//                       });
//                     }
//                     if (widget.onClick != null) {
//                       widget.onClick!();
//                     }
//                   },
//                   focusNode: widget.disabled ? FocusNode(skipTraversal: true) : null,
//                 // onPressed: () async {
//                 //   if (widget.onClick != null) widget.onClick!();
//                 // },
//                 child: Obx(() {
//                   return (AppController.loadingList.value.contains(widget.loadingTag) && widget.loadingTag != null)
//                       ? Container(
//                     width: 25,
//                     height: 25,
//                     child: CircularProgressIndicator(
//                       color: whiteColor,
//                       strokeWidth: 2,
//                     ),
//                   )
//                       : widget.child == null
//                       ? Txt(
//                     widget.text ?? '',
//                     fontSize: getFontSize(),
//                     fontWeight: FontWeight.w500,
//                     color: getTextColor(),
//                     // textDecoration:widget.disabled == false ?  widget.isLink ? TextDecoration.underline : TextDecoration.none :TextDecoration.none ,
//                     textDecoration: widget.isToggle && widget.isLink
//                         ? TextDecoration.none
//                         : (widget.disabled == false && widget.isLink)
//                         ? TextDecoration.underline
//                         : TextDecoration.none,
//                   )
//                       : widget.child!;
//                 }),
//                 style: ButtonStyle(
//                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                   ),
//                   backgroundColor: MaterialStateProperty.all(getBackgroundColor()),
//                 //   backgroundColor: MaterialStateProperty.all<Color?>(
//                 //     widget.disabled
//                 //         ? widget.color?.withOpacity(0.65) ?? Colors.transparent // استفاده ایمن از withOpacity
//                 //             : getBackgroundColor(),
//                 //
//                 // ),
//                   elevation: MaterialStateProperty.all(0),
//                   padding: MaterialStateProperty.all(
//                       EdgeInsets.only(top: 20, bottom: 20, left: 12, right: 12)),
//                   overlayColor: MaterialStateProperty.all(Colors.transparent),
//                   mouseCursor: MaterialStateProperty.all(
//                       widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

enum btnType {
  primary,
  custom
}

enum ButtonSize {
  small,
  medium,
  large
}

class Btn extends StatefulWidget {
   Function? onClick;
   btnType type;
   Widget? content;
   double? width;
   double? height;
   Color? color;
   Color? hoverColor;
   bool isLink;
   ButtonSize size;
   bool disabled;
   bool isBlock;
   bool responsive;
   double? responsiveBreakpoint;
   bool isToggle;
   int? gridColumns;
   bool centerHorizontal;

  Btn(
      this.type, {
        this.content,
        this.onClick,
        this.width,
        this.height,
        this.color = Colors.blue,
        this.hoverColor = Colors.blueAccent,
        this.isLink = false,
        this.size = ButtonSize.medium,
        this.disabled = false,
        this.isBlock = false,
        this.responsive = false,
        this.responsiveBreakpoint = 768,
        this.isToggle = false,
        this.gridColumns,
        this.centerHorizontal = false,
      });

  @override
  _BtnState createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  bool _isHovered = false;
  bool _isToggle = false;

  EdgeInsets getButtonPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return EdgeInsets.only(top: 4 , bottom: 4, right: 8 , left: 8);
      case ButtonSize.large:
        return EdgeInsets.only(top: 8 , bottom: 8, right: 16 , left: 16);
      case ButtonSize.medium:
        return EdgeInsets.only(top: 6 , bottom: 6, right: 12 , left: 12);
      default:
        return EdgeInsets.only(top: 6 , bottom: 6, right: 12 , left: 12);
    }
  }

  double getFontSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 12;
      case ButtonSize.large:
        return 16;
      case ButtonSize.medium:
      default:
        return 14;
    }
  }

  Color getBackgroundColor() {
    if (widget.disabled) {
      return widget.color?.withOpacity(0.65) ?? Colors.transparent;
    }
    if (_isHovered && widget.hoverColor != null) {
      if (widget.type == btnType.primary) {
        if (widget.isToggle) {
          widget.hoverColor = Colors.transparent;
        }
      }
      return widget.hoverColor!;
    }

    switch (widget.type) {
      case btnType.primary:
        return _isHovered ? (widget.color ?? Colors.transparent) : Colors.transparent;
      case btnType.custom:
        return widget.color ?? Colors.transparent;
      default:
        return whiteColor;
    }
  }

  Color getBorderColor() {
    if (widget.type == btnType.primary) {
      return _isHovered ? (widget.color ?? Colors.transparent) : (widget.color ?? Colors.transparent);
    }
    return Colors.transparent;
  }

  Color getTextColor() {
    const defaultColor = whiteColor;
    if (widget.isLink) {
      if (widget.isToggle) {
        return widget.color ?? defaultColor;
      } else {
        if (widget.disabled == false) {
          return Colors.blue;
        }
      }
    }

    return widget.type == btnType.custom
        ? whiteColor
        : widget.color ?? defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double? calculatedWidth;
    bool isValidGridColumns = widget.gridColumns != null && widget.gridColumns! > 0 && widget.gridColumns! <= 12;

    if (isValidGridColumns) {
      final screenWidth = size.width;
      final columnWidth = screenWidth / 12 * widget.gridColumns!;
      calculatedWidth = columnWidth;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => widget.disabled == false ? _isHovered = true : _isHovered = false),
      onExit: (_) => setState(() => _isHovered = false),
      child: IgnorePointer(
        ignoring: widget.disabled,
        child: InkWell(
          onTap: widget.disabled
              ? null
              : () async {
            if (widget.isToggle) {
              setState(() {
                _isToggle = !_isToggle;
              });
            }
            if (widget.onClick != null) {
              widget.onClick!();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: getBackgroundColor(),
              border: Border.all(
                color: _isToggle ? Colors.transparent : (getBorderColor() ?? Colors.transparent),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: getButtonPadding(),
            width: widget.isBlock
                ? size.width
                : widget.responsive && size.width <= widget.responsiveBreakpoint!
                ? size.width
                : !isValidGridColumns
                ? widget.width
                : calculatedWidth,
            margin: widget.centerHorizontal
                ? EdgeInsets.symmetric(horizontal: (size.width - (calculatedWidth ?? widget.width ?? size.width)) / 2)
                : null,
            child:widget.isBlock || widget.responsive && size.width <= widget.responsiveBreakpoint! || widget.centerHorizontal ?  Center(child: widget.content!,):widget.content!,
          ),
        ),
      ),
    );
  }
}