import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-footer.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import '../../General/txt.dart';

class MainTableBox extends StatefulWidget {

  MainTableBox();

  @override
  State<MainTableBox> createState() => _MainTableBoxState();
}
class _MainTableBoxState extends State<MainTableBox> {
  late List<Future<Widget>> _futures;

  @override
  void initState() {
    super.initState();
    if(MainController.tableInfo['schema']['filters'] != null){
      _futures = MainController.tableInfo['schema']['filters']
          .map<Future<Widget>>((filter) => ViewController.generateFilterView(filter))
          .toList();
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MainController.isLightMode.value == true ? background :whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: MainController.isLightMode.value == true ?background:dark2 )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColumnScroll(
            children: [
              TableHeader(),
              if(MainController.tableInfo['schema']['filters']!=null && MainController.tableInfo['schema']['filters'].length!=0)
                Container(
                  width:size.width > 800 ? MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50 : (size.width) - 50,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (var future in _futures)
                        FutureBuilder<Widget>(
                          future: future,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return snapshot.data ?? Container();
                            }
                          },
                        ),
                    ],
                  ),
                ),

              // Container(
              //   color: Colors.blue,
              //   child: FutureBuilder<Widget>(
              //     future: ViewController.generateFilterView(filter , context),
              //     builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return CircularProgressIndicator();
              //       } else if (snapshot.hasError) {
              //         return Txt('${AppController.of(context)!.value('error')}: ${snapshot.requireData}');
              //       } else {
              //         return Wrap(
              //           children: [
              //             snapshot.data ?? Container()
              //           ],
              //         );
              //       }
              //     },
              //   ),
              // ),
              if(MainController.tableInfo['schema']['filters']!=null &&MainController.tableInfo['schema']['filters'].length!=0)
                Container(
                  margin: EdgeInsets.only(left: 5),
                  width: 140,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    onPressed: () async {
                      List<dynamic>w=MainController.tableInfo['schema']['filters'];
                      String opration='\$eq';
                      if(ViewController.request.length!=0){
                        var d;
                        List<dynamic> d2=await DB('${MainController.tableInfo['schema']['name']}').getRecords();
                        var a= DB('${MainController.tableInfo['schema']['name']}');
                        for(var filter in ViewController.request.values){
                          var indexFilter=w.indexWhere((element) => element['column']==filter['column']);
                          if(w[indexFilter]['operator']!=null){

                            opration=w[indexFilter]['operator'];
                          }
                          if(filter['value']!='' && filter['value']!=null){

                            d=a.where('${filter['column']}','${filter['operator']}',filter['value']);
                          }
                        }
                        if(d!=null){
                          d2=await d.getRecords();

                        }
                        MainController.tableData.value=d2;

                      }},
                    child: Center(child: Txt('${AppController.of(context)!.value('apply')}', textAlign: TextAlign.center)),
                  ),
                ),
              SizedBox(height: 10,),
              TableBox(),
              SizedBox(height: 20,),
              TableFooter(),
            ],
          ),
        ],
      ),
    );
  }
}