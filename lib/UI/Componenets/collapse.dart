import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';

// class CollapseExample extends StatefulWidget {
//
//   String btnTxt;
//   Color? btnTxtColor = whiteColor;
//   Color? colorBox = whiteColor;
//   Color? borderColor =  color28;
//   String? content;
//   Color? contentColor = blackColor;
//   bool isHorizontal  =  false;
//   CollapseExample({
//     required this.btnTxt ,
//     this.btnTxtColor ,
//     this.colorBox ,
//     this.borderColor ,
//     this.content,
//     this.contentColor,
//     this.isHorizontal = false,
//   });
//
//
//
//   @override
//   State<CollapseExample> createState() => _CollapseExampleState();
// }
//
// class _CollapseExampleState extends State<CollapseExample> {
//   bool _isExpanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             setState(() {
//               _isExpanded = !_isExpanded;
//             });
//           },
//           child: Txt(widget.btnTxt , color: widget.btnTxtColor, fontWeight: FontWeight.w400,) ,
//         ),
//
//         const SizedBox(height: 10),
//
//         widget.isHorizontal ?
//         Row(
//          children: [
//          AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         width: _isExpanded ? 200 : 0,
//         child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Container(
//         width: 200,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//         color: widget.colorBox,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//         width: 1,
//         color: widget.borderColor ?? Colors.grey,
//         ),
//         ),
//         child: Text(
//         widget.content ?? '',
//         style: TextStyle(
//         color: widget.contentColor,
//         fontSize: 14,
//         ),
//         ),
//         ),
//         ),
//         ),
//        ],
//        )  :
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           height: _isExpanded ?  200: 0,
//           child: SingleChildScrollView(
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: widget.colorBox,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(width: 1 , color:widget.borderColor != null ?  widget.borderColor!: color28)
//               ),
//               child:  Txt(widget.content! , color:  widget.contentColor, fontSize: 14,),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


class Collapse extends StatefulWidget {
  String? btnTxt;
  Color? btnTxtColor;
  Color? colorBox;
  Color? borderColor;
  String? content;
  Color? contentColor;
  bool isHorizontal;
  String? targetId;
  List<String>? targetIds;

  Collapse({
    this.btnTxt,
    this.btnTxtColor,
    this.colorBox,
    this.borderColor,
    this.content,
    this.contentColor,
    this.isHorizontal = false,
    this.targetId,
    this.targetIds,
    Key? key,
  }) : super(key: key);

  @override
  State<Collapse> createState() => _CollapseState();
}

class _CollapseState extends State<Collapse> {
  bool _isShow = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.btnTxt != null)
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isShow = !_isShow;
              });
            },
            child: Txt(
              widget.btnTxt!,
              color: widget.btnTxtColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        if (widget.content != null && widget.targetId == null) ...[
          const SizedBox(height: 10),
          widget.isHorizontal
              ? Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: _isShow ? 200 : 0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.colorBox,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 1,
                        color: widget.borderColor ?? Colors.grey,
                      ),
                    ),
                    child: Txt(
                      widget.content!,
                      color: widget.contentColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          )
              : AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isShow ? 100 : 0,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.colorBox,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: widget.borderColor ?? Colors.grey,
                  ),
                ),
                child: Txt(
                  widget.content!,
                  color: widget.contentColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class MultiCollapse extends StatefulWidget {
   List<Widget> buttons;
   List<Widget> collapsibles;
   bool isHorizontal;

   MultiCollapse({
    required this.buttons,
    required this.collapsibles,
    this.isHorizontal = false,
    Key? key,
  }) : super(key: key);

  @override
  State<MultiCollapse> createState() => _MultiCollapseState();
}

class _MultiCollapseState extends State<MultiCollapse> {
  Map<String, bool> _expandedStates = {};

  void _toggleCollapse(String targetId) {
    setState(() {
      _expandedStates[targetId] = !(_expandedStates[targetId] ?? false);
    });
  }

  void _toggleAll(List<String> targetIds) {
    setState(() {
      for (var id in targetIds) {
        _expandedStates[id] = !(_expandedStates[id] ?? false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          runSpacing: 5,
          spacing: 5,
          children: widget.buttons.map((button) {
            if (button is Collapse) {
              return ElevatedButton(
                onPressed: () {
                  if (button.targetId != null) {
                    _toggleCollapse(button.targetId!);
                  } else if (button.targetIds != null) {
                    _toggleAll(button.targetIds!);
                  }
                },
                child: Txt(
                  button.btnTxt ?? '',
                  color: button.btnTxtColor,
                  fontWeight: FontWeight.w400,
                ),
              );
            }
            return button;
          }).toList(),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget.collapsibles.map((collapsible) {
            if (collapsible is Collapse && collapsible.targetId != null) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _expandedStates[collapsible.targetId!] ?? false ? 100 : 0,
                margin: EdgeInsets.only(left: 10),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: collapsible.colorBox,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 1,
                        color: collapsible.borderColor ?? Colors.grey,
                      ),
                    ),
                    child: Txt(
                      collapsible.content ?? '',
                      color: collapsible.contentColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }
            return collapsible;
          }).toList(),
        ),
      ],
    );
  }
}