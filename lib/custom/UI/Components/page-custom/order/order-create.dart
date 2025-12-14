import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:finance/Admin/Public/styles.dart';
import '../../../../../Admin/UI/Componenets/General/column-scroll.dart';
import 'form-create-order-custom.dart';
import '../orderItem/form-create-orderItem-custom.dart';

class OrderCreatePage extends StatelessWidget {
  String tableName;
  List<dynamic> items;
  List<dynamic> productItems;
  OrderCreatePage(this.tableName , this.items , this.productItems);
  final FocusNode _focusNode = FocusNode();

  @override

  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    Rx<bool> isHoverBtnBack = false.obs;

    return RawKeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKey: (event) {
      if (event is RawKeyDownEvent) {
        if (event.logicalKey == LogicalKeyboardKey.f1) {
          print('f1 clicked');
          HelperController.createFunction('Orders');
          if (!ViewController.isClickedBtn.value) {
            MainController.goToTablePage(
              MainController.SubMenuList[
              MainController.selectedSubItem.value
              ],
            );
          }
        }

        if (event.logicalKey == LogicalKeyboardKey.f4) {
          print('f4 clicked');
          ViewCustomController.addContainer(context ,this.productItems );
        }
      }
    },
    child: Scaffold(
      body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
          ),
          child: Stack(
            children: [
              Obx(() {
                return  Positioned(
                  // right:MainController.isClickedItem.value == true ? 300 :50,

                  // right: size.width > 800 ? MainController.isClickedItem.value == true ? 300 :50 : 50,

                    right: Directionality.of(context) == TextDirection.rtl ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                    left: Directionality.of(context) == TextDirection.ltr ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,

                    child: Container(
                      // width: MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50,
                        width:size.width > 800 ? MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50 : (size.width) - 50,
                        height: size.height,
                        // color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
                        color: MainController.isLightMode.value == false ? color6 :color9,
                        child: ColumnScroll(
                          children: [
                            SizedBox(height: 80,),

                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Txt('${AppController.of(context)!.value('add')}' , fontSize: 24 , fontWeight: FontWeight.w500, color:MainController.isLightMode.value == true ? whiteColor:primaryDark ,),
                                      SizedBox(width: 5,),
                                      Txt('${MainController.tableInfo['schema']['title']}' , fontSize: 24 , fontWeight: FontWeight.w500, color:MainController.isLightMode.value == true ? whiteColor:primaryDark ,),
                                    ],
                                  ),
                                  // if(MainController.SubMenuList[MainController.selectedSubItem.value]['view'] != 'custom')
                                  Obx((){
                                    return Row(
                                      children: [
                                        Row(
                                          children: [
                                            MouseRegion(
                                              onEnter: (_){
                                                isHoverBtnBack.value = true;
                                              },
                                              onExit: (_){
                                                isHoverBtnBack.value = false;
                                              },
                                              child: InkWell(
                                                onTap: (){

                                                  MainController.goToTablePage(MainController
                                                      .SubMenuList[
                                                  MainController
                                                      .selectedSubItem
                                                      .value]);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    border: Border.all(color: colorBtn , width: 1),
                                                    color: isHoverBtnBack.value == false ? Colors.transparent : colorBtn,
                                                  ),
                                                  child: Txt('${AppController.of(context)!.value('back')}' , color:isHoverBtnBack.value == false ? colorBtn : whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            MouseRegion(
                                              onEnter: (_){
                                              },
                                              onExit: (_){
                                              },
                                              child: InkWell(
                                                onTap: () async{
                                                  HelperController.createFunction(this.tableName);

                                                  if(ViewController.isClickedBtn.value == false){
                                                    // Get.to(() => TablePage());
                                                    MainController.goToTablePage(MainController
                                                        .SubMenuList[
                                                    MainController
                                                        .selectedSubItem
                                                        .value]);
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    color: colorBtn,
                                                  ),
                                                  child: Txt('${AppController.of(context)!.value('save')} (F1)' , color:whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Column(
                              children: [
                                FormCreateOrderCustom(this.items),
                                SizedBox(height: 20,),
                                FormCreateOrderItemCustom(this.productItems),
                              ],
                            )
                          ],
                        )
                    )
                );
              }),
              Header(),
              MenuBox(),
            ],
          )
      ),
    )
    );
  }
}