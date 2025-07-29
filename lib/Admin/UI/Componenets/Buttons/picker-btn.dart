import 'package:flutter/material.dart';
import 'package:panel/Admin/Logic/Controllers/app-controller.dart';
import 'package:panel/Admin/Public/styles.dart';
import '../General/img.dart';

class PickerBtn extends StatelessWidget {
  String icon,text;
  Function? onClick;

   PickerBtn(this.icon,this.text,{Key? key,this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        if(this.onClick!=null)
          onClick!();
      },
      child: Container(
        width: 120,
        height: 30,
        padding: EdgeInsets.only(left: 8,right: 8),
        decoration: BoxDecoration(
            border: Border.all(width: borderSize,color: itemColor5),
            borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Img(icon),
            Text(text,style: AppController.fontStyle(fontTypes.text1, itemColor1),)
          ],
        ),
      ),
    );
  }
}
