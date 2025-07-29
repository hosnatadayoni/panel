import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';

class CustomRangeSlider extends StatefulWidget {
   String? label;
   double? min;
   double? max;
   double? value;
   ValueChanged<double>? onChanged;
   Color? activeColor;
   Color? inactiveColor;
   Color? thumbColor;
   bool? disabled;
   Color? disabledColor;
   Color? lableColor;
   double? step;

   CustomRangeSlider({
     this.label ='',
     this.min = 0,
     this.max = 100,
     this.value = 0,
     this.onChanged,
     this.activeColor = Colors.blue,
     this.inactiveColor = Colors.grey,
     this.thumbColor = Colors.white,
     this.disabled = false,
     this.disabledColor = Colors.grey,
     this.lableColor = blackColor,
     this.step,
   });

  @override
  _CustomRangeSliderState createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Txt(
          widget.label!,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: widget.lableColor,
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: widget.activeColor,
            inactiveTrackColor:widget.inactiveColor,
            trackHeight: 4.0,
            thumbColor: widget.thumbColor,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
            overlayColor: widget.activeColor!.withAlpha(32),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
            disabledActiveTrackColor: widget.disabledColor,
            disabledInactiveTrackColor: widget.disabledColor!.withOpacity(0.5),
            disabledThumbColor: widget.disabledColor,
          ),
          child: Slider(
            min: widget.min!,
            max: widget.max!,
            value: _currentValue,
            onChanged: widget.disabled! ? null : (newValue) {
              setState(() {
                _currentValue = newValue;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(newValue);
              }
            },
            divisions:widget.step != null ? (widget.max! - widget.min!) ~/ widget.step! : null,

          ),
        ),
      ],
    );
  }
}