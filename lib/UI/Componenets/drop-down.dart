import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
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
  List<DropdownItem>? itemsDropDown;
  String dropDownTitle;
  Color? dropDownTitelColor;
  Color? colorBox;
  Color? colorHoverBox;
  Color? iconColor;
  bool? isSplitButton;
  List<String>? spreadLinkList;
  DropDownSize size;
  Color? ColorDropDownBox;
  Color? ColorTitleDropDownBox;
  bool? showActiveSelectItem;
  Color? ColorActiveBox;
  directions? direction;
  Color? borderButtonColor;
  bool? hasForm;


  Dropdown({
     this.itemsDropDown,
    required this.dropDownTitle,
    this.dropDownTitelColor = whiteColor,
    this.colorBox = color31,
    this.colorHoverBox = color33,
    this.iconColor = whiteColor,
    this.isSplitButton = false,
    this.spreadLinkList,
    this.size = DropDownSize.medium,
    this.ColorDropDownBox = whiteColor,
    this.ColorTitleDropDownBox = blackColor,
    this.showActiveSelectItem = false,
    this.ColorActiveBox = colorBtn,
    this.direction = directions.down,
    this.borderButtonColor = color5,
    this.hasForm = false,

  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  late final GlobalKey buttonKey = GlobalKey();
  late final GlobalKey<PopupMenuButtonState<String>> popupMenuKey = GlobalKey();
  Offset? menuOffset;
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

  IconData getIconDirection(){
    switch (this.widget.direction) {
      case directions.down:
        return Icons.arrow_drop_down;
      case directions.up:
        return Icons.arrow_drop_up;
      case directions.start:
        return Icons.arrow_right;
      case directions.end:
        return Icons.arrow_left;
      default:
        return Icons.arrow_drop_down;
    }

  }

  Offset getOffset() {
    final renderBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;
    final popupState = popupMenuKey.currentState;



    // if (popupState == null) return Offset.zero;

    if (renderBox == null) return Offset.zero;


    final size = renderBox.size;

    switch (widget.direction) {
      case directions.up:
        return Offset(0, -size.height - 5);
      case directions.down:
        return Offset(0, size.height + 5);
      case directions.start:
        return Offset((-size.width) - 5, 0);
      case directions.end:
        return Offset((size.width)-5, 0);
      case directions.right:
        return Offset(0, size.height + 5);
      case directions.left:
        return Offset(size.width, size.height + 5);
      default: return Offset(0, size.height + 5);
    }
  }



  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && buttonKey.currentContext != null) {
        setState(() {
          menuOffset = getOffset();
        });
      }
    });
    var size = MediaQuery.of(context).size;

    Rx<bool> isHoverMain = false.obs;
    Rx<bool> isHoverSplit = false.obs;

    return Obx(() {
      return this.widget.isSplitButton!
          ? Container(
        decoration: BoxDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MouseRegion(
              onEnter: (_) {
                isHoverSplit.value = true;
              },
              onExit: (_) {
                isHoverSplit.value = false;
              },
              child: PopUpMenuButtonWidget(selectedItem, size, hoveredIndex, Container(
                padding: EdgeInsets.only(
                    left: 9, right: 9, top: 11, bottom: 11),
                decoration: BoxDecoration(
                  color: isHoverSplit.value
                      ? this.widget.colorHoverBox
                      : this.widget.colorBox,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Icon(getIconDirection(),
                    color: this.widget.iconColor, size:getIconSize()),
              ), buttonKey, popupMenuKey),
        //       child: PopupMenuButton<String>(
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(16),
        //           side: BorderSide(
        //             color: widget.borderButtonColor!,
        //             width: 1,
        //           ),
        //         ),
        //         offset: getOffset(),
        //         onSelected: (value){
        //           selectedItem.value = value;
        //         },
        //         onOpened: (){
        //           selectedItem.value = '';
        //         },
        //         color: this.widget.ColorDropDownBox,
        //         itemBuilder: (BuildContext context) =>
        //         widget.hasForm == false ?
        //         [
        //           ...widget.itemsDropDown!.map((item) =>
        //        item.isDisabled ? PopupMenuItem<String>(
        //        padding: EdgeInsets.zero,
        //        enabled: false,
        //        child: Container(
        //   width: size.width,
        //   padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
        //   child: Txt(
        //     item.text,
        //     color: Colors.grey.shade400,
        //   ),
        // ),
        //       ):
        //           item.isInteractive?
        //               PopupMenuItem<String>(
        //             padding: EdgeInsets.zero,
        //             value: item.value,
        //             child: Obx((){
        //               final isActive = item.isActive ||
        //                   selectedItem.value == item.text ||
        //                   (selectedItem.value.isEmpty &&
        //                       widget.itemsDropDown!.indexOf(item) == 0);
        //               return Container(
        //                   // color:hoveredIndex.value == item && widget.itemsDropDown.indexOf(item) != 0 ? Colors.grey[300] :  selectedItem.value == item ||
        //                   //     (selectedItem.value.isEmpty && widget.itemsDropDown.indexOf(item) == 0)
        //                   //     ? this.widget.ColorActiveBox
        //                   //     : Colors.transparent,
        //                   color: hoveredIndex.value == item.text
        //                       ? Colors.grey[300]
        //                       : isActive
        //                       ? this.widget.ColorActiveBox
        //                       : Colors.transparent,
        //                   width: size.width,
        //                   padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
        //                   child: Txt(item.text , color: this.widget.ColorTitleDropDownBox,));
        //             })
        //           ):
        //           PopupMenuItem<String>(
        //               padding: EdgeInsets.zero,
        //               enabled: false,
        //               child: Obx((){
        //                 return Container(
        //                     color:hoveredIndex.value == item && widget.itemsDropDown!.indexOf(item) != 0 ? Colors.grey[300] :  selectedItem.value == item ||
        //                         (selectedItem.value.isEmpty && widget.itemsDropDown!.indexOf(item) == 0)
        //                         ? this.widget.ColorActiveBox
        //                         : Colors.transparent,
        //                     width: size.width,
        //                     padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
        //                     child: Txt(item.text , color: this.widget.ColorTitleDropDownBox,));
        //               })
        //           )).toList(),
        //           if (this.widget.spreadLinkList != null)
        //           const PopupMenuDivider(),
        //           if (this.widget.spreadLinkList != null)
        //             for(var item in this.widget.spreadLinkList!)
        //               PopupMenuItem<String>(
        //              padding: EdgeInsets.zero,
        //               value: item,
        //               child: MouseRegion(
        //               onEnter: (_){
        //                 hoveredIndex.value = item;
        //               },
        //               onExit: (_){
        //                 hoveredIndex.value = '';
        //               },
        //               child: Obx((){
        //                 return Container(
        //                     color: hoveredIndex.value == item? Colors.grey[300]: selectedItem.value == item
        //                         ? this.widget.ColorActiveBox
        //                         : Colors.transparent,
        //                     width: size.width,
        //                     child: Container(
        //                         padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
        //                         child: Txt(item, color: this.widget.ColorTitleDropDownBox,)));
        //               })
        //             ),
        //           ),
        //         ]:
        //         [
        //           PopupMenuItem<String>(
        //             enabled: false,
        //             child: FormWidget(),
        //           ),
        //           if (this.widget.spreadLinkList != null)
        //             const PopupMenuDivider(),
        //           if (this.widget.spreadLinkList != null)
        //             for(var item in this.widget.spreadLinkList!)
        //               PopupMenuItem<String>(
        //                 padding: EdgeInsets.zero,
        //                 value: item,
        //                 child: MouseRegion(
        //                     onEnter: (_){
        //                       hoveredIndex.value = item;
        //                     },
        //                     onExit: (_){
        //                       hoveredIndex.value = '';
        //                     },
        //                     child: Obx((){
        //                       return Container(
        //                           color: hoveredIndex.value == item? Colors.grey[300]: selectedItem.value == item
        //                               ? this.widget.ColorActiveBox
        //                               : Colors.transparent,
        //                           width: size.width,
        //                           child: Container(
        //                               padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
        //                               child: Txt(item, color: this.widget.ColorTitleDropDownBox,)));
        //                     })
        //                 ),
        //               ),
        //         ],
        //         child: Container(
        //           padding: EdgeInsets.only(
        //               left: 9, right: 9, top: 11, bottom: 11),
        //           decoration: BoxDecoration(
        //             color: isHoverSplit.value
        //                 ? this.widget.colorHoverBox
        //                 : this.widget.colorBox,
        //             borderRadius: BorderRadius.only(
        //                 topRight: Radius.circular(15),
        //                 bottomRight: Radius.circular(15)),
        //           ),
        //           child: Icon(getIconDirection(),
        //               color: this.widget.iconColor, size:getIconSize()),
        //         ),
        //       ),
            ),
            MouseRegion(
              onEnter: (_) {
                isHoverMain.value = true;
              },
              onExit: (_) {
                isHoverMain.value = false;
              },
              child: Container(
                padding: EdgeInsets.only(
                    left: 12, right: 12, top: 6, bottom: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                  color: isHoverMain.value
                      ? this.widget.colorHoverBox
                      : this.widget.colorBox,
                ),
                child: Txt(this.widget.dropDownTitle,
                    color: this.widget.dropDownTitelColor , fontSize: getFontSize(), fontWeight: FontWeight.w400,),
              ),
            ),
          ],
        ),
      )
          : Container(
            key: buttonKey,
            child: PopUpMenuButtonWidget(selectedItem, size, hoveredIndex,  MouseRegion(
              onEnter: (_) {
                isHover.value = true;
              },
              onExit: (_) {
                isHover.value = false;
              },
              child:Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:
                  isHover.value ? this.widget.colorHoverBox : this.widget.colorBox,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: this.widget.direction == directions.start?Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Txt(this.widget.dropDownTitle,
                        color: this.widget.dropDownTitelColor , fontSize: getFontSize()),
                    Icon(getIconDirection(),
                        color: this.widget.iconColor, size: getIconSize()),
                  ],
                ) :Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(getIconDirection(),
                        color: this.widget.iconColor, size: getIconSize()),
                    Txt(this.widget.dropDownTitle,
                        color: this.widget.dropDownTitelColor , fontSize: getFontSize()),
                  ],
                ),
              )
            ), buttonKey, popupMenuKey),
            // child:  PopupMenuButton<String>(
            //   key: popupMenuKey,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(16),
            //     side: BorderSide(
            //       color: widget.borderButtonColor!,
            //       width: 1,
            //     ),
            //   ),
            //   offset: getOffset(),
            //   onSelected: (value){
            //     selectedItem.value = value;
            //   },
            //   onOpened: (){
            //     selectedItem.value = '';
            //   },
            //   color: this.widget.ColorDropDownBox,
            //   itemBuilder: (BuildContext context) =>
            //   widget.hasForm == false ?
            //   [
            //     ...widget.itemsDropDown!.map((item) =>
            //     item.isHeader! ?  PopupMenuItem<String>(
            //       padding: EdgeInsets.zero,
            //       enabled: false,
            //       child: Container(
            //         width: size.width,
            //         padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
            //         child: Txt(
            //           item.text,
            //           color: Colors.grey.shade400,
            //           fontSize: 14,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     ):
            //     item.isDisabled ? PopupMenuItem<String>(
            //       padding: EdgeInsets.zero,
            //       enabled: false,
            //       child: Container(
            //         width: size.width,
            //         padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
            //         child: Txt(
            //           item.text,
            //           color: Colors.grey.shade400,
            //         ),
            //       ),
            //     ):
            //     item.isInteractive?
            //     PopupMenuItem<String>(
            //       padding: EdgeInsets.zero,
            //       value: item.value,
            //       child: MouseRegion(
            //           onEnter: (_){
            //             hoveredIndex.value = item.text;
            //           },
            //           onExit: (_){
            //             hoveredIndex.value = '';
            //           },
            //           child: Obx((){
            //             final isActive = item.isActive ||
            //                 selectedItem.value == item.text ||
            //                 (selectedItem.value.isEmpty &&
            //                     widget.itemsDropDown!.indexOf(item) == 0);
            //             return Container(
            //               // color:hoveredIndex.value == item && widget.itemsDropDown.indexOf(item) != 0 ? Colors.grey[300]  :  selectedItem.value == item ||
            //               //     (selectedItem.value.isEmpty && widget.itemsDropDown.indexOf(item) == 0)
            //               //     ? this.widget.ColorActiveBox
            //               //     : Colors.transparent,
            //                 color: hoveredIndex.value == item.text
            //                     ? Colors.grey[300]
            //                     : isActive
            //                     ? this.widget.ColorActiveBox
            //                     : Colors.transparent,
            //                 width: size.width,
            //                 padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
            //
            //                 child: Txt(item.text , color: this.widget.ColorTitleDropDownBox,  ));
            //           })
            //       ),
            //     ):
            //     PopupMenuItem<String>(
            //       padding: EdgeInsets.zero,
            //       enabled: false,
            //       child: MouseRegion(
            //           onEnter: (_){
            //             hoveredIndex.value = item.text;
            //           },
            //           onExit: (_){
            //             hoveredIndex.value = '';
            //           },
            //           child: Obx((){
            //             final isActive = item.isActive ||
            //                 selectedItem.value == item.text ||
            //                 (selectedItem.value.isEmpty &&
            //                     widget.itemsDropDown!.indexOf(item) == 0);
            //             return Container(
            //                 color:hoveredIndex.value == item && widget.itemsDropDown!.indexOf(item) != 0 ? Colors.grey[300]  :  selectedItem.value == item ||
            //                     (selectedItem.value.isEmpty && widget.itemsDropDown!.indexOf(item) == 0)
            //                     ? this.widget.ColorActiveBox
            //                     : Colors.transparent,
            //                 width: size.width,
            //                 padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
            //
            //                 child: Txt(item.text , color: this.widget.ColorTitleDropDownBox,  ));
            //           })
            //       ),
            //     )).toList(),
            //     if (this.widget.spreadLinkList != null)
            //       const PopupMenuDivider(),
            //     if (this.widget.spreadLinkList != null)
            //       for(var item in this.widget.spreadLinkList!)
            //           PopupMenuItem<String>(
            //         padding: EdgeInsets.zero,
            //         value: item,
            //         child: Container(
            //             color: selectedItem.value == item
            //                 ? this.widget.ColorActiveBox : Colors.transparent,
            //             width: size.width,
            //             child: MouseRegion(
            //               onEnter: (_){
            //                 hoveredIndex.value = item;
            //               },
            //               onExit: (_){
            //                 hoveredIndex.value = '';
            //               },
            //               child: Obx((){
            //                 return Container(
            //                     color: hoveredIndex.value == item ? Colors.grey[300]: selectedItem.value == item
            //                         ? this.widget.ColorActiveBox
            //                         : Colors.transparent,
            //                     width: size.width,
            //                     padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
            //                     child: Txt(item, color: this.widget.ColorTitleDropDownBox,));
            //               }),
            //             )),
            //       ),
            //   ] :
            //   [
            //     PopupMenuItem<String>(
            //       enabled: false,
            //       child: FormWidget(),
            //     ),
            //     if (this.widget.spreadLinkList != null)
            //       const PopupMenuDivider(),
            //     if (this.widget.spreadLinkList != null)
            //       for(var item in this.widget.spreadLinkList!)
            //         PopupMenuItem<String>(
            //           padding: EdgeInsets.zero,
            //           value: item,
            //           child: MouseRegion(
            //               onEnter: (_){
            //                 hoveredIndex.value = item;
            //               },
            //               onExit: (_){
            //                 hoveredIndex.value = '';
            //               },
            //               child: Obx((){
            //                 return Container(
            //                     color: hoveredIndex.value == item? Colors.grey[300]: selectedItem.value == item
            //                         ? this.widget.ColorActiveBox
            //                         : Colors.transparent,
            //                     width: size.width,
            //                     child: Container(
            //                         padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
            //                         child: Txt(item, color: this.widget.ColorTitleDropDownBox,)));
            //               })
            //           ),
            //         ),
            //   ],
            //   child: MouseRegion(
            //     onEnter: (_) {
            //       isHover.value = true;
            //     },
            //     onExit: (_) {
            //       isHover.value = false;
            //     },
            //     child: Container(
            //       padding:
            //       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //       decoration: BoxDecoration(
            //         color:
            //         isHover.value ? this.widget.colorHoverBox : this.widget.colorBox,
            //         borderRadius: BorderRadius.circular(15),
            //       ),
            //       child: this.widget.direction == directions.start?Row(
            //         mainAxisSize: MainAxisSize.min,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Txt(this.widget.dropDownTitle,
            //               color: this.widget.dropDownTitelColor , fontSize: getFontSize()),
            //           Icon(getIconDirection(),
            //               color: this.widget.iconColor, size: getIconSize()),
            //         ],
            //       ) :Row(
            //         mainAxisSize: MainAxisSize.min,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Icon(getIconDirection(),
            //               color: this.widget.iconColor, size: getIconSize()),
            //           Txt(this.widget.dropDownTitle,
            //               color: this.widget.dropDownTitelColor , fontSize: getFontSize()),
            //         ],
            //       ),
            //     ),
            //   ),
            // )
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
  Widget PopUpMenuButtonWidget(RxString selectedItem, var size , RxString hoveredIndex , Widget box , buttonKey,popupMenuKey){
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: widget.borderButtonColor!,
          width: 1,
        ),
      ),
      offset: getOffset(),
      onSelected: (value){
        selectedItem.value = value;
      },
      onOpened: (){
        selectedItem.value = '';
      },
      color: this.widget.ColorDropDownBox,
      itemBuilder: (BuildContext context) =>
      widget.hasForm == false ?
      [
        ...widget.itemsDropDown!.map((item) =>
        item.isDisabled ? PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          enabled: false,
          child: Container(
            width: size.width,
            padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
            child: Txt(
              item.text,
              color: Colors.grey.shade400,
            ),
          ),
        ):
        item.isInteractive?
        // PopupMenuItem<String>(
        //     padding: EdgeInsets.zero,
        //     value: item.value,
        //     child: Obx((){
        //       final isActive = item.isActive ||
        //           selectedItem.value == item.text ||
        //           (selectedItem.value.isEmpty &&
        //               widget.itemsDropDown!.indexOf(item) == 0);
        //         return Container(
        //           // color:hoveredIndex.value == item && widget.itemsDropDown.indexOf(item) != 0 ? Colors.grey[300] :  selectedItem.value == item ||
        //           //     (selectedItem.value.isEmpty && widget.itemsDropDown.indexOf(item) == 0)
        //           //     ? this.widget.ColorActiveBox
        //           //     : Colors.transparent,
        //             color: hoveredIndex.value == item.text
        //                 ? Colors.grey[300]
        //                 : isActive
        //                 ? this.widget.ColorActiveBox
        //                 : Colors.transparent,
        //             width: size.width,
        //             padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
        //             child: Txt(item.text , color: this.widget.ColorTitleDropDownBox,));
        //
        //     })
        // ):
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          value: item.value,
          child: MouseRegion(
            onEnter: (_) {
              hoveredIndex.value = item.text;
            },
            onExit: (_) {
              hoveredIndex.value = '';
            },
            child: Obx(() {
              final isActive = item.isActive ||
                  selectedItem.value == item.text ||
                  (selectedItem.value.isEmpty &&
                      widget.itemsDropDown!.indexOf(item) == 0);
              return Container(
                color: hoveredIndex.value == item.text
                    ? Colors.grey[300]
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
        ):
        PopupMenuItem<String>(
            padding: EdgeInsets.zero,
            enabled: false,
            child: Obx((){
              return Container(
                  color:hoveredIndex.value == item && widget.itemsDropDown!.indexOf(item) != 0 ? Colors.grey[300] :  selectedItem.value == item ||
                      (selectedItem.value.isEmpty && widget.itemsDropDown!.indexOf(item) == 0)
                      ? this.widget.ColorActiveBox
                      : Colors.transparent,
                  width: size.width,
                  padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
                  child: Txt(item.text , color: this.widget.ColorTitleDropDownBox,));
            })
        )).toList(),
        if (this.widget.spreadLinkList != null)
          const PopupMenuDivider(),
        if (this.widget.spreadLinkList != null)
          for(var item in this.widget.spreadLinkList!)
            PopupMenuItem<String>(
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
                        color: hoveredIndex.value == item? Colors.grey[300]: selectedItem.value == item
                            ? this.widget.ColorActiveBox
                            : Colors.transparent,
                        width: size.width,
                        child: Container(
                            padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
                            child: Txt(item, color: this.widget.ColorTitleDropDownBox,)));
                  })
              ),
            ),
      ]:
      [
        PopupMenuItem<String>(
          enabled: false,
          child: FormWidget(),
        ),
        if (this.widget.spreadLinkList != null)
          const PopupMenuDivider(),
        if (this.widget.spreadLinkList != null)
          for(var item in this.widget.spreadLinkList!)
            PopupMenuItem<String>(
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
                        color: hoveredIndex.value == item? Colors.grey[300]: selectedItem.value == item
                            ? this.widget.ColorActiveBox
                            : Colors.transparent,
                        width: size.width,
                        child: Container(
                            padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
                            child: Txt(item, color: this.widget.ColorTitleDropDownBox,)));
                  })
              ),
            ),
      ],
      child: box,
    );
  }
}

class DropdownItem {
   String text;
   bool isInteractive;
   String? value;
   bool isActive;
   bool isDisabled;
   bool? isHeader;



  DropdownItem({
    required this.text,
    this.isInteractive = true,
    this.value,
    this.isActive = false,
    this.isDisabled = false,
    this.isHeader = false,
  });
}

// class _DropdownState extends State<Dropdown> {
//   late final GlobalKey buttonKey = GlobalKey();
//   final RxString selectedItem = RxString('');
//   final RxString hoveredIndex = RxString('');
//   final RxBool isHover = RxBool(false);
//   final RxBool isHoverMain = RxBool(false);
//   final RxBool isHoverSplit = RxBool(false);
//   Offset? menuOffset;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//   double getFontSize() {
//     switch (this.widget.size) {
//       case DropDownSize.small:
//         return 14;
//       case DropDownSize.large:
//         return 20;
//       case DropDownSize.medium:
//         return 16;
//       default:
//         return 16;
//     }
//   }
//
//   double getIconSize(){
//     switch (this.widget.size) {
//       case DropDownSize.small:
//         return 15;
//       case DropDownSize.large:
//         return 25;
//       case DropDownSize.medium:
//         return 15;
//       default:
//         return 15;
//     }
//   }
//
//   IconData getIconDirection(){
//     switch (this.widget.direction) {
//       case directions.down:
//         return Icons.arrow_drop_down;
//       case directions.up:
//         return Icons.arrow_drop_up;
//       case directions.start:
//         return Icons.arrow_right;
//       case directions.end:
//         return Icons.arrow_left;
//       default:
//         return Icons.arrow_drop_down;
//     }
//
//   }
//
//   Offset getOffset() {
//     final renderBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;
//     if (renderBox == null) return Offset.zero;
//
//     final size = renderBox.size;
//
//     switch (widget.direction) {
//       case directions.up:
//         return Offset(0, -size.height - 190);
//       case directions.down:
//         return Offset(0, size.height + 5);
//       case directions.start:
//         return Offset((-size.width) - 5, 0);
//       case directions.end:
//         return Offset((size.width)-5, 0);
//       default: return Offset(0, size.height + 5);
//     }
//   }
//
//
//   // Widget _buildMenuItem(DropdownItem item, BuildContext context) {
//   //   final size = MediaQuery.of(context).size;
//   //   final isActive = item.isActive ||
//   //       selectedItem.value == item.text ||
//   //       (selectedItem.value.isEmpty && widget.itemsDropDown.indexOf(item) == 0);
//   //
//   //   if (item.isDisabled) {
//   //     return PopupMenuItem<String>(
//   //       padding: EdgeInsets.zero,
//   //       enabled: false,
//   //       child: Container(
//   //         width: size.width,
//   //         padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
//   //         child: Txt(
//   //           item.text,
//   //           color: Colors.grey.shade400,
//   //         ),
//   //       ),
//   //     );
//   //   }
//   //
//   //   if (!item.isInteractive) {
//   //     return PopupMenuItem<String>(
//   //       padding: EdgeInsets.zero,
//   //       enabled: false,
//   //       child: Container(
//   //         width: size.width,
//   //         padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
//   //         child: Txt(item.text, color: widget.ColorTitleDropDownBox),
//   //       ),
//   //     );
//   //   }
//   //
//   //   return PopupMenuItem<String>(
//   //     padding: EdgeInsets.zero,
//   //     value: item.value ?? item.text,
//   //     child: MouseRegion(
//   //       onEnter: (_) => hoveredIndex.value = item.text,
//   //       onExit: (_) => hoveredIndex.value = '',
//   //       child: Obx(() => Container(
//   //         color: hoveredIndex.value == item.text
//   //             ? Colors.grey[300]
//   //             : isActive
//   //             ? widget.ColorActiveBox
//   //             : Colors.transparent,
//   //         width: size.width,
//   //         padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
//   //         child: Txt(
//   //           item.text,
//   //           color: isActive ? Colors.white : widget.ColorTitleDropDownBox,
//   //         ),
//   //       )),
//   //     ),
//   //   );
//   // }
//   PopupMenuEntry<String> _buildMenuItem(DropdownItem item, BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isActive = item.isActive ||
//         selectedItem.value == item.text ||
//         (selectedItem.value.isEmpty && widget.itemsDropDown.indexOf(item) == 0);
//
//     if (item.isDisabled) {
//       return PopupMenuItem<String>(
//         padding: EdgeInsets.zero,
//         enabled: false,
//         child: Container(
//           width: size.width,
//           padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
//           child: Txt(
//             item.text,
//             color: Colors.grey.shade400,
//           ),
//         ),
//       );
//     }
//
//     if (!item.isInteractive) {
//       return PopupMenuItem<String>(
//         padding: EdgeInsets.zero,
//         enabled: false,
//         child: Container(
//           width: size.width,
//           padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
//           child: Txt(item.text, color: widget.ColorTitleDropDownBox),
//         ),
//       );
//     }
//
//     return PopupMenuItem<String>(
//       padding: EdgeInsets.zero,
//       value: item.value ?? item.text,
//       child: MouseRegion(
//         onEnter: (_) => hoveredIndex.value = item.text,
//         onExit: (_) => hoveredIndex.value = '',
//         child: Obx(() => Container(
//           color: hoveredIndex.value == item.text
//               ? Colors.grey[300]
//               : isActive
//               ? widget.ColorActiveBox
//               : Colors.transparent,
//           width: size.width,
//           padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
//           child: Txt(
//             item.text,
//             color: isActive ? Colors.white : widget.ColorTitleDropDownBox,
//           ),
//         )),
//       ),
//     );
//   }
//
//   Widget _buildButtonContent() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: isHover.value ? widget.colorHoverBox : widget.colorBox,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: widget.direction == directions.start
//           ? Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Txt(widget.dropDownTitle,
//               color: widget.dropDownTitelColor, fontSize: getFontSize()),
//           Icon(getIconDirection(),
//               color: widget.iconColor, size: getIconSize()),
//         ],
//       )
//           : Row(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(getIconDirection(),
//               color: widget.iconColor, size: getIconSize()),
//           Txt(widget.dropDownTitle,
//               color: widget.dropDownTitelColor, fontSize: getFontSize()),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSplitButton() {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         MouseRegion(
//           onEnter: (_) => isHoverSplit.value = true,
//           onExit: (_) => isHoverSplit.value = false,
//           child: PopupMenuButton<String>(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//               side: BorderSide(color: widget.borderButtonColor!, width: 1),
//             ),
//             offset: getOffset(),
//             onSelected: (value) => selectedItem.value = value,
//             onOpened: () => selectedItem.value = '',
//             color: widget.ColorDropDownBox,
//             itemBuilder: (context) => [
//               ...widget.itemsDropDown.map((item) => _buildMenuItem(item, context)),
//               if (widget.spreadLink != null) const PopupMenuDivider(),
//               if (widget.spreadLink != null)
//                 _buildMenuItem(
//                   DropdownItem(
//                     text: widget.spreadLink!,
//                     value: widget.spreadLink,
//                   ),
//                   context,
//                 ),
//             ],
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 11),
//               decoration: BoxDecoration(
//                 color: isHoverSplit.value ? widget.colorHoverBox : widget.colorBox,
//                 borderRadius: const BorderRadius.only(
//                     topRight: Radius.circular(15),
//                     bottomRight: Radius.circular(15)),
//               ),
//               child: Icon(getIconDirection(),
//                   color: widget.iconColor, size: getIconSize()),
//             ),
//           ),
//         ),
//         MouseRegion(
//           onEnter: (_) => isHoverMain.value = true,
//           onExit: (_) => isHoverMain.value = false,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(15),
//                   bottomLeft: Radius.circular(15)),
//               color: isHoverMain.value ? widget.colorHoverBox : widget.colorBox,
//             ),
//             child: Txt(
//               widget.dropDownTitle,
//               color: widget.dropDownTitelColor,
//               fontSize: getFontSize(),
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted && buttonKey.currentContext != null) {
//         setState(() => menuOffset = getOffset());
//       }
//     });
//
//     return Obx(() => widget.isSplitButton!
//         ? _buildSplitButton()
//         : Container(
//       key: buttonKey,
//       child: PopupMenuButton<String>(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//           side: BorderSide(color: widget.borderButtonColor!, width: 1),
//         ),
//         offset: getOffset(),
//         onSelected: (value) => selectedItem.value = value,
//         onOpened: () => selectedItem.value = '',
//         color: widget.ColorDropDownBox,
//         itemBuilder: (context) => [
//           ...widget.itemsDropDown.map((item) => _buildMenuItem(item, context)),
//           if (widget.spreadLink != null) const PopupMenuDivider(),
//           if (widget.spreadLink != null)
//             _buildMenuItem(
//               DropdownItem(
//                 text: widget.spreadLink!,
//                 value: widget.spreadLink,
//               ),
//               context,
//             ),
//         ],
//         child: MouseRegion(
//           onEnter: (_) => isHover.value = true,
//           onExit: (_) => isHover.value = false,
//           child: _buildButtonContent(),
//         ),
//       ),
//     ),
//     );
//   }
// }