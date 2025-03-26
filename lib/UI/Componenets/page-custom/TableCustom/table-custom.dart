import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/Logic/Models/dataModel.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Form/form-checkBox.dart';
import 'package:finance/UI/Views/edit.dart';
import 'package:finance/boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:finance/Logic/Controllers/dataController.dart';

class TableCustomBox extends StatefulWidget {
  const TableCustomBox({Key? key}) : super(key: key);

  @override
  State<TableCustomBox> createState() => _TableCustomBoxState();
}

class _TableCustomBoxState extends State<TableCustomBox> {
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
      List<dynamic> columnList = ViewController.getColumnList('order-item');

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
                // defaultColumnWidth: FixedColumnWidth(200.0),
                defaultColumnWidth: FixedColumnWidth((columnList.length > 8 ? 200.0 : size.width / (columnList.length + 1))),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.all(color: MainController.isLightMode.value == true?  whiteColor:color1),
                children: [
                  TableRow(children: [
                    for(var i =0 ; i<columnList.length;i++)
                      if(columnList[i]['is-show-table'] == true)
                        Center(child: Container(
                            padding: EdgeInsets.all(10),
                            child: Txt('${columnList[i]['name']}',fontSize: 16, fontWeight: FontWeight.w700, color:MainController.isLightMode.value == true?  whiteColor:color2))),

                    Container(
                        padding: EdgeInsets.all(10),
                        child: Center(child: Txt('${AppController.of(context)!.value('operation')}',fontSize: 16, fontWeight: FontWeight.w700, color:MainController.isLightMode.value == true?  whiteColor:color2)))
                  ]
                  ),
                  for(var i=MainController.startIndex.value ; i<MainController.endIndex.value; i++)
                    if(MainController.tableData.value.length > i)
                      TableRow(
                          children: [
                            for(var j =0 ; j<columnList.length;j++)
                              if(columnList[j]['is-show-table'] == true)
                                if (columnList[j]['type'] == 'string' ||
                                    columnList[j]['type'] == 'number' ||
                                    columnList[j]['type'] == 'date'||
                                    columnList[j]['type'] == 'mobile' ||
                                    columnList[j]['type'] == 'email'
                                )
                                  Center(
                                    child: Container(
                                      child: Txt(
                                        '${MainController.tableData.value[i].data[columnList[j]['name']] != null ? MainController.tableData.value[i].data[columnList[j]['name']]:''}',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: MainController.isLightMode.value == true ? whiteColor : color2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                else if (columnList[j]['type'] == 'checkbox')
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: CheckBox(
                                        checkBoxName: '${MainController.tableData.value[i].data[columnList[j]['name']]}',
                                        checkBoxTitle: '',
                                        defaultValue: MainController.tableData.value[i].data[columnList[j]['name']],
                                        onChange: (text) async {
                                          DataModel dataModel = MainController.tableData.value[i];
                                          dataModel.data['${MainController.SubMenuList[MainController.selectedSubItem.value]['columns'][j]['name']}'] = text;
                                          final data = DataModel(
                                            id: dataModel.id,
                                            data: dataModel.data,
                                          );
                                          dataController.allData.value[i] = data;
                                          MainController.tableData.value[i] = data;
                                          await box.putAt(i, data);

                                        },
                                        index: i,

                                      ),
                                    ),
                                  )
                                else if (columnList[j]['type'] == 'color')
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: MainController.tableData.value[i].data[columnList[j]['name']] != null
                                          ? Center(
                                            child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Color(int.parse('${MainController.tableData.value[i].data[columnList[j]['name']]}')),
                                      ),
                                          )
                                          : Container(),
                                    )
                                  // Center(
                                  //   child: Container(
                                  //     padding: EdgeInsets.all(10),
                                  //     child: Checkbox(
                                  //       value: MainController.tableData.value[i].data[columnList[j]['name']] ?? false,
                                  //       onChanged: (bool? value) {
                                  //         setState(() {
                                  //           MainController.tableData.value[i].data[columnList[j]['name']] = value ?? false;
                                  //         });
                                  //       },
                                  //     ),
                                  //   ),
                                  // ),




                                // FutureBuilder<Widget>(
                                //   future:ViewController.generateDataColumn(j,i),
                                //   builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                                //     if (snapshot.connectionState == ConnectionState.waiting) {
                                //       return CircularProgressIndicator();
                                //     } else if (snapshot.hasError) {
                                //       return Txt('${AppController.of(context)!.value('error')}: ${snapshot.error}');
                                //     } else {
                                //       return snapshot.data ?? Container();
                                //     }
                                //   },
                                // ),
                            // ViewController.generateDataColumn(j,i),
                            // Txt('${MainController.tableData.value[i].data['a']}', fontSize: 14, fontWeight: FontWeight.w500, color: MainController.isLightMode.value == true ? whiteColor : color2, textAlign: TextAlign.center,),
                            // Txt('${MainController.tableData.value[i].data['b']}',fontSize: 14, fontWeight: FontWeight.w500, color: MainController.isLightMode.value == true ? whiteColor : color2, textAlign: TextAlign.center,),
                            // Txt('${MainController.tableData.value[i].data['c']}',fontSize: 14, fontWeight: FontWeight.w500, color: MainController.isLightMode.value == true ? whiteColor : color2, textAlign: TextAlign.center,),
                                else if(columnList[j]['type'] == 'select')
                                      FutureBuilder<String>(
                                      future:ViewCustomController.getTitleSelectBoxFormCustom(columnList[j] , MainController.tableData.value[i]),
                                      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                         return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Txt('${AppController.of(context)!.value('error')}');
                                      }
                                      else{
                                        final data = snapshot.data!;
                                        return Center(
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Txt(
                                              '${data}',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: MainController.isLightMode.value == true ? whiteColor : color2,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }
                                      }
                                      )
                                else if(columnList[j]['type'] == 'multiSelect')
                                        FutureBuilder<String>(
                                            future:ViewCustomController.getTitleMultiSelctBoxFormCustom(columnList[j] , MainController.tableData.value[i]),
                                            builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Txt('${AppController.of(context)!.value('error')}');
                                              }
                                              else{
                                                final data = snapshot.data!;
                                                return Center(
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Txt(
                                                      '${data}',
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                      color: MainController.isLightMode.value == true ? whiteColor : color2,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                        )
                                else if(columnList[j]['type'] == 'radiobutton')
                                        FutureBuilder<String>(
                                              future:ViewCustomController.getTitleSelectBoxFormCustom(columnList[j] , MainController.tableData.value[i]),
                                              builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  return Txt('${AppController.of(context)!.value('error')}');
                                                }
                                                else{
                                                  final data = snapshot.data!;
                                                  return Center(
                                                    child: Container(
                                                      padding: EdgeInsets.all(10),
                                                      child: Txt(
                                                        '${data}',
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        color: MainController.isLightMode.value == true ? whiteColor : color2,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                          )
                                else if(columnList[j]['type'] == 'file')
                                        Obx(() {
                                              return Center(
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: Txt(
                                                    '${MainController.tableData.value[i].data[columnList[j]['name']] != null ? MainController.tableData.value[i].data[columnList[j]['name']].length != 0 ? MainController.tableData.value[i].data[columnList[j]['name']] :'':''}',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: MainController.isLightMode.value == true ? whiteColor : color2,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              );
                                            }),




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
              ),),
          )
      );
    });
  }
}