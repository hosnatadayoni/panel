import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
class TableFooter extends StatefulWidget {
  const TableFooter({Key? key}) : super(key: key);

  @override
  State<TableFooter> createState() => _TableFooterState();
}

class _TableFooterState extends State<TableFooter> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // var tableSelected = MainController.SubMenuList[MainController.selectedSubItem.value]['table-name'];


    return Obx((){
      return Container(
        child: size.width > 556 ?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // children: pagenationBox(ViewController.totalPage.value , tableSelected),
          children: pagenationBox(ViewController.totalPage.value , MainController.tableName.value),
        ) :
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // children: pagenationBox(ViewController.totalPage.value , tableSelected),
          children: pagenationBox(ViewController.totalPage.value , MainController.tableName.value),
        ),);
    });
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
          HelperController.pageInateFunction();
          // MainController.tableData.value= await DB('${tableSelected}').paginate();
          // MainController.allData.value= MainController.tableData.value;
        },
        child: Container(
            margin: EdgeInsets.only(right: Directionality.of(context) == TextDirection.ltr ? 5  : 0 , left:Directionality.of(context) == TextDirection.rtl ? 5  : 0  ),
            width: 40,
            height: 40,
            child: Obx((){
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:isHover.value == true  ? colorBtn:i ==MainController.tableInfo['currentPage'] ? colorBtn : Colors.blue,
                ),
                child: Center(child: Txt('${i}', textAlign: TextAlign.center , color: whiteColor,)),
              );
            })
        ),
      ),
    );
  }

  List<Widget> pagenationBox(totalPages , tableSelected){
    var size = MediaQuery.of(context).size;

    return [
      Obx((){
        return Container(
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
        );
      }),
      size.width > 556 ?
      Expanded(child: Wrap(
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
                HelperController.pageInateFunction();

                // MainController.tableData.value= await DB('${tableSelected}').paginate();
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
              margin: EdgeInsets.only(right: Directionality.of(context) == TextDirection.ltr ? 5  : 0 , left:Directionality.of(context) == TextDirection.rtl ? 5  : 0  ),
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
                  HelperController.pageInateFunction();

                  // MainController.tableData.value= await DB('${tableSelected}').paginate();

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
      )):
      Container(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: Wrap(
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
                  HelperController.pageInateFunction();
                  // MainController.tableData.value= await DB('${tableSelected}').paginate();
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
                margin: EdgeInsets.only(right: Directionality.of(context) == TextDirection.ltr ? 5  : 0 , left:Directionality.of(context) == TextDirection.rtl ? 5  : 0  ),
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
                    HelperController.pageInateFunction();
                    // MainController.tableData.value= await DB('${tableSelected}').paginate();

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
      )
    ];

  }

}