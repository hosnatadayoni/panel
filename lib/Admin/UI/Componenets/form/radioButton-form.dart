import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
enum directionRadioButton {
  vertical,
  horizontal,
}

class RadioButton extends StatefulWidget {
   List<RadioItem>? items;
   Color? activeColor;
   directionRadioButton? layoutDirection;
   Function(String?)? onChanged;
   MainAxisAlignment? mainAxisAlignment;
   CrossAxisAlignment? crossAxisAlignment;


  RadioButton({this.items,
    this.activeColor = colorBtn ,
    this.layoutDirection = directionRadioButton.vertical ,
    this.onChanged,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start

  });

  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    for (var item in widget.items!) {
      if (item.checked == true) {
        selectedValue = item.text;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.layoutDirection == directionRadioButton.vertical ?  Column(
      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        for (var item in widget.items!)
          radioBox(item)
      ],
    ) :
    Row(
      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        for (var item in widget.items!) ...[
          radioBox(item),
          // SizedBox(width: 10),
        ],
      ],
    );
  }
  Widget radioBox(item){
    return  Opacity(
      opacity: item.disabled! ? 0.5 : 1.0,
      child: Row(
        mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.start,
        children: [
          Container(
            width: item.width,
            height: item.height,
            child: Radio<String>(
              value: item.text!= null ? item.text!:'',
              groupValue: selectedValue,
              onChanged: item.disabled!
                  ? null
                  : (value) {
                setState(() {
                  selectedValue = value;
                  if(widget.onChanged != null){
                    this.widget.onChanged!(value);
                  }
                });
              },
              fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return widget.activeColor!;
                  }
                  return Colors.grey;
                },
              ),
            ),
          ),
          if(item.text != '')SizedBox(width: 10),
          if(item.text != '')
             Txt(item.text! , color: item.lableColor, fontSize: 16, fontWeight: FontWeight.w400,),
        ],
      ),
    );
  }

}

class RadioItem {
   String? text;
   bool? disabled;
   bool? checked;
   Color? lableColor;
   double? width;
   double? height;

  RadioItem({
    this.text,
    this.disabled = false,
    this.checked = false,
    this.lableColor = blackColor,
    this.width = 16,
    this.height = 16,
  });
}
