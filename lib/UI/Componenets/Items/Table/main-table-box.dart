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
    print('_MainTableBoxState.build>>\$eq>>${MainController.tableInfo}>>>${MainController.tableInfo['filters']}');
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
                      return Txt('${AppController.of(context)!.value('error')}: ${snapshot.requireData}');
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
                      List<dynamic>w=MainController.tableInfo['filters'];
                      String opration='\$eq';
                      if(ViewController.request.length!=0){
                        print('_MainTableBoxState.build>>>2>>${ViewController.request.values}');
                        var d;
                        List<dynamic> d2=await DB('${MainController.tableInfo['table-name']}').getRecords();
                        var a= DB('${MainController.tableInfo['table-name']}');
                      for(var filter in ViewController.request.values){
                        print('_MainTableBoxState.build>>>${filter}');
                          var indexFilter=w.indexWhere((element) => element['column']==filter['column']);
                        if(w[indexFilter]['oprator']!=null){

                            opration=w[indexFilter]['oprator'];
                        }
                        if(filter['value']!='' && filter['value']!=null){

                          d=a.where('${filter['column']}','${filter['oprator']}',filter['value']);
                        }
                      }
                      if(d!=null){
                        d2=await d.getRecords();

                      }
                      MainController.tableData.value=d2;

                    }},
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
