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
import 'package:finance/UI/Componenets/page-custom/FormCustom/form-edit-order-custom.dart';
import 'package:finance/UI/Componenets/page-custom/FormCustom/form-edit-orderItem-custom.dart';
import 'package:finance/UI/Componenets/page-custom/FormCustom/form-create-order-custom.dart';
import 'package:finance/UI/Componenets/page-custom/FormCustom/form-create-orderItem-custom.dart';
import 'package:finance/UI/Views/table-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Logic/Controllers/dataController.dart';
import '../../boxes.dart';

class EditPage extends StatefulWidget {
  EditPage({required this.index , this.data});
  DataModel? data;
  int index;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late Future<Widget> _future;

  @override
  void initState() {
    super.initState();
    _future = ViewController.generateEditFormView(widget.data!.data);
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
              print('widget.data2>>>${widget.data!.data}');
              return Positioned(
                // right: MainController.isClickedItem.value == true ? 300 :50,
                right: size.width > 800 ? MainController.isClickedItem.value == true ? 300 :50 : 50,
                child: Container(
                  // width: MainController.isClickedItem.value == true ?(size.width) - 300:(size.width) - 50,
                  width:size.width > 800 ? MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50 : (size.width) - 50,
                  height: size.height,
                  padding: EdgeInsets.all(15),
                  color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
                  child:  ColumnScroll(
                    children: [
                      SizedBox(height: 80,),
                      MainController.SubMenuList[MainController.selectedSubItem.value]['view'] != 'custom'?FutureBuilder<Widget>(
                        future: _future,
                        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Txt('${AppController.of(context)!.value('error')}: ${snapshot.error}');
                          } else {
                            return snapshot.data ?? Container();
                          }
                        },
                      ):
                      MainController.SubMenuList[MainController.selectedSubItem.value]['table-name'] == 'order' ? Column(
                        children: [
                          FormEditOrderCustom(index: widget.index , data: widget.data),
                          FormEditOrderItemCustom(index: widget.index , data: widget.data),
                        ],
                      ):FormEditOrderItemCustom(index: widget.index , data: widget.data),
                      // ViewController.generateEditFormView(widget.data!.data),
                      SizedBox(height: 20,),
                      if(MainController.SubMenuList[MainController.selectedSubItem.value]['view'] != 'custom')
                        Container(
                        padding: EdgeInsets.all(10),
                        width: size.width,
                        child:size.width > 550? Row(
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
                                  print('widget.data!.data>>>${widget.data!.data}');
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
                                 ViewController.isClickedEditBtn.value = true;
                                  final data = DataModel(
                                    id: widget.data!.id,
                                    data: ViewController.request,
                                  );
                                  print('xxxx>>>${data.data}');
                                 bool isValidator;
                                  List<bool> isValidatorList=[];
                                  for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
                                    isValidator = await ValidatorController.checkInputValidation(j,data.data);
                                    isValidatorList.add(isValidator);
                                  }
                                  print('isValidatorList>>>${isValidatorList}');
                                  bool isExsistsValidation = isValidatorList.contains(false);
                                  print('isExsistsValidation>>>${isExsistsValidation}');
                                  if(isExsistsValidation){
                                    isValidatorList=[];
                                  }
                                  else{
                                    dataController.allData.value[widget.index] =  data;
                                    MainController.tableData.value[widget.index] = data;
                                    await box.putAt(widget.index,data);
                                    print('dataController.allData.value[widget.index]>>>${dataController.allData.value[widget.index].data}');
                                    print('MainController.tableData.value[widget.index]>>>>${MainController.tableData.value[widget.index]}');
                                    MainController.isClickedItem.value = true;
                                    ViewController.isClickedEditBtn.value = false;
                                    Get.to(() => TablePage());
                                  }


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
                        ):Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                                  print('widget.data!.data>>>${widget.data!.data}');
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
                            SizedBox(height: 10,),
                            InkWell(
                              onTap: ()async{
                                ViewController.isClickedEditBtn.value = true;
                                final data = DataModel(
                                  id: widget.data!.id,
                                  data: ViewController.request,
                                );
                                print('xxxx>>>${data.data}');
                                bool isValidator;
                                List<bool> isValidatorList=[];
                                for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
                                  isValidator = await ValidatorController.checkInputValidation(j,data.data);
                                  isValidatorList.add(isValidator);
                                }
                                print('isValidatorList>>>${isValidatorList}');
                                bool isExsistsValidation = isValidatorList.contains(false);
                                print('isExsistsValidation>>>${isExsistsValidation}');
                                if(isExsistsValidation){
                                  isValidatorList=[];
                                }
                                else{
                                  dataController.allData.value[widget.index] =  data;
                                  MainController.tableData.value[widget.index] = data;
                                  await box.putAt(widget.index,data);
                                  print('dataController.allData.value[widget.index]>>>${dataController.allData.value[widget.index].data}');
                                  print('MainController.tableData.value[widget.index]>>>>${MainController.tableData.value[widget.index]}');
                                  MainController.isClickedItem.value = true;
                                  ViewController.isClickedEditBtn.value = false;
                                  Get.to(() => TablePage());
                                }


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
