import 'package:finance/Admin/Public/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Public/config.dart';

import '../../../Logic/Controllers/main-controller.dart';

class Loading extends StatelessWidget {
  Function? getLoadedComponent;
  List<String>?loadingName;
  double?height,width,size;
  double?strokeWidth;
  Color?color;
  Loading({this.height,this.color,this.width,this.size,this.getLoadedComponent,this.strokeWidth,this.loadingName});
  Color defultColor=MainController.isLightMode.value == false ? color6.withOpacity(0.5):background.withOpacity(0.5);
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Obx((){
      return
          AppController.hasLoadingList(this.loadingName!) ?
          Container(
            width:width!=null?width:size.width ,
            height:height!=null?height: size.height,
            color: this.color,
            child:  Stack(
              children: [
                Container(
                  color:  this.color??defultColor,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colorBtn,
                      strokeWidth: 4,
                    ),
                  ),
                ),
              ],
            ),
          ) : this.getLoadedComponent != null ? getLoadedComponent!() : Container();
      });
  }
}
