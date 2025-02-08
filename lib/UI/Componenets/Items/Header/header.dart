import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/user-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Views/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';


class Header extends StatelessWidget {
   Header({this.title});
   String? title;
  Rx<bool> isHoverMenu = false.obs;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx((){
      return Positioned(
         right:size.width > 800 ? MainController.isClickedItem.value == true ? 300 :50 : 50,
        child: Container(
          padding: EdgeInsets.all(15),
          color: MainController.isLightMode.value == true? background:whiteColor,
          width: size.width > 800 ? MainController.isClickedItem.value == true ?(size.width) - 300:(size.width) - 50 : (size.width) - 50,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  MainController.isClickedItem.value = false;
                  MainController.selectedItem.value = -1;
                  MainController.selectedSubItem.value = -1;
                  Get.to(() => DashboardPage());
                },
                  child: Txt('${this.title}' , fontSize: 20 , fontWeight: FontWeight.w500 , color: MainController.isLightMode.value == true? whiteColor : color3)),
              // InkWell(
              //   onTap: (){
              //   },
              //   child: MouseRegion(
              //     onEnter:(_){
              //       isHoverMenu.value = true;
              //     },
              //     onExit: (_){
              //       isHoverMenu.value = false;
              //     },
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Txt('logout' , fontSize: 20 , fontWeight: FontWeight.w500, color: isHoverMenu.value == true && MainController.isLightMode.value == false ? colorBtn : isHoverMenu.value == false && MainController.isLightMode.value == false ? color3 : isHoverMenu.value == false && MainController.isLightMode.value == true ? whiteColor : color3,),
              //         Stack(
              //           children: [
              //             Container(
              //                 width: 40,
              //                 height: 40,
              //                 child: Icon(CupertinoIcons.bell_fill, size: 25, color: isHoverMenu.value == true && MainController.isLightMode.value == false ? colorBtn : isHoverMenu.value == false && MainController.isLightMode.value == false ? color3 : isHoverMenu.value == false && MainController.isLightMode.value == true ? whiteColor : color3,)),
              //             Positioned(
              //               left: 1,
              //               child: Container(
              //                 width: 20,
              //                 height: 20,
              //                 decoration: BoxDecoration(
              //                   color: redColor,
              //                   shape: BoxShape.circle,
              //                 ),
              //                 child: Txt('1' , color: whiteColor, textAlign: TextAlign.center,),
              //               ),
              //             )
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                          width: 40,
                          height: 40,
                          child: Icon(CupertinoIcons.bell_fill, size: 25, color: isHoverMenu.value == true && MainController.isLightMode.value == false ? colorBtn : isHoverMenu.value == false && MainController.isLightMode.value == false ? color3 : isHoverMenu.value == false && MainController.isLightMode.value == true ? whiteColor : color3,)),
                      Positioned(
                        left: 1,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: redColor,
                            shape: BoxShape.circle,
                          ),
                          child: Txt('1' , color: whiteColor, textAlign: TextAlign.center,),
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 5,),
                  PopupMenuTheme(
                    data: PopupMenuThemeData(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
                        side: BorderSide(width: borderSize , color: itemColor34),
                      ),
                      color:MainController.isLightMode.value == true? background:whiteColor,
                    ),
                    child: PopupMenuButton(
                      elevation: 0,
                      offset: Offset(0, 35),
                      onSelected: (value) {
                      },
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry>[
                          PopupMenuItem(
                              value: 'userName',
                              child: Txt('${UserController.userName.value}',fontSize: 18 , fontWeight: FontWeight.w300 , color: MainController.isLightMode.value == false ? color3:whiteColor)
                          ),
                          PopupMenuItem(
                            value: 'logout',
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Txt('${AppController.of(context)!.value('logout')}' , fontSize: 18 , fontWeight: FontWeight.w300, color: isHoverMenu.value == true && MainController.isLightMode.value == false ? colorBtn : isHoverMenu.value == false && MainController.isLightMode.value == false ? color3 : isHoverMenu.value == false && MainController.isLightMode.value == true ? whiteColor : color3,),
                              ],
                            ),
                          ),
                        ];
                      },
                      child:  Container(
                        // padding: EdgeInsets.all(10),
                        width: 190,
                        height: 300,
                        padding: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: colorBtn , width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: colorBtn,
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Txt('${AppController.of(context)!.value('user account information')}' , fontSize: 16, fontWeight: FontWeight.w400,color: whiteColor,),
                              SizedBox(width: 10,),
                              Icon(Icons.arrow_drop_down_sharp , size: 20, color: whiteColor,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
