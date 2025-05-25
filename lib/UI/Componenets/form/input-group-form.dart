import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/btn.dart';
import 'package:finance/UI/Componenets/dropDown/drop-down.dart';
import 'package:finance/UI/Componenets/form/checkbox-form.dart';
import 'package:finance/UI/Componenets/form/file-form.dart';
import 'package:finance/UI/Componenets/form/input-form.dart';
import 'package:finance/UI/Componenets/form/radioButton-form.dart';
import 'package:finance/UI/Componenets/form/select-form.dart';
import 'package:flutter/material.dart';

class InputGroup extends StatelessWidget {
  bool? isShowStart;
  bool? isShowEnd;
  Color? colorBox;
  Color? borderColorBox;
  FieldType fieldType;
  InputSize? size;
  List<Widget>? inputs;
  List<Widget>? icons;
  bool? isSelectBox;
  List<CustomSelect>? selectList;
  bool? isFileBox;
  List<FileForm>? fileList;

  InputGroup({
    this.isShowStart = false,
    this.isShowEnd = false,
    this.colorBox = color38,
    this.borderColorBox = color5,
    this.fieldType = FieldType.input,
    this.size = InputSize.medium,
    this.inputs,
    this.icons,
    this.isSelectBox =  false,
    this.selectList,
    this.isFileBox =  false,
    this.fileList
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if(this.isShowStart!)
        //   box(isLeft: false),
        // if(!this.isSelectBox! || !this.isFileBox!)
        //    ..._buildInputs(),
        // if(this.isSelectBox!)
        //   ..._buildSelectBox(),
        // if(this.isFileBox!)
        //   ..._buildFileBox(),
        // if(this.isShowEnd!)
        //   box(isLeft: true),
        if (this.isShowStart!) box(isLeft: false),
        ..._buildChildren(),
        if (this.isShowEnd!) box(isLeft: true),
      ],
    );
  }
  // List<Widget> _buildInputs() {
  //   return inputs != null ? inputs!.map((input) {
  //     return Expanded(
  //       child: input,
  //     );
  //   }).toList():[];
  // }
  List<Widget> _buildChildren() {
    if (isSelectBox!) return _buildSelectBox();
    if (isFileBox!) return _buildFileBox();
    return _buildInputs();
  }

  List<Widget> _buildInputs() {
      if (inputs == null) return [];

      return inputs!.asMap().entries.map((entry) {
        final child = entry.value;

        if (child is Text || (child is Txt)) {
          return Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: colorBox,
              border: Border.all(width: 1, color: borderColorBox!),
            ),
            alignment: Alignment.center,
            child: child,
          );
        }
        if(child is Btn || child is Dropdown){
          return Container(
              height: 48,
              child: child);
        }

        return Expanded(
          child: child,
        );
      }).toList();
    }

  List<Widget> _buildSelectBox() {
    return selectList != null ? selectList!.map((select) {
      return Expanded(
        child: select,
      );
    }).toList():[];
  }

  List<Widget> _buildFileBox() {
    return fileList != null ? fileList!.map((file) {
      return Expanded(
        child: file,
      );
    }).toList():[];
  }

  Widget box({bool? isLeft}) {
    final padding = switch(this.size!) {
    InputSize.large => EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    InputSize.medium => EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    InputSize.small => EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    };

    double getFontSize() {
    switch (this.size!) {
    case InputSize.small:
    return 14;
    case InputSize.large:
    return 20;
    case InputSize.medium:
    return 16;
    default:
    return 16;
    }
    }
    return Row(
      children: [
        if(this.icons != null)
         for(int i=0;i<this.icons!.length;i++)
    this.icons![i] is Btn ||this.icons![i] is Dropdown ? Center(child: Container(height:48 , child: this.icons![i])) :
    Container(
           height: 48,
           padding:padding,
           decoration: BoxDecoration(
           color: this.colorBox,
           border: Border.all(width: 1, color: this.borderColorBox!),
           borderRadius: BorderRadius.horizontal(
              left:isLeft! ?  i == this.icons!.length - 1 ? Radius.circular(5): Radius.zero: Radius.zero,
              right: isLeft ? Radius.zero : i == 0 ? Radius.circular(5) : Radius.zero,
           )
           ),
           alignment: Alignment.center,
           child: IntrinsicHeight(
             child: this.icons![i],
           ),
    ),
        // Container(
        //   padding:padding,
        //   decoration: BoxDecoration(
        //     color: this.colorBox,
        //     border: Border.all(width: 1, color: this.borderColorBox!),
        //     borderRadius: BorderRadius.horizontal(
        //       left: isLeft! ? Radius.circular(5) : Radius.zero,
        //       right: isLeft ? Radius.zero : Radius.circular(5),
        //     ),
        //   ),
        //   alignment: Alignment.center,
        //   child:this.isCheckBox! ? CheckBoxForm(checked: this.checkedCheckBox,
        // disabled: this.disable!, width: this.width , height:this.height):
        // this.isRadio! ? RadioButton(items: this.items, ):
        // Txt('@' , fontSize:getFontSize() ,),
        // ),
      ],
    );
  }
}
