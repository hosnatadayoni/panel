import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';

class TableFooter extends StatefulWidget {
  var index;
   TableFooter({this.index}) ;

  @override
  State<TableFooter> createState() => _TableFooterState();
}

class _TableFooterState extends State<TableFooter> {
  Rx<int> indexTable = 0.obs;
  Rx<String> tableSelected = ''.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      indexTable.value =
          widget.index ?? MainController.selectedSubItem.value;
      tableSelected.value =
      MainController.menuList[indexTable.value].schema.name!;
      MainController.infoSchema.value =
      MainController.menuList[indexTable.value];
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx((){
      return Container(
        child: size.width > 556 ?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: pagenationBox( MainController.pageInfo[tableSelected.value]!=null?MainController.pageInfo[tableSelected.value]!.totalPage:1, tableSelected.value),
        ) :
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: pagenationBox( MainController.pageInfo[tableSelected.value]!=null?MainController.pageInfo[tableSelected.value]!.totalPage:1, tableSelected.value),
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
            MainController.infoSchema.value.schema.currentPage = i;
          });
          print('_TableFooterState.box currentPage>>>${i}>>>${MainController.infoSchema.value.schema.currentPage} ${MainController.infoSchema.value.schema.name}');
         await HelperController.pageInateFunction();
          MainController.allData.value = MainController.dataRecord;
          print('_TableFooterState.box>>>>>${{MainController.dataRecord.value.length}}');
        },
        child: Container(
            margin: EdgeInsets.only(right: Directionality.of(context) == TextDirection.ltr ? 5  : 0 , left:Directionality.of(context) == TextDirection.rtl ? 5  : 0  ),
            width: 40,
            height: 40,
            child: Obx((){
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:isHover.value == true  ? colorBtn:i ==MainController.infoSchema.value.schema.currentPage ? colorBtn : Colors.blue,
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
    // print('_TableFooterState.pagenationBox>>>${MainController.infoSchema.value.schema.name}>>>${MainController.pageInfo[MainController.infoSchema.value.schema.name]}');
    // print('_TableFooterState.pagenationBox>>${MainController.infoSchema.value.schema.name}>>${MainController.pageInfo[MainController.infoSchema.value.schema.name]!.totalRecords}');
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
              Txt('${MainController.dataRecord.value.length == 0 ? 0 : (MainController
                  .pageInfo[MainController.infoSchema.value.schema.name]
                  ?.start ??
                  0) + 1}',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: color3,),
              Txt('${AppController.of(context)!.value('until')}',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: color3,),
              Txt('${ (MainController.pageInfo[MainController.infoSchema.value.schema.name]?.end??0 ) }', fontSize: 16,
                fontWeight: FontWeight.w400,
                color: color3,),
              Txt('${AppController.of(context)!.value('from')}',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: color3,),
              Txt('${(MainController.pageInfo[MainController.infoSchema.value.schema.name]?.totalRecords ?? 0)}',
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
                  .infoSchema.value.schema.currentPage > 1
                  ? color3
                  : color7,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(15)),
              onPressed: MainController
                  .infoSchema.value.schema.currentPage > 1 ? () async {
                setState(() {
                  MainController.infoSchema.value.schema.currentPage --;
                });
                await HelperController.pageInateFunction();

                // MainController.dataRecord.value= await DB('${tableSelected}').paginate();
              } : null,
              child: Txt('${AppController.of(context)!.value(
                  'previous')}', color: MainController
                  .infoSchema.value.schema.currentPage > 1
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
              color: MainController.infoSchema.value.schema.currentPage <
                  totalPages
                  ? color3
                  : color7,
            ),
            child: Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15)),
                onPressed: MainController
                    .infoSchema.value.schema.currentPage <
                    totalPages ? () async {
                  setState(() {
                    MainController.infoSchema.value.schema.currentPage++;
                  });
                  await HelperController.pageInateFunction();

                  //MainController.dataRecord.value= await DB('${tableSelected}').paginate();

                } : null,
                child: Txt(
                  '${AppController.of(context)!.value('next')}',
                  color: MainController
                      .infoSchema.value.schema.currentPage <
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
                    .infoSchema.value.schema.currentPage > 1
                    ? color3
                    : color7,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15)),
                onPressed: MainController
                    .infoSchema.value.schema.currentPage> 1 ? () async {
                  setState(() {
                    MainController.infoSchema.value.schema.currentPage--;
                  });
                  // MainController.renderPagination();
                 await HelperController.pageInateFunction();

                  // MainController.dataRecord.value= await DB('${tableSelected}').paginate();
                } : null,
                child: Txt('${AppController.of(context)!.value(
                    'previous')}', color: MainController
                    .infoSchema.value.schema.currentPage > 1
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
                color: MainController.infoSchema.value.schema.currentPage <
                    totalPages
                    ? color3
                    : color7,
              ),
              child: Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15)),
                  onPressed: MainController
                      .infoSchema.value.schema.currentPage<
                      totalPages ? () async {
                    setState(() {
                      MainController.infoSchema.value.schema.currentPage++;
                    });
                    // MainController.renderPagination();
                    await HelperController.pageInateFunction();

                   /// MainController.dataRecord.value= await DB('${tableSelected}').paginate();

                  } : null,
                  child: Txt(
                    '${AppController.of(context)!.value('next')}',
                    color: MainController
                        .infoSchema.value.schema.currentPage <
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