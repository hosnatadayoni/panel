import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/btn.dart';
import 'package:finance/Admin/UI/Componenets/dropDown/drop-down-item.dart';
import 'package:finance/Admin/UI/Componenets/dropDown/drop-down.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class ButtonItem {
  btnType? type;
  Widget? contetnBtn;
  Function(int)? onPressed;
  bool? isActive;
  bool? isOutline;
  bool? isCheckBox;
  bool? isRadio;
  bool? isChechked;
  bool? isDropdown;
  String? contentBtnDropDown;
  List<DropdownItem>? itemsDropDown;

  ButtonItem({
    required this.type,
    this.contetnBtn,
    this.onPressed,
    this.isActive =  false,
    this.isOutline = false,
    this.isCheckBox = false,
    this.isRadio = false,
    this.isChechked =  false,
    this.isDropdown =  false,
    this.contentBtnDropDown = '',
    this.itemsDropDown
  });
  Color backgroundColor(){
    if(this.type == btnType.primary){
      return colorBtn;
    }
    else if(this.type == btnType.secondary){
      return secondry;
    }
    else if(this.type == btnType.success){
      return success;
    }
    else if(this.type == btnType.danger){
      return danger;
    }
    else if(this.type == btnType.warning){
      return warning;
    }
    else if(this.type == btnType.info){
      return info;
    }
    else if(this.type == btnType.light){
      return light;
    }
    else if(this.type == btnType.dark){
      return dark;
    }
    else if(this.type == btnType.link){
      return Colors.transparent;
    }
    return Colors.transparent;
  }
  Color HoverbackgroundColor(){
    if(this.type == btnType.primary){
      return primaryHover;
    }
    else if(this.type == btnType.secondary){
      return secondryHover;
    }
    else if(this.type == btnType.success){
      return successHover;
    }
    else if(this.type == btnType.danger){
      return dangerHover;
    }
    else if(this.type == btnType.warning){
      return warningHover;
    }
    else if(this.type == btnType.info){
      return infoHover;
    }
    else if(this.type == btnType.light){
      return lightHover;
    }
    else if(this.type == btnType.dark){
      return darkHover;
    }
    else if(this.type == btnType.link){
      return Colors.transparent;
    }
    return Colors.transparent;
  }

  Color contentColor(){
    // if (isCheckBox == true) {
    //   return  backgroundColor();
    // }
    if(this.type == btnType.primary || this.type == btnType.secondary ||
        this.type == btnType.success || this.type == btnType.danger || this.type == btnType.dark){
      return whiteColor;
    }
    else if(this.type == btnType.warning || this.type == btnType.info || this.type == btnType.light){
      return blackColor;
    }
    else if(this.type == btnType.link){
      return colorBtn;
    }
    return dark;
  }

}