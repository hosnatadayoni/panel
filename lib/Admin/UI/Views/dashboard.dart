import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Public/images.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/img.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Dashboard/bar-chart.dart';
import 'package:finance/Admin/UI/Componenets/Items/Dashboard/line-chart2.dart';
import 'package:finance/Admin/UI/Componenets/Items/Dashboard/dashboard-box.dart';
import 'package:finance/Admin/UI/Componenets/Items/Dashboard/dashboard-info.dart';
import 'package:finance/Admin/UI/Componenets/Items/Dashboard/dashboard-info2.dart';
import 'package:finance/Admin/UI/Componenets/Items/Dashboard/dashboard-info3.dart';
import 'package:finance/Admin/UI/Componenets/Items/Dashboard/line-chart.dart';
import 'package:finance/Admin/UI/Componenets/Items/Dashboard/main-pie-chart.dart';
import 'package:finance/Admin/UI/Componenets/Items/Dashboard/main-bar-chart.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/Admin/UI/Componenets/accordion.dart';
import 'package:finance/Admin/UI/Componenets/alert.dart';
import 'package:finance/Admin/UI/Componenets/badge.dart';
import 'package:finance/Admin/UI/Componenets/breadCrumb.dart';
import 'package:finance/Admin/UI/Componenets/btn-group/btn-group-item.dart';
import 'package:finance/Admin/UI/Componenets/btn-group/btn-group.dart';
import 'package:finance/Admin/UI/Componenets/card.dart';
import 'package:finance/Admin/UI/Componenets/carousel-slider.dart';
import 'package:finance/Admin/UI/Componenets/close-btn.dart';
import 'package:finance/Admin/UI/Componenets/collapse.dart';
import 'package:finance/Admin/UI/Componenets/dropDown/drop-down-item.dart';
import 'package:finance/Admin/UI/Componenets/dropDown/drop-down.dart';
import 'package:finance/Admin/UI/Componenets/form.dart';
import 'package:finance/Admin/UI/Componenets/modal.dart';
import 'package:finance/Admin/UI/Componenets/placeholder/btn-placeholder.dart';
import 'package:finance/Admin/UI/Componenets/placeholder/content-placeholder.dart';
import 'package:finance/Admin/UI/Componenets/placeholder/img-placeholder.dart';
import 'package:finance/Admin/UI/Componenets/popOvers.dart';
import 'package:finance/Admin/UI/Componenets/progress/progress-item.dart';
import 'package:finance/Admin/UI/Componenets/progress/progress.dart';
import 'package:finance/Admin/UI/Componenets/spinner.dart';
import 'package:finance/Admin/UI/Views/test-component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../Componenets/btn.dart';
import '../Componenets/dissmisiable-alert.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: Obx((){
          return Container(
            width: size.width,
            color: MainController.isLightMode.value == false ? color6 :color9,
            child: Stack(
              children: [
                Header(),
                SizedBox(height: 20,),
                Positioned(
                  // right: size.width > 800 ? MainController.isClickedItem.value == true ? 320 : 50 : 50,

                  right: Directionality.of(context) == TextDirection.rtl ? size.width > 800 ? MainController.isClickedItem.value == true ? 320 : 50 : 50 : 0,
                  left: Directionality.of(context) == TextDirection.ltr ? size.width > 800 ? MainController.isClickedItem.value == true ? 320 : 50 : 50 : 0,
                  top: 100,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: size.width > 800
                        ? MainController.isClickedItem.value == true
                        ? (size.width) - 350
                        : (size.width) - 50
                        : (size.width) - 50,
                    height: size.height,

                    child: ColumnScroll(
                      children: [
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width,
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              alignment: WrapAlignment.start,
                              children: [
                                DashboardBox(icon: Icons.supervised_user_circle_outlined, count: 21, text: '${AppController.of(context)!.value('canceled orders')}', index: 0),
                                DashboardBox(icon: Icons.shield_moon_rounded, count: 0, text: '${AppController.of(context)!.value('unverified drivers')}', index: 1),
                                DashboardBox(icon: Icons.supervised_user_circle_sharp, count: 118, text: '${AppController.of(context)!.value('number of users')}', index: 2),
                              ],
                            ),
                          ),
                        ],
                      ),]
                    ),
                  ),
                ),
                MenuBox(),
              ],
            ),
          );
        })
    );
  }
}
