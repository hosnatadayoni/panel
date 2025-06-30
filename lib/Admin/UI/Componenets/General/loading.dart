import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Public/config.dart';

class Loading extends StatelessWidget {
  Function? getLoadedComponent;
  List<String>?loadingName;
  double?height,width,size;
  double?strokeWidth;
  Color?color;
  Loading({this.height,this.color,this.width,this.size,this.getLoadedComponent,this.strokeWidth,this.loadingName});
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
                  color:  this.color??Colors.white.withOpacity(0.9),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: appColor,
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
