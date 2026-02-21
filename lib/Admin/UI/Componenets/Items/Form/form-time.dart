import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimePickerBox extends StatefulWidget {
  TimePickerBox({this.column, this.onTimeChanged, this.selectedTime , this.isSeletedTime});
  var column;
  Function(String?)? onTimeChanged;
  TimeOfDay? selectedTime;
  Rx<bool>? isSeletedTime = false.obs;

  @override
  _TimePickerBoxState createState() => _TimePickerBoxState();
}

class _TimePickerBoxState extends State<TimePickerBox> {
  final _formKey = GlobalKey<FormBuilderState>();


  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    var inputRequired;
    String? errorMessage;

    if(widget.column.validators != null){
      inputRequired = widget.column.validators.firstWhere(
              (validator) => validator['type'] == 'required',
          orElse: () => null
      );
      errorMessage = inputRequired?['message'];
    }
    final dateFormat = widget.column.format != null
        ? (widget.column.format == 24 ? DateFormat.Hm() : DateFormat.jm())
        : DateFormat.Hm();
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormBuilder(
            key: _formKey,
            child: FormBuilderDateTimePicker(
              name: 'appointment_time',
              inputType: InputType.time,
              format: dateFormat,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.access_time , color: color3,),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: color3),
                  ),
                hintText: widget.selectedTime != null
                    ? _formatTime(widget.selectedTime!)
                    : _formatTime(TimeOfDay.now()),
                hintStyle: TextStyle(color: MainController.isLightMode.value ? whiteColor : primaryDark),

              ),
              style: TextStyle(color: MainController.isLightMode.value ? whiteColor : primaryDark),
              initialTime: widget.selectedTime ?? TimeOfDay.now(),
              onChanged: (value) {
                if (value != null) {
                  widget.isSeletedTime!.value = true;
                  final newTime = TimeOfDay.fromDateTime(value);
                  String time = _formatTime(newTime);
                    widget.onTimeChanged!(time);
                }
              },
              validator: (value) {
                if (value == null) {
                  return '${AppController.of(context)!.value('Please select a time')}';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 5),
          if(inputRequired != null)
            if(inputRequired['type'] == 'required')
              ViewController.isClickedBtn.value == true && widget.isSeletedTime!.value == false || ViewController.isClickedEditBtn.value == true && widget.isSeletedTime!.value == false
                  ? Txt(
                '${errorMessage ?? ''}',
                color: errorColor,
              )
                  : Container(),
        ],
      );
    });
  }
}