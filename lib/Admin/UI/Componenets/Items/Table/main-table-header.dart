import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Views/create.dart';
import 'package:finance/Admin/UI/Views/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/get_rx.dart';

class MainTableHeader extends StatefulWidget {
  const MainTableHeader({Key? key}) : super(key: key);

  @override
  State<MainTableHeader> createState() => _MainTableHeaderState();
}

class _MainTableHeaderState extends State<MainTableHeader> {
  String? fileExelPath;
  @override
  Widget build(BuildContext context) {
    Rx<bool> isHoverBtn = false.obs;
    return Container(
      padding: EdgeInsets.only(right: 10 , left: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Txt('${MainController.selectedSubItem.value != -1 ? MainController.tableInfo['title']:''}' , fontSize: 24 , fontWeight: FontWeight.w500, color:MainController.isLightMode.value == true ? whiteColor:primaryDark ,)),
          Row(
            children: [
              MouseRegion(
                onEnter:(_){
                  isHoverBtn.value = true;
                },
                onExit: (_){
                  isHoverBtn.value = false;
                },
                child: InkWell(
                  onTap: (){
                    MainController.isClickedItem.value = false;
                    MainController.selectedItem.value = -1;
                    MainController.selectedSubItem.value = -1;
                    Get.to(() => DashboardPage());
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: colorBtn , width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: isHoverBtn.value == true ? colorBtn : Colors.transparent
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back , color: isHoverBtn.value == true ? whiteColor:colorBtn),
                        SizedBox(width: 10,),
                        Txt('${AppController.of(context)!.value('back')}' , fontSize: 16, fontWeight: FontWeight.w400,color: isHoverBtn.value == true ? whiteColor : colorBtn,),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              PopupMenuTheme(
                data: PopupMenuThemeData(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
                    side: BorderSide(width: borderSize , color: itemColor34),
                  ),
                  color:MainController.isLightMode.value == true? background:whiteColor,
                ),
                child: PopupMenuButton(
                  elevation: 0,
                  offset: Offset(0, 55),
                  onSelected: (value) {
                    setState(() {
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry>[
                      PopupMenuItem(
                          onTap: () {
                            setState(()  {
                              ViewController.isClickedBtn.value = false;
                              ViewController.isClickedEditBtn.value = false;
                            });
                            Future.delayed(Duration.zero , ()async{
                              ViewController.request={};
                              if(MainController.SubMenuList[MainController.selectedSubItem.value]['view']=='custom'){
                                HelperController.createPageFunction();
                              //   await Get.to(() => MainController.SubMenuList[MainController.selectedSubItem.value]['create-view-address']);
                              }
                              else{
                                await Get.to(() => CreatePage());
                              }

                            });
                          },
                          value: 'create',
                          child: Container(
                            child: Row(
                              children: [
                                Icon(Icons.add, color: MainController.isLightMode.value == false ? color3:whiteColor, size: 15,),
                                SizedBox(width: 5,),
                                Txt('${AppController.of(context)!.value('create')}' , color: MainController.isLightMode.value == false ? color3:whiteColor)
                              ],
                            ),
                          )
                      ),
                      PopupMenuItem(
                          onTap: ()async{
                            await MainController.createExel(fileExelPath);
                          },
                          value: 'Export Excel',
                          child: Container(
                            child: Row(
                              children: [
                                FaIcon(FontAwesomeIcons.fileExcel , size: 15 , color: MainController.isLightMode.value == false ? color3:whiteColor,),
                                SizedBox(width: 10,),
                                Txt('${AppController.of(context)!.value('excel output')}' , color: MainController.isLightMode.value == false ? color3:whiteColor)
                              ],
                            ),
                          )
                      ),
                      PopupMenuItem(
                          onTap: ()async{
                            await MainController.readExcelFile(fileExelPath);
                          },
                          value: 'Import Excel',
                          child: Container(
                            child: Row(
                              children: [
                                FaIcon(FontAwesomeIcons.fileExcel , size: 15 , color: MainController.isLightMode.value == false ? color3:whiteColor,),
                                SizedBox(width: 10,),
                                Txt('${AppController.of(context)!.value('excel input')}' , color: MainController.isLightMode.value == false ? color3:whiteColor)
                              ],
                            ),
                          )
                      ),
                    ];
                  },
                  child:  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorBtn , width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: colorBtn,
                    ),
                    child: Row(
                      children: [
                        Txt('${AppController.of(context)!.value('operation')}' , fontSize: 16, fontWeight: FontWeight.w400,color: whiteColor,),
                        SizedBox(width: 10,),
                        Icon(Icons.arrow_drop_down_sharp , size: 20, color: whiteColor,),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
