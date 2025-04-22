import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';

class CustomAccordion extends StatefulWidget {
  String accordianTitle;
  Color accordianTitleColor;
  Color accordianBoxColor;
  String accordianDescription;
  Color accordianDescriptionColor;
  Color colorIcon;
  Color colorBoxDescription;


  CustomAccordion({required this.accordianTitle ,
    required this.accordianTitleColor ,
    required this.accordianBoxColor,
    required this.accordianDescription,
    required this.accordianDescriptionColor,
    required this.colorIcon,
    required this.colorBoxDescription,
  });
  @override
  _CustomAccordionState createState() => _CustomAccordionState();
}

class _CustomAccordionState extends State<CustomAccordion> {
  bool _isExpanded = false;


  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.accordianBoxColor,
            ),

            child: Row(
              children: [
                Txt(
                  '${widget.accordianTitle}',
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
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: _isExpanded ? 100 : 0,
          width:size.width,
          color: widget.colorBoxDescription,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Txt('${widget.accordianDescription}' , color: widget.accordianDescriptionColor, fontSize: 14, fontWeight: FontWeight.w500,),
          ),
        ),
      ],
    );
  }
}