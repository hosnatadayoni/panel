import 'package:panel/Admin/Public/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CloseBtn extends StatelessWidget {
   VoidCallback onClose;
   Color? iconColor;
   Color? iconHoverColor;
   double? size;
   String? closeButtonTooltip;
   bool? isDisabled;
   // bool? isDark;

   CloseBtn({required this.onClose ,
     this.iconColor ,
     this.size ,
     this.closeButtonTooltip ,
     this.iconHoverColor ,
     this.isDisabled = false,
     // this.isDark = false,
   });

  @override
  Widget build(BuildContext context) {
    Rx<bool> isHover= false.obs;
    double opacity = this.isDisabled! ? 0.5 : 1.0;
    Color _getIconColor() {
      if (isHover.value) {
        // return iconHoverColor ?? (isDark! ? color32 : blackColor);
        return iconHoverColor ?? blackColor;
      }
      return iconColor ?? color31;
    }
    return Obx((){
      return IgnorePointer(
        ignoring: this.isDisabled!,
        child: Opacity(
          opacity: opacity,
          child: MouseRegion(
            onEnter: this.isDisabled! ? null : (_){
              isHover.value = true;
            },
            onExit:this.isDisabled! ? null : (_){
              isHover.value = false;
            },
            child: IconButton(
              onPressed: onClose,
              icon: Icon(Icons.close, color: _getIconColor()),
              tooltip: closeButtonTooltip,
            ),
          ),
        ),
      );
    });

  }
}
