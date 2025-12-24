import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';

class CustomAccordion extends StatefulWidget {
  String accordianTitle;
  Color accordianTitleColor;
  Color accordianBoxColor;
  String accordianDescription;
  Color accordianDescriptionColor;
  Color colorIcon;
  Color colorBoxDescription;
  double? width;
  bool? isOpen;
  Color? borderColor;


  CustomAccordion({
    required this.accordianTitle ,
    required this.accordianTitleColor ,
    required this.accordianBoxColor,
    required this.accordianDescription,
    required this.accordianDescriptionColor,
    required this.colorIcon,
    required this.colorBoxDescription,
    this.width,
    this.isOpen =  false,
    this.borderColor
  });
  @override
  _CustomAccordionState createState() => _CustomAccordionState();
}

class _CustomAccordionState extends State<CustomAccordion> {
  late bool _isExpanded;
  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isOpen ?? false;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            width: widget.width != null ? widget.width : size.width,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: widget.accordianBoxColor,
              border:widget.borderColor != null ? Border.all(width: 1, color: widget.borderColor!) : null
            ),
            child: Row(
              children: [
                Txt(
                  widget.accordianTitle,
                  color: widget.accordianTitleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                ),
                Spacer(),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: widget.colorIcon,
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            decoration: BoxDecoration(
              border:widget.borderColor != null ? Border.all(width: 1, color: widget.borderColor!) : null,
              color: widget.colorBoxDescription,
            ),
            width: widget.width != null ? widget.width : size.width,
            child: _isExpanded
                ? Padding(
              padding: EdgeInsets.all(16),
              child: Txt(
                widget.accordianDescription,
                color: widget.accordianDescriptionColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            )
                : null,
          ),
        ),
      ],
    );
  }
}
