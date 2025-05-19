import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/drop-down.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
enum ButtonGroupSize { large, medium, small }
enum ButtonGroupAxis { horizontal, vertical }
class ButtonGroup extends StatefulWidget {
   List<ButtonItem> buttons;
   double spacing;
   double borderRadius;
   ButtonGroupSize size;
   ButtonGroupAxis axis;

   ButtonGroup({
    required this.buttons,
    this.spacing = 0.0,
    this.borderRadius = 4.0,
    this.size = ButtonGroupSize.medium,
    this.axis = ButtonGroupAxis.horizontal,
  });

  @override
  State<ButtonGroup> createState() => _ButtonGroupState();
}
class _ButtonGroupState extends State<ButtonGroup> {
  RxList<bool> checkboxStates = <bool>[].obs;
  @override
  void initState() {
    super.initState();
    checkboxStates = widget.buttons.map((button) =>  false).toList().obs;

  }
  EdgeInsets _getPadding() {
    switch (widget.size) {
      case ButtonGroupSize.large:
        return const EdgeInsets.symmetric(vertical: 10, horizontal: 16);
      case ButtonGroupSize.medium:
        return const EdgeInsets.symmetric(vertical: 6, horizontal: 12);
      case ButtonGroupSize.small:
        return const EdgeInsets.symmetric(vertical: 4, horizontal: 8);
      default:
        return EdgeInsets.symmetric(vertical: 6, horizontal: 12);
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case ButtonGroupSize.large:
        return 18;
      case ButtonGroupSize.medium:
        return 16;
      case ButtonGroupSize.small:
        return 14;
      default:
        return 16;
    }
  }
  double _getButtonHeight() {
    switch (widget.size) {
      case ButtonGroupSize.small: return 36;
      case ButtonGroupSize.medium: return 42;
      case ButtonGroupSize.large: return 48;
      default: return 42;
    }
  }
  @override
  Widget build(BuildContext context) {
    Rx<int> isHoverBtn = (-1).obs;
    Rx<int> selectedIndex = (-1).obs;

    return widget.axis == ButtonGroupAxis.horizontal ?  IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:_buildButtons(isHoverBtn , selectedIndex),
      ),
    ) :
    IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:_buildButtons(isHoverBtn , selectedIndex),
      ),
    )
    ;
  }
  List<Widget> _buildButtons(Rx<int> isHoverBtn, Rx<int> selectedIndex){
    return List.generate(widget.buttons.length, (index) {

      final leftBorderRadius = index == 0
          ? BorderRadius.only(
        topRight: Radius.circular(widget.borderRadius),
        bottomRight: Radius.circular(widget.borderRadius),
      )
          : BorderRadius.zero;

      final rightBorderRadius = index == widget.buttons.length - 1
          ? BorderRadius.only(
        topLeft: Radius.circular(widget.borderRadius),
        bottomLeft: Radius.circular(widget.borderRadius),
      )
          : BorderRadius.zero;
      final topBorderRadius = index == 0
          ? BorderRadius.only(
        topRight: Radius.circular(widget.borderRadius),
        topLeft: Radius.circular(widget.borderRadius),
      )
          : BorderRadius.zero;

      final bottomBorderRadius = index == widget.buttons.length - 1
          ? BorderRadius.only(
        bottomLeft: Radius.circular(widget.borderRadius),
        bottomRight: Radius.circular(widget.borderRadius),
      )
          : BorderRadius.zero;

      return Obx((){

        final isHover = isHoverBtn.value == index;
        final button = widget.buttons[index];
        final isOutline = button.isOutline ?? false;
        final isCheckBox = button.isCheckBox ?? false;
        final isRadio = button.isRadio ?? false;

        // final bgColor = isCheckBox
        //     ? Colors.transparent
        //     : button.isActive!
        //     ? button.activeColor
        //     : isHover
        //     ? button.hoverBtnColor
        //     : isOutline
        //     ? Colors.transparent
        //     : button.buttonColor;
        Color? getBackgroundColor() {
          if (isCheckBox) {
            return checkboxStates[index] ? button.buttonColor : Colors.transparent;
          }
          if(isRadio){
            return (selectedIndex.value == index || (button.isChechked!))
                ? button.buttonColor
                : Colors.transparent;
          }
          return isCheckBox || isRadio
              ? Colors.transparent
              : button.isActive!
              ? button.activeColor
              : isHover
              ? button.hoverBtnColor
              : isOutline
              ? Colors.transparent
              : button.buttonColor;
        }
        return SizedBox(
          height: _getButtonHeight(),
          child: MouseRegion(
            onEnter:
                (_) => isHoverBtn.value = index,
            onExit: button.isCheckBox!
                ? null
                : (_) => isHoverBtn.value = -1,
            child: InkWell(
              onTap: (){
                if (button.isCheckBox!) {
                  checkboxStates[index] = !checkboxStates[index];
                }
                if (button.isRadio!) {
                  for (var btn in widget.buttons) {
                    btn.isChechked = false;
                  }
                  selectedIndex.value = index;
                }
                widget.buttons[index].onPressed?.call(index);
              },
              child:widget.buttons[index].isDropdown! ?
              Dropdown(dropDownTitle: button.contentBtnDropDown!,
                colorBox:getBackgroundColor() ,
                colorHoverBox:getBackgroundColor() ,
                borderRadius:widget.axis == ButtonGroupAxis.horizontal ?  leftBorderRadius + rightBorderRadius : topBorderRadius + bottomBorderRadius ,
                itemsDropDown: button.itemsDropDown,padding:_getPadding() , borderColor: (isRadio || button.isCheckBox!)
                    ? widget.buttons[index].buttonColor!
                    : isHover || widget.buttons[index].isActive!
                    ? widget.buttons[index].hoverBtnColor!
                    : widget.buttons[index].buttonColor!,) : Container(
                padding: _getPadding(),
                decoration: BoxDecoration(
                    color:getBackgroundColor(),
                    borderRadius:widget.axis == ButtonGroupAxis.horizontal ?  leftBorderRadius + rightBorderRadius : topBorderRadius + bottomBorderRadius,
                    border: Border.all(width: 1 , color: (isRadio || button.isCheckBox!)
                        ? widget.buttons[index].buttonColor!
                        : isHover || widget.buttons[index].isActive!
                        ? widget.buttons[index].hoverBtnColor!
                        : widget.buttons[index].buttonColor!,)
                ),
                child:widget.buttons[index].contetnBtn!
                // child: Txt(widget.buttons[index].contetnBtn! , color:widget.buttons[index].contentBtnColor, fontSize: _getFontSize(), fontWeight: FontWeight.w400,textAlign: TextAlign.center,),
              ),
            ),),
        );
      });
    });
  }
}
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