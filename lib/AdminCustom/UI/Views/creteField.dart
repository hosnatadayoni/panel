
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class CretePageField extends StatefulWidget {
  String tableName;
  CretePageField(this.tableName);

  @override
  State<CretePageField> createState() => _CretePageFieldState();
}

class _CretePageFieldState extends State<CretePageField> {
  List<dynamic> items = [];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Rx<bool> isHoverBtnBack = false.obs;

    Future<void> loadItems() async {
      for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
        items = await ViewController.itemsList(MainController.tableInfo['columns'][j]);
      }
    }

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
                    right: Directionality.of(context) == TextDirection.rtl ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                    left: Directionality.of(context) == TextDirection.ltr ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                    child: Container(
                        width: size.width > 800
                            ? MainController.isClickedItem.value == true
                            ? (size.width) - 300
                            : (size.width) - 50
                            : (size.width) - 50,
                        height: size.height,
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
                            Column(
                              children: [
                                for (var j = 0; j < MainController.tableInfo['columns'].length; j++)
                                 if (MainController.tableInfo['columns'][j]['is-show-store'] == true)
                                  if (MainController.tableInfo['columns'][j]['type'] == 'string' ||
                                      MainController.tableInfo['columns'][j]['type'] == 'int' ||
                                      MainController.tableInfo['columns'][j]['type'] == 'Number double' ||
                                      MainController.tableInfo['columns'][j]['type'] == 'Number int' ||
                                      MainController.tableInfo['columns'][j]['type'] == 'email' ||
                                      MainController.tableInfo['columns'][j]['type'] == 'mobile')
                                    ViewController.generateFormTextField(GlobalKey(), MainController.tableInfo['columns'][j], MainController.tableInfo['columns'][j]['type'], '')
                                 else if(MainController.tableInfo['columns'][j]['type'] == 'checkbox')
                                  ViewController.generateFormCheckBox(MainController.tableInfo['columns'][j], false.obs)
                                 else if(MainController.tableInfo['columns'][j]['type'] == 'date')
                                      ViewController.generateFormDateBox(MainController.tableInfo['columns'][j], Jalali.now(), false.obs)
                                 else if(MainController.tableInfo['columns'][j]['type'] == 'color')
                                      ViewController.generateFormColorBox(MainController.tableInfo['columns'][j], Colors.blue, false.obs)
                                 else if(MainController.tableInfo['columns'][j]['type'] == 'file')
                                      ViewController.generateFileBox('', MainController.tableInfo['columns'][j], false.obs)
                                 else if(MainController.tableInfo['columns'][j]['type'] == 'time')
                                      ViewController.generateFormTimeBox(MainController.tableInfo['columns'][j], TimeOfDay.now(), false.obs)
                                 else if(MainController.tableInfo['columns'][j]['type'] == 'select')
                                   if(MainController.tableInfo['columns'][j]['name'] == 'type' ||
                                       MainController.tableInfo['columns'][j]['name'] == 'type_field')
                                     ViewController.generateStoreFormSelectBox(MainController.tableInfo['columns'][j] , items , '','' , false.obs)



                              ],
                            ),
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
