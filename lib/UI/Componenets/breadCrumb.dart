import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';

class Breadcrumb extends StatefulWidget {
   List<BreadcrumbItem> items;
   Color? separatorColor;
   double separatorSize;
   Axis direction;
   MainAxisAlignment alignment;
   String? separator;
   bool showSeparator;
   double spaceBetweenItems;
   Color? itemClickedColor;
  double separatorPadding;
   Color? itemColor;

   Breadcrumb({
    required this.items,
    this.separatorColor,
    this.separatorSize = 16.0,
    this.direction = Axis.horizontal,
    this.alignment = MainAxisAlignment.start,
    this.separator = '>',
    this.showSeparator = true,
    this.spaceBetweenItems = 16.0,
    this.itemClickedColor,
    this.separatorPadding = 8.0,
    this.itemColor
  });

  @override
  State<Breadcrumb> createState() => _BreadcrumbState();
}

class _BreadcrumbState extends State<Breadcrumb> {
  int? activeIndex;
  List<bool> clickedStates = [];

  @override
  void initState() {
    super.initState();
    clickedStates = List<bool>.filled(widget.items.length, false);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      child: Flex(
        direction: widget.direction,
        mainAxisAlignment: widget.alignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.items.length * 2 - 1, (index) {
          if (index.isOdd) {
            if (widget.showSeparator) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: widget.separatorPadding),
                child: widget.separator == null || widget.separator!.isEmpty
                    ? SizedBox(width: widget.separatorSize)
                    : Txt(
                  widget.separator!,
                  fontSize: widget.separatorSize,
                  color: widget.separatorColor ?? color20,
                ),
              );
            } else {
              return SizedBox(width: widget.spaceBetweenItems);
            }
          }

          final itemIndex = index ~/ 2;
          final item = widget.items[itemIndex];
          final isFirst = itemIndex == 0;
          // final isClicked = activeIndex != null && itemIndex <= activeIndex!;
          // final isClicked = activeIndex == itemIndex;
          final isClicked = clickedStates[itemIndex];

          return InkWell(
            onTap: (){
                setState(() {
                  activeIndex = itemIndex;
                  clickedStates[itemIndex] = true;
                });
                item.onPressed?.call();
            },
            child: Txt(
              item.label,
              color: isClicked
                  ? widget.itemClickedColor
                  : widget.itemColor,
              textDecoration: isClicked
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          );
        }),
      ),
    );
  }
}

class BreadcrumbItem {
  final String label;
  final VoidCallback? onPressed;

  BreadcrumbItem({
    required this.label,
    this.onPressed,
  });
}