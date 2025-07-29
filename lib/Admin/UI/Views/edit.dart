import 'package:panel/Admin/Logic/Controllers/app-controller.dart';
import 'package:panel/Admin/Logic/Controllers/helper-controller.dart';
import 'package:panel/Admin/Logic/Controllers/main-controller.dart';
import 'package:panel/Admin/Logic/Controllers/view-controller.dart';
import 'package:panel/Admin/Logic/Models/dataModel.dart';
import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:panel/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:panel/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panel/Admin/Logic/Models/db.dart';

class EditPage extends StatefulWidget {
  EditPage({this.data});

  var data;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late Future<Widget> _future;

  @override
  void initState() {
    super.initState();
    _future = ViewController.generateEditFormView(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Rx<bool> isHoverBtnBack = false.obs;
    print('ViewController.request s>>>${ViewController.request}');
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MainController.isLightMode.value == true
              ? darkBackground
              : backgroundLight,
        ),
        child: Stack(
          children: [
            Obx(() {
              return Positioned(
                // right: MainController.isClickedItem.value == true ? 300 :50,
                right: size.width > 800
                    ? MainController.isClickedItem.value == true
                        ? 300
                        : 50
                    : 50,
                child: Container(
                  // width: MainController.isClickedItem.value == true ?(size.width) - 300:(size.width) - 50,
                  width: size.width > 800
                      ? MainController.isClickedItem.value == true
                          ? (size.width) - 300
                          : (size.width) - 50
                      : (size.width) - 50,
                  height: size.height,
                  padding: EdgeInsets.all(15),
                  // color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
                  color: MainController.isLightMode.value == false
                      ? color6
                      : color9,
                  child: ColumnScroll(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      // MainController.SubMenuList[MainController.selectedSubItem.value]['view'] != 'custom'?
                      FutureBuilder<Widget>(
                        future: _future,
                        builder: (BuildContext context,
                            AsyncSnapshot<Widget> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Txt(
                                '${AppController.of(context)!.value('error')}: ${snapshot.requireData}');
                          } else {
                            return snapshot.data ?? Container();
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (MainController.selectedSubItem.value != -1)
                        Container(
                            padding: EdgeInsets.all(10),
                            width: size.width,
                            child: Wrap(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              alignment: WrapAlignment.end,
                              children: [
                                MouseRegion(
                                  onEnter: (_) {
                                    isHoverBtnBack.value = true;
                                  },
                                  onExit: (_) {
                                    isHoverBtnBack.value = false;
                                  },
                                  child: InkWell(
                                    onTap: () async {
                                      await MainController.goToTablePage(MainController.SubMenuList[MainController.selectedSubItem.value]);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                            color: colorBtn, width: 1),
                                        color: isHoverBtnBack.value == false
                                            ? Colors.transparent
                                            : colorBtn,
                                      ),
                                      child: Txt(
                                        '${AppController.of(context)!.value('back')}',
                                        color: isHoverBtnBack.value == false
                                            ? colorBtn
                                            : whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () async {
                                    print('_EditPageSate.build>>>${ViewController.request}>>>${MainController.tableName.value}');
                                    HelperController.editFunction(MainController.tableName.value,request:ViewController.request ,id:widget.data!['_id'] );
                                    if (ViewController.isClickedBtn.value ==
                                        false) {}
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: colorBtn,
                                    ),
                                    child: Txt(
                                      '${AppController.of(context)!.value('edit')}',
                                      color: whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ))
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
