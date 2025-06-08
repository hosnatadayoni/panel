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
  Color? borderColor;
  BorderRadius? borderRadius;
  Color? lableColor;

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
    this.inputWidth,
    this.borderColor = color5,
    this.borderRadius,
    this.lableColor = dark,

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
    return widget.layoutDirection == direction.vertical ?
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.lableText != null)
           Txt(widget.lableText! , fontSize: 16, fontWeight: FontWeight.w400,color: widget.lableColor,),
        if(widget.lableText != null)
           SizedBox(height: 10,),
        FormBox(),
       if(widget.formText != null)
          SizedBox(height: 10,),
       if(widget.formText != null)
          Txt(widget.formText!, fontSize: 14, fontWeight: FontWeight.w400,color: widget.formTextColor),
      ],
    ) :
    Wrap(
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
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

    final textAreaPadding = widget.fieldType == FieldType.textarea
    ? EdgeInsets.symmetric(vertical: 12, horizontal: 12)
        : padding;

    return  Container(
      width:  widget.layoutDirection == direction.horizontal
          ? widget.inputWidth ?? 200
          : null,
      child: TextFormField(
        controller: widget.keyBoardType == keyboardType.password ? _passwordController : _emailController,
        decoration:  InputDecoration(
          // labelText: widget.lableText!= null ? widget.lableText : '',
          hintText: widget.hintText != null ? widget.hintText : '',
          enabledBorder: widget.isPlainTxt! ? InputBorder.none : OutlineInputBorder(
          borderRadius: widget.borderRadius!= null ? widget.borderRadius! : BorderRadius.zero,
          // borderRadius: BorderRadius.only(
          // topLeft: Radius.circular(widget.hasEndBox ?0:5),
          // topRight: Radius.circular(widget.hasStartBox ?0:5),
          // bottomLeft: Radius.circular(widget.hasEndBox ?0:5),
          // bottomRight: Radius.circular(widget.hasStartBox ?0:5),
          // ),
          borderSide: BorderSide(
         color: widget.borderColor!,
         width: 1.0,
         ),
         ),
          border: widget.isPlainTxt! ? InputBorder.none : OutlineInputBorder(
          borderSide: BorderSide(
          color: widget.borderColor!,
          width: 1.0,
          ),
    borderRadius: widget.borderRadius!= null ? widget.borderRadius! : BorderRadius.zero,
    //       borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(widget.hasEndBox ?0:5),
    //       topRight: Radius.circular(widget.hasStartBox ?0:5),
    //       bottomLeft: Radius.circular(widget.hasEndBox ?0:5),
    //       bottomRight: Radius.circular(widget.hasStartBox ?0:5),
    // ),
    ),
          contentPadding:widget.isPlainTxt!
    ? (widget.fieldType == FieldType.textarea
    ? textAreaPadding: EdgeInsets.zero): (widget.fieldType == FieldType.textarea? textAreaPadding: padding),
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
