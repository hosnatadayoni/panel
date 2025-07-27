import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import '../General/txt.dart';


enum btnType{
  primary,
  secondary,
  mini,
  custom
}

class Btn extends StatelessWidget {
  Function? onClick;
  btnType type;
  bool isHalf;
  String? loadingTag;
  String? text;
  Widget? child;
  double? width;
  double? height;
  fontTypes fontType;
  Color? color;
  Btn(this.type,{this.text,this.onClick,this.isHalf=false,this.width,this.height,this.fontType=fontTypes.heading4,this.loadingTag , this.child , this.color});

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return  Center(
      child: Container(
          width: this.isHalf?((size.width<maxItemWidth?size.width:maxItemWidth)-(2*paddingSize))/2.05:this.width??maxItemWidth,
          height: height??50,
          decoration: BoxDecoration(
            border: Border.all(color:this.type==btnType.secondary?itemColor5:Colors.transparent,width: borderSize),
            borderRadius: BorderRadius.circular(15)
          ),
          child: ElevatedButton(

            onPressed: ()async{
              if(this.onClick!=null)
                  this.onClick!();
            },
            child:
            Obx(
                    () {
                  return (AppController.loadingList.contains(loadingTag) && loadingTag!=null)?
                  Container(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: whiteColor,
                      strokeWidth: 2,
                    ),
                  )
                      : this.child == null ? Txt(this.text??'' , color: type==btnType.primary || type==btnType.custom? whiteColor:type==btnType.mini?itemColor3:itemColor2): this.child!;
                }
            ),
              style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
          )
              ),
              backgroundColor: MaterialStateProperty.all(type==btnType.primary?Colors.transparent:type==btnType.mini?itemColor3.withOpacity(0.15):type==btnType.custom?this.color:whiteColor),
              elevation: MaterialStateProperty.all(0),
                  padding: MaterialStateProperty.all(EdgeInsets.zero)

            )
          ),
        ),
    );
  }
}
