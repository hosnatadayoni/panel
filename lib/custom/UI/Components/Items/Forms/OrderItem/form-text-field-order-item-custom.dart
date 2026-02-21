import 'package:finance/Admin/Logic/Controllers/AdminController.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/Logic/Models/order-item.dart';
import 'package:finance/custom/UI/Components/Items/Forms/OrderItem/two-decimal-input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class FormTextFieldOrderItemCustom extends StatefulWidget {
  String? lable;
  String? hint;
  Function? onChange, updateChange;
  bool? isNumberInt;
  bool? isNumberDouble;
  String? initValue;
  bool? isValidate;
  String name;
  GlobalKey<FormBuilderState>? fbKey;
  var column;
  var maxValidator;
  var minValidator;
  double height;
  String keyOrderItem;

  FormTextFieldOrderItemCustom(
      {this.lable,
        this.hint,
        this.onChange,
        this.updateChange,
        this.isNumberInt = false,
        this.isNumberDouble = false,
        this.initValue,
        this.fbKey,
        this.isValidate = true,
        required this.name,
        this.column,
        this.height = 50,
        this.keyOrderItem = ''
      });

  @override
  State<FormTextFieldOrderItemCustom> createState() => _FormTextFieldOrderItemCustomState();
}

class _FormTextFieldOrderItemCustomState extends State<FormTextFieldOrderItemCustom> {
  final textFieldKey = GlobalKey<FormBuilderFieldState>();
  var txt = null;
  final FocusNode _focusNode = FocusNode();
  String? _errorText;
  final TextEditingController _formConroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (widget.isValidate == true) _validateInput(widget.keyOrderItem);

        if (widget.updateChange != null) {
          widget.updateChange!();
        }
      }
    });
  }

  void _validateInput(String key) {
    if (widget.column != null) {
      if (widget.column.validators != null) {
        var inputRequired;

        if (OrderItem.orderItemsList[widget.keyOrderItem]?[widget.column.name] == '' ||
            OrderItem.orderItemsList[widget.keyOrderItem]?[widget.column.name] == null) {
          inputRequired = widget.column.validators.firstWhere(
                  (validator) => validator['type'] == 'required',
              orElse: () => null);
          if (inputRequired != null) {
            if (inputRequired['message'] != null) {
              setState(() {
                _errorText = inputRequired['message'];
              });
            }
          } else {
            setState(() {
              _errorText = null;
            });
          }
        } else {
          setState(() {
            _errorText = null;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ViewController.isClickedBtn.value) {
         if (widget.column != null) {
            if (OrderItem.orderItemsList[widget.keyOrderItem]![widget.column.name] == '' ||
                OrderItem.orderItemsList[widget.keyOrderItem]![widget.column.name] == null) {
              var inputRequired;

              if (widget.column.validators != null) {
                inputRequired = widget.column.validators.firstWhere(
                        (validator) => validator['type'] == 'required',
                    orElse: () => null);
                if (inputRequired != null) {
                  _errorText = inputRequired['message'];
                }
              }
            } else if (ViewCustomController.order[widget.column.name] != '') {
              if (widget.column.validators != null) {
                if (widget.isNumberInt == true || widget.isNumberDouble == true) {
                  var maxValidator;
                  var minValidator;
                  maxValidator = widget.column.validators.firstWhere(
                          (validator) => validator['type'] == 'max',
                      orElse: () => null);
                  minValidator = widget.column.validators.firstWhere(
                          (validator) => validator['type'] == 'min',
                      orElse: () => null);
                  var number = ViewCustomController.order[widget.column.name];
                  if (number != null) {
                    if (minValidator != null && maxValidator != null) {
                      if (number < minValidator['value']) {
                        _errorText = minValidator['message'];
                      } else {
                        if (number > maxValidator['value']) {
                          _errorText = maxValidator['message'];
                        } else {
                          _errorText = null;
                        }
                      }
                    }
                  }
                }
              }
            }
          }

      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormBuilder(
            key: widget.fbKey,
            child: SizedBox(
              height: widget.height,
              child: FormBuilderTextField(
                key: textFieldKey,
                focusNode: _focusNode,
                controller: widget.initValue == null ? _formConroller : null,

                keyboardType:
                     widget.isNumberInt! || widget.isNumberDouble!
                    ? TextInputType.number
                    : TextInputType.text,
                minLines: 1,
                inputFormatters: [
                  TwoDecimalInputFormatter(),
                ],
                initialValue: widget.initValue,
                style: TextStyle(
                    color:  MainController.isLightMode.value == true
                        ? whiteColor
                        : primaryDark),
                onChanged: (value) {
                  if (widget.onChange != null) this.widget.onChange!(value);
                },
                onEditingComplete: () {},
                onSubmitted: (value) {},
                name: widget.name,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),

                  labelText: '${this.widget.lable}',
                  labelStyle: TextStyle(
                      color:  MainController.isLightMode.value == true
                          ? whiteColor
                          : primaryDark),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorBtn, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: color3, width: 1.0),
                  ),
                  // errorText: _errorText,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Txt(
            '${_errorText != null ? _errorText : ''}',
            color: errorColor,
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
