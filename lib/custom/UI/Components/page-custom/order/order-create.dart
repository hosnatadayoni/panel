import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/record-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/dataModel.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../../../Admin/UI/Componenets/General/column-scroll.dart';
import '../../../../Logic/Models/order-item.dart';
import 'form-create-order-custom.dart';
import '../orderItem/form-create-orderItem-custom.dart';

class OrderCreatePage extends StatefulWidget {
  final String tableName;
  final List<dynamic> customerItems;
  final List<dynamic> productItems;
  OrderCreatePage(this.tableName, this.customerItems, this.productItems);

  @override
  State<OrderCreatePage> createState() => _OrderCreatePageState();
}
class F1Intent extends Intent {
  const F1Intent();
}

class F4Intent extends Intent {
  const F4Intent();
}
class _OrderCreatePageState extends State<OrderCreatePage> {
  Rx<bool> isHoverBtnBack = false.obs;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  Future<void> _handleF4(BuildContext context) async {
    await ViewCustomController.checkOrder(context, widget.productItems);
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
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Txt(
                                  '${AppController.of(context)!.value('add')}',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: MainController.isLightMode.value == true
                                      ? whiteColor
                                      : primaryDark,
                                ),
                                SizedBox(width: 5),
                                Txt(
                                  '${MainController.infoSchema.value.schema.title}',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: MainController.isLightMode.value == true
                                      ? whiteColor
                                      : primaryDark,
                                ),
                              ],
                            ),
                            Obx(() {
                              return Row(
                                children: [
                                  MouseRegion(
                                    onEnter: (_) {
                                      isHoverBtnBack.value = true;
                                    },
                                    onExit: (_) {
                                      isHoverBtnBack.value = false;
                                    },
                                    child: InkWell(
                                      onTap: () {
                                        HelperController.goToTablePage(
                                            MainController.menuList[
                                            MainController
                                                .selectedSubItem.value]);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          border:
                                          Border.all(color: colorBtn, width: 1),
                                          color: isHoverBtnBack.value == false
                                              ? Colors.transparent
                                              : colorBtn,
                                        ),
                                        child: Txt(
                                          '${AppController.of(context)!.value('back')}',
                                          color: isHoverBtnBack.value == false
                                              ? colorBtn
                                              : whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  MouseRegion(
                                    onEnter: (_) {},
                                    onExit: (_) {},
                                    child: InkWell(
                                      onTap: () async {
                                        ViewController.isClickedBtn.value = true;
                                        HelperController.createFunction(widget.tableName);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: colorBtn,
                                        ),
                                        child: Txt(
                                          '${AppController.of(context)!.value('save')} (F1)',
                                          color: whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                      Shortcuts(
                        shortcuts: <LogicalKeySet, Intent>{
                          LogicalKeySet(LogicalKeyboardKey.f1): const F1Intent(),
                          LogicalKeySet(LogicalKeyboardKey.f4): const F4Intent(),
                        },
                        child: Actions(
                          actions:{
                            F1Intent: CallbackAction<F1Intent>(
                              onInvoke: (intent) async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                await Future.delayed(const Duration(milliseconds: 50));
                                ViewController.isClickedBtn.value = true;
                                HelperController.createFunction('Orders');
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
                                FormCreateOrderCustom(widget.customerItems),
                                const SizedBox(height: 20),
                                FormCreateOrderItemCustom(widget.productItems),
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
//
// class _OrderCreatePageState extends State<OrderCreatePage> {
//   Rx<bool> isHoverBtnBack = false.obs;
//
//   @override
//   void initState() {
//     super.initState();
//     print('OrderItem.orderItemsList order create>>>${OrderItem.orderItemsList}');
//     RawKeyboard.instance.addListener(_handleKey);
//   }
//
//   @override
//   void dispose() {
//     RawKeyboard.instance.removeListener(_handleKey);
//     super.dispose();
//   }
//
//   void _handleKey(RawKeyEvent event) {
//     print('F4 pressed');
//     if (event is RawKeyDownEvent) {
//       if (event.logicalKey == LogicalKeyboardKey.f1) {
//         ViewController.isClickedBtn.value = true;
//         HelperController.createFunction('Orders');
//       }
//
//       if (event.logicalKey == LogicalKeyboardKey.f4) {
//         _handleF4(context);
//       }
//     }
//   }
//
//   Future<void> _handleF4(BuildContext context) async {
//     print("handle f4:${OrderItem.orderItemsList.value}");
//     print('ViewCustomController.containers by click f4>>>${ViewCustomController.containers.value}');
//     await ViewCustomController.checkOrder(context, widget.productItems);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: Container(
//         width: size.width,
//         height: size.height,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: MainController.isLightMode.value == true
//               ? darkBackground
//               : backgroundLight,
//         ),
//         child: Stack(
//           children: [
//             Obx(() {
//               return Positioned(
//                 right: Directionality.of(context) == TextDirection.rtl
//                     ? size.width > 800
//                     ? MainController.isClickedItem.value == true
//                     ? 300
//                     : 50
//                     : 50
//                     : 0,
//                 left: Directionality.of(context) == TextDirection.ltr
//                     ? size.width > 800
//                     ? MainController.isClickedItem.value == true
//                     ? 300
//                     : 50
//                     : 50
//                     : 0,
//                 child: Container(
//                   width: size.width > 800
//                       ? MainController.isClickedItem.value == true
//                       ? (size.width) - 300
//                       : (size.width) - 50
//                       : (size.width) - 50,
//                   height: size.height,
//                   color: MainController.isLightMode.value == false
//                       ? color6
//                       : color9,
//                   child: ColumnScroll(
//                     children: [
//                       SizedBox(height: 80),
//                       Container(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Txt(
//                                   '${AppController.of(context)!.value('add')}',
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.w500,
//                                   color: MainController.isLightMode.value == true
//                                       ? whiteColor
//                                       : primaryDark,
//                                 ),
//                                 SizedBox(width: 5),
//                                 Txt(
//                                   '${MainController.tableInfo['schema']['title']}',
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.w500,
//                                   color: MainController.isLightMode.value == true
//                                       ? whiteColor
//                                       : primaryDark,
//                                 ),
//                               ],
//                             ),
//                             Obx(() {
//                               return Row(
//                                 children: [
//                                   MouseRegion(
//                                     onEnter: (_) {
//                                       isHoverBtnBack.value = true;
//                                     },
//                                     onExit: (_) {
//                                       isHoverBtnBack.value = false;
//                                     },
//                                     child: InkWell(
//                                       onTap: () {
//                                         MainController.goToTablePage(
//                                             MainController.SubMenuList[
//                                             MainController
//                                                 .selectedSubItem.value]);
//                                       },
//                                       child: Container(
//                                         padding: EdgeInsets.all(10),
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10)),
//                                           border:
//                                           Border.all(color: colorBtn, width: 1),
//                                           color: isHoverBtnBack.value == false
//                                               ? Colors.transparent
//                                               : colorBtn,
//                                         ),
//                                         child: Txt(
//                                           '${AppController.of(context)!.value('back')}',
//                                           color: isHoverBtnBack.value == false
//                                               ? colorBtn
//                                               : whiteColor,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w400,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 5),
//                                   MouseRegion(
//                                     onEnter: (_) {},
//                                     onExit: (_) {},
//                                     child: InkWell(
//                                       onTap: () async {
//                                         ViewController.isClickedBtn.value = true;
//                                         HelperController.createFunction(widget.tableName);
//                                       },
//                                       child: Container(
//                                         padding: EdgeInsets.all(10),
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10)),
//                                           color: colorBtn,
//                                         ),
//                                         child: Txt(
//                                           '${AppController.of(context)!.value('save')} (F1)',
//                                           color: whiteColor,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w400,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Column(
//                         children: [
//                           FormCreateOrderCustom(widget.customerItems),
//                           SizedBox(height: 20),
//                           FormCreateOrderItemCustom(widget.productItems),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             }),
//             Header(),
//             MenuBox(),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class _OrderCreatePageState extends State<OrderCreatePage> {
//   Rx<bool> isHoverBtnBack = false.obs;
//
//   @override
//   void initState() {
//     super.initState();
//     print('OrderItem.orderItemsList order create>>>${OrderItem.orderItemsList}');
//   }
//
//   Future<void> _handleF4(BuildContext context) async {
//     print("handle f4:${OrderItem.orderItemsList.value}");
//     print('ViewCustomController.containers by click f4>>>${ViewCustomController.containers.value}');
//     await ViewCustomController.checkOrder(context, widget.productItems);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//
//     return Shortcuts(
//       shortcuts: <LogicalKeySet, Intent>{
//         LogicalKeySet(LogicalKeyboardKey.f1): const ActivateIntent(),
//         LogicalKeySet(LogicalKeyboardKey.f4): const Intent(1),
//       },
//       child: Actions(
//         actions: <Type, Action<Intent>>{
//           ActivateIntent: CallbackAction<Intent>(
//             onInvoke: (intent) {
//               // F1
//               ViewController.isClickedBtn.value = true;
//               HelperController.createFunction('Orders');
//               return null;
//             },
//           ),
//           Intent: CallbackAction<Intent>(
//             onInvoke: (intent) {
//               // F4
//               print('F4 pressed');
//               _handleF4(context);
//               return null;
//             },
//           ),
//         },
//         child: Focus(
//           autofocus: true,
//           child: Scaffold(
//             body: Container(
//               width: size.width,
//               height: size.height,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: MainController.isLightMode.value == true
//                     ? darkBackground
//                     : backgroundLight,
//               ),
//               child: Stack(
//                 children: [
//                   Obx(() {
//                     return Positioned(
//                       right: Directionality.of(context) == TextDirection.rtl
//                           ? size.width > 800
//                           ? MainController.isClickedItem.value == true
//                           ? 300
//                           : 50
//                           : 50
//                           : 0,
//                       left: Directionality.of(context) == TextDirection.ltr
//                           ? size.width > 800
//                           ? MainController.isClickedItem.value == true
//                           ? 300
//                           : 50
//                           : 50
//                           : 0,
//                       child: Container(
//                         width: size.width > 800
//                             ? MainController.isClickedItem.value == true
//                             ? (size.width) - 300
//                             : (size.width) - 50
//                             : (size.width) - 50,
//                         height: size.height,
//                         color: MainController.isLightMode.value == false
//                             ? color6
//                             : color9,
//                         child: ColumnScroll(
//                           children: [
//                             const SizedBox(height: 80),
//                             // 🔽 بقیه UI دقیقاً همان کد قبلی شماست
//                             Column(
//                               children: [
//                                 FormCreateOrderCustom(widget.customerItems),
//                                 const SizedBox(height: 20),
//                                 FormCreateOrderItemCustom(widget.productItems),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//                   Header(),
//                   MenuBox(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


