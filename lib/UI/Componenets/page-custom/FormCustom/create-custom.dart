import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/UI/Componenets/page-custom/order/form-create-order-custom.dart';
import 'package:finance/UI/Componenets/page-custom/orderItem/form-create-orderItem-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateCustom extends StatelessWidget {
  const CreateCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainController.SubMenuList[MainController.selectedSubItem.value]['view'] == 'order' ? Column(
      children: [
        FormCreateOrderCustom(),
        SizedBox(height: 20,),
        FormCreateOrderItemCustom(),
      ],
    ) : FormCreateOrderItemCustom();
  }
}
