import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class DismissibleAlert extends StatefulWidget {
  final String message;
  final AlertType type;
  final VoidCallback? onDismiss;
  final Alignment alignment;
  final Duration dismissDuration;

  const DismissibleAlert({
    required this.message,
    this.type = AlertType.info,
    this.onDismiss,
    this.alignment = Alignment.center,
    this.dismissDuration = const Duration(milliseconds: 300),
    Key? key,
  }) : super(key: key);

  @override
  _DismissibleAlertState createState() => _DismissibleAlertState();
}

class _DismissibleAlertState extends State<DismissibleAlert>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _offsetAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.dismissDuration,
    );

    _opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(_controller);


    final offset = _getOffsetForAlignment();
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: offset,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isVisible = false);
        widget.onDismiss?.call();
      }
    });
  }

  Offset _getOffsetForAlignment() {
    switch (widget.alignment) {
      case Alignment.topLeft:
      case Alignment.topCenter:
      case Alignment.topRight:
        return const Offset(0, -1);
      case Alignment.bottomLeft:
      case Alignment.bottomCenter:
      case Alignment.bottomRight:
        return const Offset(0, 1);
      case Alignment.centerLeft:
        return const Offset(-1, 0);
      case Alignment.centerRight:
        return const Offset(1, 0);
      default:
        return Offset.zero;
    }
  }

  void _handleDismiss() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return SizedBox.shrink();

    return Align(
      alignment: widget.alignment,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                  Flexible(
                  child: Txt(
                  widget.message,
                      color: _getTextColor(),
                  ),
                   ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: _handleDismiss,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case AlertType.success:
        return Colors.green.shade100;
      case AlertType.error:
        return Colors.red.shade100;
      case AlertType.warning:
        return Colors.orange.shade100;
      default:
        return Colors.blue.shade100;
    }
  }

  Color _getTextColor() {
    switch (widget.type) {
      case AlertType.success:
        return Colors.green.shade900;
      case AlertType.error:
        return Colors.red.shade900;
      case AlertType.warning:
        return Colors.orange.shade900;
      default:
        return Colors.blue.shade900;
    }
  }
}

enum AlertType { success, error, warning, info }