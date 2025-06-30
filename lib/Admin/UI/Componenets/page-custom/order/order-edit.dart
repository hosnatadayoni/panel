import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/dataController.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/Admin/Logic/Models/order-item.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/Admin/UI/Componenets/page-custom/order/form-edit-order-custom.dart';
import 'package:finance/Admin/UI/Componenets/page-custom/orderItem/form-edit-orderItem-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finance/Admin/Logic/Models/db.dart';

class OrderEdit extends StatefulWidget {
  OrderEdit({this.data});
  var data;

  @override
  State<OrderEdit> createState() => _OrderEditState();
}

class _OrderEditState extends State<OrderEdit> {
  Rx<Widget> _future= Rx<Widget>(Container());
  Rx<Widget> _future2= Rx<Widget>(Container());

  f()async{
    _future.value =await ViewCustomController.generateEditFormOrderView(widget.data);
    _future2.value =await ViewCustomController.getOrderItems(widget.data);
  }
  @override
  void initState() {
    super.initState();
    f();
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
                  // color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
                  color: MainController.isLightMode.value == false ? color6 :color9,
                  child:  ColumnScroll(
                    children: [
                      SizedBox(height: 80,),
                      // Obx((){
                      //   return  Column(
                      //     children: [
                      //       _future.value,
                      //       SizedBox(height: 20,),
                      //       _future2.value,
                      //       // FormEditOrderCustom(data: widget.data),
                      //       // SizedBox(height: 20,),
                      //
                      //       // FutureBuilder<Widget>(
                      //       //   future:_future!,
                      //       //   builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      //       //     print('_OrderEditState.build>>_future2');
                      //       //
                      //       //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       //
                      //       //       return CircularProgressIndicator();
                      //       //     } else if (snapshot.hasError) {
                      //       //       return Txt('${AppController.of(context)!.value('error')}: ${snapshot.requireData}');
                      //       //     } else {
                      //       //       return Container(color:Colors.red,child:snapshot.data) ?? Container();
                      //       //     }
                      //       //   },
                      //       // ),
                      //       // FutureBuilder<Widget>(
                      //       //   future:_future2,
                      //       //   builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      //       //     print('_OrderEditState.build>>_future');
                      //       //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       //       return CircularProgressIndicator();
                      //       //     } else if (snapshot.hasError) {
                      //       //       return Txt('${AppController.of(context)!.value('error')}: ${snapshot.requireData}');
                      //       //     } else {
                      //       //       return Container(color:Colors.blue,child:snapshot.data) ?? Container();
                      //       //     }
                      //       //   },
                      //       // ),
                      //     ],
                      //   );
                      // }),

                      InkWell(
                        onTap: ()async{
                          // await DB('order3').parent().where('_id', '\$eq', '${widget.data!['_id']}').
                          // updateRecord({
                          //   'price':900000 , 'type' : ['2'] , 'checkBox' : false , 'radiobutton' : '2'
                          // });
                          print('flsawws>>>${await DB('order3').parent().getRecords()}');
                          await DB('order3').parent().where('_id', '\$eq', 'c4326285-c0cd-4da0-893b-b77fce7fb291').
                          updateRecord({
                            'price':20000000 , 'type' : ['2'] , 'checkBox' : false , 'radiobutton' : '2'
                          });
                          print('getRecord sample table>>>${await DB('sample').getRecords()}');
                          await DB('order3').parent().where('price', '\$gte', 50000).
                          updateRecord({
                            'type' : ['1' , '2'] , 'sampleSelect':'09405051-de7f-4175-9197-730a0613c9e8'
                          });

                          await DB('order3').parent().where('price', '\$lte', 50000).
                          updateRecord({
                           'sampleSelect':''
                          });

                          print('dsajklddwsww>>>${await DB('itemsOrder2').parent(parentId: '328c5ec1-c3e7-4d6c-8ae5-547482ec05a4', parentTable: 'order3').getRecords()}');
                          // // await DB('itemsOrder2').parent(parentId: '${widget.data!['parent_id']}', parentTable: 'order3').
                          // // where('_id', '\$eq', '852e1903-e27d-485f-8967-fdfc1c47785b').updateRecord({
                          // //   'title': 'order item 3'
                          // // });
                          await DB('itemsOrder2').parent(parentId: '328c5ec1-c3e7-4d6c-8ae5-547482ec05a4', parentTable: 'order3').
                          where('_id', '\$eq', '73604568-da1b-494e-b4ea-a835d4dd8df7').updateRecord({
                            'title': 'new order item 2'
                          });
                          await DB('itemsOrder2').parent(parentId: 'c4326285-c0cd-4da0-893b-b77fce7fb291', parentTable: 'order3').
                          where('title', '\$eq', 'order item 2 - 2').updateRecord({
                            'description': 'BBBBBBBB'
                          });

                          await DB('itemsOrder2').parent(parentId: '328c5ec1-c3e7-4d6c-8ae5-547482ec05a4', parentTable: 'order3').
                          where('title', '\$eq', 'new order item 1').updateRecord({
                            'description': 'AAAAAA'
                          });





                          // var orderItems=await DB('itemsOrder2').where('parent_id', '\$eq', '${widget.data!['_id']}').getRecords();
                          // for(var orderItem in  orderItems){
                          //   if(OrderItem.orderItemsList.containsKey(orderItem['_id'])){
                          //     // DB('order-itemss').where('id', '\$eq', '${orderItem['id']}').updateRecord(OrderItem.orderItemsList[orderItem['id']]);
                          //     DB('itemsOrder2').where('_id', '\$eq', '${orderItem['_id']}').updateRecord(OrderItem.orderItemsList[orderItem['_id']]);
                          //   }
                          //   else{
                          //     // DB('order-itemss').where('id', '\$eq', '${orderItem['id']}').deleteRecord();
                          //     DB('itemsOrder2').where('_id', '\$eq', '${orderItem['_id']}').deleteRecord();
                          //   }
                          // }

                          // MainController.goToTablePage();
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

