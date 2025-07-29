import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panel/Admin/Logic/Controllers/app-controller.dart';
import 'package:panel/Admin/Public/config.dart';




class Loading extends StatelessWidget {
  double? width,height;
  String?loadingTag;
  Function? getLoadedComponent;
  Color? color;

  Loading({this.getLoadedComponent,this.loadingTag,this.width,this.height , this.color});
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Obx(
            () {
          return AppController.hasLoading(loadingTag)?
          Container(
            width:width!=null?width:size.width ,
            height:height!=null?height: size.height,
            color: this.color,
            child:  Stack(
              children: [
                // this.getLoadedComponent!=null?getLoadedComponent!():Container(),
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
          ):this.getLoadedComponent!=null?getLoadedComponent!():Container();
        }
    );
  }
}
