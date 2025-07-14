import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Logic/Models/db.dart';
import '../Componenets/btn.dart';

class EditPage extends StatefulWidget {
  EditPage({this.data});
  var data;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Rx<Widget> _future=Column().obs;

  addWidget()async{
    Future.delayed(Duration.zero, () async {
      _future.value = await ViewController.generateEditFormView(widget.data);
    });
  }
  @override
  void initState() {
    super.initState();
    addWidget();
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
          color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
        ),
        child: Stack(
          children: [
            Obx((){
              return Positioned(
                // right: MainController.isClickedItem.value == true ? 300 :50,
                // right: size.width > 800 ? MainController.isClickedItem.value == true ? 300 :50 : 50,

                right: Directionality.of(context) == TextDirection.rtl ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                left: Directionality.of(context) == TextDirection.ltr ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                child: Container(
                  // width: MainController.isClickedItem.value == true ?(size.width) - 300:(size.width) - 50,
                  width:size.width > 800 ? MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50 : (size.width) - 50,
                  height: size.height,
                  padding: EdgeInsets.all(15),
                  // color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
                  color: MainController.isLightMode.value == false ? color6 :color9,
                  child:  ColumnScroll(
                    children: [
                      SizedBox(height: 80,),
                      // MainController.SubMenuList[MainController.selectedSubItem.value]['view'] != 'custom'?
                      _future.value,
                      //     :
                      // MainController.SubMenuList[MainController.selectedSubItem.value]['table-name'] == 'order' ? Column(
                      //   children: [
                      //     FormEditOrderCustom(index: widget.index , data: widget.data),
                      //     FormEditOrderItemCustom(index: widget.index , data: widget.data),
                      //   ],
                      // ):FormEditOrderItemCustom(index: widget.index , data: widget.data),
                      // ViewController.generateEditFormView(widget.data!.data),
                      SizedBox(height: 20,),
                      if(MainController.selectedSubItem.value != -1)
                         if(MainController.SubMenuList[MainController.selectedSubItem.value]['view'] != 'custom')
                            Container(
                        padding: EdgeInsets.all(10),
                        width: size.width,
                        child: Wrap(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          alignment: WrapAlignment.end,
                          children: [
                            // MouseRegion(
                            //   onEnter: (_){
                            //     isHoverBtnBack.value = true;
                            //   },
                            //   onExit: (_){
                            //     isHoverBtnBack.value = false;
                            //   },
                            //   child: InkWell(
                            //     onTap: () async {
                            //       await MainController.loadData();
                            //       await MainController.goToTablePage();
                            //     },
                            //     child: Container(
                            //       padding: EdgeInsets.all(10),
                            //       decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.all(Radius.circular(10)),
                            //         border: Border.all(color: colorBtn , width: 1),
                            //         color: isHoverBtnBack.value == false ? Colors.transparent : colorBtn,
                            //       ),
                            //       child: Txt('${AppController.of(context)!.value('back')}' , color:isHoverBtnBack.value == false ? colorBtn : whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
                            //     ),
                            //   ),
                            // ),
                            Btn(type: btnType.primary, isOutline: true, content: Txt(
                              '${AppController.of(context)!.value('back')}', fontSize: 16, fontWeight: FontWeight.w400,
                            ),onClick: () async {
                              await MainController.loadData();
                              await MainController.goToTablePage(MainController.SubMenuList[MainController.selectedSubItem.value]);
                            }),
                            SizedBox(width: 5,),
                            // InkWell(
                            //   onTap: ()async{
                            //     // Map<String,dynamic> parent=await DB.parentItem;
                            //     // if(parent.length==0) {
                            //     print('_EditPageState.build>>>${ViewController.request}');
                            //           await DB('${MainController.tableInfo['table-name']}').where('_id', '\$eq', '${widget.data!['_id']}')
                            //           .updateRecords(ViewController.request);
                            //     // }
                            //     // else{
                            //     //   await DB('${MainController.tableInfo['table-name']}').parent(parentTable: '${parent['parent_table']}',parentId:'${parent['parent_id']}' ).where('_id', '\$eq', '${widget.data!['_id']}')
                            //     //       .updateRecords(ViewController.request);
                            //     // }
                            //     if (ViewController.isClickedBtn.value == false) {
                            //       await MainController.goToTablePage();
                            //     }
                            //   },
                            //   child: Container(
                            //     padding: EdgeInsets.all(10),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.all(Radius.circular(10)),
                            //       color: colorBtn,
                            //     ),
                            //     child: Txt('${AppController.of(context)!.value('edit')}' , color:whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
                            //   ),
                            // ),
                            Btn(type: btnType.primary , content: Txt(
                              '${AppController.of(context)!.value('edit')}',
                              color: whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                                onClick: () async {
                                  print('_EditPageState.build>>>${ViewController.request}>>>${widget.data!['_id']}');
                                  if(ViewController.request.length!=0) {
                                    await DB('${MainController.tableInfo['schema']['name']}').where('_id', '\$eq', '${widget.data!['_id']}').updateRecords(ViewController.request);
                                  }
                                  else{
                                    await MainController.loadData();
                                    await MainController.goToTablePage(MainController.SubMenuList[MainController.selectedSubItem.value]);
                                  }
                                  // // Map<String,dynamic> parent=await DB.parentItem;
                                  // // if(parent.length==0) {
                                  // print('_EditPageState.build>>>${ViewController.request}');
                                  // await DB('${MainController.tableInfo['schema']['name']}').where('_id', '\$eq', '${widget.data!['_id']}')
                                  //     .updateRecords(ViewController.request);
                                  // // }
                                  // // else{
                                  // //   await DB('${MainController.tableInfo['name']}').parent(parentTable: '${parent['parent_table']}',parentId:'${parent['parent_id']}' ).where('_id', '\$eq', '${widget.data!['_id']}')
                                  // //       .updateRecords(ViewController.request);
                                  // // }
                                  if (ViewController.isClickedBtn.value == false) {
                                    await MainController.goToTablePage(MainController.SubMenuList[MainController.selectedSubItem.value]);
                                  }
                                } , loadingTag: 'update-records'),
                          ],
                        )
                      )
                    ],
                  ),
                ),
              );
            }),
            Header(),
            MenuBox(),
          ],
        ),
      ),
    );
  }
}
