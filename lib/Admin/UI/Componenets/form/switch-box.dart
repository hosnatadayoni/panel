import 'package:flutter/material.dart';
// import 'package:flutter_switch/flutter_switch.dart';
import 'package:finance/Admin/Public/styles.dart';
import '../General/txt.dart';


class SwitchBox extends StatefulWidget {
  bool? checked;
  ValueChanged<bool>? onChanged;
  String? label;
  bool disabled;
  Color? activeColorBox;
  Color? activeColorSwitch;
  Color? inActiveColorBox;
  Color? inActiveColorSwitch;
  Color? inActiveBorderSwitch;


  SwitchBox({
    this.checked =  false,
    this.onChanged,
    this.label,
    this.disabled = false,
    this.activeColorBox = colorBtn,
    this.inActiveColorBox = whiteColor,
    this.activeColorSwitch = whiteColor,
    this.inActiveColorSwitch = color40,
    this.inActiveBorderSwitch = color38,


});
  @override
  _SwitchBoxState createState() => _SwitchBoxState();
}

class _SwitchBoxState extends State<SwitchBox> {
  late bool _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.checked!;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return Wrap(
    //   runSpacing: 10,
    //   spacing: 10,
    //   children: [
    //     IntrinsicWidth(
    //       child: FlutterSwitch(
    //         width: 60,
    //         height: 30,
    //         activeColor: widget.activeColorBox!,
    //         activeToggleColor: widget.activeColorSwitch!,
    //         inactiveColor: widget.inActiveColorBox!,
    //         inactiveToggleColor: widget.inActiveColorSwitch!,
    //         inactiveSwitchBorder: Border.all(width: 1, color: widget.inActiveBorderSwitch!),
    //         valueFontSize: 25.0,
    //         toggleSize: 20,
    //         value: _currentValue,
    //         disabled: widget.disabled,
    //         borderRadius: 30.0,
    //         padding: 8.0,
    //         onToggle: (val) {
    //           setState(() {
    //             _currentValue = val;
    //           });
    //           widget.onChanged?.call(val);
    //         },
    //       ),
    //     ),
    //     Txt(
    //       widget.label ?? '',
    //       color: widget.disabled ? Colors.grey : null,
    //     ),
    //   ],
    // );
  }
}