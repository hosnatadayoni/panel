import 'package:finance/Public/styles.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
   bool checked;
   ValueChanged<bool>? onChanged;
   String? label;
   bool disabled;
   Color? activeColorBox;
   Color? activeColorSwitch;
   Color? inActiveColorSwitch;

  CustomSwitch({
    this.checked = false,
    this.onChanged,
    this.label,
    this.disabled = false,
    this.activeColorBox = Colors.blue,
    this.activeColorSwitch = whiteColor,
    this.inActiveColorSwitch = color40,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: _currentValue,
          onChanged: widget.disabled
              ? null
              : (bool newValue) {
            setState(() {
              _currentValue = newValue;
            });
            widget.onChanged?.call(newValue);
          },
          activeTrackColor: widget.disabled
              ? widget.activeColorBox?.withOpacity(0.5)
              : widget.activeColorBox,
          inactiveTrackColor: widget.disabled
              ? whiteColor.withOpacity(0.5)
              : whiteColor,
            thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (widget.disabled) {
                return _currentValue
                    ? widget.activeColorSwitch!.withOpacity(0.5)
                    : widget.inActiveColorSwitch!.withOpacity(0.5);
              }
              return states.contains(MaterialState.selected)
                  ? widget.activeColorSwitch!
                  : widget.inActiveColorSwitch!;
            }),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: 8),
        Text(
          widget.label ?? '',
          style: TextStyle(
            color: widget.disabled ? Colors.grey : null,
          ),
        ),
      ],
    );
  }
}