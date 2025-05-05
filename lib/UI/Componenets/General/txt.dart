import 'package:flutter/cupertino.dart';

class Txt extends StatelessWidget {
   String text;
   String fontFamily ;
   int? maxLine;
   double? fontSize;
   FontWeight? fontWeight;
   Color? color;
   TextOverflow? textOverflow;
   TextDecoration? textDecoration;
   TextAlign? textAlign;
   FontStyle? fontStyle;

  Txt(this.text, {this.fontFamily = 'IRANSanse',this.maxLine, this.fontSize , this.fontWeight , this.color , this.textOverflow , this.textDecoration , this.textAlign , this.fontStyle});

  @override
  Widget build(BuildContext context) {
    return maxLine!=null || textOverflow!=null ?
    Container(
      child: Row(
        children: [
          Expanded(
            child: getText()
          ),
        ],
      ),
    ):
    getText();
  }

  Widget getText(){
    return Text(
      text,
      style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight ,
          color:color ,
          decoration: textDecoration,
        fontStyle: fontStyle
      ),
      textAlign: textAlign,
      maxLines: maxLine ,
      overflow: textOverflow,

    );
  }
}
