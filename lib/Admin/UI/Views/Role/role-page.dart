import 'package:finance/Admin/Logic/Models/ServerModel/route.dart';
import 'package:finance/Admin/UI/Views/Role/table-role.dart';
import 'package:finance/Admin/UI/Views/Route/table-route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Logic/Controllers/main-controller.dart';
import '../../../Public/styles.dart';
import '../../Componenets/Items/Header/header.dart';
import '../../Componenets/Items/Menu/menu.dart';

class RolePage extends StatelessWidget {
  RouteModel route=new RouteModel();
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
                  TableRole()
                ],
              ),
            );
          })
      ),
    );
  }
}
