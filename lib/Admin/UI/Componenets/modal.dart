import 'dart:math';
import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/General/myDivider.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'btn.dart';

enum ModalSize {
  small,   // 300px
  medium, // 500px
  large,   // 800px
  xlarge,   // 1140px
  fullScreen //size.width
}
enum ModalFullscreenMode {
  none,
  smDown,    // زیر 576px
  mdDown,    // زیر 768px
  lgDown,    // زیر 992px
  xlDown,    // زیر 1200px
  xxlDown    // زیر 1400px
}
class CustomModal extends StatelessWidget {
  btnType type;
  Widget contetnBtn;
   Widget? header;
   Widget body;
   Widget? footer;
   Color? borderColorBox;
   Color? closeIconColor;
   Color? closeIconHoverColor;
   bool? staticBackdrop;
   bool? isModalDialogCenter;
   ModalSize? modalSize;
   ModalFullscreenMode? modalFullscreenMode;

   CustomModal({
     required this.type,
     required this.contetnBtn,
     required this.header,
     required this.body,
     this.footer,
     this.borderColorBox = color28,
     this.closeIconColor = color35,
     this.closeIconHoverColor = color36,
     this.staticBackdrop = false,
     this.isModalDialogCenter =  false,
     this.modalSize = ModalSize.medium,
     this.modalFullscreenMode = ModalFullscreenMode.none,
  });
   void _showModal(BuildContext context){
     final animationController = AnimationController(
       vsync: Navigator.of(context),
       duration: const Duration(milliseconds: 300),
     );
     final scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
       CurvedAnimation(parent: animationController, curve: Curves.easeOut),
     );
     showGeneralDialog(
       context: context,
       barrierDismissible:this.staticBackdrop! ? false: true,
       barrierLabel: '',
       transitionDuration: const Duration(milliseconds: 600),
         transitionBuilder: (context, animation, secondaryAnimation, child) {
           return SlideTransition(
             position: Tween<Offset>(
               begin: const Offset(0, -1.0),
               end: const Offset(0, 0.0),
             ).animate(CurvedAnimation(
               parent: animation,
               curve: Curves.easeOut,
             )),
             child: FadeTransition(
               opacity: animation,
               child: Container(
                   // padding: EdgeInsets.only(
                   //     top: _shouldBeFullscreen(context)
                   //         ? 0
                   //         : (this.isModalDialogCenter == false ? 20 : 0)
                   // ),
                   // padding:  EdgeInsets.only(top:this.modalSize == ModalSize.fullScreen ? 0: this.isModalDialogCenter == false ? 20 : 0),
                   child: child
               ),
             ),
           );
         },
         pageBuilder: (context, animation, secondaryAnimation){
           return GestureDetector(
             onTap: () {
               if (staticBackdrop ?? false) {
                 animationController.forward().then((_) {
                   animationController.reverse();
                 });
               }
               else {
                 Navigator.of(context).pop();
               }
             },
             behavior: HitTestBehavior.opaque,
             child: ScaleTransition(
               scale: scaleAnimation,
               child: Dialog(
                 elevation: 0,
                 // insetPadding: this.modalSize == ModalSize.fullScreen ?EdgeInsets.zero : EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                 insetPadding: _shouldBeFullscreen(context)
                     ? EdgeInsets.zero
                     : getPadding(context),
                 alignment: this.isModalDialogCenter == false ? Alignment.topCenter : Alignment.center,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(_shouldBeFullscreen(context) == false ? 16.0:0),
                   side: BorderSide(
                     color: this.borderColorBox!,
                     width: 1.0,
                   ),
                 ),
                 child:_shouldBeFullscreen(context) ?
                 Container(child: box(context)):
                 IntrinsicHeight(
                   child: box(context),
                 ),
               ),
             ),
           );
         }
     );
   }

   bool _shouldBeFullscreen(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;

     switch(modalFullscreenMode) {
       case ModalFullscreenMode.smDown:
         return screenWidth < 576;
       case ModalFullscreenMode.mdDown:
         return screenWidth < 768;
       case ModalFullscreenMode.lgDown:
         return screenWidth < 992;
       case ModalFullscreenMode.xlDown:
         return screenWidth < 1200;
       case ModalFullscreenMode.xxlDown:
         return screenWidth < 1400;
       case ModalFullscreenMode.none:
       default:
         return modalSize == ModalSize.fullScreen;
     }
   }

   double _getModalWidth(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;

     if (_shouldBeFullscreen(context)) {
       return screenWidth;
     }

     switch(modalSize) {
       case ModalSize.small:
         return screenWidth < 575 ? screenWidth : 300;
       case ModalSize.medium:
         return screenWidth < 575 ? screenWidth : 500;
       case ModalSize.large:
         return screenWidth < 575 ? screenWidth : 800;
       case ModalSize.xlarge:
         return screenWidth < 575 ? screenWidth : 1140;
       case ModalSize.fullScreen:
         return screenWidth;
       default:
         return 500;
     }
   }

   double _getModalHeight(BuildContext context) {
     if (_shouldBeFullscreen(context)) {
       return MediaQuery.of(context).size.height;
     }
     return MediaQuery.of(context).size.height * 0.8;
   }

   EdgeInsets getPadding(BuildContext context){
     final screenWidth = MediaQuery.of(context).size.width;
     if(screenWidth < 575){
       if(this.modalSize == ModalSize.small ||
           this.modalSize == ModalSize.large ||
           this.modalSize == ModalSize.xlarge || this.modalSize == ModalSize.medium){

         return EdgeInsets.symmetric(horizontal: 10, vertical: 10);

       }

     }
     return EdgeInsets.symmetric(horizontal: 20, vertical: 20);

   }

   @override
  Widget build(BuildContext context) {
     return Btn(type: this.type, onClick:(){
       _showModal(context);
     } ,
       content: this.contetnBtn,
     );
     // return Obx((){
     //   Rx<bool> isHoverBtn =  false.obs;
     //   return MouseRegion(
     //     onEnter: (_){
     //       isHoverBtn.value = true;
     //     },
     //     onExit: (_){
     //       isHoverBtn.value = false;
     //     },
     //     child: InkWell(
     //       onTap: (){
     //         _showModal(context);
     //       },
     //       child: Container(
     //         decoration: BoxDecoration(
     //           borderRadius: BorderRadius.circular(10),
     //           color:isHoverBtn.value == false ?  btnColor:btnHoverColor,
     //         ),
     //         padding: EdgeInsets.only(top: 6 , bottom: 6 , left: 12 , right: 12),
     //         child: Txt('${this.btnTxt}' , color: this.colorCloseTxt, fontSize: 16, fontWeight: FontWeight.w400,),
     //       ),
     //     ),
     //   );
     // });
   }
   Widget box(BuildContext context){
     Rx<bool> isHoverCloseBtn =  false.obs;
     Rx<bool> isHoverMainBtn =  false.obs;
     Rx<bool> isHoverCloseIcon =  false.obs;
     final isFullscreen = _shouldBeFullscreen(context);
     return ConstrainedBox(
       constraints: BoxConstraints(
         // maxWidth: _getModalWidth(context),
         // minWidth: 300,
         // maxHeight: _getModalHeight(context),
         maxWidth: _getModalWidth(context),
         minWidth: isFullscreen ? MediaQuery.of(context).size.width : 300,
         maxHeight: _getModalHeight(context),
       ),
       child: Column(
         mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           // Header
           if(this.header != null)Container(
             padding: EdgeInsets.all(15),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 // Txt(
                 //   header,
                 //   fontSize: 20,
                 //   fontWeight: FontWeight.w500,
                 // ),
                 Expanded(
                   child: header!,
                 ),
                 Obx((){
                   return MouseRegion(
                     onExit: (_){
                       isHoverCloseIcon.value = false;
                     },
                     onEnter: (_){
                       isHoverCloseIcon.value = true;
                     },
                     child: IconButton(
                       icon: Icon(Icons.close , color: isHoverCloseIcon.value ? this.closeIconHoverColor : this.closeIconColor ,),
                       onPressed: () => Navigator.of(context).pop(),
                     ),
                   );
                 })
               ],
             ),
           ),

           if(this.header != null)MyDivider(),

           // Body
           Expanded(
               child: SingleChildScrollView(
                 child: Container(
                     padding: EdgeInsets.all(15),
                     child: body),
               )
           ),

           if(this.footer != null)SizedBox(height: 16),

           if(this.footer != null)MyDivider(),

           // Footer
           Container(
             padding: EdgeInsets.all(15),
             child: this.footer != null ? this.footer: Container(),
           ),
         ],
       ),
     );
   }
}
