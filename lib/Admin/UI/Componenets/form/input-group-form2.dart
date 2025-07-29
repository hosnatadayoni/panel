import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:panel/Admin/UI/Componenets/form/input-form.dart';
import 'package:flutter/material.dart';
import '../Buttons/btn.dart';
import 'file-form.dart';
import 'select-form.dart';

class InputGroup2 extends StatelessWidget {
  List<Widget>? inputs;
  List<Widget>? prefixIcons;
  List<Widget>? suffixIcons;
  Color? iconBoxColor;
  Color? borderIconBoxColor;
  String? formTxt;
  Color? formTxtColor;
  InputSize? size;
  double? width;
  double? height;
  bool? isWrap;

   InputGroup2({
    this.inputs,
     this.prefixIcons,
     this.suffixIcons,
     this.iconBoxColor = color38,
     this.borderIconBoxColor = color5,
     this.formTxt,
     this.formTxtColor = secondry,
     this.size = InputSize.medium,
     this.width,
     this.height,
     this.isWrap = true,

});

  @override
  Widget build(BuildContext context) {

    final padding = switch(this.size!) {
    InputSize.large => EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    InputSize.medium => EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    InputSize.small => EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        this.isWrap!? Wrap(
        runSpacing: 5,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: buildElements(),
        ):
        Row(
           children: buildElements(),
        ),
        if(this.formTxt != null)SizedBox(height: 5,),
        if(this.formTxt != null)Txt(this.formTxt! , fontSize: 14, fontWeight: FontWeight.w400, color: this.formTxtColor,)
      ],
    );
  }
  List<Widget> buildElements(){
    return [
      if(prefixIcons != null)
        for(int i=0;i<this.prefixIcons!.length;i++)
          Container(
            height: 48,
            child: this.prefixIcons![i],
          ),
      //    Container(
      //    padding: padding,
      //    decoration: BoxDecoration(
      //     color: this.iconBoxColor,
      //     border: Border.all(width: 1 , color: this.borderIconBoxColor!),
      //     borderRadius: BorderRadius.only(
      //       topRight: Radius.circular(i == 0 ? 5 : 0),
      //       bottomRight: Radius.circular(i == 0 ? 5 : 0),
      //     )
      //    ),
      //    alignment: Alignment.center,
      //    child: IntrinsicHeight(
      //     child: this.prefixIcons![i],
      //   ),
      //
      // ),
      if(this.inputs != null)
        for(int i=0;i<this.inputs!.length;i++)
           inputs![i] is InputForm ||
              inputs![i] is FileForm ||
              inputs![i] is CustomSelect
              ?  ? (isWrap!
               ? ConstrainedBox(
             constraints: BoxConstraints(minWidth: 100), // مقدار دلخواه
             child: inputs![i],
           )
               : Flexible(child: inputs![i]))
              : Container(
            width: width ?? 40,
            height: height ?? 48,
            child: inputs![i],
          ),
      if(suffixIcons != null)
        for(int i=0;i<this.suffixIcons!.length;i++)
          Container(
              constraints: BoxConstraints(
                minHeight: height ?? 48,
              ),
              child: this.suffixIcons![i]),
      //   Container(
      //   padding: padding,
      //   decoration: BoxDecoration(
      //       color: this.iconBoxColor,
      //       border: Border.all(width: 1 , color: this.borderIconBoxColor!),
      //       borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(i == this.suffixIcons!.length -  1 ? 5 : 0),
      //         bottomLeft: Radius.circular(i == this.suffixIcons!.length -  1 ? 5 : 0),
      //       )
      //   ),
      //   alignment: Alignment.center,
      //   child: IntrinsicHeight(
      //     child: this.suffixIcons![i],
      //   ),
      // ),
    ];
  }
}
