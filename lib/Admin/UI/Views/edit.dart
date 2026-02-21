import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Componenets/Headers/header-edit.dart';
import '../Componenets/btn.dart';

class EditPage extends StatefulWidget {
  EditPage({this.data});
  var data;

  @override
  State<EditPage> createState() => _EditPageState();
}

class F1Intent extends Intent {
  const F1Intent();
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
                right: Directionality.of(context) == TextDirection.rtl ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                left: Directionality.of(context) == TextDirection.ltr ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                child: Container(
                  width:size.width > 800 ? MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50 : (size.width) - 50,
                  height: size.height,
                  padding: EdgeInsets.all(15),
                  color: MainController.isLightMode.value == false ? color6 :color9,
                  child:  ColumnScroll(
                    children: [
                      SizedBox(height: 80,),
                      Shortcuts(
                          shortcuts: <LogicalKeySet, Intent>{
                            LogicalKeySet(LogicalKeyboardKey.f1):
                            const F1Intent(),
                          },
                          child: Actions(
                              actions: <Type, Action<Intent>>{
                                F1Intent:
                                CallbackAction<F1Intent>(
                                  onInvoke: (intent) async {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    await Future.delayed(const Duration(milliseconds: 50));
                                    if(ViewController.request.length!=0) {
                                      HelperController.editFunction('${MainController.infoSchema.value.schema.name}',id:'${widget.data!['_id']}' ,request:ViewController.request);
                                    }
                                    else{
                                      // await MainController.loadData();
                                      // await HelperController.goToTablePage(MainController.menuList[MainController.selectedSubItem.value]);
                                    }
                                    return null;
                                  },
                                ),
                              },
                              child: FocusScope(
                                  autofocus: true,
                                  child:
                                  Container(child: _future.value)))),
                      SizedBox(height: 20,),
                      if(MainController.selectedSubItem.value != -1)
                         if(MainController.menuList[MainController.selectedSubItem.value].schema.view!= 'custom')
                           HeaderEdit(data: widget.data,request: ViewController.request)
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
