import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/tableModel.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:intl/intl.dart';

// class TableOrderDetailBox extends StatefulWidget {
//   TableOrderDetailBox(this.tableColumns);
//   var tableColumns;
//
//   @override
//   State<TableOrderDetailBox> createState() => _TableOrderDetailBoxState();
// }
//
// class _TableOrderDetailBoxState extends State<TableOrderDetailBox> {
//   late ScrollController _scrollController;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _scrollController.addListener(() {});
//     var size = MediaQuery.of(context).size;
//     return Obx(() {
//       print('widget.tableColumns>>>${widget.tableColumns}');
//       for (var i = 0; i < widget.tableColumns.length; i++){
//         print('widget.tableColumns[i].title>>>${widget.tableColumns[i]}');
//       }
//
//       return Container(
//           color: MainController.isLightMode.value == true
//               ? background
//               : whiteColor,
//           padding: EdgeInsets.all(15),
//           width: size.width,
//           child: Scrollbar(
//             isAlwaysShown: true,
//             thickness: 10,
//             controller: _scrollController,
//             trackVisibility: true,
//             child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 controller: _scrollController,
//                 child: Table(
//                   defaultColumnWidth: FixedColumnWidth((widget.tableColumns.length > 8 ? 150.0 : size.width / 7)),
//                   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                   border: TableBorder.all(
//                       color: MainController.isLightMode.value == true
//                           ? whiteColor
//                           : color1),
//                   children: [
//                     TableRow(
//                         children: [
//                           Center(child: Txt('#' , fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color:
//                             MainController.isLightMode.value == true ? whiteColor : color2,
//                             textAlign: TextAlign.center,)),
//                           for (var i = 0; i < widget.tableColumns.length; i++)
//                             if (widget.tableColumns[i].isShowTable == true)
//                               Center(
//                                   child: Container(
//                                       padding: EdgeInsets.all(10),
//                                       child: Txt(
//                                           '${widget.tableColumns[i].title}',
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w700,
//                                           color: MainController.isLightMode.value ==
//                                               true
//                                               ? whiteColor
//                                               : color2))),
//                           Container(
//                               padding: EdgeInsets.all(10),
//                               child: Center(
//                                   child: Txt(
//                                       '${AppController.of(context)!.value('operation')}',
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w700,
//                                       color:
//                                       MainController.isLightMode.value == true
//                                           ? whiteColor
//                                           : color2)))
//                         ]),
//                     if (MainController.dataRecord.length != 0)
//                       for (var i = 0; i < MainController.dataRecord.length; i++)
//
//                         TableRow(children: [
//                           Center(
//                             child: Txt(
//                               '${i+1}',
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color:
//                               MainController.isLightMode.value == true ? whiteColor : color2,
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                           for (var j = 0; j < widget.tableColumns.length; j++)
//                             if (widget.tableColumns[j].isShowTable == true)
//                               FutureBuilder<Widget>(
//                                 future: ViewController.generateDataColumn(j, i),
//                                 builder: (BuildContext context,
//                                     AsyncSnapshot<Widget> snapshot) {
//                                   if (snapshot.connectionState == ConnectionState.waiting) {
//                                     return CircularProgressIndicator();
//                                   } else if (snapshot.hasError) {
//                                     return Txt(
//                                         '${AppController.of(context)!.value('error')}: ${snapshot.requireData}');
//                                   } else {
//                                     return snapshot.data ?? Container();
//                                   }
//                                 },
//                               ),
//                           Center(
//                             child: Container(
//                               padding: EdgeInsets.symmetric(vertical: 8.0),
//                               child: PopupMenuTheme(
//                                 data: PopupMenuThemeData(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                     side: BorderSide(
//                                         width: borderSize, color: itemColor34),
//                                   ),
//                                   color:
//                                   MainController.isLightMode.value == true
//                                       ? background
//                                       : whiteColor,
//                                 ),
//                                 child: PopupMenuButton<String>(
//                                   elevation: 0,
//                                   offset: Offset(0, 55),
//                                   onSelected: (String value) async {
//                                     print('_TableBoxState.build PopupMenuButton>>>${value}');
//                                     if(value=='edit'){
//                                       setState(() {
//                                         MainController.isClickedItem
//                                             .value = false;
//                                         ViewController
//                                             .isClickedBtn.value = false;
//                                         ViewController.isClickedEditBtn
//                                             .value = false;
//                                         ViewController.request = {};
//                                         HelperController.editPageFunction(MainController.dataRecord.value[i]);
//                                       });
//                                     }
//                                     if(value=='refresh'){
//                                       await DB('${MainController.infoSchema.value.schema.name}').storeRecord(MainController.dataRecord.value[i]);
//                                       await MainController.loadData(
//                                           tableData: MainController.getInfoTable('${MainController.infoSchema.value.schema.name}'));
//                                       if (ViewController.isClickedBtn.value == false) {
//                                         var table = MainController.getInfoTable(MainController.tableName.value);
//                                         HelperController.goToTablePage(table, loadData: false);
//                                       }
//                                       // DB('${MainController.infoSchema.value.schema.name}').getRecords();
//                                     }
//                                     if(value=='remove'){
//                                       showDialog(
//                                           context: context,
//                                           builder:
//                                               (BuildContext context) {
//                                             return Dialog(
//                                                 child: Container(
//                                                   width: 150,
//                                                   height: 150,
//                                                   padding:
//                                                   EdgeInsets.all(15),
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                     BorderRadius.all(
//                                                         Radius.circular(
//                                                             10)),
//                                                   ),
//                                                   child: Column(
//                                                     children: [
//                                                       Txt('${AppController.of(context)!.value('Do you want this item to be removed?')}'),
//                                                       Spacer(),
//                                                       Row(
//                                                         mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                         crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .center,
//                                                         children: [
//                                                           InkWell(
//                                                             onTap: () {
//                                                               Navigator.pop(
//                                                                   context);
//                                                             },
//                                                             child:
//                                                             Container(
//                                                               padding:
//                                                               EdgeInsets
//                                                                   .all(
//                                                                   15),
//                                                               width: 52,
//                                                               height: 52,
//                                                               decoration: BoxDecoration(
//                                                                   borderRadius:
//                                                                   BorderRadius.all(Radius.circular(
//                                                                       10)),
//                                                                   color:
//                                                                   redColor),
//                                                               child: Center(
//                                                                   child:
//                                                                   Txt(
//                                                                     '${AppController.of(context)!.value('no')}',
//                                                                     color:
//                                                                     whiteColor,
//                                                                   )),
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             width: 5,
//                                                           ),
//                                                           InkWell(
//                                                             onTap:
//                                                                 () async {
//                                                               HelperController.deleteFunction(
//                                                                   MainController
//                                                                       .dataRecord
//                                                                       .value[i]['_id']);
//
//                                                             },
//                                                             child:
//                                                             Container(
//                                                               padding:
//                                                               EdgeInsets
//                                                                   .all(
//                                                                   15),
//                                                               width: 52,
//                                                               height: 52,
//                                                               decoration: BoxDecoration(
//                                                                   borderRadius:
//                                                                   BorderRadius.all(Radius.circular(
//                                                                       10)),
//                                                                   color:
//                                                                   successColor),
//                                                               child: Center(
//                                                                   child:
//                                                                   Txt(
//                                                                     '${AppController.of(context)!.value('yes')}',
//                                                                     color:
//                                                                     whiteColor,
//                                                                   )),
//                                                             ),
//                                                           )
//                                                         ],
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ));
//                                           });
//                                     }
//                                   },
//
//                                   itemBuilder: (BuildContext  context) {
//                                     return <PopupMenuEntry<String>>[
//                                       if (MainController.dataRecord.value[i]
//                                       ['sync'] ==
//                                           'false')
//                                         PopupMenuItem<String>(
//                                             value: 'refresh',
//                                             child: Container(
//                                               child: Row(
//                                                 children: [
//                                                   Icon(Icons.refresh,
//                                                       color: MainController
//                                                           .isLightMode
//                                                           .value ==
//                                                           true
//                                                           ? whiteColor
//                                                           : color3),
//                                                   SizedBox(
//                                                     width: 10,
//                                                   ),
//                                                   Txt('${AppController.of(context)!.value('refresh')}',
//                                                       color: MainController
//                                                           .isLightMode
//                                                           .value ==
//                                                           false
//                                                           ? color3
//                                                           : whiteColor)
//                                                 ],
//                                               ),
//                                             )),
//                                       PopupMenuItem<String>(
//                                           value: 'edit',
//                                           child: Container(
//                                             child: Row(
//                                               children: [
//                                                 Icon(Icons.edit,
//                                                     color: MainController
//                                                         .isLightMode
//                                                         .value ==
//                                                         true
//                                                         ? whiteColor
//                                                         : color3),
//                                                 SizedBox(
//                                                   width: 5,
//                                                 ),
//                                                 Txt('${AppController.of(context)!.value('edit')}',
//                                                     color: MainController
//                                                         .isLightMode
//                                                         .value ==
//                                                         false
//                                                         ? color3
//                                                         : whiteColor)
//                                               ],
//                                             ),
//                                           )),
//                                       PopupMenuItem<String>(
//                                           value: 'remove',
//                                           child: Container(
//                                             child: Row(
//                                               children: [
//                                                 Icon(
//                                                   CupertinoIcons.trash,
//                                                   color: MainController
//                                                       .isLightMode
//                                                       .value ==
//                                                       true
//                                                       ? whiteColor
//                                                       : color3,
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Txt('${AppController.of(context)!.value('remove')}',
//                                                     color: MainController
//                                                         .isLightMode
//                                                         .value ==
//                                                         false
//                                                         ? color3
//                                                         : whiteColor)
//                                               ],
//                                             ),
//                                           )),
//                                     ];
//                                   },
//                                   child: Container(
//                                     width: 100,
//                                     height: 45,
//                                     padding: EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                       border:
//                                       Border.all(color: colorBtn, width: 1),
//                                       borderRadius:
//                                       BorderRadius.all(Radius.circular(10)),
//                                       color: colorBtn,
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         Txt(
//                                           '${AppController.of(context)!.value('operation')}',
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w400,
//                                           color: whiteColor,
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         Icon(
//                                           Icons.arrow_drop_down_sharp,
//                                           size: 20,
//                                           color: whiteColor,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ])
//                   ],
//                 )),
//           ));
//     });
//   }
// }
class TableOrderDetailBox extends StatefulWidget {
   TableModel schema;

  TableOrderDetailBox({required this.schema});

  @override
  State<TableOrderDetailBox> createState() => _TableOrderDetailBoxState();
}

class _TableOrderDetailBoxState extends State<TableOrderDetailBox> {
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
    _scrollController.addListener(() {});
    var size = MediaQuery.of(context).size;
    var columns = widget.schema.columns.where((c) => c.isShowTable == true).toList();
    final formatter = NumberFormat('#,###');
    if (MainController.tableName.value != 'Order_Details') {
      return const SizedBox.shrink();
    }
    return Container(
      color: MainController.isLightMode.value ? background : whiteColor,
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
            defaultColumnWidth:
            FixedColumnWidth(columns.length > 8 ? 150.0 : size.width / 7),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(
                color: MainController.isLightMode.value ? whiteColor : color1),
            children: [
              // Header
              TableRow(
                children: [
                  Center(
                    child: Txt('#',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: MainController.isLightMode.value ? whiteColor : color2,
                        textAlign: TextAlign.center),
                  ),
                  Obx(() {
                    return Center(
                      child: Txt(
                        'نام کالا',
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
                        'قیمت',
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
                        'بعد اول',
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
                        'بعد دوم',
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
                        'تعداد',
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
                        'الگوی بری',
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
                    return Txt('سختی تولید',fontSize: 14, fontWeight: FontWeight.w500, color: MainController.isLightMode.value == true ? whiteColor : color2,textAlign: TextAlign.center);
                  }),
                  Obx((){
                    return Txt('بلوک',fontSize: 14, fontWeight: FontWeight.w500, color: MainController.isLightMode.value == true ? whiteColor : color2,textAlign: TextAlign.center);
                  }),
                  Obx((){
                    return Txt('طبقه',fontSize: 14, fontWeight: FontWeight.w500, color: MainController.isLightMode.value == true ? whiteColor : color2,textAlign: TextAlign.center);
                  }),
                  Obx((){
                    return Txt('واحد',fontSize: 14, fontWeight: FontWeight.w500, color: MainController.isLightMode.value == true ? whiteColor : color2,textAlign: TextAlign.center);
                  }),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Txt('${AppController.of(context)!.value('operation')}',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MainController.isLightMode.value ? whiteColor : color2),
                    ),
                  ),
                ],
              ),

              // Rows
              for (int i = 0; i < MainController.dataRecord.value.length; i++)
                TableRow(
                  children: [
                    Center(
                        child: Txt('${i + 1}',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value ? whiteColor : color2,
                            textAlign: TextAlign.center)),
                    Obx(() {
                      return Center(
                        child: Txt(
                          '${MainController.dataRecord.value[i]['Product_Name'] != null ? MainController.dataRecord.value[i]['Product_Name']['Title']:""}',
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
                          '${MainController.dataRecord.value[i]['Price'] != null ? formatter.format(MainController.dataRecord.value[i]['Price']):''}',
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
                          '${MainController.dataRecord.value[i]['First_Dimension'] != null ? MainController.dataRecord.value[i]['First_Dimension']:""}',
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
                          '${MainController.dataRecord.value[i]['Second_Dimension'] != null ? MainController.dataRecord.value[i]['Second_Dimension']:''}',
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
                          '${MainController.dataRecord.value[i]['Quantity'] != null ? MainController.dataRecord.value[i]['Quantity']:''}',
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
                          '${MainController.dataRecord.value[i]['Cut_Pattern'] != null ? MainController.dataRecord.value[i]['Cut_Pattern']['title']:''}',
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
                      return Txt('${MainController.dataRecord.value[i]['Manufacturing_Difficulty'] != null ? MainController.dataRecord.value[i]['Manufacturing_Difficulty']['title']:''}',fontSize: 14, fontWeight: FontWeight.w500, color: MainController.isLightMode.value == true ? whiteColor : color2,textAlign: TextAlign.center);
                    }),
                    Obx((){
                      return Txt('${MainController.dataRecord.value[i]['Block'] != null ? MainController.dataRecord.value[i]['Block']:""}',fontSize: 14, fontWeight: FontWeight.w500, color: MainController.isLightMode.value == true ? whiteColor : color2,textAlign: TextAlign.center);
                    }),
                    Obx((){
                      return Txt('${MainController.dataRecord.value[i]['Level'] != null ? MainController.dataRecord.value[i]['Level']:""}',fontSize: 14, fontWeight: FontWeight.w500, color: MainController.isLightMode.value == true ? whiteColor : color2,textAlign: TextAlign.center);
                    }),
                    Obx((){
                      return Txt('${MainController.dataRecord.value[i]['Unit'] != null ? MainController.dataRecord.value[i]['Unit']:""}',fontSize: 14, fontWeight: FontWeight.w500, color: MainController.isLightMode.value == true ? whiteColor : color2,textAlign: TextAlign.center);
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
                            color:
                            MainController.isLightMode.value == true
                                ? background
                                : whiteColor,
                          ),
                          child: PopupMenuButton<String>(
                            elevation: 0,
                            offset: Offset(0, 55),
                            onSelected: (String value) async {
                              if(value=='edit'){
                                setState(() {
                                  MainController.isClickedItem
                                      .value = false;
                                  ViewController
                                      .isClickedBtn.value = false;
                                  ViewController.isClickedEditBtn
                                      .value = false;
                                  ViewController.request = {};
                                  HelperController.editPageFunction(MainController.dataRecord.value[i]);
                                });
                              }
                              if(value=='refresh'){
                                await DB('${widget.schema.schema.name}').storeRecord(MainController.dataRecord.value[i]);
                                await MainController.loadData(
                                    tableData: MainController.getInfoTable('${widget.schema.schema.name}'));
                                if (ViewController.isClickedBtn.value == false) {
                                  var table = MainController.getInfoTable(MainController.tableName.value);
                                  HelperController.goToTablePage(table, loadData: false);
                                }
                                // DB('${MainController.infoSchema.value.schema.name}').getRecords();
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
                                                        HelperController.deleteFunction(
                                                            MainController.dataRecord.value[i]['_id']);

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
                                if (MainController.dataRecord.value[i]
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
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

