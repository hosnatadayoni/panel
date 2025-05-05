import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DropDownSize4 {
  small,
  medium,
  large
}
enum directions4{
  up,
  end,
  start,
  down,
}
class CustomMenu2 extends StatelessWidget {
  List<String> itemsDropDown;
  String dropDownTitle;
  Color? dropDownTitelColor;
  Color? colorBox;
  Color? colorHoverBox;
  Color? iconColor;
  bool? isSplitButton;
  String? spreadLink;
  DropDownSize4 size;
  Color? ColorDropDownBox;
  Color? ColorTitleDropDownBox;
  bool? showActiveSelectItem;
  Color? ColorActiveBox;
  directions4? direction;

  CustomMenu2({
    required this.itemsDropDown,
    required this.dropDownTitle,
    this.dropDownTitelColor = whiteColor,
    this.colorBox = color31,
    this.colorHoverBox = color33,
    this.iconColor = whiteColor,
    this.isSplitButton = false,
    this.spreadLink,
    this.size = DropDownSize4.medium,
    this.ColorDropDownBox = whiteColor,
    this.ColorTitleDropDownBox = blackColor,
    this.showActiveSelectItem = false,
    this.ColorActiveBox = colorBtn,
    this.direction = directions4.down,

  });

  double getFontSize() {
    switch (this.size) {
      case DropDownSize4.small:
        return 14;
      case DropDownSize4.large:
        return 20;
      case DropDownSize4.medium:
        return 16;
      default:
        return 16;
    }
  }
  double getIconSize(){
    switch (this.size) {
      case DropDownSize4.small:
        return 15;
      case DropDownSize4.large:
        return 25;
      case DropDownSize4.medium:
        return 15;
      default:
        return 15;
    }
  }
  IconData getIconDirection(){
    switch (this.direction) {
      case directions4.down:
        return Icons.arrow_drop_down;
      case directions4.up:
        return Icons.arrow_drop_up;
      case directions4.start:
        return Icons.arrow_right;
      case directions4.end:
        return Icons.arrow_left;
      default:
        return Icons.arrow_drop_down;
    }

  }
  Offset getOffset() {
    switch (direction) {
      case directions4.up:
        return Offset(0, -230);
      case directions4.down:
        return Offset(0, 40);
      case directions4.start:
        return Offset(-150,0);
      case directions4.end:
        return Offset(50 , 0);
      default:
        return Offset(0, 40);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Rx<bool> isHover = false.obs;
    Rx<bool> isHoverMain = false.obs;
    Rx<bool> isHoverSplit = false.obs;
    RxString selectedItem = RxString('');
    RxString hoveredIndex = ''.obs;

    return Obx(() {
      return
      Row(
        children: [
          MouseRegion(
            onEnter: (_) {
              isHover.value = true;
            },
            onExit: (_) {
              isHover.value = false;
            },
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                isHover.value ? this.colorHoverBox : this.colorBox,
                borderRadius: BorderRadius.circular(15),
              ),
              child: this.direction == directions4.start?Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Txt(this.dropDownTitle,
                      color: this.dropDownTitelColor , fontSize: getFontSize()),
                  Icon(getIconDirection(),
                      color: this.iconColor, size: getIconSize()),
                ],
              ) :Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(getIconDirection(),
                      color: this.iconColor, size: getIconSize()),
                  Txt(this.dropDownTitle,
                      color: this.dropDownTitelColor , fontSize: getFontSize()),
                ],
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value){
      selectedItem.value = value;
      },
      onOpened: (){
      selectedItem.value = '';
      },
      color: this.ColorDropDownBox,
      itemBuilder: (BuildContext context) => [
      ...itemsDropDown.map((item) => PopupMenuItem<String>(
      padding: EdgeInsets.zero,
      value: item,
      child: MouseRegion(
      onEnter: (_){
      hoveredIndex.value = item;
      },
      onExit: (_){
      hoveredIndex.value = '';
      },
      child: Obx((){
      return Container(
      color:hoveredIndex.value == item && itemsDropDown.indexOf(item) != 0 ? Colors.grey[300]  :  selectedItem.value == item ||
      (selectedItem.value.isEmpty && itemsDropDown.indexOf(item) == 0)
      ? this.ColorActiveBox
          : Colors.transparent,
      width: size.width,
      padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),

      child: Txt(item , color: this.ColorTitleDropDownBox,  ));
      })
      ),
      )).toList(),
      if(this.spreadLink != null)
      const PopupMenuDivider(),
      if(this.spreadLink != null)
      PopupMenuItem<String>(
      padding: EdgeInsets.zero,
      value: this.spreadLink,
      child: Container(
      color: selectedItem.value == spreadLink
      ? this.ColorActiveBox : Colors.transparent,
      width: size.width,
      child: MouseRegion(
      onEnter: (_){
      hoveredIndex.value = this.spreadLink!;
      },
      onExit: (_){
      hoveredIndex.value = '';
      },
      child: Obx((){
      return Container(
      color: hoveredIndex.value == this.spreadLink! ? Colors.grey[300]: selectedItem.value == spreadLink
      ? this.ColorActiveBox
          : Colors.transparent,
      width: size.width,
      padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
      child: Txt(this.spreadLink! , color: this.ColorTitleDropDownBox,));
      }),
      )),
      ),
      ],
      ),
        ],
      );

    });
  }
}