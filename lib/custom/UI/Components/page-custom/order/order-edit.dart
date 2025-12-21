import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/dataController.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/Logic/Models/order-item.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/custom/UI/Components/page-custom/order/form-edit-order-custom.dart';
import 'package:finance/custom/UI/Components/page-custom/orderItem/form-edit-orderItem-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:finance/Admin/Logic/Models/db.dart';

class OrderEditPge extends StatefulWidget {
  OrderEditPge(this.customerItems ,  this.productItems , this.orderDetailItems ,{this.data});
  var data;
  List<dynamic> customerItems;
  List<dynamic> productItems;
  List<dynamic> orderDetailItems;

  @override
  State<OrderEditPge> createState() => _OrderEditPgeState();
}

class _OrderEditPgeState extends State<OrderEditPge> {

  @override
  void initState() {
    super.initState();
    addWidget();
  }
  final FocusNode _focusNode = FocusNode();
  Rx<Widget> _future = Column().obs;
  addWidget() async {
    Future.delayed(Duration.zero, () async {
      _future.value = await ViewCustomController.getOrderItems(widget.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print('widget.data>>>${widget.data}');
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.f1) {
            print('f1 clicked');
            ViewController.isClickedEditBtn.value =  true;
            //add edit function
            // HelperController.editFunction('Orders',id:'${widget.data!['_id']}' , request:widget.data);
          }

          if (event.logicalKey == LogicalKeyboardKey.f4) {
            print('f4 clicked');
            ViewCustomController.addEditContainer(context ,widget.productItems );
          }
        }
      },
      child: Scaffold(
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
                  // right: size.width > 800 ? MainController.isClickedItem.value == true ? 300 :50 : 50,

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
                        Column(
                          children: [
                            FormEditOrderCustom(data: widget.data , widget.customerItems ),
                            SizedBox(height: 20,),
                            // FormEditOrderItemCustom(widget.productItems),
                            Container(child: _future.value)
                          ],
                        ),
                        // InkWell(
                        //   onTap: ()async{
                        //     // await DB('order3').parent().where('_id', '\$eq', '${widget.data!['_id']}').
                        //     // updateRecord({
                        //     //   'price':900000 , 'type' : ['2'] , 'checkBox' : false , 'radiobutton' : '2'
                        //     // });
                        //     // print('flsawws>>>${await DB('order3').parent().getRecords()}');
                        //     // await DB('order3').parent().where('_id', '\$eq', 'c4326285-c0cd-4da0-893b-b77fce7fb291').
                        //     // updateRecord({
                        //     //   'price':20000000 , 'type' : ['2'] , 'checkBox' : false , 'radiobutton' : '2'
                        //     // });
                        //     // print('getRecord sample table>>>${await DB('sample').getRecords()}');
                        //     // await DB('order3').parent().where('price', '\$gte', 50000).
                        //     // updateRecord({
                        //     //   'type' : ['1' , '2'] , 'sampleSelect':'09405051-de7f-4175-9197-730a0613c9e8'
                        //     // });
                        //     //
                        //     // await DB('order3').parent().where('price', '\$lte', 50000).
                        //     // updateRecord({
                        //     //   'sampleSelect':''
                        //     // });
                        //     //
                        //     // print('dsajklddwsww>>>${await DB('itemsOrder2').parent(parentId: '328c5ec1-c3e7-4d6c-8ae5-547482ec05a4', parentTable: 'order3').getRecords()}');
                        //     // // // await DB('itemsOrder2').parent(parentId: '${widget.data!['parent_id']}', parentTable: 'order3').
                        //     // // // where('_id', '\$eq', '852e1903-e27d-485f-8967-fdfc1c47785b').updateRecord({
                        //     // // //   'title': 'order item 3'
                        //     // // // });
                        //     // await DB('itemsOrder2').parent(parentId: '328c5ec1-c3e7-4d6c-8ae5-547482ec05a4', parentTable: 'order3').
                        //     // where('_id', '\$eq', '73604568-da1b-494e-b4ea-a835d4dd8df7').updateRecord({
                        //     //   'title': 'new order item 2'
                        //     // });
                        //     // await DB('itemsOrder2').parent(parentId: 'c4326285-c0cd-4da0-893b-b77fce7fb291', parentTable: 'order3').
                        //     // where('title', '\$eq', 'order item 2 - 2').updateRecord({
                        //     //   'description': 'BBBBBBBB'
                        //     // });
                        //     //
                        //     // await DB('itemsOrder2').parent(parentId: '328c5ec1-c3e7-4d6c-8ae5-547482ec05a4', parentTable: 'order3').
                        //     // where('title', '\$eq', 'new order item 1').updateRecord({
                        //     //   'description': 'AAAAAA'
                        //     // });
                        //
                        //
                        //
                        //
                        //
                        //     // var orderItems=await DB('itemsOrder2').where('parent_id', '\$eq', '${widget.data!['_id']}').getRecords();
                        //     // for(var orderItem in  orderItems){
                        //     //   if(OrderItem.orderItemsList.containsKey(orderItem['_id'])){
                        //     //     // DB('order-itemss').where('id', '\$eq', '${orderItem['id']}').updateRecord(OrderItem.orderItemsList[orderItem['id']]);
                        //     //     DB('itemsOrder2').where('_id', '\$eq', '${orderItem['_id']}').updateRecord(OrderItem.orderItemsList[orderItem['_id']]);
                        //     //   }
                        //     //   else{
                        //     //     // DB('order-itemss').where('id', '\$eq', '${orderItem['id']}').deleteRecord();
                        //     //     DB('itemsOrder2').where('_id', '\$eq', '${orderItem['_id']}').deleteRecord();
                        //     //   }
                        //     // }
                        //
                        //     // MainController.goToTablePage();
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
      ),

    );
  }
}
