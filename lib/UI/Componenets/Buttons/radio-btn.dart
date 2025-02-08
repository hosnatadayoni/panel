import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import '../../../Logic/Controllers/app-controller.dart';
import '../../../Public/styles.dart';
class RadioBtn extends StatelessWidget {
  var groupValue,optionValue;
  Function? onClick;
  String? lable,description;
  RadioBtn(this.groupValue,this.optionValue,{this.onClick,this.lable,this.description});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(onClick!=null)
          onClick!();
      },
      child:Container(
            width: maxItemWidth,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio<dynamic>(
                        activeColor: itemColor8,
                        groupValue: groupValue,
                        value: optionValue,
                        onChanged: (value){
                          if(onClick!=null)
                            onClick!();
                        },
                      ),
                      SizedBox(width: 10,),
                      Expanded(child: Txt(this.lable??'' , fontSize: 16, fontWeight: FontWeight.w400, color: itemColor11,))
                    ],
                  ),
                  SizedBox(height: 10,),
                  description!=null?Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 40),
                    child: Text(this.description!,style: AppController.fontStyle(fontTypes.heading5, itemColor4),maxLines: null,),
                  ):Container()
                ],
              ),
            ),

    )
    ;
  }
}


