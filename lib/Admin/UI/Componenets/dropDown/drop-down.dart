import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:panel/Admin/UI/Componenets/btn.dart';
import 'package:panel/Admin/UI/Componenets/dropDown/drop-down-item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DropDownSize {
  small,
  medium,
  large
}
enum directions{
  up,
  end,
  start,
  down,
  left,
  right,
}

class Dropdown extends StatefulWidget {
  btnType? type;
  List<DropdownItem>? itemsDropDown;
  String dropDownTitle;
  Color? dropDownTitelColor;
  Color? dropDownTitelHoverColor;
  bool? isSplitButton;
  List<String>? spreadLinkList;
  DropDownSize size;
  Color? ColorDropDownBox;
  Color? ColorTitleDropDownBox;
  // bool? showActiveSelectItem;
  Color? ColorActiveBox;
  Color? borderButtonColor;
  bool? hasForm;
  Color? ColorHoverBox;
  Color? ColorDisableTxt;
  BorderRadius? borderRadius;
  BorderRadius? borderRadiusSplitBtn;
  EdgeInsets? padding;
  Color? borderColor;
  bool? isOutline;


  Dropdown({
     required this.type,
     this.itemsDropDown,
    required this.dropDownTitle,
    this.dropDownTitelColor = whiteColor,
    this.dropDownTitelHoverColor = blackColor,
    this.isSplitButton = false,
    this.spreadLinkList,
    this.size = DropDownSize.medium,
    this.ColorDropDownBox = whiteColor,
    this.ColorTitleDropDownBox = blackColor,
    // this.showActiveSelectItem = false,
    this.ColorActiveBox = colorBtn,
    this.borderButtonColor = color5,
    this.hasForm = false,
    this.ColorHoverBox = color39,
    this.ColorDisableTxt = color14,
    this.borderRadius,
    this.borderRadiusSplitBtn,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderColor = color31,
    this.isOutline = false,

  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  Rx<bool> isHover = false.obs;
  RxString selectedItem = RxString('');
  RxString hoveredIndex = ''.obs;

  @override
  void initState() {
    super.initState();
  }
  double getFontSize() {
    switch (this.widget.size) {
      case DropDownSize.small:
        return 14;
      case DropDownSize.large:
        return 20;
      case DropDownSize.medium:
        return 16;
      default:
        return 16;
    }
  }

  double getIconSize(){
    switch (this.widget.size) {
      case DropDownSize.small:
        return 15;
      case DropDownSize.large:
        return 25;
      case DropDownSize.medium:
        return 15;
      default:
        return 15;
    }
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Rx<bool> isHoverMain = false.obs;
    Rx<bool> isHoverSplit = false.obs;
    Color backgroundColor(){
      if(widget.type == btnType.primary){
        return colorBtn;
      }
      else if(widget.type == btnType.secondary){
        return secondry;
      }
      else if(widget.type == btnType.success){
        return success;
      }
      else if(widget.type == btnType.danger){
        return danger;
      }
      else if(widget.type == btnType.warning){
        return warning;
      }
      else if(widget.type == btnType.info){
        return info;
      }
      else if(widget.type == btnType.light){
        return light;
      }
      else if(widget.type == btnType.dark){
        return dark;
      }
      else if(widget.type == btnType.link){
        return Colors.transparent;
      }
      return Colors.transparent;
    }
    Color HoverbackgroundColor(){
      if(widget.type == btnType.primary){
        return primaryHover;
      }
      else if(widget.type == btnType.secondary){
        return secondryHover;
      }
      else if(widget.type == btnType.success){
        return successHover;
      }
      else if(widget.type == btnType.danger){
        return dangerHover;
      }
      else if(widget.type == btnType.warning){
        return warningHover;
      }
      else if(widget.type == btnType.info){
        return infoHover;
      }
      else if(widget.type == btnType.light){
        return lightHover;
      }
      else if(widget.type == btnType.dark){
        return darkHover;
      }
      else if(widget.type == btnType.link){
        return Colors.transparent;
      }
      return Colors.transparent;
    }
    Color contentColor(){
      if(widget.type == btnType.primary || widget.type == btnType.secondary ||
          widget.type == btnType.success || widget.type == btnType.danger || widget.type == btnType.dark){
        return whiteColor;
      }
      else if(widget.type == btnType.warning || widget.type == btnType.info || widget.type == btnType.light){
        return blackColor;
      }
      else if(widget.type == btnType.link){
        return colorBtn;
      }
      return dark;
    }
    Color textColor(){
      if(widget.type == btnType.primary){
        return colorBtn;
      }
      else if(widget.type == btnType.secondary){
        return secondry;
      }
      else if(widget.type == btnType.success){
        return success;
      }
      else if(widget.type == btnType.danger){
        return danger;
      }
      else if(widget.type == btnType.warning){
        return warning;
      }
      else if(widget.type == btnType.info){
        return info;
      }
      else if(widget.type == btnType.light){
        return light;
      }
      else if(widget.type == btnType.dark){
        return dark;
      }
      else if(widget.type == btnType.link){
        return colorBtn;
      }
      return Colors.transparent;
    }
    Color colorBox() {
        if (isHover.value) {
        return HoverbackgroundColor();
      } else if (widget.isOutline!) {
        return Colors.transparent;
      }
      return backgroundColor();
    }

    return Obx(() {
      return this.widget.isSplitButton!
          ? IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MouseRegion(
                  onEnter: (_) {
                    isHoverSplit.value = true;
                  },
                  onExit: (_) {
                    isHoverSplit.value = false;
                  },
                  child: PopUpMenuButtonWidget(selectedItem, size, hoveredIndex, Center(
                    child: Container(
                      height: 48,
                      padding: EdgeInsets.only(
                          left: 9, right: 9, top: 11, bottom: 11),
                      decoration: BoxDecoration(
                        color: isHoverSplit.value
                            ? HoverbackgroundColor()
                            : widget.isOutline!? Colors.transparent :backgroundColor(),
                        borderRadius:widget.borderRadiusSplitBtn != null ? widget.borderRadiusSplitBtn :  BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5)
                        ),
                          border: Border.all(width: 1, color: isHoverSplit.value ? HoverbackgroundColor() : backgroundColor())
                      ),
                      child: Icon(Icons.arrow_drop_down,
                          color: isHoverSplit.value ?contentColor(): widget.isOutline! ? textColor(): contentColor(), size:getIconSize()),
                    ),
                  ),),
                ),
                MouseRegion(
                  onEnter: (_) {
                    isHoverMain.value = true;
                  },
                  onExit: (_) {
                    isHoverMain.value = false;
                  },
                  child: Center(
                    child: Container(
                      height: 48,
                      padding: EdgeInsets.only(
                          left: 12, right: 12, top: 6, bottom: 6),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(15),
                        //     bottomLeft: Radius.circular(15)),
                        borderRadius:widget.borderRadius != null ?  widget.borderRadius:
                        BorderRadius.all(Radius.circular(0)),
                        border: Border.all(width: 1, color: isHoverMain.value ? HoverbackgroundColor() : backgroundColor()),
                        color: isHoverMain.value
                            ? HoverbackgroundColor()
                            : widget.isOutline!? Colors.transparent :backgroundColor(),
                      ),
                      child: Center(
                        child: Txt(this.widget.dropDownTitle,
                            color: isHoverMain.value ?contentColor(): widget.isOutline! ? textColor(): contentColor() , fontSize: getFontSize(), fontWeight: FontWeight.w400,),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
          : Container(
            child: PopUpMenuButtonWidget(selectedItem, size, hoveredIndex,  MouseRegion(
              onEnter: (_) {
                isHover.value = true;
              },
              onExit: (_) {
                isHover.value = false;
              },
              child:Container(
                padding:
                widget.padding,
                decoration: BoxDecoration(
                  color:
                  colorBox(),
                  // widget.isOutline! ? Colors.transparent :isHover.value ? HoverbackgroundColor() :  backgroundColor(),
                  borderRadius:widget.borderRadius != null ?  widget.borderRadius:
                  BorderRadius.all(Radius.circular(5)),
                  border: Border.all(width: 1, color:isHover.value
                      ? HoverbackgroundColor()
                      : backgroundColor(),)
                ),
                child: Row(
                  children: [
                    Icon(Icons.arrow_drop_down,
                        color: isHover.value ?contentColor(): widget.isOutline! ? textColor(): contentColor(), size: getIconSize()),
                    Txt(this.widget.dropDownTitle,
                        color: isHover.value ?contentColor(): widget.isOutline! ? textColor(): contentColor()  , fontSize: getFontSize())
                  ],
                ),
              )
            ),),
          );
    });
  }
  Widget FormWidget() {
    Rx<bool> isChecked = false.obs;
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Txt(
                'Email address',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 5),
              TextField(
                decoration: InputDecoration(
                  hintText: 'email@example.com',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          SizedBox(height: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Txt(
                'Password',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 5),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                obscureText: true,
              ),
            ],
          ),
          SizedBox(height: 16),

          Row(
            children: [
              Obx((){
                return Checkbox(
                  value: isChecked.value,
                  activeColor: colorBtn,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked.value = value ?? false;
                    });
                  },
                );
              }),
              SizedBox(width: 8),
              Txt(
                'Remember me',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {

              },
              child: Txt('Sign in'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget PopUpMenuButtonWidget(RxString selectedItem, var size, RxString hoveredIndex, Widget box,) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: widget.borderButtonColor!,
          width: 1,
        ),
      ),
      offset: Offset(0,50),
      onSelected: (value) {
        selectedItem.value = value;
      },
      onOpened: () {
        selectedItem.value = '';
      },
      color: this.widget.ColorDropDownBox,
      itemBuilder: (BuildContext context) => widget.hasForm == false
          ? [
        if(widget.itemsDropDown != null)
          ...widget.itemsDropDown!.map((item) {
            if (item.isHeader!) {
              return PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              enabled: false,
              child: Container(
                width: size.width,
                padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
                child: Txt(
                  item.text,
                  color: widget.ColorDisableTxt,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          } else if (item.isDisabled) {
            return PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              enabled: false,
              child: Container(
                width: size.width,
                padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
                child: Txt(
                  item.text,
                  color: widget.ColorDisableTxt,
                ),
              ),
            );
          } else if (!item.isInteractive) {
            // آیتم‌های غیرفعال (isInteractive = false)
            return PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              enabled: false,
              child: Container(
                width: size.width,
                padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
                child: Txt(
                  item.text,
                  color: this.widget.ColorTitleDropDownBox,
                ),
              ),
            );
          } else {
            // آیتم‌های فعال (isInteractive = true)
            return PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              value: item.value,
              child: MouseRegion(
                onEnter: (_) {
                  if (!item.isActive) {
                    hoveredIndex.value = item.text;
                  }
                },
                onExit: (_) {
                  hoveredIndex.value = '';
                },
                child: Obx(() {
                  final isFirstItemAndActiveFirst = (item.isActiveFirst ?? false) &&
                      widget.itemsDropDown!.indexOf(item) == 0;
                  final isActive = item.isActive ||
                      selectedItem.value == item.text ||
                      (selectedItem.value.isEmpty && isFirstItemAndActiveFirst);
                  return Container(
                    color: hoveredIndex.value == item.text && !isActive
                        ? widget.ColorHoverBox
                      : isActive
                        ? this.widget.ColorActiveBox
                        : Colors.transparent,
                    width: size.width,
                    padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
                    child: Txt(
                      item.text,
                      color: this.widget.ColorTitleDropDownBox,
                    ),
                  );
                }),
              ),
            );
          }
        }).toList(),
        if (this.widget.spreadLinkList != null) const PopupMenuDivider(),
        if (this.widget.spreadLinkList != null)
          for (var item in this.widget.spreadLinkList!)
            PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              value: item,
              child: MouseRegion(
                onEnter: (_) {
                  hoveredIndex.value = item;
                },
                onExit: (_) {
                  hoveredIndex.value = '';
                },
                child: Obx(() {
                  return Container(
                    color: hoveredIndex.value == item
                        ? widget.ColorHoverBox
                        : selectedItem.value == item
                        ? this.widget.ColorActiveBox
                        : Colors.transparent,
                    width: size.width,
                    child: Container(
                      padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
                      child: Txt(item, color: this.widget.ColorTitleDropDownBox),
                    ),
                  );
                }),
              ),
            ),
      ]
          : [
        PopupMenuItem<String>(
          enabled: false,
          child: FormWidget(),
        ),
        if (this.widget.spreadLinkList != null) const PopupMenuDivider(),
        if (this.widget.spreadLinkList != null)
          for (var item in this.widget.spreadLinkList!)
            PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              value: item,
              child: MouseRegion(
                onEnter: (_) {
                  hoveredIndex.value = item;
                },
                onExit: (_) {
                  hoveredIndex.value = '';
                },
                child: Obx(() {
                  return Container(
                    color: hoveredIndex.value == item
                        ? widget.ColorHoverBox
                        : selectedItem.value == item
                        ? this.widget.ColorActiveBox
                        : Colors.transparent,
                    width: size.width,
                    child: Container(
                      padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
                      child: Txt(item, color: this.widget.ColorTitleDropDownBox),
                    ),
                  );
                }),
              ),
            ),
      ],
      child: IntrinsicWidth(child: box,),
    );
  }
}
