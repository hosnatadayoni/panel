import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Views/edit.dart';
import 'package:finance/boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TableBox extends StatefulWidget {
  const TableBox();

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
    _scrollController.addListener(() {

    });
    var size = MediaQuery.of(context).size;
    return Obx((){
      return Container(
        color: MainController.isLightMode.value == true ? background :whiteColor,
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
              defaultColumnWidth: FixedColumnWidth((size.width)  / (MainController.tableInfo['columns'].length + 1 )),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(color: MainController.isLightMode.value == true?  whiteColor:color1),
              children: [
                TableRow(children: [
                  for(var i =0 ; i<MainController.tableInfo['columns'].length;i++)
                    if(MainController.tableInfo['columns'][i]['is-show-table'] == true)
                      Center(child: Container(
                          padding: EdgeInsets.all(10),
                          child: Txt('${MainController.tableInfo['columns'][i]['name']}',fontSize: 16, fontWeight: FontWeight.w700, color:MainController.isLightMode.value == true?  whiteColor:color2))),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Center(child: Txt('${AppController.of(context)!.value('operation')}',fontSize: 16, fontWeight: FontWeight.w700, color:MainController.isLightMode.value == true?  whiteColor:color2)))
                ]),
                for(var i=MainController.startIndex.value ; i<MainController.endIndex.value; i++)
                  if(MainController.tableData.value.length > i)
                    TableRow(
                        children: [
                          for(var j =0 ; j<MainController.tableInfo['columns'].length;j++)
                            if(MainController.tableInfo['columns'][j]['is-show-table'] == true)
                              FutureBuilder<Widget>(
                                future:ViewController.generateDataColumn(j,i),
                                builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Txt('${AppController.of(context)!.value('error')}: ${snapshot.error}');
                                  } else {
                                    return snapshot.data ?? Container();
                                  }
                                },
                              ),
                          // ViewController.generateDataColumn(j,i),
                          Center(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: Wrap(
                                  children: [
                                    IconButton(onPressed: (){
                                      MainController.isClickedItem.value = false;
                                      ViewController.isClickedBtn.value = false;
                                      ViewController.isClickedEditBtn.value = false;
                                      ViewController.request = {...MainController.tableData.value[i].data};
                                      Get.to(() =>
                                          EditPage(data: MainController.tableData.value[i], index: i,));
                                    }, icon: Icon(Icons.edit , color: MainController.isLightMode.value == true ? whiteColor : color3),),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                  child: Container(
                                                    width: 150,
                                                    height: 150,
                                                    padding: EdgeInsets.all(15),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Txt('${AppController.of(context)!.value('Do you want this item to be removed?')}'),
                                                        Spacer(),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            InkWell(
                                                              onTap: (){
                                                                Navigator.pop(context);
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets.all(15),
                                                                width: 52,
                                                                height: 52,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                    color: redColor
                                                                ),
                                                                child: Center(child: Txt('${AppController.of(context)!.value('no')}' , color: whiteColor,)),

                                                              ),
                                                            ),
                                                            SizedBox(width: 5,),
                                                            InkWell(
                                                              onTap: ()async{
                                                                setState(() {
                                                                  box.deleteAt(i);
                                                                  MainController.tableData.value.removeAt(i);
                                                                });
                                                                await MainController.loadData();
                                                                MainController.renderPagination();
                                                                Navigator.pop(context);
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets.all(15),
                                                                width: 52,
                                                                height: 52,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                    color: successColor
                                                                ),
                                                                child: Center(child: Txt('${AppController.of(context)!.value('yes')}' , color: whiteColor,)),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                              );
                                            }
                                        );
                                      },
                                      icon: Icon(CupertinoIcons.trash , color:MainController.isLightMode.value == true ? whiteColor : color3,),
                                    ),
                                  ],
                                ) ),
                          )
                        ])
              ],
            ),
          ),
        )
      );
    });
  }
}
// class TableBox extends StatefulWidget {
//   const TableBox({Key? key}) : super(key: key);
//
//   @override
//   State<TableBox> createState() => _TableBoxState();
// }
//
// class _TableBoxState extends State<TableBox> {
//   ExpandableTableCell _buildCell(String content, {CellBuilder? builder}) =>
//       ExpandableTableCell(
//         child: builder != null
//             ? null
//             : _DefaultCellCard(
//           child: Center(
//             child: Txt(
//               content,
//               // style: _textStyle,
//             ),
//           ),
//         ),
//         builder: builder,
//       );
//
//   ExpandableTableCell _buildFirstRowCell() => ExpandableTableCell(
//     builder: (context, details) => _DefaultCellCard(
//       child: Padding(
//         padding: const EdgeInsets.only(left: 16.0),
//         child: Row(
//           children: [
//             SizedBox(
//               width: 24 * details.row!.address.length.toDouble(),
//               child: details.row?.children != null
//                   ? Align(
//                 alignment: Alignment.centerRight,
//                 child: AnimatedRotation(
//                   duration: const Duration(milliseconds: 500),
//                   turns: details.row?.childrenExpanded == true
//                       ? 0.25
//                       : 0,
//                   child: const Icon(
//                     Icons.keyboard_arrow_right,
//                     color: Colors.white,
//                   ),
//                 ),
//               )
//                   : null,
//             ),
//             Text(
//               '${details.row!.address.length > 1 ? details.row!.address.skip(1).map((e) => 'Sub ').join() : ''}Row ${details.row!.address.last}',
//               // style: _textStyle,
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
//
//   // ExpandableTable _buildSimpleTable() {
//   //   const int columnsCount = 20;
//   //   const int rowsCount = 20;
//   //   //Creation header
//   //   final List<ExpandableTableHeader> headers = List.generate(
//   //     columnsCount - 1,
//   //         (index) => ExpandableTableHeader(
//   //       width: index % 2 == 0 ? 200 : 150,
//   //       cell: _buildCell('Column $index'),
//   //     ),
//   //   );
//   //   //Creation rows
//   //   final List<ExpandableTableRow> rows = List.generate(
//   //     rowsCount,
//   //         (rowIndex) => ExpandableTableRow(
//   //       height: rowIndex % 2 == 0 ? 50 : 70,
//   //       firstCell: _buildCell('Row $rowIndex'),
//   //       cells: List<ExpandableTableCell>.generate(
//   //         columnsCount - 1,
//   //             (columnIndex) => _buildCell('Cell $rowIndex:$columnIndex'),
//   //       ),
//   //     ),
//   //   );
//   //
//   //   return ExpandableTable(
//   //     firstHeaderCell: _buildCell('Simple\nTable'),
//   //     headers: headers,
//   //     // scrollShadowColor: _accentColor,
//   //     rows: rows,
//   //     visibleScrollbar: true,
//   //     trackVisibilityScrollbar: true,
//   //     thumbVisibilityScrollbar: true,
//   //   );
//   // }
//
//   static  int rowsCount = MainController.tableInfo['countShowRow'];
//
//   List<ExpandableTableRow> _generateRows(int quantity, List visibleColumns) {
//     return List.generate(
//       quantity,
//           (rowIndex) => ExpandableTableRow(
//         firstCell: _buildFirstRowCell(),
//         cells:
//         List<ExpandableTableCell>.generate(
//             visibleColumns.length,
//                 (columnIndex) => _buildTxtCell(ViewController.generateDataColumn(MainController.tableInfo['columns'].indexOf(visibleColumns[columnIndex]), rowIndex))
//           // (columnIndex) => _buildTxtCell(ViewController.generateDataColumn(columnIndex,rowIndex , MainController.tableData.value),),
//         )..add(_buildRowCell(Obx(() {
//           return Container(
//             decoration: BoxDecoration(
//               color: MainController.isLightMode.value == true ? background :whiteColor,
//               border:  Border.all(color: MainController.isLightMode.value == true?  whiteColor:color1),
//             ),
//             child: Row(
//               children: [
//                 IconButton(onPressed: (){
//                   MainController.isClickedItem.value = false;
//                   Get.to(() =>
//                       EditPage(data: MainController.tableData.value[rowIndex], index: rowIndex,));}, icon: Icon(Icons.edit , color: MainController.isLightMode.value == true ? whiteColor : color3),),
//                 IconButton(
//                   onPressed: () {
//                     showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return Dialog(
//                               child: Container(
//                                 width: 150,
//                                 height: 150,
//                                 padding: EdgeInsets.all(15),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Txt('${AppController.of(context)!.value('Do you want this item to be removed?')}'),
//                                     Spacer(),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         InkWell(
//                                           onTap: (){
//                                             Navigator.pop(context);
//                                           },
//                                           child: Container(
//                                             padding: EdgeInsets.all(15),
//                                             width: 52,
//                                             height: 52,
//                                             decoration: BoxDecoration(
//                                                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                                                 color: redColor
//                                             ),
//                                             child: Center(child: Txt('${AppController.of(context)!.value('no')}' , color: whiteColor,)),
//
//                                           ),
//                                         ),
//                                         SizedBox(width: 5,),
//                                         InkWell(
//                                           onTap: ()async{
//                                             if(rowIndex < MainController.tableData.value.length){
//                                               box.deleteAt(rowIndex);
//                                               MainController.tableData.value.removeAt(rowIndex);
//                                               await MainController.loadData();
//                                               MainController.renderPagination();
//                                               Navigator.pop(context);
//                                               setState(() {
//
//                                               });
//                                               print('rowIndex>>>${rowIndex}');
//                                               print('MainController.tableData.value.length>>>>${MainController.tableData.value.length}');
//                                             }
//                                             else{
//                                               print('error');
//                                             }
//                                           },
//                                           child: Container(
//                                             padding: EdgeInsets.all(15),
//                                             width: 52,
//                                             height: 52,
//                                             decoration: BoxDecoration(
//                                                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                                                 color: successColor
//                                             ),
//                                             child: Center(child: Txt('${AppController.of(context)!.value('yes')}' , color: whiteColor,)),
//                                           ),
//                                         )
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               )
//                           );
//                         }
//                     );
//                   },
//                   icon: Icon(CupertinoIcons.trash , color:MainController.isLightMode.value == true ? whiteColor : color3,),
//                 ),
//               ],
//             ),);
//         }))),
//       ),
//     );
//   }
//
//   dynamic _buildExpandableTable() {
//     final visibleColumns = MainController.tableInfo['columns']
//         .where((column) => column['is-show-table'] == true)
//         .toList();
//     List<ExpandableTableHeader>? headers;
//     headers = List.generate(
//       visibleColumns.length,
//           (index) => ExpandableTableHeader(
//         cell: _buildContainerCell(Obx(() {
//           return Center(child: Txt('${visibleColumns[index]['name']}',fontSize: 16, fontWeight: FontWeight.w700, color:MainController.isLightMode.value == true?  whiteColor:color2));
//         })),
//       ),
//     );
//     headers.add(ExpandableTableHeader(
//       cell: _buildContainerCell(Obx((){
//         return Center(child: Txt('${AppController.of(context)!.value('operation')}',fontSize: 16, fontWeight: FontWeight.w700, color:MainController.isLightMode.value == true?  whiteColor:color2));
//       })),
//     ));
//     print('length:${MainController.tableData.length}');
//     return  ExpandableTable(
//       firstHeaderCell: visibleColumns.isNotEmpty ? _buildCell('${visibleColumns.first['name']}') : _buildCell(''),
//       // firstHeaderCell:visibleColumns. _buildCell('${visibleColumns.first['name']}'),
//       rows:MainController.tableData.length>0 ?
//       _generateRows(rowsCount < MainController.tableData.value.length ? rowsCount : MainController.tableData.value.length, visibleColumns)
//           :[],
//       headers: headers,
//       visibleScrollbar: true,
//       expanded: false,
//     );
//   }
//
//   ExpandableTableCell _buildRowCell(Widget rowContent) {
//     return ExpandableTableCell(
//       child: rowContent,
//     );
//   }
//
//   ExpandableTableCell _buildTxtCell(Widget rowContent) {
//     return ExpandableTableCell(
//       child: rowContent,
//     );
//   }
//
//   ExpandableTableCell _buildContainerCell(Widget rowContent) {
//     return ExpandableTableCell(
//         child: Obx((){
//           return Container(
//             decoration: BoxDecoration(border:  Border.all(color: MainController.isLightMode.value == true?  whiteColor:color1),),
//             child: rowContent,
//           );
//         })
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) => Container(
//     child: Obx( () {
//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: _buildExpandableTable(),
//             ),
//           ),
//         ],
//       );
//     }
//     ),
//   );
// }
//
// class _DefaultCellCard extends StatelessWidget {
//   final Widget child;
//
//
//   const _DefaultCellCard({
//     required this.child,
//   });
//
//   @override
//   Widget build(BuildContext context) => Obx(() {
//     return Container(
//       // color:  Colors.white,
//       decoration: BoxDecoration(
//         color: MainController.isLightMode.value == true ? background :whiteColor,
//         border:  Border.all(color: MainController.isLightMode.value == true?  whiteColor:color1),
//       ),
//       margin: const EdgeInsets.all(1),
//       child: child,
//     );
//   }) ;
// }
//
//
//
// class _AppCustomScrollBehavior extends MaterialScrollBehavior {
//   @override
//   Set<PointerDeviceKind> get dragDevices => {
//     PointerDeviceKind.touch,
//     PointerDeviceKind.mouse,
//     PointerDeviceKind.trackpad,
//   };
// }


