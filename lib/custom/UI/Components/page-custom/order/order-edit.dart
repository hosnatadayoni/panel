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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:uuid/uuid.dart';
import '../../../../../Admin/Logic/Controllers/record-controller.dart';
import '../../../../../Admin/Logic/Models/dataModel.dart';
import '../../../../../Admin/UI/Componenets/Popups/snackbar.dart';

class OrderEditPge extends StatefulWidget {
  final dynamic data;
  final List<dynamic> customerItems;
  final List<dynamic> productItems;
  final List<dynamic> orderDetailItems;

  OrderEditPge(this.customerItems, this.productItems, this.orderDetailItems,
      {this.data});

  @override
  State<OrderEditPge> createState() => _OrderEditPgeState();
}

class _OrderEditPgeState extends State<OrderEditPge> {
  Rx<Widget> _future = Column().obs;

  @override
  void initState() {
    super.initState();
    _loadWidgets();
    RawKeyboard.instance.addListener(_handleKey);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKey);
    super.dispose();
  }

  void _handleKey(RawKeyEvent event) async {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.f1) {
        ViewController.isClickedEditBtn.value = true;
        HelperController.editFunction('Orders',
            id: '${widget.data!['_id']}', request: widget.data);
      }
      if (event.logicalKey == LogicalKeyboardKey.f4) {
        var Id = Uuid().v4();
        DataModel newData =
        DataModel(id: Id, data: widget.data);

        bool validate = await RecordController.validate(
            'Orders', newData, MainController.getInfoTable('Orders'));
        if (validate == false) {
          ViewCustomController.addEditContainer(context, widget.productItems);
        } else {
          showSnackbar(snackTypes.error, 'لطفا آیتم های سفارش را تکمیل کنید...');
        }
      }
    }
  }

  _loadWidgets() async {
    Future.delayed(Duration.zero, () async {
      _future.value = await ViewCustomController.getOrderItems(widget.data);
    });
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
          color: MainController.isLightMode.value == true
              ? darkBackground
              : backgroundLight,
        ),
        child: Stack(
          children: [
            Obx(() {
              return Positioned(
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
                  width: size.width > 800
                      ? MainController.isClickedItem.value == true
                      ? (size.width) - 300
                      : (size.width) - 50
                      : (size.width) - 50,
                  height: size.height,
                  padding: EdgeInsets.all(15),
                  color: MainController.isLightMode.value == false
                      ? color6
                      : color9,
                  child: ColumnScroll(
                    children: [
                      SizedBox(height: 80),
                      Column(
                        children: [
                          FormEditOrderCustom(
                              data: widget.data, widget.customerItems),
                          SizedBox(height: 20),
                          Container(child: _future.value),
                        ],
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
