import 'package:finance/Admin/Public/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Img extends StatelessWidget {
  String path;
  double? width,height,radius;
  Color? color;
  Function? onClick;
  bool isNetwork;
  Img(this.path,{this.width,this.height,this.radius,this.color,this.onClick,this.isNetwork=false});
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: this.onClick==null?null:(){
        this.onClick!();
      },
      child:Center(
        child: Container(
            width: this.width,
            height: this.height,
            decoration: BoxDecoration(
                borderRadius:BorderRadius.circular(radius??0)
            ),
            child:ClipRRect(
              borderRadius: BorderRadius.circular(radius??0),
              child:
              path.split('.').last=='svg'?
              isNetwork?
              SvgPicture.network(baseUrl+this.path,color: this.color,fit: this.width==null || this.height==null?BoxFit.contain:BoxFit.fill):
              SvgPicture.asset(this.path,color: this.color,fit: this.width==null || this.height==null?BoxFit.contain:BoxFit.fill,) :
              isNetwork?
              Image.network(baseUrl+path,fit: this.width==null || this.height==null?BoxFit.contain:BoxFit.fill) :
              Image.asset(path,fit: this.width==null || this.height==null?BoxFit.contain:BoxFit.fill),
            )
        ),
      ),

    );
  }
}
