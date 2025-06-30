import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/form/input-form.dart';
import 'package:flutter/material.dart';

class CustomSelect extends StatelessWidget {
   String? selectedValue;
   List<DropdownMenuItem<String>> items;
   ValueChanged<String?>? onChanged;
   String hintText;
   InputSize? size;
   Color? colorHintText;
   Color? colorDropDownItem;
   bool? disabled;
   Color? disabledBoxColor;
   BorderRadius? borderRadius;
   double? width;

   CustomSelect({
    required this.items,
     this.onChanged,
    this.selectedValue,
    this.hintText = 'Open this select menu',
     this.size = InputSize.medium,
     this.colorHintText = darkBackground,
     this.colorDropDownItem = darkBackground,
     this.disabled = false,
     this.disabledBoxColor = color38,
     this.borderRadius,
     this.width,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final padding = switch(this.size!) {
    InputSize.large => EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    InputSize.medium => EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    InputSize.small => EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    };

    double fontSize = switch(this.size!) {
    InputSize.large => 18,
    InputSize.medium => 16,
    InputSize.small => 14,
    };
    return Container(
      width: this.width ?? size.width,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
        contentPadding: padding,
          border: OutlineInputBorder(
              borderRadius: this.borderRadius != null ?this.borderRadius! :BorderRadius.circular(0)
      ),
         fillColor: this.disabledBoxColor,
         filled:this.disabled! ?  true : false,
        ),
        hint: Txt(hintText , fontSize:fontSize , fontWeight: FontWeight.w400,color: this.colorHintText,),
        items: items,
        style: TextStyle(fontSize: fontSize , fontWeight: FontWeight.w400 , color: this.colorDropDownItem),
        onChanged: this.disabled! ? null : onChanged,
      ),
    );
  }
}