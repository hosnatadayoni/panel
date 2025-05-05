import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// enum DropDownSize2 {
//   small,
//   medium,
//   large
// }
// enum directions2{
//   up,
//   end,
//   start,
//   down,
// }
// class CustomMenu extends StatelessWidget {
//
//   List<String> itemsDropDown;
//   String dropDownTitle;
//   Color? dropDownTitelColor;
//   Color? colorBox;
//   Color? colorHoverBox;
//   Color? iconColor;
//   bool? isSplitButton;
//   String? spreadLink;
//   DropDownSize2 size;
//   Color? ColorDropDownBox;
//   Color? ColorTitleDropDownBox;
//   bool? showActiveSelectItem;
//   Color? ColorActiveBox;
//   directions2? direction;
// CustomMenu({
//   required this.itemsDropDown,
//   required this.dropDownTitle,
//   this.dropDownTitelColor = whiteColor,
//   this.colorBox = color31,
//   this.colorHoverBox = color33,
//   this.iconColor = whiteColor,
//   this.isSplitButton = false,
//   this.spreadLink,
//   this.size = DropDownSize2.medium,
//   this.ColorDropDownBox = whiteColor,
//   this.ColorTitleDropDownBox = blackColor,
//   this.showActiveSelectItem = false,
//   this.ColorActiveBox = colorBtn,
//   this.direction = directions2.down,
//
// });
//
//
// @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     Rx<bool> isHover = false.obs;
//     Rx<bool> isHoverMain = false.obs;
//     Rx<bool> isHoverSplit = false.obs;
//     RxString selectedItem = RxString('');
//     RxString hoveredIndex = ''.obs;
//     return Row(
//       children: [
//
//         MouseRegion(
//           onEnter: (_) {
//             isHover.value = true;
//           },
//           onExit: (_) {
//             isHover.value = false;
//           },
//           child: Container(
//             padding:
//             const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color:
//               isHover.value ? this.colorHoverBox : this.colorBox,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: this.direction == directions2.start?Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Txt(this.dropDownTitle,
//                     color: this.dropDownTitelColor , fontSize: getFontSize()),
//                 Icon(getIconDirection(),
//                     color: this.iconColor, size: getIconSize()),
//               ],
//             ) :Row(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(getIconDirection(),
//                     color: this.iconColor, size: getIconSize()),
//                 Txt(this.dropDownTitle,
//                     color: this.dropDownTitelColor , fontSize: getFontSize()),
//               ],
//             ),
//           ),
//         ),
//         PopupMenuButton<String>(
//           // offset: getOffset(),
//           onSelected: (value){
//             selectedItem.value = value;
//           },
//           onOpened: (){
//             selectedItem.value = '';
//           },
//           color: this.ColorDropDownBox,
//           itemBuilder: (BuildContext context) => [
//             ...itemsDropDown.map((item) => PopupMenuItem<String>(
//               padding: EdgeInsets.zero,
//               value: item,
//               child: MouseRegion(
//                   onEnter: (_){
//                     hoveredIndex.value = item;
//                   },
//                   onExit: (_){
//                     hoveredIndex.value = '';
//                   },
//                   child: Obx((){
//                     return Container(
//                         color:hoveredIndex.value == item && itemsDropDown.indexOf(item) != 0 ? Colors.grey[300]  :  selectedItem.value == item ||
//                             (selectedItem.value.isEmpty && itemsDropDown.indexOf(item) == 0)
//                             ? this.ColorActiveBox
//                             : Colors.transparent,
//                         width: size.width,
//                         padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
//
//                         child: Txt(item , color: this.ColorTitleDropDownBox,  ));
//                   })
//               ),
//             )).toList(),
//             if(this.spreadLink != null)
//               const PopupMenuDivider(),
//             if(this.spreadLink != null)
//               PopupMenuItem<String>(
//                 padding: EdgeInsets.zero,
//                 value: this.spreadLink,
//                 child: Container(
//                     color: selectedItem.value == spreadLink
//                         ? this.ColorActiveBox : Colors.transparent,
//                     width: size.width,
//                     child: MouseRegion(
//                       onEnter: (_){
//                         hoveredIndex.value = this.spreadLink!;
//                       },
//                       onExit: (_){
//                         hoveredIndex.value = '';
//                       },
//                       child: Obx((){
//                         return Container(
//                             color: hoveredIndex.value == this.spreadLink! ? Colors.grey[300]: selectedItem.value == spreadLink
//                                 ? this.ColorActiveBox
//                                 : Colors.transparent,
//                             width: size.width,
//                             padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
//                             child: Txt(this.spreadLink! , color: this.ColorTitleDropDownBox,));
//                       }),
//                     )),
//               ),
//           ],
//         ),
//       ],
//     );
//   }
// double getFontSize() {
//   switch (this.size) {
//     case DropDownSize2.small:
//       return 14;
//     case DropDownSize2.large:
//       return 20;
//     case DropDownSize2.medium:
//       return 16;
//     default:
//       return 16;
//   }
// }
// double getIconSize(){
//   switch (this.size) {
//     case DropDownSize2.small:
//       return 15;
//     case DropDownSize2.large:
//       return 25;
//     case DropDownSize2.medium:
//       return 15;
//     default:
//       return 15;
//   }
// }
// IconData getIconDirection(){
//   switch (this.direction) {
//     case directions2.down:
//       return Icons.arrow_drop_down;
//     case directions2.up:
//       return Icons.arrow_drop_up;
//     case directions2.start:
//       return Icons.arrow_right;
//     case directions2.end:
//       return Icons.arrow_left;
//     default:
//       return Icons.arrow_drop_down;
//   }
//
// }
// }


// class CustomPopupMenu extends StatefulWidget {
//   @override
//   _CustomPopupMenuState createState() => _CustomPopupMenuState();
// }
//
// class _CustomPopupMenuState extends State<CustomPopupMenu> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   final GlobalKey _buttonKey = GlobalKey();
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: Duration(milliseconds: 200),
//       vsync: this,
//     );
//   }
//
//   void _toggleMenu() {
//     if (_controller.status == AnimationStatus.completed) {
//       _controller.reverse();
//     } else {
//       _controller.forward();
//       _showMenu();
//     }
//   }
//
//   void _showMenu() {
//     final RenderBox renderBox = _buttonKey.currentContext!.findRenderObject() as RenderBox;
//     final Offset position = renderBox.localToGlobal(Offset.zero);
//
//     showMenu(
//       context: context,
//       position: RelativeRect.fromLTRB(
//         position.dx - renderBox.size.width,
//         position.dy + renderBox.size.height,
//         position.dx + renderBox.size.width,
//         position.dy - renderBox.size.height,
//       ),
//       items: [
//         PopupMenuItem(child: Text('ویرایش'), value: 'edit'),
//         PopupMenuItem(child: Text('حذف'), value: 'delete'),
//       ],
//     ).then((_) => _controller.reverse());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       key: _buttonKey,
//       onTap: _toggleMenu,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.blue,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('منوی انیمیشنی', style: TextStyle(color: Colors.white)),
//             RotationTransition(
//               turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
//               child: Icon(Icons.arrow_drop_down, color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
//
//
// enum DropDownSize3 {
//   small,
//   medium,
//   large
// }
// enum directions3{
//   up,
//   end,
//   start,
//   down,
// }
// class MyApp extends StatelessWidget {
//   List<String> itemsDropDown;
//   String dropDownTitle;
//   Color? dropDownTitelColor;
//   Color? colorBox;
//   Color? colorHoverBox;
//   Color? iconColor;
//   bool? isSplitButton;
//   String? spreadLink;
//   DropDownSize3 size;
//   Color? ColorDropDownBox;
//   Color? ColorTitleDropDownBox;
//   bool? showActiveSelectItem;
//   Color? ColorActiveBox;
//   directions3? direction;
//   MyApp({
//     required this.itemsDropDown,
//     required this.dropDownTitle,
//     this.dropDownTitelColor = whiteColor,
//     this.colorBox = color31,
//     this.colorHoverBox = color33,
//     this.iconColor = whiteColor,
//     this.isSplitButton = false,
//     this.spreadLink,
//     this.size = DropDownSize3.medium,
//     this.ColorDropDownBox = whiteColor,
//     this.ColorTitleDropDownBox = blackColor,
//     this.showActiveSelectItem = false,
//     this.ColorActiveBox = colorBtn,
//     this.direction = directions3.down,
//
//   });
//   double getFontSize() {
//     switch (this.size) {
//       case DropDownSize3.small:
//         return 14;
//       case DropDownSize3.large:
//         return 20;
//       case DropDownSize3.medium:
//         return 16;
//       default:
//         return 16;
//     }
//   }
//   double getIconSize(){
//     switch (this.size) {
//       case DropDownSize3.small:
//         return 15;
//       case DropDownSize3.large:
//         return 25;
//       case DropDownSize3.medium:
//         return 15;
//       default:
//         return 15;
//     }
//   }
//   IconData getIconDirection(){
//     switch (this.direction) {
//       case directions3.down:
//         return Icons.arrow_drop_down;
//       case directions3.up:
//         return Icons.arrow_drop_up;
//       case directions3.start:
//         return Icons.arrow_right;
//       case directions3.end:
//         return Icons.arrow_left;
//       default:
//         return Icons.arrow_drop_down;
//     }
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     // return IconButton(
//     //   icon: Icon(Icons.more_vert),
//     //   onPressed: () {
//     //     _showCustomMenu(context);
//     //   },
//     // );
//     return InkWell(
//       onTap: (){
//         _showCustomMenu(context);
//       },
//       child: Container(
//         padding:
//         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           // color:
//           // isHover.value ? this.colorHoverBox : this.colorBox,
//           // borderRadius: BorderRadius.circular(15),
//         ),
//         child: this.direction == directions3.start?Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Txt(this.dropDownTitle,
//                 color: this.dropDownTitelColor , fontSize: getFontSize()),
//             Icon(getIconDirection(),
//                 color: this.iconColor, size: getIconSize()),
//           ],
//         ) :Row(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(getIconDirection(),
//                 color: this.iconColor, size: getIconSize()),
//             Txt(this.dropDownTitle,
//                 color: this.dropDownTitelColor , fontSize: getFontSize()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showCustomMenu(BuildContext context) async {
//     RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
//
//     // موقعیت دکمه را بدست آورید
//     final RenderBox button = context.findRenderObject() as RenderBox;
//     final Offset buttonPosition = button.localToGlobal(Offset.zero);
//     final Size buttonSize = button.size;
//
//     // موقعیت منو را تنظیم کنید
//     await showMenu(
//       context: context,
//       position: RelativeRect.fromLTRB(
//         buttonPosition.dx + buttonSize.width, // سمت راست دکمه
//         buttonPosition.dy, // بالای دکمه
//         0.0,
//         0.0,
//       ),
//       items: [
//         PopupMenuItem<String>(
//           value: 'گزینه 1',
//           child: Text('گزینه 1'),
//         ),
//         PopupMenuItem<String>(
//           value: 'گزینه 2',
//           child: Text('گزینه 2'),
//         ),
//         PopupMenuItem<String>(
//           value: 'گزینه 3',
//           child: Text('گزینه 3'),
//         ),
//       ],
//     ).then((value) {
//       if (value != null) {
//         // عمل مورد نظر را انجام دهید
//         print(value);
//       }
//     });
//   }
// }

// enum DropDownSize3 {
//   small,
//   medium,
//   large
// }
// enum directions3{
//   up,
//   end,
//   start,
//   down,
// }
// class CustomMenu extends StatelessWidget {
//   List<String> itemsDropDown;
//   String dropDownTitle;
//   Color? dropDownTitelColor;
//   Color? colorBox;
//   Color? colorHoverBox;
//   Color? iconColor;
//   bool? isSplitButton;
//   String? spreadLink;
//   DropDownSize3 size;
//   Color? ColorDropDownBox;
//   Color? ColorTitleDropDownBox;
//   bool? showActiveSelectItem;
//   Color? ColorActiveBox;
//   directions3? direction;
//
//   CustomMenu({
//     required this.itemsDropDown,
//     required this.dropDownTitle,
//     this.dropDownTitelColor = whiteColor,
//     this.colorBox = color31,
//     this.colorHoverBox = color33,
//     this.iconColor = whiteColor,
//     this.isSplitButton = false,
//     this.spreadLink,
//     this.size = DropDownSize3.medium,
//     this.ColorDropDownBox = whiteColor,
//     this.ColorTitleDropDownBox = blackColor,
//     this.showActiveSelectItem = false,
//     this.ColorActiveBox = colorBtn,
//     this.direction = directions3.down,
//
//   });
//
//   double getFontSize() {
//     switch (this.size) {
//       case DropDownSize3.small:
//         return 14;
//       case DropDownSize3.large:
//         return 20;
//       case DropDownSize3.medium:
//         return 16;
//       default:
//         return 16;
//     }
//   }
//   double getIconSize(){
//     switch (this.size) {
//       case DropDownSize3.small:
//         return 15;
//       case DropDownSize3.large:
//         return 25;
//       case DropDownSize3.medium:
//         return 15;
//       default:
//         return 15;
//     }
//   }
//   IconData getIconDirection(){
//     switch (this.direction) {
//       case directions3.down:
//         return Icons.arrow_drop_down;
//       case directions3.up:
//         return Icons.arrow_drop_up;
//       case directions3.start:
//         return Icons.arrow_right;
//       case directions3.end:
//         return Icons.arrow_left;
//       default:
//         return Icons.arrow_drop_down;
//     }
//
//   }
//   Offset getOffset() {
//     switch (direction) {
//       case directions3.up:
//         return Offset(0, -230);
//       case directions3.down:
//         return Offset(0, 40);
//       case directions3.start:
//         return Offset(-150,0);
//       case directions3.end:
//         return Offset(50 , 0);
//       default:
//         return Offset(0, 40);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     Rx<bool> isHover = false.obs;
//     Rx<bool> isHoverMain = false.obs;
//     Rx<bool> isHoverSplit = false.obs;
//     RxString selectedItem = RxString('');
//     RxString hoveredIndex = ''.obs;
//     return Row(
//       children: [
//         Column(
//           children: [
//             for(var item in itemsDropDown)
//               Obx((){
//                 return Container(
//                     color:hoveredIndex.value == item && itemsDropDown.indexOf(item) != 0 ? Colors.grey[300]  :  selectedItem.value == item ||
//                         (selectedItem.value.isEmpty && itemsDropDown.indexOf(item) == 0)
//                         ? this.ColorActiveBox
//                         : Colors.transparent,
//                     width: size.width,
//                     padding: EdgeInsets.only(top: 4, bottom: 4,left: 16,right: 16),
//
//                     child: Txt(item , color: this.ColorTitleDropDownBox,  ));
//               })
//
//           ],
//         ),
//         MouseRegion(
//           onEnter: (_) {
//             isHover.value = true;
//           },
//           onExit: (_) {
//             isHover.value = false;
//           },
//           child: Container(
//             padding:
//             const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color:
//               isHover.value ? this.colorHoverBox : this.colorBox,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: this.direction == directions3.start?Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Txt(this.dropDownTitle,
//                     color: this.dropDownTitelColor , fontSize: getFontSize()),
//                 Icon(getIconDirection(),
//                     color: this.iconColor, size: getIconSize()),
//               ],
//             ) :Row(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(getIconDirection(),
//                     color: this.iconColor, size: getIconSize()),
//                 Txt(this.dropDownTitle,
//                     color: this.dropDownTitelColor , fontSize: getFontSize()),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
enum DropDownSize3 {
  small,
  medium,
  large
}

enum directions3 {
  up,
  end,
  start,
  down,
}

class CustomMenu extends StatefulWidget {
  final List<String> itemsDropDown;
  final String dropDownTitle;
  final Color? dropDownTitelColor;
  final Color? colorBox;
  final Color? colorHoverBox;
  final Color? iconColor;
  final bool? isSplitButton;
  final String? spreadLink;
  final DropDownSize3 size;
  final Color? ColorDropDownBox;
  final Color? ColorTitleDropDownBox;
  final bool? showActiveSelectItem;
  final Color? ColorActiveBox;
  final directions3? direction;

  CustomMenu({
    required this.itemsDropDown,
    required this.dropDownTitle,
    this.dropDownTitelColor = Colors.white,
    this.colorBox = Colors.grey,
    this.colorHoverBox = Colors.blueGrey,
    this.iconColor = Colors.white,
    this.isSplitButton = false,
    this.spreadLink,
    this.size = DropDownSize3.medium,
    this.ColorDropDownBox = Colors.white,
    this.ColorTitleDropDownBox = Colors.black,
    this.showActiveSelectItem = false,
    this.ColorActiveBox = Colors.blue,
    this.direction = directions3.down,
  });

  @override
  _CustomMenuState createState() => _CustomMenuState();
}

class _CustomMenuState extends State<CustomMenu> {
  bool isMenuOpen = false;
  String? selectedItem;
  String? hoveredItem;

  double getFontSize() {
    switch (widget.size) {
      case DropDownSize3.small:
        return 14;
      case DropDownSize3.large:
        return 20;
      case DropDownSize3.medium:
        return 16;
      default:
        return 16;
    }
  }

  double getIconSize() {
    switch (widget.size) {
      case DropDownSize3.small:
        return 15;
      case DropDownSize3.large:
        return 25;
      case DropDownSize3.medium:
        return 15;
      default:
        return 15;
    }
  }

  IconData getIconDirection() {
    switch (widget.direction) {
      case directions3.down:
        return Icons.arrow_drop_down;
      case directions3.up:
        return Icons.arrow_drop_up;
      case directions3.start:
        return Icons.arrow_right;
      case directions3.end:
        return Icons.arrow_left;
      default:
        return Icons.arrow_drop_down;
    }
  }

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // دکمه اصلی
        InkWell(
          onTap: toggleMenu,
          child: MouseRegion(
            onEnter: (_) => setState(() {}),
            onExit: (_) => setState(() {}),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey, // رنگ پایه
                borderRadius: BorderRadius.circular(15),
              ),
              child: widget.direction == directions3.start
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.dropDownTitle,
                      style: TextStyle(
                          color: widget.dropDownTitelColor,
                          fontSize: getFontSize())),
                  Icon(getIconDirection(),
                      color: widget.iconColor, size: getIconSize()),
                ],
              )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(getIconDirection(),
                      color: widget.iconColor, size: getIconSize()),
                  Text(widget.dropDownTitle,
                      style: TextStyle(
                          color: widget.dropDownTitelColor,
                          fontSize: getFontSize())),
                ],
              ),
            ),
          ),
        ),

        // منوی آبشاری
        if (isMenuOpen)
          Container(
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: widget.ColorDropDownBox,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
              BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
              ),
              ],
            ),
            constraints: BoxConstraints(
              maxWidth: 200, // محدودیت عرض برای جلوگیری از overflow
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var item in widget.itemsDropDown)
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedItem = item;
                        isMenuOpen = false;
                      });
                    },
                    onHover: (isHovering) {
                      setState(() {
                        hoveredItem = isHovering ? item : null;
                      });
                    },
                    child: Container(
                      color: hoveredItem == item
                          ? Colors.grey[300]
                          : selectedItem == item
                          ? widget.ColorActiveBox
                          : Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Text(item,
                          style: TextStyle(color: widget.ColorTitleDropDownBox)),
                    ),
                  ),

                if (widget.spreadLink != null) Divider(height: 1),

                if (widget.spreadLink != null)
                  InkWell(
                    onTap: () {
                      setState(() {
                        isMenuOpen = false;
                      });
                      // عملیات مربوط به spreadLink
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Text(widget.spreadLink!,
                          style: TextStyle(color: widget.ColorTitleDropDownBox)),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}