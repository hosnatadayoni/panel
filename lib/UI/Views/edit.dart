import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/validator-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Logic/Models/dataModel.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/column-scroll.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Header/header.dart';
import 'package:finance/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/UI/Views/table-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Logic/Controllers/dataController.dart';
import '../../Logic/Controllers/dataController.dart';
import '../../Logic/Controllers/record-controller.dart';
import '../../boxes.dart';

class EditPage extends StatefulWidget {
  EditPage({required this.index , this.data});
  DataModel? data;
  int index;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
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
            Obx((){
              return Positioned(
                right: MainController.isClickedItem.value == true ? 300 :50,
                child: Container(
                  width: MainController.isClickedItem.value == true ?(size.width) - 300:(size.width) - 50,
                  height: size.height,
                  padding: EdgeInsets.all(15),
                  color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
                  child: ColumnScroll(
                    children: [
                      SizedBox(height: 80,),
                      ViewController.generateEditFormView(widget.data!.data),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                                  MainController.isClickedItem.value = true;
                                  Get.to(() => TablePage());
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
                            InkWell(
                              onTap: ()async{
                               await RecordController.updateRecord(widget.data!, widget.index);


                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: colorBtn,
                                ),
                                child: Txt('${AppController.of(context)!.value('edit')}' , color:whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
            Header(title: ''),
            MenuBox(),
          ],
        ),
      ),
    );
  }
}
