import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/main-table-box.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/main-table-header.dart';
import 'package:finance/custom/Logic/Controllers/main-custom-controller.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/order-table/main-table-box-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/output-order-table/main-table-box-output-order-custom.dart';
import 'package:finance/custom/UI/Components/Views/output-order-item-page-custom/table-output-order-item-page-custom.dart';
import 'package:finance/custom/UI/Components/Views/output-order-page-custom/table-output-order-page-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class MainTableOutPutOrderCustom extends StatefulWidget {
  MainTableOutPutOrderCustom(this.ordersList);
  List<dynamic> ordersList;

  @override
  State<MainTableOutPutOrderCustom> createState() => _MainTableOutPutOrderCustomState();
}

class _MainTableOutPutOrderCustomState extends State<MainTableOutPutOrderCustom> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    RxInt count = RxInt(MainController.tableInfo['schema']['countShowRow']);

    return Obx((){
      return Scaffold(
          body: Container(
              width: size.width,
              height: size.height,
              child:  Stack(
                children: [
                  Positioned(
                    right: Directionality.of(context) == TextDirection.rtl ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                    left: Directionality.of(context) == TextDirection.ltr ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                    child: Container(
                      height: size.height,
                      width:size.width > 800 ? MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50 : (size.width) - 50,
                      padding: EdgeInsets.all(size.width > 800 ? 15 : 0),
                      color: MainController.isLightMode.value == false ? color6 :color9,
                      child: ColumnScroll(
                        children: [
                          SizedBox(height: 80,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Txt('لیست سفارشات',
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: MainController.isLightMode.value == true
                                    ? whiteColor
                                    : primaryDark,
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                  Get.context!, MaterialPageRoute(builder: (context) => TablePageOutPutOrderItemCustom(widget.ordersList)));
                            },
                            child: Container(
                              width: size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 20 , left: 20 , top: 10,bottom: 10),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.orange,),
                                    child: Center(child: Txt('ثبت خروج سفارشات انتخاب شده')),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            padding: EdgeInsets.only(left: 10 , right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200,
                                  child: FormTextField(
                                      name: 'search',
                                      lable: '${AppController.of(context)!.value('search')}...', onChange: (text){
                                    MainCustomController.searchOutPutOrder(text , widget.ordersList);
                                    setState(() {
                                      MainController.tableInfo['schema']['currentPage'] = 1;
                                    });

                                  }),
                                ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () async{
                                          count.value++;
                                          MainController.tableInfo['schema']['countShowRow'] = count.value;
                                          MainController.startIndex.value = (MainController.tableInfo['schema']['currentPage']-1) * MainController.tableInfo['schema']['countShowRow'];
                                          MainController.endIndex.value = MainController.startIndex.value + int.parse('${MainController.tableInfo['schema']['countShowRow']}');
                                          MainController.tableInfo['schema']['currentPage'] = 1;
                                          widget.ordersList= await DB('${MainController.tableInfo['schema']['name']}').paginate();
                                          ViewController.totalPage.value = await DB('${MainController.tableInfo['schema']['name']}').infoPage();
                                          },
                                            child: Icon(Icons.arrow_drop_up , color:  MainController.isLightMode.value == true?  whiteColor:color1,size: 20,),
                                          ),
                                          SizedBox(height: 0),
                                          InkWell(
                                            onTap: () async {
                                              count.value--;
                                              if(count.value < 10){
                                              count.value =  10;
                                              };
                                              MainController.tableInfo['schema']['countShowRow'] = count.value;
                                              MainController.startIndex.value = (MainController.tableInfo['schema']['currentPage']-1) * MainController.tableInfo['schema']['countShowRow'];
                                              MainController.endIndex.value = MainController.startIndex.value + int.parse('${MainController.tableInfo['schema']['countShowRow']}');
                                              MainController.tableInfo['schema']['currentPage'] = 1;
                                              widget.ordersList= await DB('${MainController.tableInfo['schema']['name']}').paginate();
                                              ViewController.totalPage.value = await DB('${MainController.tableInfo['schema']['name']}').infoPage();
                                            },
                                            child: Icon(Icons.arrow_drop_down , color:  MainController.isLightMode.value == true?  whiteColor:color1,size: 20,),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 5),
                                      Obx((){
                                        return Container(
                                          width: 25,
                                          child: Text(
                                            '${count.value}',
                                             textAlign: TextAlign.center,
                                             style: TextStyle(color: MainController.isLightMode.value == true?  whiteColor:color1,fontSize: 15),
                                          ),
                                        );
                                      })
                                    ],
                                  ),
                                  SizedBox(width: 5,),
                                  Row(
                                    children: [
                                      Txt('${AppController.of(context)!.value('show')}' , color: MainController.isLightMode.value == true?  whiteColor:color1, fontSize: 16, fontWeight: FontWeight.w400,),
                                      SizedBox(width: 5,),
                                      Txt('ورودی' , color: MainController.isLightMode.value == true?  whiteColor:color1, fontSize: 16, fontWeight: FontWeight.w400,),
                                    ],
                                  ),
                                ],
                              ),


                              ],
                            ),
                          ),
                          SizedBox(height: 25,),
                          MainTableBoxOutPutOrderCustom(widget.ordersList),
                        ],
                      ),
                    ),
                  ),
                  Header(),
                  MenuBox(),
                ],
              )
          )
      );
    });
  }
}
