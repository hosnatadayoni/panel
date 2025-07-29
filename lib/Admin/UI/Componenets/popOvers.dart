import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/General/myDivider.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:panel/Admin/UI/Componenets/tooltip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';
import 'package:super_tooltip/super_tooltip.dart';
// enum d{
//    top,
//    right,
//    bottom,
//    left
// }
// class PopOverWidget extends StatelessWidget {
//   Color? btnColor;
//   Color? btnHoverColor;
//   String btnTxt;
//   Color? btnTxtColor;
//   Color? popOverColorBox;
//   Color? popOverBorderColorBox;
//   Color? popOverHeaderColorBox;
//   String? popOverHeader;
//   Color? popOverHeaderColor;
//   String? popOverBody;
//   Color? popOverBodyColor;
//   d? direction;
//
//   PopOverWidget({this.btnColor ,
//      this.btnHoverColor,
//      this.btnTxt = '' ,
//      this.btnTxtColor =  whiteColor,
//      this.popOverColorBox = whiteColor,
//      this.popOverBorderColorBox = color5,
//      this.popOverHeaderColorBox = darkBackground,
//      this.popOverHeader,
//      this.popOverHeaderColor = color38,
//      this.popOverBody = '',
//      this.popOverBodyColor =darkBackground,
//     this.direction,
//    });
//
//   PopoverDirection _getPopoverDirection() {
//     switch (direction) {
//       case d.top:
//         return PopoverDirection.top;
//       case d.right:
//         return PopoverDirection.right;
//       case d.bottom:
//         return PopoverDirection.bottom;
//       case d.left:
//         return PopoverDirection.left;
//       default:
//         return PopoverDirection.left;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Rx<bool> isBtnHover =  false.obs;
//     var size = MediaQuery.of(context).size;
//
//     return Obx((){
//       return InkWell(
//         onTap: (){
//           showPopover(
//             context: context,
//             bodyBuilder: (context) =>  IntrinsicWidth(
//               child: IntrinsicHeight(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(width:  1 , color: this.popOverBorderColorBox!),
//                     borderRadius: BorderRadius.circular(10),
//                     color:this.popOverColorBox,
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       if(this.popOverHeader != null)
//                         Container(
//                         padding: EdgeInsets.only(top: 8, bottom: 8 , left: 16 , right: 16),
//                         color: this.popOverHeaderColorBox,
//                         child: Txt(this.popOverHeader! , fontSize: 16, fontWeight: FontWeight.w500, color: this.popOverHeaderColor,),
//                       ),
//                       if(this.popOverHeader != null)MyDivider(),
//                       if(this.popOverHeader != null)SizedBox(height: 20,),
//                       Container(
//                           padding: EdgeInsets.only(top: 8, bottom: 8 , left: 16 , right: 16),
//                           child: Txt(this.popOverBody! ,fontSize: 14, fontWeight: FontWeight.w400, color: this.popOverBodyColor, ))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             onPop: () => print('Popover was popped!'),
//             direction: _getPopoverDirection(),
//             height: null,
//             arrowHeight: 15,
//             arrowWidth: 30,
//             barrierDismissible: true,
//             barrierColor: Colors.transparent,
//           );
//         },
//         child: MouseRegion(
//           onExit: (_){
//             isBtnHover.value = false;
//           },
//           onEnter: (_){
//             isBtnHover.value = true;
//           },
//           child: Container(
//             padding: EdgeInsets.only(left: 16 , right: 16 ,  top: 8 , bottom: 8),
//             decoration: BoxDecoration(
//               color: isBtnHover.value ?this.btnHoverColor : this.btnColor,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Txt(this.btnTxt , fontSize: 20, fontWeight: FontWeight.w400, color: this.btnTxtColor,),
//
//           ),
//         ),
//       );
//     });
//   }
// }

import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/General/myDivider.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:panel/Admin/UI/Componenets/tooltip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';
import 'package:super_tooltip/super_tooltip.dart';

import 'btn.dart';
enum d {
  top,
  right,
  bottom,
  left
}

class PopOverWidget extends StatefulWidget {
  btnType type;
  ButtonSize size;
  Widget? content;
  Color? popOverColorBox;
  Color? popOverHeaderColorBox;
  String? popOverHeader;
  Color? popOverHeaderColor;
  String? popOverBody;
  Color? popOverBodyColor;
  d? direction;
  bool disabled;

  PopOverWidget({
    required this.type,
    this.size = ButtonSize.medium,
    this.content,
    this.popOverColorBox = whiteColor,
    this.popOverHeaderColorBox = darkBackground,
    this.popOverHeader,
    this.popOverHeaderColor = color38,
    this.popOverBody = '',
    this.popOverBodyColor = darkBackground,
    this.direction,
    this.disabled = false,
  });

  @override
  State<PopOverWidget> createState() => _PopOverWidgetState();
}

class _PopOverWidgetState extends State<PopOverWidget> {
  Rx<bool> isShowPopOver =  false.obs;
  PopoverDirection _getPopoverDirection() {
    switch (widget.direction) {
      case d.top:
        return PopoverDirection.top;
      case d.right:
        return PopoverDirection.right;
      case d.bottom:
        return PopoverDirection.bottom;
      case d.left:
        return PopoverDirection.left;
      default:
        return PopoverDirection.left;
    }
  }

  TooltipDirection _convertDirection(PopoverDirection direction) {
    switch (direction) {
      case PopoverDirection.top:
        return TooltipDirection.up;
      case PopoverDirection.right:
        return TooltipDirection.right;
      case PopoverDirection.bottom:
        return TooltipDirection.down;
      case PopoverDirection.left:
        return TooltipDirection.left;
      default:
        return TooltipDirection.up;
    }
  }

  void _showPopover(BuildContext context) {
    showPopover(
      context: context,
      bodyBuilder: (context) => IntrinsicWidth(child: IntrinsicHeight(child: Content()),),
      onPop: () => print('Popover was popped!'),
      direction: _getPopoverDirection(),
      height: null,
      arrowHeight: 15,
      arrowWidth: 20,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    Rx<bool> isBtnHover = false.obs;
    var size = MediaQuery.of(context).size;
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
      return Colors.transparent;
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
    final button;
    if(!widget.disabled){
      button =Obx(() {
        return box(isBtnHover , backgroundColor() , HoverbackgroundColor() , contentColor() , getButtonPadding());
      });
    }
    else{
      button = box(isBtnHover , backgroundColor() , HoverbackgroundColor() , contentColor() , getButtonPadding());
    }
    if (widget.disabled) {
      return TooltipWidget(btn: box(isBtnHover , backgroundColor() , HoverbackgroundColor() , contentColor() , getButtonPadding()),
        content:Content() ,
        direction: _convertDirection(_getPopoverDirection()),
      );
    }
    return InkWell(
      onTap: () => _showPopover(context),
      child: MouseRegion(
        onExit: (_) {
          isBtnHover.value = false;
        },
        onEnter: (_) {
          isBtnHover.value = true;
        },
        child: button,
      ),
    );
  }
  Widget box(isBtnHover ,backgroundColor , HoverbackgroundColor , contentColor , getButtonPadding ){
    return Container(
      // padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      padding:getButtonPadding ,
      decoration: BoxDecoration(
        color:!widget.disabled ? isBtnHover.value ? HoverbackgroundColor : backgroundColor : backgroundColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child:  DefaultTextStyle.merge(
        style: TextStyle(
          color:contentColor,
          decoration: widget.type == btnType.link ?TextDecoration.underline : TextDecoration.none,
        ),
        child: widget.content!,
      ),
    );
  }

  Widget Content(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: this.widget.popOverColorBox,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (this.widget.popOverHeader != null)
            Container(
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
              color: this.widget.popOverHeaderColorBox,
              child: Txt(
                this.widget.popOverHeader!,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: this.widget.popOverHeaderColor,
              ),
            ),
          if (this.widget.popOverHeader != null) MyDivider(),
          if (this.widget.popOverHeader != null) SizedBox(height: 20),
          Container(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
            child: Txt(
              this.widget.popOverBody!,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: this.widget.popOverBodyColor,
            ),
          ),
        ],
      ),
    );
  }
}
