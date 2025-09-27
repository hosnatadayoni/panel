import 'package:finance/Admin/UI/Views/Admin/table-admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Logic/Controllers/main-controller.dart';
import '../../../Public/styles.dart';
import '../../Componenets/Items/Header/header.dart';
import '../../Componenets/Items/Menu/menu.dart';

class AdminPage extends StatelessWidget {
  // AdminModel route=new AdminModel();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: Obx((){
            return Container(
              width: size.width,
              height: size.height,
              color: MainController.isLightMode.value == false ? primary :primaryDark,
              child: Stack(
                children: [
                  Header(),
                  MenuBox(),
                  TableAdmin()
                ],
              ),
            );
          })
      ),
    );
  }
}
