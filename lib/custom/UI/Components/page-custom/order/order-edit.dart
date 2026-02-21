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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OrderEditPge extends StatefulWidget {
  final dynamic data;
  final List<dynamic> customerItems;
  final List<dynamic> productItems;

  OrderEditPge(this.customerItems, this.productItems, {this.data});

  @override
  State<OrderEditPge> createState() => _OrderEditPgeState();
}

class F1Intent extends Intent {
  const F1Intent();
}

class F4Intent extends Intent {
  const F4Intent();
}

class _OrderEditPgeState extends State<OrderEditPge> {
  Rx<Widget> _future = Column().obs;

  @override
  void initState() {
    super.initState();
    _loadWidgets();
  }

  Future<void> _handleF4(BuildContext context) async {
    await ViewCustomController.checkEditOrder(context, widget.productItems,
        data: widget.data);
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
                  color: MainController.isLightMode.value == false
                      ? color6
                      : color9,
                  child: ColumnScroll(
                    children: [
                      const SizedBox(height: 80),
                      Shortcuts(
                        shortcuts: <LogicalKeySet, Intent>{
                          LogicalKeySet(LogicalKeyboardKey.f1): const F1Intent(),
                          LogicalKeySet(LogicalKeyboardKey.f4): const F4Intent(),
                        },
                        child: Actions(
                          actions: {
                            F1Intent: CallbackAction<F1Intent>(
                              onInvoke: (intent) async {
                                FocusManager.instance.primaryFocus
                                    ?.unfocus();
                                await Future.delayed(
                                    const Duration(milliseconds: 50));
                                ViewController.isClickedEditBtn.value =
                                true;
                                HelperController.editFunction('Orders',
                                    id: '${widget.data!['_id']}',
                                    request: widget.data!);
                                return null;
                              },
                            ),
                            F4Intent: CallbackAction<F4Intent>(
                              onInvoke: (intent) {
                                _handleF4(context);
                                return null;
                              },
                            ),
                          },
                          child: FocusScope(
                            autofocus: true,
                            child: Column(
                              children: [
                                FormEditOrderCustom(
                                    data: widget.data,
                                    widget.customerItems),
                                const SizedBox(height: 20),
                                Container(child: _future.value),
                              ],
                            ),
                          ),
                        ),
                      )
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
