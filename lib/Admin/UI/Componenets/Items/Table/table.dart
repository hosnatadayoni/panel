import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Helpers/token-methods.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:finance/Admin/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';

class TableBox extends StatefulWidget {
  TableBox();

  @override
  State<TableBox> createState() => _TableBoxState();
}

class _TableBoxState extends State<TableBox> {
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
    print('_TableBoxState.build table info is>>${MainController.tableInfo}');
    _scrollController.addListener(() {});
    var size = MediaQuery.of(context).size;
    return Obx(() {
      return Container(
          color: MainController.isLightMode.value == true
              ? background
              : whiteColor,
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
                  //defaultColumnWidth: FixedColumnWidth(200),
                  // defaultColumnWidth: FixedColumnWidth((size.width)  / (MainController.tableInfo['columns'].length + 1 )),
                  defaultColumnWidth: FixedColumnWidth(
                      (MainController.tableInfo['columns'].length > 8
                          ? 200.0
                          : size.width /
                              (MainController.tableInfo['columns'].length +
                                  1))),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(
                      color: MainController.isLightMode.value == true
                          ? whiteColor
                          : color1),
                  children: [
                    TableRow(children: [
                      for (var i = 0;
                          i < MainController.tableInfo['columns'].length;
                          i++)
                        if (MainController.tableInfo['columns'][i]
                                ['is-show-table'] ==
                            true)
                          Center(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Txt(
                                      '${MainController.tableInfo['columns'][i]['name']}',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: MainController.isLightMode.value ==
                                              true
                                          ? whiteColor
                                          : color2))),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                              child: Txt(
                                  '${AppController.of(context)!.value('operation')}',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      MainController.isLightMode.value == true
                                          ? whiteColor
                                          : color2)))
                    ]),
                    if (MainController.tableData.value.length != 0)
                      for (var i = 0;
                          i < MainController.tableData.value.length;
                          i++)
                        TableRow(children: [
                          for (var j = 0;
                              j < MainController.tableInfo['columns'].length;
                              j++)
                            if (MainController.tableInfo['columns'][j]
                                    ['is-show-table'] ==
                                true)
                              FutureBuilder<Widget>(
                                future: ViewController.generateDataColumn(j, i),
                                builder: (BuildContext context,
                                    AsyncSnapshot<Widget> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Txt(
                                        '${AppController.of(context)!.value('error')}: ${snapshot.requireData}');
                                  } else {
                                    return snapshot.data ?? Container();
                                  }
                                },
                              ),
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
                                  color:
                                      MainController.isLightMode.value == true
                                          ? background
                                          : whiteColor,
                                ),
                                child: PopupMenuButton<String>(
                                  elevation: 0,
                                  offset: Offset(0, 55),
                                  onSelected: (String value) async {
                                    print('_TableBoxState.build PopupMenuButton>>>${value}');
                                    var relation = MainController.tableInfo['relations']
                                        .firstWhere((item) => item['table-name'] == value, orElse: () => null);
                                    if(relation!=null){
                                      MainController.selectedItem
                                          .value = MainController
                                          .SubMenuList
                                          .indexWhere((element) =>
                                      element[
                                      'table-name'] ==
                                          relation['table-name']);
                                      MainController
                                          .tableName.value =
                                      relation['table-name'];
                                      print(
                                          '_TableBoxState.build>>${MainController.tableName.value}');
                                      HelperController
                                          .relationFunction(
                                          table: relation,
                                          index: i);
                                    }
                                    if(value=='edit'){
                                      setState(() {
                                        MainController.isClickedItem
                                            .value = false;
                                        ViewController
                                            .isClickedBtn.value = false;
                                        ViewController.isClickedEditBtn
                                            .value = false;
                                        ViewController.request = {};
                                        HelperController
                                            .editPageFunction(
                                            MainController.tableData
                                                .value[i]);
                                      });
                                    }
                                    if(value=='refresh'){
                                      await DB(
                                          '${MainController.tableInfo['table-name']}')
                                          .where('id', '\$eq',
                                          '${MainController.tableData.value[i]['id']}')
                                          .updateRecord(MainController
                                          .tableData.value[i]);
                                    }
                                    if(value=='remove'){
                                      showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext context) {
                                            return Dialog(
                                                child: Container(
                                                  width: 150,
                                                  height: 150,
                                                  padding:
                                                  EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            10)),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Txt('${AppController.of(context)!.value('Do you want this item to be removed?')}'),
                                                      Spacer(),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                            Container(
                                                              padding:
                                                              EdgeInsets
                                                                  .all(
                                                                  15),
                                                              width: 52,
                                                              height: 52,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.all(Radius.circular(
                                                                      10)),
                                                                  color:
                                                                  redColor),
                                                              child: Center(
                                                                  child:
                                                                  Txt(
                                                                    '${AppController.of(context)!.value('no')}',
                                                                    color:
                                                                    whiteColor,
                                                                  )),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          InkWell(
                                                            onTap:
                                                                () async {
                                                              HelperController.deleteFunction(MainController.tableData.value[i]);
                                                              // setState(() {
                                                              //   DB('${MainController.tableInfo['table-name']}').where('_id', '\$eq', '${MainController.tableData.value[i]['_id']}').deleteRecord();
                                                              // });
                                                              // MainController.tableData.value= await DB('${MainController.tableInfo['table-name']}').paginate();
                                                              // ViewController.totalPage.value = await DB('${MainController.tableInfo['table-name']}').infoPage();
                                                              // Navigator.pop(context);
                                                            },
                                                            child:
                                                            Container(
                                                              padding:
                                                              EdgeInsets
                                                                  .all(
                                                                  15),
                                                              width: 52,
                                                              height: 52,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.all(Radius.circular(
                                                                      10)),
                                                                  color:
                                                                  successColor),
                                                              child: Center(
                                                                  child:
                                                                  Txt(
                                                                    '${AppController.of(context)!.value('yes')}',
                                                                    color:
                                                                    whiteColor,
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

                                  itemBuilder: (BuildContext  context) {
                                    return <PopupMenuEntry<String>>[
                                      if (MainController.tableData.value[i]
                                              ['sync'] ==
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
                                                                .isLightMode
                                                                .value ==
                                                            true
                                                        ? whiteColor
                                                        : color3),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Txt('${AppController.of(context)!.value('edit')}',
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
                                          value: 'remove',
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.trash,
                                                  color: MainController
                                                              .isLightMode
                                                              .value ==
                                                          true
                                                      ? whiteColor
                                                      : color3,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Txt('${AppController.of(context)!.value('remove')}',
                                                    color: MainController
                                                                .isLightMode
                                                                .value ==
                                                            false
                                                        ? color3
                                                        : whiteColor)
                                              ],
                                            ),
                                          )),
                                      if (MainController.tableInfo['relations'].length != 0)
                                        for (var item in MainController.tableInfo['relations'])
                                          PopupMenuItem<String>(

                                            // onTap: (){
                                            //   print('_TableBoxState.build');
                                            //     MainController.selectedItem
                                            //       .value = MainController
                                            //       .SubMenuList
                                            //       .indexWhere((element) =>
                                            //   element[
                                            //   'table-name'] ==
                                            //       item['table-name']);
                                            //   MainController
                                            //       .tableName.value =
                                            //   item['table-name'];
                                            //   print(
                                            //       '_TableBoxState.build>>${MainController.tableName.value}');
                                            //   HelperController
                                            //       .relationFunction(
                                            //       table: item,
                                            //       index: i);
                                            // },
                                              value: item['table-name'].toString(),
                                              child: Container(
                                                child: Txt(
                                                  item['title'],
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
                                      border:
                                          Border.all(color: colorBtn, width: 1),
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
                )),
          ));
    });
  }
}
