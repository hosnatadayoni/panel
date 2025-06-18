import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'btn.dart';

class Collapse extends StatefulWidget {
  Widget? btnContent;
  Color? btnTxtColor;
  Color? colorBox;
  Color? borderColor;
  String? content;
  Color? contentColor;
  bool isHorizontal;
  String? targetId;
  List<String>? targetIds;
  Color? colorBtn;
  Color? colorBtnHover;
  btnType? type;
  bool? isOutlineBtn;


  Collapse({
    this.btnContent,
    this.btnTxtColor = whiteColor,
    this.colorBox,
    this.borderColor,
    this.content,
    this.contentColor,
    this.isHorizontal = false,
    this.targetId,
    this.targetIds,
    this.colorBtn =  Colors.blue,
    this.colorBtnHover = colorHoverBtn,
    required this.type,
    this.isOutlineBtn =  false,
    Key? key,
  }) : super(key: key);

  @override
  State<Collapse> createState() => _CollapseState();
}

class _CollapseState extends State<Collapse> {
  bool _isShow = false;
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.btnContent != null)
          Btn(
            type: widget.type,
              isOutline: widget.isOutlineBtn,
              content: widget.btnContent,
              onClick: (){
            setState(() {
              _isShow = !_isShow;
            });
          }),
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
  Map<int, bool> _hoverStates = {};

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
          children: widget.buttons.asMap().entries.map((entry) {
            final index = entry.key;
            final button = entry.value;

            if (button is Collapse) {
              return Btn(
                    type: button.type,
                    isOutline: button.isOutlineBtn,
                    content: button.btnContent,
                    onClick: (){
                      if (button.targetId != null) {
                        _toggleCollapse(button.targetId!);
                      } else if (button.targetIds != null) {
                        _toggleAll(button.targetIds!);
                      }
                    },
                );
              return InkWell(
                onTap: () {
                  if (button.targetId != null) {
                    _toggleCollapse(button.targetId!);
                  } else if (button.targetIds != null) {
                    _toggleAll(button.targetIds!);
                  }
                },
                child: MouseRegion(
                  onEnter: (_) => setState(() => _hoverStates[index] = true),
                  onExit: (_) => setState(() => _hoverStates[index] = false),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: _hoverStates[index] ?? false
                          ? button.colorBtnHover
                          : button.colorBtn,
                    ),
                    padding: EdgeInsets.only(top: 6, bottom: 6, left: 12, right: 12),
                    // child: Txt(
                    //   button.btnTxt ?? '',
                    //   color: button.btnTxtColor,
                    //   fontWeight: FontWeight.w400,
                    // ),
                    child: button.btnContent,
                  ),
                ),
                // child: Btn(
                //     type: button.type,
                //     isOutline: button.isOutlineBtn,
                //     content: button.btnContent,
                // ),
              );
            }
            return button;
          }).toList(),
        ),
        SizedBox(height: 10,),
        Wrap(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: widget.collapsibles.map((collapsible) {
            if (collapsible is Collapse && collapsible.targetId != null) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _expandedStates[collapsible.targetId!] ?? false ? 0 : 100,
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