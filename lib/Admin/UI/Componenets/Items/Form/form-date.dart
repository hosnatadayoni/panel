import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
class DateBox extends StatefulWidget {
   DateBox({this.onDateChanged , this.selectedDate , this.column , this.isSeletedDate});
   // Function? onTap;
   Function(String?)? onDateChanged;
   // String? selectedDate;
   Jalali? selectedDate;
   var column;
   Rx<bool>? isSeletedDate = false.obs;
  @override
  State<DateBox> createState() => _DateBoxState();
}

class _DateBoxState extends State<DateBox> {
  var dateSelected=null;
  @override
  Widget build(BuildContext context) {
    var inputRequired;
    String? errorMessage;
    if(widget.column != null){
      if(widget.column.validators != null){
        inputRequired = widget.column.validators.firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
        if(inputRequired!=null)
          errorMessage = inputRequired['message'];
      }
    }

    return Obx((){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              InkWell(
                  onTap: ()async {
                    Jalali? picked = await showPersianDatePicker(
                      context: context,
                      initialDate: dateSelected == null ? widget.selectedDate!:dateSelected,
                      firstDate: Jalali(1385 , 8),
                      lastDate: Jalali(1450 , 9),
                    );
                    if(picked != null){
                      setState(() {
                        widget.isSeletedDate!.value = true;
                        widget.selectedDate = picked;
                        dateSelected = picked;
                      });
                      // MainController.selectedDate!.value= picked;
                      // print('MainController.selectedDate!.value>>>${MainController.selectedDate!.value}');
                      // String date = '${MainController.selectedDate!.value.year.obs}${'/'}${MainController.selectedDate!.value.month.obs}${'/'}${MainController.selectedDate!.value.day.obs}';
                      // dataJson[name] =  date;
                      String date = '${picked.year}/${picked.month}/${picked.day}';

                      if(widget.onDateChanged!=null){
                        this.widget.onDateChanged!(date);
                      }
                    }
                  },

                  child: Icon(Icons.date_range_outlined, color: color3, size: 30.0)),
              SizedBox(width: 5,),
              Txt(dateSelected == null ?'${widget.selectedDate!.year}/${widget.selectedDate!.month}/${widget.selectedDate!.day}':'${dateSelected.year}/${dateSelected.month}/${dateSelected.day}', color: MainController.isLightMode.value ? whiteColor : primaryDark ,),

            ],
          ),
          SizedBox(height: 5),
          if(inputRequired != null)
            if(inputRequired['type'] == 'required')
              ViewController.isClickedBtn.value== true && widget.isSeletedDate!.value == false || ViewController.isClickedEditBtn.value== true && widget.isSeletedDate!.value == false?
              Txt('${errorMessage != null ? errorMessage:''}' , color: errorColor,):Container(),

        ],
      );
    });
  }
}
