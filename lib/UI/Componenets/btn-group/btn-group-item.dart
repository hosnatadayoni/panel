import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/dropDown/drop-down-item.dart';
import 'package:finance/UI/Componenets/dropDown/drop-down.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class ButtonItem {
  Color? buttonColor;
  Color? hoverBtnColor;
  Color? contentBtnColor;
  Widget? contetnBtn;
  Function(int)? onPressed;
  bool? isActive;
  Color? activeColor;
  bool? isOutline;
  bool? isCheckBox;
  bool? isRadio;
  bool? isChechked;
  bool? isDropdown;
  String? contentBtnDropDown;
  List<DropdownItem>? itemsDropDown;

  ButtonItem({
    this.buttonColor = Colors.blue,
    this.hoverBtnColor = colorHoverBtn,
    this.contentBtnColor =  whiteColor,
    this.contetnBtn,
    this.onPressed,
    this.isActive =  false,
    this.activeColor = colorHoverBtn,
    this.isOutline = false,
    this.isCheckBox = false,
    this.isRadio = false,
    this.isChechked =  false,
    this.isDropdown =  false,
    this.contentBtnDropDown = '',
    this.itemsDropDown
  });
}