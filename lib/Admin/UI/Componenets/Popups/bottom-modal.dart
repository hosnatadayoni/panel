import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:finance/Admin/Public/styles.dart';


showBottomModal(BuildContext context,double height,Widget child,{String? title,bool dragable=true}){

  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      enableDrag: dragable,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: maxItemWidth,
      ),
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(10.0),topLeft: Radius.circular(10.0)),
      ),
      builder: (builder){
        return Container(
                  width: maxItemWidth,
                  height: height+WidgetsBinding.instance.window.viewInsets.bottom,
                  padding: EdgeInsets.only(left: paddingSize,right: paddingSize,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10.0),topLeft: Radius.circular(10.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 25,),
                        Container(
                          width: 75,
                          height:5 ,
                          decoration: BoxDecoration(
                              color: itemColor39,
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                        title!=null?Container(
                            margin: EdgeInsets.only(top: 10,bottom: 30),
                            child: Text(title,style: TextStyle(color: itemColor1,fontWeight: FontWeight.w700,fontSize: 18),)
                        ):Container(),
                        Expanded(child: child)
                      ],
                    ),
                );
      }
  );
}




