import 'package:finance/Admin/Public/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
enum AlertDirection{
  left,
  right,
  center
}
enum alertType{
  primary,
  secondary,
  success,
  danger,
  warning,
  info,
  light,
  dark,
}
class Alert extends StatefulWidget {
   Widget? content;
   double? width;
   bool dismissible;
  VoidCallback? onDismissed;
   Duration animationDuration;
   Color? colorCloseBtn;
   Color? colorCloseBtnHover;
   AlertDirection? direction;
   alertType type;

  Alert({
    this.content,
    this.width,
    this.dismissible = false,
    this.onDismissed,
    this.animationDuration = const Duration(milliseconds: 300),
    this.colorCloseBtn = Colors.grey,
    this.colorCloseBtnHover = blackColor,
    this.direction = AlertDirection.right,
    required this.type,


  });

  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (widget.dismissible) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (!_isVisible) return;

    setState(() {
      _isVisible = false;
    });

    _animationController.reverse().then((_) {
      if (widget.onDismissed != null) {
        widget.onDismissed!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return widget.dismissible ? FadeTransition(
      opacity: _animation,
      child: box(),
    ): box();
  }
  Widget box(){
    var size = MediaQuery.of(context).size;
    Rx<bool> isHover =  false.obs;
    Color backgroundColor(){
      if(widget.type == alertType.primary){
        return alertPrimary;
      }
      else if(widget.type == alertType.secondary){
        return alertSecondry;
      }
      else if(widget.type == alertType.success){
        return alertSuccess;
      }
      else if(widget.type == alertType.danger){
        return alertDanger;
      }
      else if(widget.type == alertType.warning){
        return alertWarning;
      }
      else if(widget.type == alertType.info){
        return alertInfo;
      }
      else if(widget.type == alertType.light){
        return alertLight;
      }
      else if(widget.type == alertType.dark){
        return alertDark;
      }
      return Colors.transparent;
    }
    Color ContentColor(){
      if(widget.type == alertType.primary){
        return alertContentPrimary;
      }
      else if(widget.type == alertType.secondary){
        return alertContentSecondry;
      }
      else if(widget.type == alertType.success){
        return alertContentSuccess;
      }
      else if(widget.type == alertType.danger){
        return alertContentDanger;
      }
      else if(widget.type == alertType.warning){
        return alertContentWarning;
      }
      else if(widget.type == alertType.info){
        return alertContentInfo;
      }
      else if(widget.type == alertType.light){
        return alertContentLight;
      }
      else if(widget.type == alertType.dark){
        return alertContentDark;
      }
      return Colors.transparent;
    }
    Color borderColor(){
      if(widget.type == alertType.primary){
        return alertBorderPrimary;
      }
      else if(widget.type == alertType.secondary){
        return alertBorderSecondry;
      }
      else if(widget.type == alertType.success){
        return alertBorderSuccess;
      }
      else if(widget.type == alertType.danger){
        return alertBorderDanger;
      }
      else if(widget.type == alertType.warning){
        return alertBorderWarning;
      }
      else if(widget.type == alertType.info){
        return alertBorderInfo;
      }
      else if(widget.type == alertType.light){
        return alertBorderLight;
      }
      else if(widget.type == alertType.dark){
        return alertBorderDark;
      }
      return Colors.transparent;
    }
    return Column(
      crossAxisAlignment: widget.direction == AlertDirection.left ?
      CrossAxisAlignment.end : widget.direction == AlertDirection.center ? CrossAxisAlignment.center :
      CrossAxisAlignment.start,
      children: [
        Container(
          width: widget.width ?? size.width,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1 , color: borderColor()),
            color: backgroundColor(),
          ),
          child:widget.dismissible ?  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DefaultTextStyle(style: TextStyle(color: ContentColor()), child:widget.content! ),
              MouseRegion(
                onEnter: (_){
                  isHover.value = true;
                },
                onExit: (_){
                  isHover.value = false;
                },
                child: Obx((){
                  return IconButton(
                    icon: Icon(Icons.close, size: 20 , color:isHover.value ? widget.colorCloseBtnHover :widget.colorCloseBtn ,),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: _dismiss,
                  );
                }),
              ),
            ],
          ):DefaultTextStyle(style: TextStyle(color: ContentColor()), child:widget.content! ),
        ),
      ],
    );
  }
}
