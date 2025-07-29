import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class TableHeader extends StatefulWidget {
  const TableHeader({Key? key}) : super(key: key);

  @override
  State<TableHeader> createState() => _TableHeaderState();
}

class _TableHeaderState extends State<TableHeader> {
  List<int> showInfo = [10 , 25 , 50 , 100];
  int  selectedCount =  10;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(left: 15 , right: 15),
      width:size.width ,
      child: size.width > 600 ?
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Txt('${AppController.of(context)!.value('show')}' , color: MainController.isLightMode.value == true?  whiteColor:color1, fontSize: 16, fontWeight: FontWeight.w400,),
              SizedBox(width: 5,),
              Container(
                width: 70,
                child: PopupMenuTheme(
                  data: PopupMenuThemeData(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
                      side: BorderSide(width: borderSize , color: itemColor34),
                    ),
                    color:MainController.isLightMode.value == true? background:whiteColor,
                  ),
                  child: PopupMenuButton<int>(
                    elevation: 0,
                    offset: Offset(0, 45),
                    onSelected: (value) async {
                      setState(() {
                        MainController.tableInfo['countShowRow'] = value;
                        selectedCount = value;
                        MainController.startIndex.value = (MainController.tableInfo['currentPage']-1) * MainController.tableInfo['countShowRow'];
                        MainController.endIndex.value = MainController.startIndex.value + int.parse('${MainController.tableInfo['countShowRow']}');
                        MainController.tableInfo['currentPage'] = 1;
                        // MainController.renderPagination();
                      });
                      MainController.tableData.value= await DB('${MainController.tableInfo['table-name']}').paginate();
                      print('MainController.tableData.value.length g>>>${MainController.tableData.value.length}');
                      print('MainController.tableInfo[countShowRow] f>>>${MainController.tableInfo['countShowRow']}');
                      ViewController.totalPage.value = await DB('${MainController.tableInfo['table-name']}').infoPage();
                    },
                    itemBuilder: (BuildContext context) {
                      return showInfo.map((item) {
                        return PopupMenuItem<int>(
                          value: item,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Txt(
                                  '$item',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: MainController.isLightMode.value == true ? whiteColor : color1,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: MainController.isLightMode.value == true? whiteColor : color1 ),
                        borderRadius: BorderRadius.circular(16),
                        color: MainController.isLightMode.value == true? background : whiteColor,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_drop_down_sharp , size: 20, color:  color1,),
                          SizedBox(width: 5,),
                          Txt('${MainController.tableInfo['countShowRow']}' , fontSize: 14 , fontWeight: FontWeight.w700, color: MainController.isLightMode.value == true? whiteColor : color1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5,),
              Txt('${AppController.of(context)!.value('row')}' , color: MainController.isLightMode.value == true?  whiteColor:color1, fontSize: 16, fontWeight: FontWeight.w400,)
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Txt('${AppController.of(context)!.value('search')}:' , fontSize: 16, fontWeight: FontWeight.w400,color: MainController.isLightMode.value == true ? whiteColor:color1, ),
                    SizedBox(width: 5,),
                    Container(
                      width: 200,
                      child: FormTextField(
                        name: 'search',
                          lable: '${AppController.of(context)!.value('search')}...', onChange: (text){
                          MainController.search(text);
                        setState(() {
                          MainController.tableInfo['currentPage'] = 1;
                        });

                      }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ):
      Column(
        children: [
          Row(
            // crossAxisAlignment: WrapCrossAlignment.center,

            children: [
              Txt('${AppController.of(context)!.value('show')}' , color: MainController.isLightMode.value == true?  whiteColor:color1, fontSize: 16, fontWeight: FontWeight.w400,),
              SizedBox(width: 5,),
              Container(
                width: 70,
                child: PopupMenuTheme(
                  data: PopupMenuThemeData(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
                      side: BorderSide(width: borderSize , color: itemColor34),
                    ),
                    color:MainController.isLightMode.value == true? background:whiteColor,
                  ),
                  child: PopupMenuButton<int>(
                    elevation: 0,
                    offset: Offset(0, 45),
                    onSelected: (value) async {
                      setState(() {
                        MainController.tableInfo['countShowRow'] = value;
                        selectedCount = value;
                        MainController.startIndex.value = (MainController.tableInfo['currentPage']-1) * MainController.tableInfo['countShowRow'];
                        MainController.endIndex.value = MainController.startIndex.value + int.parse('${MainController.tableInfo['countShowRow']}');
                        MainController.tableInfo['currentPage'] =1;
                        // MainController.renderPagination();
                      });
                      MainController.tableData.value= await DB('${MainController.tableInfo['table-name']}').paginate();
                      ViewController.totalPage.value =  (MainController.tableData.value.length / MainController.tableInfo['countShowRow']).ceil();
                    },
                    itemBuilder: (BuildContext context) {
                      return showInfo.map((item) {
                        return PopupMenuItem<int>(
                          value: item,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Txt(
                                  '$item',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: MainController.isLightMode.value == true ? whiteColor : color1,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: MainController.isLightMode.value == true? whiteColor : color1 ),
                        borderRadius: BorderRadius.circular(16),
                        color: MainController.isLightMode.value == true? background : whiteColor,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_drop_down_sharp , size: 20, color:  color1,),
                          SizedBox(width: 5,),
                          Txt('${MainController.tableInfo['countShowRow']}' , fontSize: 14 , fontWeight: FontWeight.w700, color: MainController.isLightMode.value == true? whiteColor : color1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5,),
              Txt('${AppController.of(context)!.value('row')}' , color: MainController.isLightMode.value == true?  whiteColor:color1, fontSize: 16, fontWeight: FontWeight.w400,)
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Txt('${AppController.of(context)!.value('search')}:' , fontSize: 16, fontWeight: FontWeight.w400,color: MainController.isLightMode.value == true ? whiteColor:color1, ),
                    SizedBox(width: 5,),
                    Container(
                      width: 200,
                      child: FormTextField(
                          name: 'search',
                          lable: '${AppController.of(context)!.value('search')}...', onChange: (text){
                        MainController.search(text);
                        setState(() {
                          MainController.tableInfo['currentPage'] = 1;
                        });

                      }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}
