import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
enum directionRadioButton {
  vertical,
  horizontal,
}
class RadioButton extends StatefulWidget {
   List<RadioItem>? items;
   Color? activeColor;
   directionRadioButton? layoutDirection;

  RadioButton({this.items, this.activeColor = Colors.blue ,this.layoutDirection = directionRadioButton.vertical });

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
      children: [
        for (var item in widget.items!)
          radioBox(item)
      ],
    ) :
    Row(
      children: [
        for (var item in widget.items!) ...[
          radioBox(item),
          SizedBox(width: 10),
        ],
      ],
    );
  }
  Widget radioBox(item){
    return  Opacity(
      opacity: item.disabled! ? 0.5 : 1.0,
      child: Row(
        children: [
          Radio<String>(
            value: item.text!,
            groupValue: selectedValue,
            onChanged: item.disabled!
                ? null
                : (value) {
              print('Selected value: $value');
              setState(() {
                selectedValue = value;
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
          SizedBox(width: 5),
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

  RadioItem({
    required this.text,
    this.disabled = false,
    this.checked = false,
    this.lableColor = blackColor
  });
}
