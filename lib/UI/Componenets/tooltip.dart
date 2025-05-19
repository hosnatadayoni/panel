import 'package:finance/UI/Componenets/General/column-scroll.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class TooltipWidget extends StatefulWidget {
  final Widget content;
  final Widget btn;
  final TooltipDirection direction;

  const TooltipWidget({
    required this.content,
    required this.btn,
    required this.direction,
  });

  @override
  State<TooltipWidget> createState() => _TooltipWidgetState();
}

class _TooltipWidgetState extends State<TooltipWidget> {
  final _controller = SuperTooltipController();
  final _btnKey = GlobalKey();
  Size? _btnSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = _btnKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          _btnSize = renderBox.size;
        });
      }
    });
  }

  double _calculateArrowOffset() {
    if (_btnSize == null) return 30;

    switch(widget.direction) {
      case TooltipDirection.up:
      case TooltipDirection.down:
        return _btnSize!.height/2;
      case TooltipDirection.left:
      case TooltipDirection.right:
        return _btnSize!.width/2;
    }
  }

  TooltipDirection _getAdjustedDirection(BuildContext context) {
    final renderBox = _btnKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return widget.direction;

    final position = renderBox.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final contentWidth = widget.content is SizedBox
        ? (widget.content as SizedBox).width ?? 200
        : 200;
    final contentHeight = widget.content is SizedBox
        ? (widget.content as SizedBox).height ?? 100
        : 100;
    if (widget.direction == TooltipDirection.right &&
        position.dx + renderBox.size.width + contentWidth > screenWidth) {
      return TooltipDirection.left;
    }
    else if (widget.direction == TooltipDirection.left &&
        position.dx - renderBox.size.width - contentWidth < 0) {
      return TooltipDirection.right;
    }
    return widget.direction;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (_) async => await _controller.hideTooltip(),
      onEnter: (_) async => await _controller.showTooltip(),
      child: SuperTooltip(
        showBarrier: false,
        controller: _controller,
        popupDirection: _getAdjustedDirection(context),
        borderColor: Colors.transparent,
        hasShadow: false,
        arrowTipDistance: _calculateArrowOffset(),
        elevation: 0,
        arrowLength: 10,
        content: IntrinsicWidth(child: widget.content),
        child: KeyedSubtree(
          key: _btnKey,
          child: widget.btn,
        ),
      ),
    );
  }
}
