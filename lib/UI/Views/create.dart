import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/UI/Componenets/Items/Header/header.dart';
import 'package:finance/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/UI/Views/table-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Logic/Models/db.dart';
import '../../Public/styles.dart';
import '../Componenets/General/column-scroll.dart';
import '../Componenets/General/txt.dart';

class CreatePage extends StatefulWidget {
  CreatePage();

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  DateTime? startTime;

  DateTime? endTime;
  late Future<Widget> _future;
  Map<String , dynamic> dataJson = {};
  @override
  void initState() {
    super.initState();
    _future = ViewController.generateStoreFormView(dataJson);
  }

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
            // color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
            color: MainController.isLightMode.value == false ? color6 :color9,
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
                                                await DB('${MainController.tableInfo['table-name']}').storeRecord(ViewController.request);
                                                if(ViewController.isClickedBtn.value == false){
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
                          SizedBox(height: 10,),
                          // MainController.SubMenuList[MainController.selectedSubItem.value]['view'] != 'custom'?
                          Container(
                            child:
                            FutureBuilder<Widget>(
                              future:_future,
                              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Txt('${AppController.of(context)!.value('error')}: ${snapshot.error}');
                                } else {
                                  return snapshot.data ?? Container(); 
                                }
                              },
                            ))
                              // :
                          // Column(
                          //   children: MainController.SubMenuList.map((subMenu) {
                          //     if (subMenu['table-name'] == 'order') {
                          //       return Column(
                          //         children: [
                          //           FormOrderCustom(),
                          //           if (subMenu['table-name'] == 'order-item')
                          //             Column(
                          //               children: [
                          //                 SizedBox(height: 20),
                          //                 FormOrderItemCustom(),
                          //               ],
                          //             ),
                          //         ],
                          //       );
                          //     }
                          //     return Container(); // Return an empty container for other cases
                          //   }).toList(),
                          // ),


                          // MainController.SubMenuList[MainController.selectedSubItem.value]['view'] == 'custom' ?
                          // Column(
                          //   children: [
                          //     FormCreateOrderCustom(),
                          //     SizedBox(height: 20,),
                          //     FormCreateOrderItemCustom(),
                          //   ],
                          // )
                              // :FormCreateOrderItemCustom(),


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