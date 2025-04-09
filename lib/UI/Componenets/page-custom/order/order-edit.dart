import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/column-scroll.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Header/header.dart';
import 'package:finance/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/UI/Componenets/page-custom/order/form-edit-order-custom.dart';
import 'package:finance/UI/Componenets/page-custom/orderItem/form-edit-orderItem-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Logic/Models/db.dart';

class OrderEdit extends StatefulWidget {
  OrderEdit({this.data});
  var data;

  @override
  State<OrderEdit> createState() => _OrderEditState();
}

class _OrderEditState extends State<OrderEdit> {
  late Future<Widget> _future;

  @override
  void initState() {
    super.initState();
    _future = getOrderItems(widget.data);
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
          color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
        ),
        child: Stack(
          children: [
            Obx((){
              return Positioned(
                right: size.width > 800 ? MainController.isClickedItem.value == true ? 300 :50 : 50,
                child: Container(
                  width:size.width > 800 ? MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50 : (size.width) - 50,
                  height: size.height,
                  padding: EdgeInsets.all(15),
                  color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
                  child:  ColumnScroll(
                    children: [
                      SizedBox(height: 80,),
                      Column(
                        children: [
                          FormEditOrderCustom(data: widget.data),
                          FutureBuilder<Widget>(
                            future:_future,
                            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Txt('${AppController.of(context)!.value('error')}: ${snapshot.error}');
                              } else {
                                return snapshot.data ?? Container();
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                     // Container(
                        //     padding: EdgeInsets.all(10),
                        //     width: size.width,
                        //     child: Wrap(
                        //       // mainAxisAlignment: MainAxisAlignment.end,
                        //       alignment: WrapAlignment.end,
                        //       children: [
                        //         MouseRegion(
                        //           onEnter: (_){
                        //             isHoverBtnBack.value = true;
                        //           },
                        //           onExit: (_){
                        //             isHoverBtnBack.value = false;
                        //           },
                        //           child: InkWell(
                        //             onTap: (){
                        //               print('widget.data!.data>>>${widget.data!.data}');
                        //               MainController.isClickedItem.value = true;
                        //               MainController.goToTablePage();
                        //             },
                        //             child: Container(
                        //               padding: EdgeInsets.all(10),
                        //               decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.all(Radius.circular(10)),
                        //                 border: Border.all(color: colorBtn , width: 1),
                        //                 color: isHoverBtnBack.value == false ? Colors.transparent : colorBtn,
                        //               ),
                        //               child: Txt('${AppController.of(context)!.value('back')}' , color:isHoverBtnBack.value == false ? colorBtn : whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(width: 5,),
                        //         InkWell(
                        //           onTap: ()async{
                        //             DB('${MainController.tableInfo['table-name']}').where('id', '==', '${widget.data!.id}').updateRecord(ViewController.request);
                        //           },
                        //           child: Container(
                        //             padding: EdgeInsets.all(10),
                        //             decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.all(Radius.circular(10)),
                        //               color: colorBtn,
                        //             ),
                        //             child: Txt('${AppController.of(context)!.value('edit')} ' , color:whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
                        //           ),
                        //         ),
                        //       ],
                        //     )
                        // )
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
Future<Widget> getOrderItems(var data) async {
  print('data id>>${data!.id}');
  List<dynamic>items=await DB('order-items').where("سفارش", '==', "${data.id}").getRecords();
  print('items length>>${items.length}');
  return Column(
    children: [
      for(var item in items)
        // Text('${item}')
        FormEditOrderItemCustom(data:item)
    ],
  );
}