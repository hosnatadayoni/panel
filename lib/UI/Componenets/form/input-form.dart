import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/form/color-form.dart';
import 'package:finance/UI/Componenets/form/file-form.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
enum keyboardType{
  email,
  password,
}
enum FieldType {
  input,
  textarea
}
enum InputSize {
  large,
  medium,
  small,
}
enum direction {
  vertical,
  horizontal,
}

class InputForm extends StatefulWidget {
  String? lableText;
  String? hintText;
  String? formText;
  Color? formTextColor;
  keyboardType? keyBoardType;
  String? showError;
  String? showEmptyError;
  bool? disabled;
  FieldType fieldType;
  int? rows;
  InputSize? size;
  bool? readOnly;
  bool? isPlainTxt;
  direction layoutDirection;
  double? inputWidth;

  InputForm({this.lableText ,
    this.hintText ,
    this.formText ,
    this.formTextColor = Colors.grey,
    this.keyBoardType ,
    this.showError ,
    this.showEmptyError,
    this.disabled = false,
    this.fieldType = FieldType.input,
    this.rows,
    this.size = InputSize.medium,
    this.readOnly = false,
    this.isPlainTxt = false,
    this.layoutDirection = direction.vertical,
    double? inputWidth,

  });
  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return widget.layoutDirection == direction.vertical ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Txt(widget.lableText != null ? widget.lableText! : ''),
        SizedBox(height: 10,),
        FormBox(),
       SizedBox(height: 5,),
       Txt(widget.formText != null ? widget.formText!:'' , fontSize: 14, fontWeight: FontWeight.w400,color: widget.formTextColor),
      ],
    ) : Row(
      children: [
        Txt(widget.lableText != null ? widget.lableText! : ''),
        SizedBox(width: widget.lableText != null ? 15 : 0,),
        FormBox(),
        SizedBox(width: 15,),
        Txt(widget.formText != null ? widget.formText!:'' , fontSize: 14, fontWeight: FontWeight.w400,color: widget.formTextColor),
      ],
    );
  }
  Widget FormBox(){
    final padding = switch(widget.size!) {
    InputSize.large => EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    InputSize.medium => EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    InputSize.small => EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    };

    final textStyle = switch(widget.size!) {
    InputSize.large => TextStyle(fontSize: 20),
    InputSize.medium => TextStyle(fontSize: 16),
    InputSize.small => TextStyle(fontSize: 14),
    };
    return  Container(
      width:  widget.layoutDirection == direction.horizontal
          ? widget.inputWidth ?? 200
          : null,
      child: TextFormField(
        controller: widget.keyBoardType == keyboardType.password ? _passwordController : _emailController,
        decoration:  InputDecoration(
          labelText: widget.lableText!= null ? widget.lableText : '',
          hintText: widget.hintText != null ? widget.hintText : '',
          border: widget.isPlainTxt! ? InputBorder.none : OutlineInputBorder(),
          contentPadding:widget.isPlainTxt! ? EdgeInsets.zero : padding,
          // helperText:widget.formText != null ? widget.formText :'',
          filled: widget.disabled,
          fillColor: widget.disabled!
              ? Theme.of(context).inputDecorationTheme.fillColor?.withOpacity(0.5)
              : null,
          labelStyle: widget.disabled!
              ? TextStyle(color: Theme.of(context).disabledColor)
              : null,
          hintStyle: widget.disabled!
              ? TextStyle(color: Theme.of(context).disabledColor)
              : null,
        // alignLabelWithHint: true,
        ),
        style: textStyle,
        enabled: widget.disabled! ? false : true,
        readOnly: widget.readOnly!,
        keyboardType:widget.fieldType == FieldType.textarea ?
        TextInputType.multiline : widget.keyBoardType ==  keyboardType.email ?
        TextInputType.emailAddress : TextInputType.text,
        obscureText:widget.fieldType == FieldType.input ?
        widget.keyBoardType == keyboardType.password ? true : false : false,
        maxLines: widget.fieldType == FieldType.textarea ?  widget.rows ?? 3 : 1,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.showEmptyError;
          }
          if(widget.keyBoardType == keyboardType.email){
            if (!value.contains('@')) {
              return widget.showError;
            }
          }
          else if(widget.keyBoardType == keyboardType.password){
            if (value.length < 6) {
              return widget.showError;
            }
          }
          return null;
        },
      ),
    );
  }
}
