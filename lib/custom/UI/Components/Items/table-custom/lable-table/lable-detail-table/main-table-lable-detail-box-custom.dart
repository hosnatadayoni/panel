import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-footer.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/lable-table/lable-detail-table/table-lable-detail-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/lable-table/table-lable-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/order-table/table-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:get/get.dart';

class MainTableLableDetailBoxCustom extends StatefulWidget {
  MainTableLableDetailBoxCustom(this.index);
  int index;

  @override
  State<MainTableLableDetailBoxCustom> createState() => _MainTableLableDetailBoxCustomState();
}

class _MainTableLableDetailBoxCustomState extends State<MainTableLableDetailBoxCustom> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MainController.isLightMode.value == true
              ? background
              : whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
              color: MainController.isLightMode.value == true
                  ? background
                  : dark2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return ColumnScroll(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Txt('لیست سفارش ها' , color: MainController.isLightMode.value == true
                    ? whiteColor
                    : dark2),
                  ],
                ),
                SizedBox(height: 20,),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor:
                              MainController.isLightMode.value
                                  ? whiteColor
                                  : primaryDark,
                            ),
                            child: Checkbox(
                              value: false,
                              onChanged: (val) async {
                              },
                              activeColor: colorBtn,
                              checkColor: whiteColor,
                              side: BorderSide(
                                  color:
                                  MainController.isLightMode.value
                                      ? whiteColor
                                      : primaryDark,
                                  width: 2),
                              // border
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () async {
                            },
                            child: Txt(
                              'همه موارد',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: MainController.isLightMode.value
                                  ? whiteColor
                                  : color2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10,),
                      Row(
                        children: [
                          Txt(
                            'از',
                            fontSize: 14,
                            color: MainController.isLightMode.value ? whiteColor : color2,
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: MainController.isLightMode.value ? whiteColor : primaryDark,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                    });
                                  },
                                  child: Icon(Icons.arrow_drop_up,
                                      size: 20,
                                      color: MainController.isLightMode.value ? whiteColor : primaryDark),
                                ),
                                Txt(
                                  '',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: MainController.isLightMode.value ? whiteColor : color2,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                    });
                                  },
                                  child: Icon(Icons.arrow_drop_down,
                                      size: 20,
                                      color: MainController.isLightMode.value ? whiteColor : primaryDark),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Txt(
                            'تا',
                            fontSize: 14,
                            color: MainController.isLightMode.value ? whiteColor : color2,
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: MainController.isLightMode.value ? whiteColor : primaryDark,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {

                                    });
                                  },
                                  child: Icon(Icons.arrow_drop_up,
                                      size: 20,
                                      color: MainController.isLightMode.value ? whiteColor : primaryDark),
                                ),
                                Txt(
                                  '',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: MainController.isLightMode.value ? whiteColor : color2,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                    });
                                  },
                                  child: Icon(Icons.arrow_drop_down,
                                      size: 20,
                                      color: MainController.isLightMode.value ? whiteColor : primaryDark),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                TableHeader(),
                if(MainController.tableName.value == 'lable')
                  TableLableDetailBoxCustom(widget.index),
                SizedBox(
                  height: 20,
                ),
                TableFooter(index: MainController.menuList.value.indexWhere((element) => element.schema.name=="Order_Details")),
              ],
            );
          }),
        ],
      ),
    );
  }
}
