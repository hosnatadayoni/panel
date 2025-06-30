import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Public/styles.dart';

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
enum btnType{
  primary,
  secondary,
  success,
  danger,
  warning,
  info,
  light,
  dark,
  link,
}

enum ButtonSize {
  small,
  medium,
  large
}

class Btn extends StatefulWidget {
   btnType? type;
   Function? onClick;
   Widget? content;
   double? width;
   double? height;
   bool? isOutline;
   ButtonSize size;
   bool disabled;
   bool isBlock;
   bool responsive;
   double? responsiveBreakpoint;
   bool? isActive;
   bool isToggle;
   bool isCenter;
   BorderRadius? borderRadius;

  Btn(
       {
         required this.type,
        this.content,
        this.onClick,
        this.width,
        this.height,
        this.isOutline = false,
        this.size = ButtonSize.medium,
        this.disabled = false,
        this.isBlock = false,
        this.responsive = false,
        this.responsiveBreakpoint = 768,
         this.isActive = false,
        this.isToggle = false,
        this.isCenter = false,
        this.borderRadius
      });

  @override
  _BtnState createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  bool _isHovered = false;


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

  // Color getBackgroundColor() {
  //   if (widget.disabled) {
  //     return widget.colorBtn?.withOpacity(0.65) ?? Colors.transparent;
  //   }
  //   if (_isHovered && widget.hoverColor != null) {
  //     if (widget.type == btnType.primary) {
  //       if (widget.isToggle) {
  //         widget.hoverColor = Colors.transparent;
  //       }
  //     }
  //     return widget.hoverColor!;
  //   }
  //
  //   switch (widget.type) {
  //     case btnType.primary:
  //       return _isHovered ? (widget.colorBtn ?? Colors.transparent) : Colors.transparent;
  //     case btnType.custom:
  //       return widget.colorBtn ?? Colors.transparent;
  //     default:
  //       return whiteColor;
  //   }
  // }
  //
  // Color getBorderColor() {
  //   if (widget.type == btnType.primary) {
  //     return _isHovered ? (widget.colorBtn ?? Colors.transparent) : (widget.colorBtn ?? Colors.transparent);
  //   }
  //   return Colors.transparent;
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // double? calculatedWidth;
    // bool isValidGridColumns = widget.gridColumns != null && widget.gridColumns! > 0 && widget.gridColumns! <= 12;
    //
    // if (isValidGridColumns) {
    //   final screenWidth = size.width;
    //   final columnWidth = screenWidth / 12 * widget.gridColumns!;
    //   calculatedWidth = columnWidth;
    // }

    return widget.isCenter ? Center(child: btnWidget(),):btnWidget();
  }
  Widget btnWidget(){
    var size = MediaQuery.of(context).size;
    bool _isToggle = false;
    if(widget.type == null){
      _isHovered = false;
    }

    Color backgroundColor(){
      if(widget.type == btnType.primary){
        return colorBtn;
      }
      else if(widget.type == btnType.secondary){
        return secondry;
      }
      else if(widget.type == btnType.success){
        return success;
      }
      else if(widget.type == btnType.danger){
        return danger;
      }
      else if(widget.type == btnType.warning){
        return warning;
      }
      else if(widget.type == btnType.info){
        return info;
      }
      else if(widget.type == btnType.light){
        return light;
      }
      else if(widget.type == btnType.dark){
        return dark;
      }
      else if(widget.type == btnType.link){
        return Colors.transparent;
      }
      return widget.isActive! ? dark:Colors.transparent;
    }

    Color textColor(){
      if(widget.type == btnType.primary){
        return colorBtn;
      }
      else if(widget.type == btnType.secondary){
        return secondry;
      }
      else if(widget.type == btnType.success){
        return success;
      }
      else if(widget.type == btnType.danger){
        return danger;
      }
      else if(widget.type == btnType.warning){
        return warning;
      }
      else if(widget.type == btnType.info){
        return info;
      }
      else if(widget.type == btnType.light){
        return light;
      }
      else if(widget.type == btnType.dark){
        return dark;
      }
      else if(widget.type == btnType.link){
        return colorBtn;
      }
      return widget.isActive! ? dark:Colors.transparent;
    }

    Color HoverbackgroundColor(){
      if(widget.type == btnType.primary){
        return primaryHover;
      }
      else if(widget.type == btnType.secondary){
        return secondryHover;
      }
      else if(widget.type == btnType.success){
        return successHover;
      }
      else if(widget.type == btnType.danger){
        return dangerHover;
      }
      else if(widget.type == btnType.warning){
        return warningHover;
      }
      else if(widget.type == btnType.info){
        return infoHover;
      }
      else if(widget.type == btnType.light){
        return lightHover;
      }
      else if(widget.type == btnType.dark){
        return darkHover;
      }
      else if(widget.type == btnType.link){
        return Colors.transparent;
      }
      return Colors.transparent;
    }

    Color contentColor(){
      if(widget.type == btnType.primary || widget.type == btnType.secondary ||
          widget.type == btnType.success || widget.type == btnType.danger || widget.type == btnType.dark){
        return whiteColor;
      }
      else if(widget.type == btnType.warning || widget.type == btnType.info || widget.type == btnType.light){
        return blackColor;
      }
      else if(widget.type == btnType.link){
        return colorBtn;
      }
      return dark;
    }

    Color colorBox() {
      if (widget.disabled) {
        if (widget.isOutline!) {
          return Colors.transparent;
        } else {
          return backgroundColor().withOpacity(0.6);
        }
      } else if (_isHovered) {
        return HoverbackgroundColor();
      } else if (widget.isOutline!) {
        return Colors.transparent;
      }
      return backgroundColor();
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
            // if (widget.isToggle) {
            //   setState(() {
            //     _isToggle = !_isToggle;
            //   });
            // }
            if (widget.isToggle) {
              setState(() {
                widget.isActive = !widget.isActive!;
              });
            }
            if (widget.onClick != null) {
              widget.onClick!();
            }
          },
          child: IntrinsicWidth(
            child: Container(
              decoration: BoxDecoration(
                color:widget.isActive! ?HoverbackgroundColor() :colorBox(),
                border: Border.all(
                  color:widget.disabled ? widget.isOutline! ?backgroundColor().withOpacity(0.6) : backgroundColor().withOpacity(0.1) :  _isHovered ? HoverbackgroundColor() : widget.isActive! ?HoverbackgroundColor(): backgroundColor(),
                  // color: widget.disabled ?backgroundColor().withOpacity(0.6) :  _isToggle ? Colors.transparent : _isHovered ? widget.hoverBtnColor! :widget.colorBtn!,
                  width: 1,
                ),
                borderRadius: widget.borderRadius != null ? widget.borderRadius : BorderRadius.circular(5),
              ),
              padding: getButtonPadding(),
              width: widget.isBlock || widget.responsive && size.width <= widget.responsiveBreakpoint!
                  ? size.width : widget.isCenter ? size.width * 0.5
                  : widget.width,
              height: widget.height != null ? widget.height : null,
              child:
              Center(
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    color:_isHovered ?contentColor(): widget.isOutline! ? textColor(): contentColor(),
                    decoration: widget.type == btnType.link ?TextDecoration.underline : TextDecoration.none,
                  ),
                  child: widget.content!,
                ),
              ),
            ),
              ),
            ),
          ),
        );
  }
}