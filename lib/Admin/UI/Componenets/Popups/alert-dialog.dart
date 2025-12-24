import 'package:flutter/material.dart';

showAlertDialog(BuildContext context,{Function? onClose,String? title,Widget? child}) {

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.white,
    shape:Border.all(),

    title:Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Text(title??'',),
        InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.clear,size: 20,),
        )

      ],
    ) ,
    titlePadding: EdgeInsets.all(15),
    // content: Text(text!,textAlign: TextAlign.center,style: TextStyle(color: itemColor2,fontWeight: FontWeight.w400,fontSize: 14)),
    actions: [
      child!=null?child:Container()
    ],

  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  ).then((value) {
    if(onClose!=null)
      onClose();
  } );
}
