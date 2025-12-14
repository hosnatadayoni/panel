import 'package:finance/Admin/Logic/Controllers/AdminController.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/custom/Logic/Models/order-item.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/loading.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Views/Access/access-page.dart';
import 'package:finance/Admin/UI/Views/component-page.dart';
import 'package:finance/Admin/UI/Views/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../Logic/Controllers/connect-server-controller.dart';
import '../../../Views/Admin/admin-page.dart';
import '../../../Views/Role/role-page.dart';
import '../../../Views/Route/route-page.dart';
import '../../../Views/Route/table-route.dart';


class MenuBox extends StatefulWidget {
  MenuBox({Key? key}) : super(key: key);
  @override
  State<MenuBox> createState() => _MenuBoxState();
}

class _MenuBoxState extends State<MenuBox> {
  Rx<int> hoverItem = (-1).obs;
  Rx<bool> isHoverTheme = false.obs;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(() {
      return Stack(
        children: [
          Container(
            width: 50,
            color: MainController.isLightMode.value == false
                ? primary
                : primaryDark,
          ),
          Loading(
            loadingName: ['get-records'],
            getLoadedComponent: () => Positioned(
              // right: 50,
              right: Directionality.of(context) == TextDirection.rtl ? 50 : 0,
              left: Directionality.of(context) == TextDirection.ltr ? 50 : 0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < MainController.items.length; i++)
                      MainController.selectedItem == i &&
                              MainController.isClickedItem.value == true
                          ? Loading(
                              loadingName: ['list-schema'],
                              getLoadedComponent: () => Container(
                                width: 250,
                                height: size.height,
                                color: MainController.isLightMode.value == true
                                    ? background
                                    : whiteColor,
                                padding: EdgeInsets.only(
                                    right: 20, left: 10, top: 10, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    for (var j = 0;
                                        j < MainController.SubMenuList.length;
                                        j++)
                                      if (MainController.SubMenuList[j]
                                              ['schema']['main_menu'] ??
                                          true)
                                        Column(children: [
                                          InkWell(
                                              onTap: () async {
                                                MainController.selectedSubItem.value = j;
                                                DB.parentItem = {};
                                                MainController.tableName.value =
                                                MainController.SubMenuList[j]['schema']['name'];
                                                MainController.SubMenuList[j]['schema']['currentPage'] = 1;

                                                await MainController.goToTablePage(MainController.SubMenuList[j]);
                                              },
                                              child: Txt('${MainController.SubMenuList[j]['schema']['title']}', fontSize: 16, fontWeight: FontWeight.w400,
                                                color: MainController.isLightMode.value == true &&
                                                        MainController.selectedSubItem.value == j
                                                    ? itemColor8
                                                    : MainController.isLightMode.value == false &&
                                                            MainController.selectedSubItem.value == j
                                                        ? primary
                                                        : MainController
                                                                    .isLightMode
                                                                    .value ==
                                                                false
                                                            ? color1
                                                            : whiteColor,
                                              )),
                                          SizedBox(
                                            height: 20,
                                          )
                                        ]),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                  ]),
            ),
          ),
          AnimatedContainer(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      MainController.isClickedItem.value = false;
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.menu, color: whiteColor, size: 30),
                    )),
                SizedBox(
                  height: 20,
                ),
                for (var i = 0; i < MainController.items.length; i++)
                  Obx(() {
                    return Column(
                      children: [
                        Container(
                          width: size.width,
                          child: Stack(
                            children: [
                              MouseRegion(
                                  onEnter: (_) {
                                    hoverItem.value = i;
                                  },
                                  onExit: (_) {
                                    hoverItem.value = -1;
                                  },
                                  child: InkWell(
                                      onTap: () async {
                                        print('_MenuBoxState.build$i');
                                        MainController.selectedItem.value = i;
                                        if (MainController.selectedItem.value == 0) {
                                          Get.to(() => DashboardPage());
                                          MainController.isClickedItem.value =
                                              false;
                                        } else if (MainController.selectedItem.value == 1 ) {
                                          Get.to(() => ComponentPage());
                                          MainController.isClickedItem.value = false;
                                        }
                                        else if (MainController.selectedItem.value == 3 ) {
                                          await ConncetServerController.getRoute();
                                          Get.to(() => RoutePage());
                                          MainController.isClickedItem.value = false;
                                        }
                                        else if (MainController.selectedItem.value == 4 ) {
                                          await AdminController.getAccess();
                                          Get.to(() => AccessPage());
                                          MainController.isClickedItem.value = false;
                                        }
                                        else if (MainController.selectedItem.value == 5 ) {
                                          await AdminController.getRoles();

                                          Get.to(() => RolePage());
                                          MainController.isClickedItem.value = false;
                                        }  else if (MainController.selectedItem.value == 6 ) {
                                          await AdminController.getAdmins();

                                          Get.to(() => AdminPage());
                                          MainController.isClickedItem.value = false;
                                        }  else {
                                          MainController.isClickedItem.value = true;
                                          await MainController.loadJson();
                                        }
                                        MainController.itemSelected.value = MainController.items[MainController
                                            .selectedItem.value];
                                        // Get.to(() => TablePage());
                                        MainController.selectedSubItem.value =
                                            -1;
                                      },
                                      child: Container(
                                          width: 50,
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              left: 10,
                                              bottom: 10,
                                              right: 10),
                                          color: MainController
                                                      .selectedItem.value ==
                                                  i
                                              ? MainController
                                                          .isLightMode.value ==
                                                      false
                                                  ? whiteColor
                                                  : background
                                              : Colors.transparent,
                                          child: Center(
                                              child: Icon(
                                            MainController.items[i].icon,
                                            size: 30,
                                            color: MainController
                                                        .selectedItem.value ==
                                                    i
                                                ? MainController.isLightMode
                                                            .value ==
                                                        true
                                                    ? itemColor8
                                                    : primary
                                                : whiteColor,
                                          ))))),
                              hoverItem == i
                                  ? Positioned(
                                      // right:60,
                                      right: Directionality.of(context) ==
                                              TextDirection.rtl
                                          ? 60
                                          : null,
                                      left: Directionality.of(context) ==
                                              TextDirection.ltr
                                          ? 60
                                          : null,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: primary,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Txt(
                                          '${MainController.items[i].title}',
                                          color: whiteColor,
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }),
                Spacer(),
                if (MainController.isLightMode.value == false)
                  Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          MainController.isLightMode.value = true;
                        },
                        child: MouseRegion(
                          onEnter: (_) {
                            isHoverTheme.value = true;
                          },
                          onExit: (_) {
                            isHoverTheme.value = false;
                          },
                          child: Container(
                              width: 50,
                              padding: EdgeInsets.only(
                                  top: 10, left: 10, bottom: 10, right: 10),
                              child: Center(
                                  child: Icon(Icons.dark_mode,
                                      color: whiteColor))),
                        ),
                      ),
                      isHoverTheme.value == true
                          ? Positioned(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(
                                          right: Directionality.of(context) ==
                                                  TextDirection.rtl
                                              ? 70
                                              : 0,
                                          left: Directionality.of(context) ==
                                                  TextDirection.ltr
                                              ? 70
                                              : 0),
                                      decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Txt(
                                        'Theme',
                                        color: whiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                if (MainController.isLightMode.value == true)
                  Stack(children: [
                    InkWell(
                      onTap: () {
                        MainController.isLightMode.value = false;
                      },
                      child: MouseRegion(
                        onEnter: (_) {
                          isHoverTheme.value = true;
                        },
                        onExit: (_) {
                          isHoverTheme.value = false;
                        },
                        child: Container(
                            width: 50,
                            padding: EdgeInsets.only(
                                top: 10, left: 10, bottom: 10, right: 10),
                            child: Icon(Icons.light_mode, color: whiteColor)),
                      ),
                    ),
                    isHoverTheme.value == true
                        ? Positioned(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                        right: Directionality.of(context) ==
                                                TextDirection.rtl
                                            ? 70
                                            : 0,
                                        left: Directionality.of(context) ==
                                                TextDirection.ltr
                                            ? 70
                                            : 0),
                                    decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Txt(
                                      'Theme',
                                      color: whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container()
                  ]),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            duration: Duration(seconds: 1),
          )
        ],
      );
    });
  }
}
