import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/column-scroll.dart';
import 'package:finance/UI/Componenets/Items/Table/table-footer.dart';
import 'package:finance/UI/Componenets/Items/Table/table-header.dart';
import 'package:finance/UI/Componenets/Items/Table/table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainTableBox extends StatelessWidget {
  const MainTableBox({Key? key}) : super(key: key);

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
