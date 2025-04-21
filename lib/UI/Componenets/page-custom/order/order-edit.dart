import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/dataController.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Models/order-item.dart';
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
                  // color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
                  color: MainController.isLightMode.value == false ? color6 :color9,
                  child:  ColumnScroll(
                    children: [
                      SizedBox(height: 80,),
                      Column(
                        children: [
                          FormEditOrderCustom(data: widget.data),
                          SizedBox(height: 20,),
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

Future<Widget> getOrderItems(var data) async {
  List<dynamic>items=await DB('order-itemss').where("سفارش", '==', "${data.id}").getRecords();
  for(var item in items){
    OrderItem.orderItemsList[item['id']]=item;
  }
  return Column(
    children: [
        FormEditOrderItemCustom()
    ],
  );
}