import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/UI/Componenets/Headers/header-create.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  Rx<Widget> _future = Column().obs;
  Map<String, dynamic> dataJson = {};

  addWidget() async {
    Future.delayed(Duration.zero, () async {
      _future.value = await ViewController.generateStoreFormView(
          MainController.tableInfo['columns']);
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


    return Scaffold(
      body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
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
                    right: Directionality.of(context) == TextDirection.rtl
                        ? size.width > 800
                            ? MainController.isClickedItem.value == true
                                ? 300
                                : 50
                            : 50
                        : 0,
                    left: Directionality.of(context) == TextDirection.ltr
                        ? size.width > 800
                            ? MainController.isClickedItem.value == true
                                ? 300
                                : 50
                            : 50
                        : 0,
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
                            HeaderCreate(widget.tableName),
                            SizedBox(
                              height: 10,
                            ),
                            Container(child: _future.value)
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
