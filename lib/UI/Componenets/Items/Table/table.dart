import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/dataController.dart';
import 'package:finance/Logic/Controllers/helper-controller.dart';
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

import '../../../../Logic/Controllers/view-custom-controller.dart';
import '../../../../Logic/Models/db.dart';
import '../../../Views/table-page.dart';

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
    _scrollController.addListener(() {

    });
    var size = MediaQuery.of(context).size;
    for(var i=MainController.startIndex.value ; i<MainController.endIndex.value; i++){
      print('k90000>>>${MainController.tableData.value[i].data}');
    }
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
              // defaultColumnWidth: FixedColumnWidth((size.width)  / (MainController.tableInfo['columns'].length + 1 )),
              defaultColumnWidth: FixedColumnWidth((MainController.tableInfo['columns'].length > 8 ? 200.0 : size.width / (MainController.tableInfo['columns'].length + 1))),
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
                                      HelperController.editPageFunction(MainController.tableData.value[i]);
                                      // Get.to(() =>
                                      //     EditPage(data: MainController.tableData.value[i], index: i,));
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
                                                                setState(()  {
                                                                  DB('${MainController.tableInfo['table-name']}').where('id', '==', '${MainController.tableData.value[i].id}').deleteRecord();
                                                                });
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
                                    if(MainController.tableInfo['relations'].length!=0)
                                      for(var item in MainController.tableInfo['relations'])
                                      InkWell(
                                        onTap: () async {
                                          var items=await DB('${item['table-name']}').parent(parentId:MainController.tableData.value[i].id ,parentTable:MainController.tableInfo['table-name']).getRecords();

                                          for(var item in items){
                                            print('_TableBoxState.build>>${MainController.tableData.value[i]}');
                                            print('_TableBoxState.build>>${item.values}');
                                            MainController.tableData.add(item.values);
                                          }

                                          MainController.tableInfo=MainController.SubMenuList.where((element) => element['table-name']==item['table-name']);
                                          print('_TableBoxState.build>>${MainController.tableInfo}');
                                          // await MainController.loadData(tableData: ViewCustomController.getDataTable(item['table-name']));
                                          Get.to(() => TablePage());
                                          },
                                        child: Container(
                                          child: Text(item['title']),
                                        ),
                                      )
                                  ],
                                ) ),
                          )
                        ])
              ],
            )
          ),
        )
      );
    });
  }
}

