import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/myDivider.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/tooltip.dart';
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

enum d {
  top,
  right,
  bottom,
  left
}

class PopOverWidget extends StatefulWidget {
   Color? btnColor;
   Color? btnHoverColor;
   String btnTxt;
   Color? btnTxtColor;
   Color? popOverColorBox;
   Color? popOverHeaderColorBox;
   String? popOverHeader;
   Color? popOverHeaderColor;
   String? popOverBody;
   Color? popOverBodyColor;
   d? direction;
   bool disabled;

  PopOverWidget({
    this.btnColor,
    this.btnHoverColor,
    this.btnTxt = '',
    this.btnTxtColor = whiteColor,
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
      bodyBuilder: (context) => IntrinsicWidth(
        child: IntrinsicHeight(
          child: Content(),
        ),
      ),
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
    final button;
    if(!widget.disabled){
      button =Obx(() {
        return box(isBtnHover);
      });
    }
    else{
      button = box(isBtnHover);
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
  Widget box(isBtnHover){
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color:!widget.disabled ? isBtnHover.value ? this.widget.btnHoverColor : this.widget.btnColor : this.widget.btnColor!.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Txt(
        this.widget.btnTxt,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color:this.widget.btnTxtColor,
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
