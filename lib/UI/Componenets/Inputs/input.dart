import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Logic/Controllers/app-controller.dart';
import '../../../Logic/Controllers/main-controller.dart';
import '../../../Public/styles.dart';

class Input extends StatefulWidget {
  String? lable,hint;
  Function? onChange;
  bool isNumber,hasBorder, isMobile;
  TextAlign align;
  Widget? icon1,icon2;
  double? width;
  double? height;
  int lines;
  var initValue;
  fontTypes hintFontType;
   double? radius;
  double? fontSize;
  Function? onTap;
  bool? isFocused;
  Color? inputColor;
  Color borderColor;
  Color? hintColor;
  Input({this.lable,this.width=maxItemWidth,this.height=55,this.hint,this.initValue,this.onChange,this.isNumber=false,this.icon1,this.icon2,this.lines=1,this.align=TextAlign.right,
    this.hasBorder=true,this.hintFontType=fontTypes.text5  ,
    this.radius = 16, this.fontSize = 14 , this.isMobile = false,
    this.onTap , this.isFocused = false , this.hintColor ,required this.borderColor,this.inputColor
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late final _textController;
  final _focusNode = new FocusNode();
  @override
  void initState() {
    super.initState();
    // _textController = widget.isLoginPage == false ? TextEditingController(text: widget.initValue??''):MainController.textEditingContorller;
    _focusNode.addListener(() {
      if(_focusNode.hasFocus){
        _textController.text=_textController.text+'';
      }
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    if(WidgetsBinding.instance.window.viewInsets.bottom==0 && FocusManager.instance.primaryFocus!=null){
      FocusManager.instance.primaryFocus!.unfocus();
    }
    var size=MediaQuery.of(context).size;
    return Container(
      height: widget.lines==1?this.widget.height??null:null,
      width: this.widget.width??maxItemWidth,
      alignment: Alignment.center,
      // decoration: BoxDecoration(boxShadow: widget.shadow),

      child: TextFormField(
         onTap: (){
           if(widget.onTap!=null)
              widget.onTap!();
       },
        style: TextStyle(color: itemColor39),
        // initialValue: isNumber || initValue=='' || initValue==null?'${initValue??''}':'${initValue??''} ',
        autofocus: widget.isFocused == true ? true : false,
        // controller: _textController,
        focusNode: _focusNode,
        textAlign: widget.align,
        minLines: widget.lines,
        maxLines: widget.lines,
        textDirection: widget.isNumber?TextDirection.ltr:TextDirection.rtl,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: widget.lines>1?30:10 , right:10 ,  left:10),
          filled: true,
          // fillColor: whiteColor,
          prefixIcon: widget.icon1!=null?widget.icon1:null,
          suffixIcon: widget.icon2!=null?widget.icon2:null,
          errorBorder: widget.hasBorder? OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent,width: borderSize),
            borderRadius: BorderRadius.circular(widget.radius!),
          ):InputBorder.none,
          enabledBorder:OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent   ,width: borderSize),
            borderRadius: BorderRadius.circular(widget.radius!),
          ),
          focusedBorder:widget.hasBorder? OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius!),
            borderSide: BorderSide(color: itemColor8,width: borderSize),
          ):InputBorder.none,
          floatingLabelStyle:TextStyle(color: itemColor13),
          labelStyle: AppController.fontStyle(fontTypes.text5, itemColor3),
          alignLabelWithHint: true,
          labelText: this.widget.lable,
          hintText: this.widget.hint,
          // hintStyle: AppController.fontStyle(fontTypes.text5, itemColor3),
          hintStyle: TextStyle(fontSize: widget.fontSize , fontWeight: FontWeight.w300 , color: itemColor3,),

        ),
        keyboardType: widget.isNumber?TextInputType.number:TextInputType.text,
        inputFormatters: <TextInputFormatter>[
          if(widget.isMobile)
            LengthLimitingTextInputFormatter(11),
          widget.isNumber?FilteringTextInputFormatter.digitsOnly:
          FilteringTextInputFormatter.singleLineFormatter,
        ],
        onChanged: (text){
          if(widget.onChange!=null)
            this.widget.onChange!(text);
        },
      ),
    );
  }
}
