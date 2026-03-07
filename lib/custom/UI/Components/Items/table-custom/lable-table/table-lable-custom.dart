import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/UI/Components/Views/lable-page-custom/lable-detail-page-custom/table-lable-detail-page-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:finance/Admin/Logic/Models/db.dart';

class TableLableBoxCustom extends StatefulWidget {
  TableLableBoxCustom();

  @override
  State<TableLableBoxCustom> createState() => _TableLableBoxCustomState();
}

class _TableLableBoxCustomState extends State<TableLableBoxCustom> {
  late ScrollController _scrollController;


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx((){
      return Container(
        color: MainController.isLightMode.value == true ? background : whiteColor,
        padding: EdgeInsets.all(15),
        width: size.width,
        child: Scrollbar(
          isAlwaysShown: true,
          thickness: 10,
          controller: _scrollController,
          trackVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Table(
              defaultColumnWidth: FixedColumnWidth(
                (150),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(
                color: MainController.isLightMode.value == true
                    ? whiteColor
                    : color1,
              ),
              children: [
                TableRow(
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Txt(
                          '#',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : color2,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Txt(
                          'کد ورودی',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : color2,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Txt(
                          'مشتری',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : color2,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Txt(
                          'تاریخ ورود',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : color2,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Txt(
                          'شماره نقشه',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : color2,
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Center(
                            child: Txt(
                                '${AppController.of(context)!.value('operation')}',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: MainController.isLightMode.value == true
                                    ? whiteColor
                                    : color2))),
                  ],
                ),
                if (MainController.dataRecord.length != 0)
                  for (var i = 0; i < MainController.dataRecord.length; i++)
                    TableRow(children: [
                      Obx(() {
                        return Center(
                          child: Txt(
                            '${i+1}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      Obx(() {
                        return Center(
                          child: Txt(
                            '${MainController.dataRecord.value[i]['Input_Code']}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      Obx(() {
                        final type = MainController.dataRecord.value[i]['Customer'];
                        return Center(
                          child: Txt(
                            '${type != null && type is Map && type['_id'] != null
                                ? type['Name_and_lastName']
                                : ''}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      Obx(() {
                        return Center(
                          child: Txt(
                            '${MainController.dataRecord.value[i]['Date']}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      Obx(() {
                        return Center(
                          child: Txt(
                            '${MainController.dataRecord.value[i]['Drawing_Number']}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      InkWell(
                        onTap: () async {
                          await Get.to(() => TablePageLableDetailCustom(MainController.dataRecord.value[i]['_id']));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: notCheckedOutBtnColor,
                              ),
                              child: Txt('جزییات' , color: whiteColor,),
                            ),
                          ),
                        ),
                      )
                    ])
              ],
            ),
          ),
        ),
      );
    });
  }
}
