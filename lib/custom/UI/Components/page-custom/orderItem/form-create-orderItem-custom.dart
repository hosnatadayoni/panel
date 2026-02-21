import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-footer.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-header.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/custom/Logic/Models/order-item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import '../../../../../Admin/Logic/Controllers/record-controller.dart';
import '../../../../../Admin/Logic/Models/dataModel.dart';
import '../../../../../Admin/Logic/Models/db.dart';
import '../../../../../Admin/UI/Componenets/Popups/snackbar.dart';

class FormCreateOrderItemCustom extends StatefulWidget {
  List<dynamic> productItems;

  FormCreateOrderItemCustom(this.productItems);

  @override
  State<FormCreateOrderItemCustom> createState() =>
      _FormCreateOrderItemCustomState();
}

class _FormCreateOrderItemCustomState extends State<FormCreateOrderItemCustom> {
  void initState() {
    super.initState();
  }

  // Map<String, Widget> containers = {};

  // void _addContainer() {
  //   setState(() {
  //     var Id = Uuid().v4();
  //     String newKey = Id;
  //     containers[newKey] = buildContainer(newKey);
  //     OrderItem.orderItemsList[newKey] = {...ViewCustomController.orderItem};
  //   });
  // }
  // void _removeContainer(String key) {
  //   setState(() {
  //     containers.remove(key);
  //     OrderItem.orderItemsList.remove(key);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      autofocus: true,
      child: Column(
        children: [
          if (MainController.selectedSubItem.value != -1)
            // if(MainController.SubMenuList[MainController.selectedSubItem.value]['table-name'] != 'Orders')
            if (MainController.infoSchema.value.schema.name != 'Orders')
              SizedBox(
                height: 20,
              ),
          Obx(() {
            return Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: MainController.isLightMode.value == true
                          ? whiteColor
                          : primaryDark),
                  borderRadius: BorderRadius.circular(10)),
              child: ColumnScroll(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Txt('لیست سفارش ها',
                        color: MainController.isLightMode.value == true
                            ? whiteColor
                            : primaryDark)
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: ViewCustomController.isShowAlert.value
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.end,
                    children: [
                      if (ViewCustomController.isShowAlert.value)
                        Txt(
                          'میزان سفارش از سقف مجاز مشتری بیشتر است',
                          color: errorColor,
                          fontSize: 16,
                        ),
                      InkWell(
                        onTap: () async {
                          await ViewCustomController.checkOrder(
                              context, widget.productItems);
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              right: 20, left: 20, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.orange,
                          ),
                          child: Center(
                              child: Txt(
                                  '${AppController.of(context)!.value('surcharge')} (F4)')),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      children: [
                        for (var container
                            in ViewCustomController.containers.entries)
                          ViewCustomController
                              .containers.value['${container.key}']!,
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}
