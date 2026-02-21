import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Logic/Controllers/app-controller.dart';
import '../../../Logic/Controllers/helper-controller.dart';
import '../../../Logic/Controllers/main-controller.dart';
import '../../../Public/styles.dart';
import '../General/txt.dart';
class HeaderCreate extends StatelessWidget {
  String tableName;
  HeaderCreate(this.tableName);
  Rx<bool> isHoverBtnBack = false.obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Txt(
                '${AppController.of(context)!.value('add')}',
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color:
                MainController.isLightMode.value ==
                    true
                    ? whiteColor
                    : primaryDark,
              ),
              SizedBox(
                width: 5,
              ),
              Txt(
                '${MainController.infoSchema.value.schema.title != null ? MainController.infoSchema.value.schema.title : ''}',
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color:
                MainController.isLightMode.value ==
                    true
                    ? whiteColor
                    : primaryDark,
              ),
            ],
          ),
          // if(MainController.menuList[MainController.selectedSubItem.value]['view'] != 'custom')
          Obx(() {
            return Row(
              children: [
                Row(
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
                              MainController
                                  .menuList[
                              MainController
                                  .selectedSubItem
                                  .value]);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    10)),
                            border: Border.all(
                                color: colorBtn,
                                width: 1),
                            color:
                            isHoverBtnBack.value ==
                                false
                                ? Colors.transparent
                                : colorBtn,
                          ),
                          child: Txt(
                            '${AppController.of(context)!.value('back')}',
                            color:
                            isHoverBtnBack.value ==
                                false
                                ? colorBtn
                                : whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    MouseRegion(
                      onEnter: (_) {},
                      onExit: (_) {},
                      child: InkWell(
                        onTap: () async {
                          HelperController.createFunction(this.tableName);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
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
                )
              ],
            );
          }),
        ],
      ),
    );
  }
}
