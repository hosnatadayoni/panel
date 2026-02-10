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
  TableBoxCustom();

  @override
  State<TableBoxCustom> createState() => _TableBoxCustomState();
}

class _TableBoxCustomState extends State<TableBoxCustom> {
  late ScrollController _scrollController;
  RxMap<String, int> quantities = <String, int>{}.obs;
  RxMap<String, double> areas = <String, double>{}.obs;
  f() async {
    // for (var row in MainController.tableData){
    //   String id = row['_id'];
    //   quantities[id] = await ViewCustomController.calculateTotalQuantity(id);
    //   areas[id] = await ViewCustomController.calculateTotalArea(id);
    // }

  }


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await f();
    });

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // return Obx(() {
    //   return Container(
    //       color: MainController.isLightMode.value == true
    //           ? background
    //           : whiteColor,
    //       padding: EdgeInsets.all(15),
    //       width: size.width,
    //       child: Scrollbar(
    //         isAlwaysShown: true,
    //         thickness: 10,
    //         controller: _scrollController,
    //         trackVisibility: true,
    //         child: SingleChildScrollView(
    //             scrollDirection: Axis.horizontal,
    //             controller: _scrollController,
    //             child: Table(
    //               defaultColumnWidth: FixedColumnWidth((MainController.infoSchema.value['columns'].length > 8 ? 150.0 : size.width / 7)),
    //               defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    //               border: TableBorder.all(
    //                   color: MainController.isLightMode.value == true
    //                       ? whiteColor
    //                       : color1),
    //               children: [
    //                 TableRow(
    //                     children: [
    //                   for (var i = 0; i < MainController.infoSchema.value['columns'].length; i++)
    //                     if (MainController.infoSchema.value['columns'][i]
    //                     ['is_show_table'] ==
    //                         true)
    //                       Center(
    //                           child: Container(
    //                               padding: EdgeInsets.all(10),
    //                               child: Txt(
    //                                   '${MainController.infoSchema.value['columns'][i]['title']}',
    //                                   fontSize: 16,
    //                                   fontWeight: FontWeight.w700,
    //                                   color: MainController.isLightMode.value ==
    //                                       true
    //                                       ? whiteColor
    //                                       : color2))),
    //                   Container(
    //                       padding: EdgeInsets.all(10),
    //                       child: Center(
    //                           child: Txt(
    //                               '${AppController.of(context)!.value('operation')}',
    //                               fontSize: 16,
    //                               fontWeight: FontWeight.w700,
    //                               color:
    //                               MainController.isLightMode.value == true
    //                                   ? whiteColor
    //                                   : color2)))
    //                 ]),
    //                 if (MainController.tableData.length != 0)
    //                   for (var i = 0; i < MainController.tableData.length; i++)
    //                     TableRow(
    //
    //                         children: [
    //                       for (var j = 0;
    //                       j < MainController.infoSchema.value['columns'].length;
    //                       j++)
    //                         if (MainController.infoSchema.value['columns'][j]
    //                         ['is_show_table'] ==
    //                             true)
    //                           FutureBuilder<Widget>(
    //                             future: ViewController.generateDataColumn(j, i),
    //                             builder: (BuildContext context,
    //                                 AsyncSnapshot<Widget> snapshot) {
    //                               if (snapshot.connectionState == ConnectionState.waiting) {
    //                                 return CircularProgressIndicator();
    //                               } else if (snapshot.hasError) {
    //                                 return Txt(
    //                                     '${AppController.of(context)!.value('error')}: ${snapshot.requireData}');
    //                               } else {
    //                                 return snapshot.data ?? Container();
    //                               }
    //                             },
    //                           ),
    //                       Center(
    //                         child: Container(
    //                           padding: EdgeInsets.symmetric(vertical: 8.0),
    //                           child: PopupMenuTheme(
    //                             data: PopupMenuThemeData(
    //                               shape: RoundedRectangleBorder(
    //                                 borderRadius: BorderRadius.circular(16),
    //                                 side: BorderSide(
    //                                     width: borderSize, color: itemColor34),
    //                               ),
    //                               color:
    //                               MainController.isLightMode.value == true
    //                                   ? background
    //                                   : whiteColor,
    //                             ),
    //                             child: PopupMenuButton<String>(
    //                               elevation: 0,
    //                               offset: Offset(0, 55),
    //                               onSelected: (String value) async {
    //                                 print('_TableBoxState.build PopupMenuButton>>>${value}');
    //                                 var relation = MainController.infoSchema.value['schema']['relations']!=null ?MainController.infoSchema.value['schema']['relations']
    //                                     .firstWhere((item) => item == value, orElse: () => null):null;
    //                                 if(relation!=null){
    //                                   MainController
    //                                       .tableName.value =
    //                                   relation;
    //                                   HelperController.relationFunction(table: relation, index: i);
    //                                 }
    //                                 if(value=='edit'){
    //                                   setState(() {
    //                                     MainController.isClickedItem
    //                                         .value = false;
    //                                     ViewController
    //                                         .isClickedBtn.value = false;
    //                                     ViewController.isClickedEditBtn
    //                                         .value = false;
    //                                     ViewController.request = {};
    //                                     HelperController.editPageFunction(MainController.dataRecord[i]);
    //                                   });
    //                                 }
    //                                 if(value=='refresh'){
    //                                   await DB('${MainController.infoSchema.value['schema']['name']}').storeRecord(MainController.dataRecord[i]);
    //                                   await MainController.loadData(
    //                                       tableData: MainController.getInfoTable('${MainController.infoSchema.value['schema']['name']}'));
    //                                   if (ViewController.isClickedBtn.value == false) {
    //                                     var table = MainController.getInfoTable(MainController.tableName.value);
    //                                     MainController.goToTablePage(table, loadData: false);
    //                                   }
    //                                   // DB('${MainController.infoSchema.value['schema']['name']}').getRecords();
    //                                 }
    //                                 if(value=='remove'){
    //                                   showDialog(
    //                                       context: context,
    //                                       builder:
    //                                           (BuildContext context) {
    //                                         return Dialog(
    //                                             child: Container(
    //                                               width: 150,
    //                                               height: 150,
    //                                               padding:
    //                                               EdgeInsets.all(15),
    //                                               decoration: BoxDecoration(
    //                                                 borderRadius:
    //                                                 BorderRadius.all(
    //                                                     Radius.circular(
    //                                                         10)),
    //                                               ),
    //                                               child: Column(
    //                                                 children: [
    //                                                   Txt('${AppController.of(context)!.value('Do you want this item to be removed?')}'),
    //                                                   Spacer(),
    //                                                   Row(
    //                                                     mainAxisAlignment:
    //                                                     MainAxisAlignment
    //                                                         .center,
    //                                                     crossAxisAlignment:
    //                                                     CrossAxisAlignment
    //                                                         .center,
    //                                                     children: [
    //                                                       InkWell(
    //                                                         onTap: () {
    //                                                           Navigator.pop(
    //                                                               context);
    //                                                         },
    //                                                         child:
    //                                                         Container(
    //                                                           padding:
    //                                                           EdgeInsets
    //                                                               .all(
    //                                                               15),
    //                                                           width: 52,
    //                                                           height: 52,
    //                                                           decoration: BoxDecoration(
    //                                                               borderRadius:
    //                                                               BorderRadius.all(Radius.circular(
    //                                                                   10)),
    //                                                               color:
    //                                                               redColor),
    //                                                           child: Center(
    //                                                               child:
    //                                                               Txt(
    //                                                                 '${AppController.of(context)!.value('no')}',
    //                                                                 color:
    //                                                                 whiteColor,
    //                                                               )),
    //                                                         ),
    //                                                       ),
    //                                                       SizedBox(
    //                                                         width: 5,
    //                                                       ),
    //                                                       InkWell(
    //                                                         onTap:
    //                                                             () async {
    //                                                           HelperController.deleteFunction(
    //                                                               MainController
    //                                                                   .tableData
    //                                                                   .value[i]['_id']);
    //
    //                                                         },
    //                                                         child:
    //                                                         Container(
    //                                                           padding:
    //                                                           EdgeInsets
    //                                                               .all(
    //                                                               15),
    //                                                           width: 52,
    //                                                           height: 52,
    //                                                           decoration: BoxDecoration(
    //                                                               borderRadius:
    //                                                               BorderRadius.all(Radius.circular(
    //                                                                   10)),
    //                                                               color:
    //                                                               successColor),
    //                                                           child: Center(
    //                                                               child:
    //                                                               Txt(
    //                                                                 '${AppController.of(context)!.value('yes')}',
    //                                                                 color:
    //                                                                 whiteColor,
    //                                                               )),
    //                                                         ),
    //                                                       )
    //                                                     ],
    //                                                   )
    //                                                 ],
    //                                               ),
    //                                             ));
    //                                       });
    //                                 }
    //                               },
    //
    //                               itemBuilder: (BuildContext  context) {
    //                                 return <PopupMenuEntry<String>>[
    //                                   if (MainController.dataRecord[i]
    //                                   ['sync'] ==
    //                                       'false')
    //                                     PopupMenuItem<String>(
    //                                         value: 'refresh',
    //                                         child: Container(
    //                                           child: Row(
    //                                             children: [
    //                                               Icon(Icons.refresh,
    //                                                   color: MainController
    //                                                       .isLightMode
    //                                                       .value ==
    //                                                       true
    //                                                       ? whiteColor
    //                                                       : color3),
    //                                               SizedBox(
    //                                                 width: 10,
    //                                               ),
    //                                               Txt('${AppController.of(context)!.value('refresh')}',
    //                                                   color: MainController
    //                                                       .isLightMode
    //                                                       .value ==
    //                                                       false
    //                                                       ? color3
    //                                                       : whiteColor)
    //                                             ],
    //                                           ),
    //                                         )),
    //                                   PopupMenuItem<String>(
    //                                       value: 'edit',
    //                                       child: Container(
    //                                         child: Row(
    //                                           children: [
    //                                             Icon(Icons.edit,
    //                                                 color: MainController
    //                                                     .isLightMode
    //                                                     .value ==
    //                                                     true
    //                                                     ? whiteColor
    //                                                     : color3),
    //                                             SizedBox(
    //                                               width: 5,
    //                                             ),
    //                                             Txt('${AppController.of(context)!.value('edit')}',
    //                                                 color: MainController
    //                                                     .isLightMode
    //                                                     .value ==
    //                                                     false
    //                                                     ? color3
    //                                                     : whiteColor)
    //                                           ],
    //                                         ),
    //                                       )),
    //                                   PopupMenuItem<String>(
    //                                       value: 'remove',
    //                                       child: Container(
    //                                         child: Row(
    //                                           children: [
    //                                             Icon(
    //                                               CupertinoIcons.trash,
    //                                               color: MainController
    //                                                   .isLightMode
    //                                                   .value ==
    //                                                   true
    //                                                   ? whiteColor
    //                                                   : color3,
    //                                             ),
    //                                             SizedBox(
    //                                               width: 10,
    //                                             ),
    //                                             Txt('${AppController.of(context)!.value('remove')}',
    //                                                 color: MainController
    //                                                     .isLightMode
    //                                                     .value ==
    //                                                     false
    //                                                     ? color3
    //                                                     : whiteColor)
    //                                           ],
    //                                         ),
    //                                       )),
    //                                   if (MainController.infoSchema.value['schema']['relations']!=null&& MainController.infoSchema.value['schema']['relations'].length != 0)
    //                                     for (var item in MainController.infoSchema.value['schema']['relations'])
    //                                       PopupMenuItem<String>(
    //                                           value: item.toString(),
    //                                           child: Container(
    //                                             child: Txt(
    //                                               item,
    //                                               fontSize: 16,
    //                                               fontWeight: FontWeight.w400,
    //                                               color: whiteColor,
    //                                             ),
    //                                           )),
    //                                 ];
    //                               },
    //                               child: Container(
    //                                 width: 100,
    //                                 height: 45,
    //                                 padding: EdgeInsets.all(10),
    //                                 decoration: BoxDecoration(
    //                                   border:
    //                                   Border.all(color: colorBtn, width: 1),
    //                                   borderRadius:
    //                                   BorderRadius.all(Radius.circular(10)),
    //                                   color: colorBtn,
    //                                 ),
    //                                 child: Row(
    //                                   children: [
    //                                     Txt(
    //                                       '${AppController.of(context)!.value('operation')}',
    //                                       fontSize: 16,
    //                                       fontWeight: FontWeight.w400,
    //                                       color: whiteColor,
    //                                     ),
    //                                     SizedBox(
    //                                       width: 10,
    //                                     ),
    //                                     Icon(
    //                                       Icons.arrow_drop_down_sharp,
    //                                       size: 20,
    //                                       color: whiteColor,
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       )
    //                     ])
    //               ],
    //             )),
    //       ));
    // });
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
                (MainController.infoSchema.value.columns.length > 8
                    ? 150.0
                    : size.width / 7),
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
                            '${MainController.dataRecord[i]['Input_Code']}',
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
                            '${MainController.dataRecord[i]['Customer'] != null ? MainController.dataRecord[i]['Customer']['Name_and_lastName'] :''}',
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
                            '${MainController.dataRecord[i]['Date']}',
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
                            '${MainController.dataRecord[i]['Drawing_Number']}',
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
                            '${MainController.dataRecord[i]['Drawing_Number(customer)']}',
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
                            '${MainController.dataRecord[i]['Type'] != null ? MainController.dataRecord[i]['Type']['title']:''}',
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
                        return Txt('${quantities[MainController.dataRecord[i]['_id']] != 0 ? quantities[MainController.dataRecord[i]['_id']] :0}',fontSize: 14, fontWeight: FontWeight.w500, color: MainController.isLightMode.value == true ? whiteColor : color2,textAlign: TextAlign.center);
                      }),
                      Obx((){
                        return Txt('${areas[MainController.dataRecord[i]['_id']]}',fontSize: 14, fontWeight: FontWeight.w500, color: MainController.isLightMode.value == true ? whiteColor : color2,textAlign: TextAlign.center);
                      }),
                      Obx(() {
                        return Center(
                          child: Txt(
                            '${MainController.dataRecord[i]['Picture'] != null ? MainController.dataRecord[i]['Picture'] : ""}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
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
                                var relation = MainController.infoSchema.value.schema.relations!=
                                    null
                                    ? MainController.infoSchema.value.schema.relations!
                                    .firstWhere((item) => item == value,
                                    orElse: () => null)
                                    : null;
                                if (relation != null) {
                                  MainController.tableName.value = relation;
                                  HelperController.relationFunction(
                                      table: relation, index: i);
                                }
                                if (value == 'edit') {
                                  setState(() {
                                    MainController.isClickedItem.value = false;
                                    ViewController.isClickedBtn.value = false;
                                    ViewController.isClickedEditBtn.value = false;
                                    ViewController.request = {};
                                    HelperController.editPageFunction(MainController.dataRecord[i]);
                                  });
                                }
                                if (value == 'refresh') {
                                  await DB(
                                      '${MainController.infoSchema.value.schema.name}')
                                      .storeRecord(
                                      MainController.dataRecord[i]);
                                  await MainController.loadData(
                                      tableData: MainController.getInfoTable(
                                          '${MainController.infoSchema.value.schema.name}'));
                                  if (ViewController.isClickedBtn.value ==
                                      false) {
                                    var table = MainController.getInfoTable(
                                        MainController.tableName.value);
                                    HelperController.goToTablePage(table,
                                        loadData: false);
                                  }
                                  // DB('${MainController.infoSchema.value['schema']['name']}').getRecords();
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
                                                              MainController.dataRecord[i]['_id']);
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
                                  if (MainController.dataRecord[i]['sync'] ==
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
                                  if (MainController.infoSchema.value.schema.relations != null &&
                                      MainController.infoSchema.value.schema.relations!.length !=
                                          0)
                                    for (var item in MainController.infoSchema.value.schema.relations! )
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
