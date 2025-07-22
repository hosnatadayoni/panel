import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class TooltipWidget extends StatefulWidget {
  Widget content;
  Widget btn;
  TooltipDirection? direction;

  TooltipWidget({
    required this.content,
    required this.btn,
    this.direction = TooltipDirection.right,
  });

  @override
  State<TooltipWidget> createState() => _TooltipWidgetState();
}

class _TooltipWidgetState extends State<TooltipWidget> {
  final _controller = SuperTooltipController();
  final _btnKey = GlobalKey();
  Size? _btnSize;
  TooltipDirection? _adjustedDirection;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateAdjustedDirection();
    });
  }

  void _calculateAdjustedDirection() {
    final renderBox = _btnKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;
    final buttonSize = renderBox.size;

    setState(() {
      _btnSize = buttonSize;
      _adjustedDirection = _getOppositeDirectionIfNeeded(
        buttonPosition,
        buttonSize,
        screenSize,
        widget.direction ?? TooltipDirection.down,
      );
    });
  }

  TooltipDirection _getOppositeDirectionIfNeeded(
      Offset buttonPosition,
      Size buttonSize,
      Size screenSize,
      TooltipDirection preferredDirection,
      ) {

    const minRequiredSpace = 100.0;

    double availableSpace;
    switch (preferredDirection) {
      case TooltipDirection.up:
        availableSpace = buttonPosition.dy;
        break;
      case TooltipDirection.down:
        availableSpace = screenSize.height - buttonPosition.dy - buttonSize.height;
        break;
      case TooltipDirection.left:
        availableSpace = buttonPosition.dx;
        break;
      case TooltipDirection.right:
        availableSpace = screenSize.width - buttonPosition.dx - buttonSize.width;
        break;
    }

    if (availableSpace >= minRequiredSpace) {
      return preferredDirection;
    }

    switch (preferredDirection) {
      case TooltipDirection.up:
        return TooltipDirection.down;
      case TooltipDirection.down:
        return TooltipDirection.up;
      case TooltipDirection.left:
        return TooltipDirection.right;
      case TooltipDirection.right:
        return TooltipDirection.left;
    }
  }

  double _calculateArrowOffset() {
    if (_btnSize == null) return 30;

    switch (_adjustedDirection ?? widget.direction!) {
      case TooltipDirection.up:
      case TooltipDirection.down:
        return _btnSize!.height / 2;
      case TooltipDirection.left:
      case TooltipDirection.right:
        return _btnSize!.width / 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _calculateAdjustedDirection();
        });

        return MouseRegion(

          // onExit: (_) async => await _controller.hideTooltip(),
          // onEnter: (_) async => await _controller.showTooltip(),
          onExit: (_) async {
            if (_controller.isVisible) {
              await _controller.hideTooltip();
            }
          },
          onEnter: (_) async {
            if (!_controller.isVisible) {
              await _controller.showTooltip();
            }
          },
          child: SuperTooltip(
            showBarrier: false,
            controller: _controller,
            popupDirection: _adjustedDirection ?? widget.direction!,
            borderColor: Colors.transparent,
            hasShadow: false,
            elevation: 0,
            arrowLength: 10,
            // arrowTipDistance: _calculateArrowOffset(),
            content: IntrinsicWidth(child: widget.content),
            child: MouseRegion(
              onExit: (_) async {
                if (_controller.isVisible) {
                  await _controller.hideTooltip();
                }
              },
              onEnter: (_) async {
                if (!_controller.isVisible) {
                  await _controller.showTooltip();
                }
              },
              child: KeyedSubtree(
                key: _btnKey,
                child: widget.btn,
              ),
            ),
          ),
        );
      },
    );
  }
}
