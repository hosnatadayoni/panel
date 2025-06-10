import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Models/db.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
class TableFooter extends StatefulWidget {
  const TableFooter({Key? key}) : super(key: key);

  @override
  State<TableFooter> createState() => _TableFooterState();
}

class _TableFooterState extends State<TableFooter> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var tableSelected = MainController.SubMenuList[MainController.selectedSubItem.value]['table-name'];
    return  FutureBuilder<dynamic>(
      future: DB(tableSelected).infoPage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        int totalPages = snapshot.data!;
        return Container(
          child: size.width > 556 ?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // alignment:WrapAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: Row(
                  children: [
                    Txt('${AppController.of(context)!.value('show')}',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: color3,),
                    Txt('${MainController.tableData.value.length == 0
                        ? 0
                        : MainController.startIndex.value + 1}',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: color3,),
                    Txt('${AppController.of(context)!.value('until')}',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: color3,),
                    Txt('${MainController.endIndex.value}', fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: color3,),
                    Txt('${AppController.of(context)!.value('from')}',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: color3,),
                    Txt('${MainController.tableData.value.length}',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: color3,),
                    Txt('${AppController.of(context)!.value('row')}',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: color3,),
                  ],
                ),
              ),
              Expanded(child: Container(
                child:
                Wrap(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5)),
                        color: MainController
                            .tableInfo['currentPage'] > 1
                            ? color3
                            : color7,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15)),
                        onPressed: MainController
                            .tableInfo['currentPage'] > 1 ? () async {
                          setState(() {
                            MainController.tableInfo['currentPage']--;
                          });
                          // MainController.renderPagination();
                          MainController.tableData.value= await DB('${tableSelected}').pageInate();
                        } : null,
                        child: Txt('${AppController.of(context)!.value(
                            'previous')}', color: MainController
                            .tableInfo['currentPage'] > 1
                            ? whiteColor
                            : color3),
                      ),
                    ),
                    SizedBox(width: 5,),
                    if (totalPages > 5) ...[
                      box(1, tableSelected),
                      box(2, tableSelected),
                      SizedBox(width: 5),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        width: 40,
                        height: 40,
                        child: Center(child: Txt('...', fontSize: 20)),
                      ),
                      SizedBox(width: 5),
                      box(totalPages - 1, tableSelected),
                      box(totalPages, tableSelected),
                    ] else ...[
                      for (var i = 1; i <= totalPages; i++)
                        box(i, tableSelected),
                    ],
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5)),
                        color: MainController.tableInfo['currentPage'] <
                            totalPages
                            ? color3
                            : color7,
                      ),
                      child: Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15)),
                          onPressed: MainController
                              .tableInfo['currentPage'] <
                              totalPages ? () async {
                            setState(() {
                              MainController.tableInfo['currentPage']++;
                            });
                            // MainController.renderPagination();
                            MainController.tableData.value= await DB('${tableSelected}').pageInate();

                          } : null,
                          child: Txt(
                            '${AppController.of(context)!.value('next')}',
                            color: MainController
                                .tableInfo['currentPage'] <
                                totalPages
                                ? whiteColor
                                : color3,),
                        ),
                      ),
                    ),
                  ],
                ),

              )),
            ],
          ) :
          Column(
            children: [
              Row(
                children: [
                  Txt('${AppController.of(context)!.value('show')}',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: color3,),
                  Txt('${MainController.tableData.value.length == 0
                      ? 0
                      : MainController.startIndex.value + 1}', fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: color3,),
                  Txt('${AppController.of(context)!.value('until')}',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: color3,),
                  Txt('${MainController.endIndex.value}', fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: color3,),
                  Txt('${AppController.of(context)!.value('from')}',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: color3,),
                  Txt('${MainController.tableData.value.length}',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: color3,),
                  Txt('${AppController.of(context)!.value('row')}',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: color3,),
                ],
              ),
              SizedBox(height: 5,),
              Obx(() {
                return Container(
                  child:
                  Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(5)),
                          color: MainController.tableInfo['currentPage'] > 1
                              ? color3
                              : color7,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15)),
                          onPressed: MainController
                              .tableInfo['currentPage'] > 1 ? () {
                            setState(() {
                              MainController.tableInfo['currentPage']--;
                            });
                            MainController.renderPagination();
                          } : null,
                          child: Txt('${AppController.of(context)!.value(
                              'previous')}', color: MainController
                              .tableInfo['currentPage'] > 1
                              ? whiteColor
                              : color3),
                        ),
                      ),
                      SizedBox(width: 5,),
                      // if (MainController.totalPages.value >= 5) ...[
                      //   Container(
                      //     margin: EdgeInsets.only(left: 5),
                      //     width: 40,
                      //     height: 40,
                      //     child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //           primary: MainController
                      //               .tableInfo['currentPage'] == 1
                      //               ? colorBtn
                      //               : Colors.blue),
                      //       onPressed: () {
                      //         setState(() {
                      //           MainController.tableInfo['currentPage'] = 1;
                      //         });
                      //         MainController.renderPagination();
                      //       },
                      //       child: Center(child: Txt(
                      //           '1', textAlign: TextAlign.center)),
                      //     ),
                      //   ),
                      //   Container(
                      //     margin: EdgeInsets.only(left: 5),
                      //     width: 40,
                      //     height: 40,
                      //     child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //           primary: MainController
                      //               .tableInfo['currentPage'] == 2
                      //               ? colorBtn
                      //               : Colors.blue),
                      //       onPressed: () {
                      //         setState(() {
                      //           MainController.tableInfo['currentPage'] = 2;
                      //         });
                      //         MainController.renderPagination();
                      //       },
                      //       child: Center(child: Txt(
                      //           '2', textAlign: TextAlign.center)),
                      //     ),
                      //   ),
                      //   SizedBox(width: 5,),
                      //   Txt('...', fontSize: 20),
                      //   SizedBox(width: 5,),
                      //   Container(
                      //     margin: EdgeInsets.only(left: 5),
                      //     // width: 45,
                      //     // height: 45,
                      //     child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //         primary: MainController
                      //             .tableInfo['currentPage'] ==
                      //             MainController.totalPages.value - 1
                      //             ? colorBtn
                      //             : Colors.blue,
                      //         padding: EdgeInsets.all(15),),
                      //       onPressed: () {
                      //         setState(() {
                      //           MainController.tableInfo['currentPage'] =
                      //               MainController.totalPages.value - 1;
                      //         });
                      //         MainController.renderPagination();
                      //       },
                      //       child: Center(child: Txt(
                      //           '${MainController.totalPages.value - 1}',
                      //           textAlign: TextAlign.center)),
                      //     ),
                      //   ),
                      //   Container(
                      //     margin: EdgeInsets.only(left: 5),
                      //     // width: 45,
                      //     // height: 45,
                      //     child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //           primary: MainController
                      //               .tableInfo['currentPage'] ==
                      //               MainController.totalPages.value
                      //               ? colorBtn
                      //               : Colors.blue,
                      //           padding: EdgeInsets.all(15)),
                      //       onPressed: () {
                      //         setState(() {
                      //           MainController.tableInfo['currentPage'] =
                      //               MainController.totalPages.value;
                      //         });
                      //         MainController.renderPagination();
                      //       },
                      //       child: Center(child: Txt(
                      //           '${MainController.totalPages.value}',
                      //           textAlign: TextAlign.center)),
                      //     ),
                      //   ),
                      // ] else
                      //   ... [
                      //     ...List.generate(
                      //         MainController.totalPages.value, (index) {
                      //       return Container(
                      //         margin: EdgeInsets.only(left: 5),
                      //         child: ElevatedButton(
                      //           style: ElevatedButton.styleFrom(
                      //             primary: MainController
                      //                 .tableInfo['currentPage'] == index + 1
                      //                 ? colorBtn
                      //                 : Colors.blue,
                      //             padding: EdgeInsets.all(15),),
                      //           onPressed: () {
                      //             setState(() {
                      //               MainController
                      //                   .tableInfo['currentPage'] =
                      //                   index + 1;
                      //             });
                      //             MainController.renderPagination();
                      //           },
                      //           child: Center(child: Txt('${index + 1}',
                      //               textAlign: TextAlign.center)),
                      //         ),
                      //       );
                      //     }),
                      //   ],
                      if (totalPages > 5) ...[
                        box(1, tableSelected),
                        box(2, tableSelected),
                        SizedBox(width: 5),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          width: 40,
                          height: 40,
                          child: Center(child: Txt('...', fontSize: 20)),
                        ),
                        SizedBox(width: 5),
                        box(totalPages - 1, tableSelected),
                        box(totalPages, tableSelected),
                      ] else ...[
                        for (var i = 1; i <= totalPages; i++)
                          box(i, tableSelected),
                      ],
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(5)),
                          color: MainController.tableInfo['currentPage'] <
                              MainController.totalPages.value
                              ? color3
                              : color7,
                        ),
                        child: Container(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(15)),
                            onPressed: MainController
                                .tableInfo['currentPage'] <
                                MainController.totalPages.value ? () {
                              setState(() {
                                MainController.tableInfo['currentPage']++;
                              });
                              MainController.renderPagination();
                            } : null,
                            child: Txt(
                              '${AppController.of(context)!.value('next')}',
                              color: MainController
                                  .tableInfo['currentPage'] <
                                  MainController.totalPages.value
                                  ? whiteColor
                                  : color3,),
                          ),
                        ),
                      ),
                    ],
                  ),

                );
                // return Container(
                //   width:500,
                //   child: Wrap(
                //     runSpacing:10,
                //     // spacing:10,
                //     children: <Widget>[
                //       Container(
                //         height:40,
                //         decoration:BoxDecoration(
                //           borderRadius: BorderRadius.all(Radius.circular(5)),
                //           color:MainController.table['currentPage'] > 1  ? color3 :color7,
                //         ),
                //         child: ElevatedButton(
                //           onPressed:
                //           MainController.table['currentPage'] > 1 ? () {
                //             setState(() {
                //               MainController.table['currentPage']--;
                //             });
                //             MainController.renderPagination();
                //           } : null,
                //           child: Txt('${AppController.of(context)!.value('previous')}' , color: MainController.table['currentPage'] > 1 ? whiteColor : color3,),
                //         ),
                //       ),
                //       SizedBox(width: 5,),
                //       Container(
                //         child: Wrap(
                //           runSpacing:10,
                //           children: List.generate(MainController.totalPages.value, (index) {
                //             return Container(
                //               margin: EdgeInsets.only(left: 5),
                //               width: 40,
                //               height: 40,
                //               child: ElevatedButton(
                //                 style: ElevatedButton.styleFrom(primary: MainController.table['currentPage'] == index+1 ? colorBtn:Colors.blue),
                //                 onPressed: () {
                //                   setState(() {
                //                     MainController.table['currentPage'] = index + 1;
                //                   });
                //                   MainController.renderPagination();
                //                 },
                //                 child: Center(child: Txt('${index + 1}' , textAlign: TextAlign.center)),
                //               ),
                //             );
                //           }),
                //         ),
                //       ),
                //       Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.all(Radius.circular(5)),
                //           color:MainController.table['currentPage'] < MainController.totalPages.value ? color3 :color7,
                //         ),
                //         child: Container(
                //           height:40,
                //           child: ElevatedButton(
                //             onPressed: MainController.table['currentPage'] < MainController.totalPages.value  ? () {
                //               setState(() {
                //                 MainController.table['currentPage']++;
                //               });
                //               MainController.renderPagination();
                //             } : null,
                //             child: Txt('${AppController.of(context)!.value('next')}' , color: MainController.table['currentPage'] < MainController.totalPages.value ? whiteColor : color3,),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // );
              }),
            ],
          ),
        );
      },
    );
  }
  Widget box(int i , tableSelected){
    Rx<bool> isHover = false.obs;
    return MouseRegion(
      onEnter: (_){
        isHover.value = true;
      },
      onExit: (_){
        isHover.value = false;
      },
      child: InkWell(
        onTap: ()async{

          setState(() {
            MainController.tableInfo['currentPage'] = i;
          });
           MainController.tableData.value= await DB('${tableSelected}').pageInate();
            print('_TableFooterState.box>>>${MainController.tableData.value}');

        },
        child: Container(
            margin: EdgeInsets.only(left: 5),
            width: 40,
            height: 40,
            child: Obx((){
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:isHover.value == true  ? colorBtn:i ==MainController.tableInfo['currentPage'] ? colorBtn : Colors.blue,
                ),
                // onPressed: () {
                //   setState(() {
                //     MainController.tableInfo['currentPage'] = 1;
                //   });
                //   MainController.renderPagination();
                // },
                child: Center(child: Txt('${i}', textAlign: TextAlign.center , color: whiteColor,)),
              );
            })
        ),
      ),
    );
  }

}
