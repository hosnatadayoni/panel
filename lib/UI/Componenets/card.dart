import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/img.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
enum directionCard{
  left,
  right,
  center
}
class CustomCard extends StatelessWidget {
  Color? colorBox;
  Color? borderColorBox;
  Widget? body;
  // Img? imageTop;
  // Img? imageBottom;
  String? cardHeader;
  String? cardFooter;
  double? width;
  Color? headerOrFooterBackgroundColor;
  Color? cardHeaderOrFooterColor;
  Color? cardHeaderOrFooterBorderColor;
  directionCard d;
  bool? imageOverlay;
  String? imgUrl;
  // bool? horizental;
  // int? flexRight;
  // int? flexLeft;
  double? hieght;

  CustomCard({
    this.colorBox ,
    this.borderColorBox = Colors.grey ,
    this.body,
    // this.imageTop,
    // this.imageBottom,
    this.cardHeader,
    this.cardFooter,
    this.width,
    this.headerOrFooterBackgroundColor =color38,
    this.cardHeaderOrFooterColor,
    this.cardHeaderOrFooterBorderColor,
    this.d = directionCard.right,
    this.imageOverlay = false,
    this.imgUrl,
    // this.horizental = false,
    // this.flexRight =  4,
    // this.flexLeft =  6,
    this.hieght,
  });
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: this.width != null ? this.width : size.width,
      height: this.hieght != null ? this.hieght : null,
      decoration: BoxDecoration(
        color:this.colorBox,
        border: Border.all(color: this.borderColorBox! , width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children:[
          if(this.cardHeader != null)
            Positioned(
            top:0,
            right: 0,
            left: 0,
            child:  ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              child: Container(
                width:this.width != null ? this.width : size.width,
                padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: this.cardHeaderOrFooterBorderColor != null ?this.cardHeaderOrFooterBorderColor!: Colors.transparent,
                      width: 1,
                    ),
                  ),

                  color: this.headerOrFooterBackgroundColor,
                ),
                child: this.d == directionCard.center ? Center(
                  child: Container(
                      child: Txt(this.cardHeader! , color: this.cardHeaderOrFooterColor, fontSize: 16,)),
                ):Container(
                    child: Txt(this.cardHeader! , color: this.cardHeaderOrFooterColor, fontSize: 16,)),
              ),
            ),),
          if(this.cardFooter != null)
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child:  ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                child: Container(
                  width:this.width != null ? this.width : size.width,
                  padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: this.cardHeaderOrFooterBorderColor != null ?this.cardHeaderOrFooterBorderColor!: Colors.transparent,
                        width: 1,
                      ),
                    ),
                    color: this.headerOrFooterBackgroundColor,
                  ),
                  child: this.d == directionCard.center ? Center(
                    child: Container(
                        child: Txt(this.cardFooter! , color: this.cardHeaderOrFooterColor, fontSize: 16,)),
                  ):Container(
                      child: Txt(this.cardFooter! , color: this.cardHeaderOrFooterColor, fontSize: 16,)),
                ),
              ),),
          this.imageOverlay! ?
          Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: this.width,
                  child: Img(this.imgUrl!,width: this.width != null ? this.width : size.width, height: this.hieght != null ? this.hieght : 300 ,radius: 16,)),
              Box(context),
            ],
          ) : Box(context),
        ],
      )
    );
  }
  Widget Box(context){
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: this.cardHeader != null ? 40 : 0, bottom: this.cardFooter != null ? 40 : 0),
      width: this.width != null ? this.width : size.width,
      padding: EdgeInsets.all(16),
      child: this.d == directionCard.center ? Center(child: this.body!,) : this.body!,
    );
  }
  // Widget ColumnBox(context){
  //   var size = MediaQuery.of(context).size;
  //   return Column(
  //     children: [
  //       // if (this.imageTop != null)
  //       //   Container(
  //       //     width: this.width != null ? this.width : size.width,
  //       //     decoration: BoxDecoration(
  //       //       borderRadius: BorderRadius.only(
  //       //         topLeft: Radius.circular(15),
  //       //         topRight: Radius.circular(15),
  //       //         bottomLeft: Radius.circular(0),
  //       //         bottomRight: Radius.circular(0),
  //       //
  //       //       ),
  //       //       color: Colors.blueGrey,
  //       //
  //       //     ),
  //       //     child: Center(child: this.imageTop!),),
  //       if(this.cardHeader != null)
  //         SizedBox(height: 40,),
  //       Container(
  //         width: this.width != null ? this.width : size.width,
  //         padding: EdgeInsets.all(16),
  //         child: this.d == directionCard.center ? Center(child: this.body!,) : this.body!,
  //       ),
  //       if(this.cardFooter != null)
  //         SizedBox(height: 40,),
  //       // if (imageBottom != null)
  //       //   Container(
  //       //     width: this.width != null ? this.width : size.width,
  //       //     decoration: BoxDecoration(
  //       //       borderRadius: BorderRadius.only(
  //       //         topLeft: Radius.circular(0),
  //       //         topRight: Radius.circular(0),
  //       //         bottomLeft: Radius.circular(15),
  //       //         bottomRight: Radius.circular(15),
  //       //
  //       //       ),
  //       //       color: Colors.blueGrey,
  //       //
  //       //     ),
  //       //     child: this.imageBottom!,),
  //     ],
  //   );
  // }
}
