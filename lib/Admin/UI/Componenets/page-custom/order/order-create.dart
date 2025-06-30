import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/Admin/UI/Views/table-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/styles.dart';
import '../../General/column-scroll.dart';
import '../../General/txt.dart';
import 'form-create-order-custom.dart';
import '../orderItem/form-create-orderItem-custom.dart';

class OrderCreatePage extends StatelessWidget {
  OrderCreatePage();


  @override

  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    Rx<bool> isHoverBtnBack = false.obs;

    return Scaffold(
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
                    right: size.width > 800 ? MainController.isClickedItem.value == true ? 300 :50 : 50,
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
                                      Txt('${MainController.tableInfo['title']}' , fontSize: 24 , fontWeight: FontWeight.w500, color:MainController.isLightMode.value == true ? whiteColor:primaryDark ,),
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

                                                  MainController.goToTablePage();
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
                                                  // await DB('${MainController.tableInfo['table-name']}').storeRecord(ViewController.request);
                                                  // for (var i = MainController.startIndex.value; i < MainController.endIndex.value; i++){
                                                  // }
                                                  print('sasdddfvv>>>${await DB('sample').getRecords()}');
                                                  await DB('order3').storeRecord({'price':6000 ,
                                                    'sampleSelect' : '8a4049b9-c6d2-4e9b-a00d-064195b9dcb8' ,
                                                    'type' : ['1'] , 'checkBox' : true , 'radiobutton' : '1'});
                                                  List<dynamic> orderList = await DB('order3').getRecords();
                                                  await DB('itemsOrder2').parent(parentId: '${orderList.last['_id']}', parentTable: 'order3').storeRecord({'title': 'order item 1' ,
                                                    'description' : 'desription  order item 1-1'});
                                                  await DB('itemsOrder2').parent(parentId: '${orderList.last['_id']}', parentTable: 'order3').storeRecord({'title': 'order item 2' ,
                                                    'description' : 'desription  order item 2-1'});


                                                  if(ViewController.isClickedBtn.value == false){
                                                    // Get.to(() => TablePage());
                                                    MainController.goToTablePage();
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    color: colorBtn,
                                                  ),
                                                  child: Txt('${AppController.of(context)!.value('save')}' , color:whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
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
                            // SizedBox(height: 10,),
                            // Column(
                            //   children: [
                            //     FormCreateOrderCustom(),
                            //     SizedBox(height: 20,),
                            //     FormCreateOrderItemCustom(),
                            //   ],
                            // )
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
    );
  }
}
