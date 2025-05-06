import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/column-scroll.dart';
import 'package:finance/UI/Componenets/Items/Table/table-footer.dart';
import 'package:finance/UI/Componenets/Items/Table/table-header.dart';
import 'package:finance/UI/Componenets/Items/Table/table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Logic/Controllers/app-controller.dart';
import '../../../../Logic/Models/db.dart';
import '../../General/txt.dart';

class MainTableBox extends StatefulWidget {

   MainTableBox();

  @override
  State<MainTableBox> createState() => _MainTableBoxState();
}
late Future<Widget> _future;

// @override
// void initState() {
//   _future =;
// }
class _MainTableBoxState extends State<MainTableBox> {
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
              if(MainController.tableInfo['filters']!=null && MainController.tableInfo['filters'].length!=0)
                for(var filter in MainController.tableInfo['filters'])
                FutureBuilder<Widget>(
                  future: ViewController.generateFilterView(filter),
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
              if(MainController.tableInfo['filters']!=null &&MainController.tableInfo['filters'].length!=0)
                Container(
                  margin: EdgeInsets.only(left: 5),
                  width: 140,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    onPressed: () async {
                      List<dynamic> d=await DB('${MainController.tableInfo['table-name']}').getRecords();
                      List<dynamic> d2=[];
                      print('request>>${ViewController.request}');
                      for(var filter in ViewController.request.keys){
                        if(ViewController.request[filter]!=''){
                          print('ViewController.request[filter]>>>${ViewController.request[filter].runtimeType}');
                          d=await DB('${MainController.tableInfo['table-name']}').where('${filter}','==',ViewController.request[filter]).getRecords();
                        }
                      }
                      MainController.tableData.value=d;
                      print('filter btn >>>${d}>>${MainController.tableInfo['table-name']}');
                      print('filter bttn >>>${d2}>>${MainController.tableInfo['table-name']}');
                    },
                    child: Center(child: Txt('اعمال', textAlign: TextAlign.center)),
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
