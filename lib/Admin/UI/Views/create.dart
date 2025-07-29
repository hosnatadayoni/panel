import 'package:panel/Admin/Logic/Controllers/app-controller.dart';
import 'package:panel/Admin/Logic/Controllers/helper-controller.dart';
import 'package:panel/Admin/Logic/Controllers/main-controller.dart';
import 'package:panel/Admin/Logic/Controllers/view-controller.dart';
import 'package:panel/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:panel/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:panel/Admin/UI/Views/table-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:panel/Admin/Logic/Models/db.dart';
import '../../Public/styles.dart';
import '../Componenets/General/column-scroll.dart';
import '../Componenets/General/txt.dart';

class CreatePage extends StatefulWidget {
  String tableName;
  CreatePage(this.tableName);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  DateTime? startTime;

  DateTime? endTime;
  late Future<Widget> _future;
  Map<String, dynamic> dataJson = {};

  @override
  void initState() {
    super.initState();
    _future = ViewController.generateStoreFormView(MainController.tableInfo['columns']);
  }

  @override
  Widget build(BuildContext context) {
    print('_CreatePageState.build>>${MainController.SubMenuList.indexWhere((element) => element['table-name']=='schema')}');

    var size = MediaQuery.of(context).size;
    Rx<bool> isHoverBtnBack = false.obs;

    return Scaffold(
      body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
            color: MainController.isLightMode.value == false ? color6 : color9,
          ),
          child: Stack(
            children: [
              Obx(() {
                return Positioned(
                    // right:MainController.isClickedItem.value == true ? 300 :50,

                    // right: size.width > 800
                    //     ? MainController.isClickedItem.value == true
                    //         ? 300
                    //         : 50
                    //     : 50,
                    right: Directionality.of(context) == TextDirection.rtl ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                    left: Directionality.of(context) == TextDirection.ltr ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                    child: Container(
                        // width: MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50,
                        width: size.width > 800
                            ? MainController.isClickedItem.value == true
                                ? (size.width) - 300
                                : (size.width) - 50
                            : (size.width) - 50,
                        height: size.height,
                        // color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
                        color: MainController.isLightMode.value == false
                            ? color6
                            : color9,
                        child: ColumnScroll(
                          children: [
                            SizedBox(
                              height: 80,
                            ),

                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Txt(
                                        '${AppController.of(context)!.value('add')}',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            MainController.isLightMode.value ==
                                                    true
                                                ? whiteColor
                                                : primaryDark,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Txt(
                                        '${MainController.tableInfo['title']}',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            MainController.isLightMode.value ==
                                                    true
                                                ? whiteColor
                                                : primaryDark,
                                      ),
                                    ],
                                  ),
                                  // if(MainController.SubMenuList[MainController.selectedSubItem.value]['view'] != 'custom')
                                  Obx(() {
                                    return Row(
                                      children: [
                                        Row(
                                          children: [
                                            MouseRegion(
                                              onEnter: (_) {
                                                isHoverBtnBack.value = true;
                                              },
                                              onExit: (_) {
                                                isHoverBtnBack.value = false;
                                              },
                                              child: InkWell(
                                                onTap: () {
                                                  MainController.goToTablePage(MainController.SubMenuList[MainController.selectedSubItem.value]);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    border: Border.all(
                                                        color: colorBtn,
                                                        width: 1),
                                                    color:
                                                        isHoverBtnBack.value ==
                                                                false
                                                            ? Colors.transparent
                                                            : colorBtn,
                                                  ),
                                                  child: Txt(
                                                    '${AppController.of(context)!.value('back')}',
                                                    color:
                                                        isHoverBtnBack.value ==
                                                                false
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
                                            MouseRegion(
                                              onEnter: (_) {},
                                              onExit: (_) {},
                                              child: InkWell(
                                                onTap: () async {
                                                  print('_CreatePageState.build>>>${ViewController.request}');
                                                  HelperController.createFunction(widget.tableName);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    color: colorBtn,
                                                  ),
                                                  child: Txt(
                                                    '${AppController.of(context)!.value('save')}',
                                                    color: whiteColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
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
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: FutureBuilder<Widget>(
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
                            ))
                          ],
                        )));
              }),
              Header(),
              MenuBox(),
            ],
          )),
    );
  }
}
