import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class CheckBoxForm extends StatefulWidget {
   String? text;
   Color? textColor;
   Color? activeColor;
   bool? checked;
   bool disabled;
   double? width;
   double? height;
   ValueChanged<bool?>? onChanged;

  CheckBoxForm({
    this.text,
    this.textColor = darkBackground,
    this.activeColor = colorBtn,
    this.checked = false,
    this.disabled = false,
    this.width = 16,
    this.height = 16,
    this.onChanged,
  });

  @override
  State<CheckBoxForm> createState() => _CheckBoxFormState();
}

class _CheckBoxFormState extends State<CheckBoxForm> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              side: BorderSide(
                color: Colors.grey,
                width: 1.5,
              ),
              fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (widget.disabled) {
                  return widget.activeColor!.withOpacity(0.5);
                }
                if (states.contains(MaterialState.selected)) {
                  return widget.activeColor!;
                }
                return Colors.transparent;
              }),
            ),
          ),
          child: Container(
            width: widget.width,
            height: widget.height,
            child: Checkbox(
              value: widget.checked,
              onChanged: widget.disabled
                  ? null
                  : (value) {
                setState(() {
                  widget.checked = value!;
                  if(widget.onChanged != null){
                    this.widget.onChanged!(value);
                  }
                });
              },
            ),
          ),
        ),
        if(widget.text != null)SizedBox(width: 10,),
        Txt(
          widget.text != null ? widget.text! : '',
          color: widget.disabled
              ? widget.textColor!.withOpacity(0.5)
              : widget.textColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}

