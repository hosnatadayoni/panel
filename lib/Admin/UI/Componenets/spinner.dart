import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/btn.dart';
import 'package:flutter/material.dart';

enum SpinnerType {
  border,
  grow
}
enum SpinnerAlignment {
 start,
  center,
  end
}

class Spinner extends StatefulWidget {
   // Color color;
   double size;
   SpinnerType type;
   Duration duration;
   SpinnerAlignment alignment;
   btnType typeSpinner;

  Spinner({
    // this.color = Colors.blue,
    this.size = 25,
    this.type = SpinnerType.border,
    this.duration = const Duration(seconds: 1),
    this.alignment = SpinnerAlignment.start,
    required this.typeSpinner,
  });

  @override
  State<Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,    // مقدار نهایی opacity
    ).animate(_controller);

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor(){
      if(widget.typeSpinner == btnType.primary){
        return colorBtn;
      }
      else if(widget.typeSpinner == btnType.secondary){
        return secondry;
      }
      else if(widget.typeSpinner == btnType.success){
        return success;
      }
      else if(widget.typeSpinner == btnType.danger){
        return danger;
      }
      else if(widget.typeSpinner == btnType.warning){
        return warning;
      }
      else if(widget.typeSpinner == btnType.info){
        return info;
      }
      else if(widget.typeSpinner == btnType.light){
        return light;
      }
      else if(widget.typeSpinner == btnType.dark){
        return dark;
      }
      else if(widget.typeSpinner == btnType.link){
        return Colors.transparent;
      }
      return Colors.transparent;
    }
    return Align(
      alignment: widget.alignment == SpinnerAlignment.center ? Alignment.center : widget.alignment == SpinnerAlignment.end ? Alignment.centerLeft : Alignment.centerRight,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: widget.type == SpinnerType.border
            ? CircularProgressIndicator(color: backgroundColor())
            : AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: backgroundColor(),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}