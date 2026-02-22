import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:finance/Admin/Logic/Models/db.dart';

class TableBoxCustom extends StatefulWidget {
  TableBoxCustom(this.table);
  var table;

  @override
  State<TableBoxCustom> createState() => _TableBoxCustomState();
}

class _TableBoxCustomState extends State<TableBoxCustom> {
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
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Txt(
                          'شماره نقشه(مشتری)',
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
                          'نوع',
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
                          'تعداد جام',
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
                          'متراژ',
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
                          'عکس',
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
                      Obx(() {
                        return Center(
                          child: Txt(
                            '${MainController.dataRecord.value[i]['Drawing_Number(customer)'] != null ? MainController.dataRecord.value[i]['Drawing_Number(customer)']:''}',
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
                        final type = MainController.dataRecord.value[i]['Type'];
                        return Center(
                          child: Txt(
                            '${ type != null && type is Map && type['title'] != null
                                ? type['title']
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
                      Obx((){
                        return Txt(
                          '${ViewCustomController.total.value[MainController.dataRecord.value[i]['_id']]?['sumQuantity'] ?? 0}',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: MainController.isLightMode.value == true ? whiteColor : color2,
                          textAlign: TextAlign.center,
                        );
                      }),
                      Obx((){
                        return Txt(
                          '${ViewCustomController.total.value[MainController.dataRecord.value[i]['_id']]?['sumArea'] ?? 0}',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: MainController.isLightMode.value == true ? whiteColor : color2,
                          textAlign: TextAlign.center,
                        );
                      }),
                      ViewController.generateCellFileBox(MainController.getColumnsTable(MainController.tableName.value).indexWhere((element) => element.name == 'Picture2'), i , tableData: widget.table),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: PopupMenuTheme(
                            data: PopupMenuThemeData(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                    width: borderSize, color: itemColor34),
                              ),
                              color: MainController.isLightMode.value == true
                                  ? background
                                  : whiteColor,
                            ),
                            child: PopupMenuButton<String>(
                              elevation: 0,
                              offset: Offset(0, 55),
                              onSelected: (String value) async {
                                print(
                                    '_TableBoxState.build PopupMenuButton>>>${value}');
                                var relation = MainController.setRelations('Orders') !=
                                    null
                                    ? MainController.setRelations('Orders')
                                    .firstWhere((item) => item == value,
                                    orElse: () => null)
                                    : null;
                                if (relation != null) {
                                  MainController.tableName.value = relation;
                                  print(
                                      'data of relation>>>${MainController.dataRecord} ${relation}');
                                  await HelperController.relationFunction(
                                      table: relation, index: i);
                                }
                                if (value == 'edit') {
                                  setState(() {
                                    MainController.isClickedItem.value = false;
                                    ViewController.isClickedBtn.value = false;
                                    ViewController.isClickedEditBtn.value = false;
                                    ViewController.request = {};
                                    HelperController.editPageFunction(MainController.dataRecord.value[i]);
                                  });
                                }
                                if (value == 'remove') {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                            child: Container(
                                              width: 150,
                                              height: 150,
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Column(
                                                children: [
                                                  Txt('${AppController.of(context)!.value('Do you want this item to be removed?')}'),
                                                  Spacer(),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.all(15),
                                                          width: 52,
                                                          height: 52,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10)),
                                                              color: redColor),
                                                          child: Center(
                                                              child: Txt(
                                                                '${AppController.of(context)!.value('no')}',
                                                                color: whiteColor,
                                                              )),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          await HelperController
                                                              .deleteFunction(
                                                              MainController
                                                                  .dataRecord
                                                                  .value[i]
                                                              ['_id']);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.all(15),
                                                          width: 52,
                                                          height: 52,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10)),
                                                              color: successColor),
                                                          child: Center(
                                                              child: Txt(
                                                                '${AppController.of(context)!.value('yes')}',
                                                                color: whiteColor,
                                                              )),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ));
                                      });
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuEntry<String>>[
                                  if (MainController.dataRecord.value[i]['sync'] ==
                                      'false')
                                    PopupMenuItem<String>(
                                        value: 'refresh',
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(Icons.refresh,
                                                  color: MainController
                                                      .isLightMode
                                                      .value ==
                                                      true
                                                      ? whiteColor
                                                      : color3),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Txt('${AppController.of(context)!.value('refresh')}',
                                                  color: MainController
                                                      .isLightMode
                                                      .value ==
                                                      false
                                                      ? color3
                                                      : whiteColor)
                                            ],
                                          ),
                                        )),
                                  PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit,
                                                color: MainController
                                                    .isLightMode.value ==
                                                    true
                                                    ? whiteColor
                                                    : color3),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Txt('${AppController.of(context)!.value('edit')}',
                                                color: MainController
                                                    .isLightMode.value ==
                                                    false
                                                    ? color3
                                                    : whiteColor)
                                          ],
                                        ),
                                      )),
                                  PopupMenuItem<String>(
                                      value: 'remove',
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.trash,
                                              color: MainController
                                                  .isLightMode.value ==
                                                  true
                                                  ? whiteColor
                                                  : color3,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Txt('${AppController.of(context)!.value('remove')}',
                                                color: MainController
                                                    .isLightMode.value ==
                                                    false
                                                    ? color3
                                                    : whiteColor)
                                          ],
                                        ),
                                      )),
                                  if (MainController.setRelations('Orders') !=
                                      null &&
                                      MainController.setRelations('Orders')
                                          .length !=
                                          0)
                                    for (var item in MainController.setRelations('Orders'))
                                      PopupMenuItem<String>(
                                          value: item.toString(),
                                          child: Container(
                                            child: Txt(
                                              item,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: whiteColor,
                                            ),
                                          )),
                                ];
                              },
                              child: Container(
                                width: 100,
                                height: 45,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: colorBtn, width: 1),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  color: colorBtn,
                                ),
                                child: Row(
                                  children: [
                                    Txt(
                                      '${AppController.of(context)!.value('operation')}',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: 20,
                                      color: whiteColor,
                                    ),
                                  ],
                                ),
                              ),
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
