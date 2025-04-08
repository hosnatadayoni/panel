import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/validator-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Logic/Models/dataModel.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/page-custom/order/form-create-order-custom.dart';
import 'package:finance/UI/Componenets/page-custom/orderItem/form-create-orderItem-custom.dart';
import 'package:finance/UI/Views/table-page.dart';
import 'package:finance/boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:finance/Logic/Controllers/dataController.dart';
class EditPageCustom extends StatefulWidget {
  EditPageCustom({required this.index , this.data});
  DataModel? data;
  int index;

  @override
  State<EditPageCustom> createState() => _EditPageCustomState();
}

class _EditPageCustomState extends State<EditPageCustom> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Rx<bool> isHoverBtnBack = false.obs;
    return Obx((){
      return Column(
        children: [
          MainController.SubMenuList[MainController.selectedSubItem.value]['table-name'] == 'order' ? Column(
            children: [
              FormCreateOrderCustom(),
              FormCreateOrderItemCustom(),
            ],
          ):FormCreateOrderItemCustom(),
          SizedBox(height: 20,),
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
                      MainController.goToTablePage();
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
                      MainController.goToTablePage();
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
          ),
        ],
      );
    });
  }
}
