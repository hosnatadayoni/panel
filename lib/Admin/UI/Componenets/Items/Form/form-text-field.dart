import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/mobile-format.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/thousand-separator-inputFormatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../Logic/Controllers/AdminController.dart';

class FormTextField extends StatefulWidget {
  String? lable;
  String? hint;
  Function? onChange, updateChange;
  bool? isNumberInt;
  bool? isNumberDouble;
  String? initValue;
  bool? isMobile;
  bool? isLoginPage;
  bool? isPassword;
  bool? isLongTxt;
  bool? isValidate;
  String name;
  GlobalKey<FormBuilderState>? fbKey;
  var column;
  var maxValidator;
  var minValidator;
  bool? isEmail;
  double height;

  FormTextField(
      {this.lable,
      this.hint,
      this.onChange,
      this.updateChange,
      this.isNumberInt = false,
      this.isNumberDouble = false,
      this.initValue,
      this.isMobile = false,
      this.isLoginPage = false,
      this.isPassword = false,
      this.fbKey,
      this.isLongTxt = false,
      this.isValidate = true,
      required this.name,
      this.column,
      this.isEmail,
        this.height = 50,
      });

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
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
        print('widget.isValidate>>>${widget.isValidate}');
        if (widget.isValidate == true) _validateInput();

        if (widget.updateChange != null) {
          widget.updateChange!();
        }
      }
    });
  }

  void _validateInput() {
    if (widget.column != null) {
      if (widget.column['validators'] != null || widget.column['validators'] != []) {
        var inputRequired;
        if (ViewController.request[widget.column['name']] == '' ||
            ViewController.request[widget.column['name']] == null) {
          inputRequired = widget.column['validators'].firstWhere(
              (validator) => validator['type'] == 'reqiured',
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
          if (widget.isNumberInt == true || widget.isNumberDouble == true) {
            var maxValidator = widget.column['validators'].firstWhere(
                (validator) => validator['type'] == 'max',
                orElse: () => null);
            var minValidator = widget.column['validators'].firstWhere(
                (validator) => validator['type'] == 'min',
                orElse: () => null);
            var number = ViewController.request[widget.column['name']];
            if (number != null) {
              if (minValidator != null || maxValidator != null) {
                if (number < minValidator['value']) {
                  setState(() {
                    _errorText = minValidator['message'];
                  });
                } else {
                  if (number > maxValidator['value']) {
                    setState(() {
                      _errorText = maxValidator['message'];
                    });
                  } else {
                    setState(() {
                      _errorText = null;
                    });
                  }
                }
              }
            }
          } else if (widget.isEmail == true) {
            var emailValidator = widget.column['validators'].firstWhere(
                (validator) => validator['type'] == 'email',
                orElse: () => null);
            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
            setState(() {
              if (!emailRegex
                  .hasMatch(ViewController.request[widget.column['name']])) {
                _errorText = emailValidator['message'];
              } else {
                _errorText = null;
              }
            });
          } else if (widget.isMobile == true) {
            var mobileValidator = widget.column['validators'].firstWhere(
                (validator) => validator['type'] == 'mobile',
                orElse: () => null);
            // setState(() {
            //   if(!text.value.startsWith('9')){
            //     _errorText =   mobileValidator['message'];
            //   }
            //   else{
            //     _errorText =   null;
            //   }
            // });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ViewController.isClickedBtn.value) {
        if (widget.column != null) {
          if (ViewController.request[widget.column['name']] == '' ||
              ViewController.request[widget.column['name']] == null) {
            var inputRequired;

            if (widget.column['validators'] != null) {
              inputRequired = widget.column['validators'].firstWhere(
                  (validator) => validator['type'] == 'required',
                  orElse: () => null);
              if (inputRequired != null) {
                _errorText = inputRequired['message'];
              }
            }
          } else if (ViewController.request[widget.column['name']] != '') {
            if (widget.column['validators'] != null) {
              if (widget.isNumberInt == true || widget.isNumberDouble == true) {
                var maxValidator;
                var minValidator;
                maxValidator = widget.column['validators'].firstWhere(
                    (validator) => validator['type'] == 'max',
                    orElse: () => null);
                minValidator = widget.column['validators'].firstWhere(
                    (validator) => validator['type'] == 'min',
                    orElse: () => null);
                var number = ViewController.request[widget.column['name']];
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
                    // if (number < minValidator['value'] || number > maxValidator['value']) {
                    //   setState(() {
                    //     // _errorText = '${AppController.of(context)!.value('The entered number must be between')} ${minValidator['value']} ${AppController.of(context)!.value('and')} ${maxValidator['value']} ${AppController.of(context)!.value('be')} ';
                    //     _errorText =   errorMessage;
                    //   });
                    // } else {
                    //   setState(() {
                    //     _errorText = null;
                    //   });
                    // }
                  }
                }
              } else if (widget.isEmail == true) {
                var emailValidator = widget.column['validators'].firstWhere(
                    (validator) => validator['type'] == 'email',
                    orElse: () => null);
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

                if (!emailRegex
                    .hasMatch(ViewController.request[widget.column['name']])) {
                  _errorText = emailValidator['message'];
                } else {
                  _errorText = null;
                }
              } else if (widget.isMobile == true) {
                var mobileValidator = widget.column['validators'].firstWhere(
                    (validator) => validator['type'] == 'mobile',
                    orElse: () => null);
              }

              // else{
              //   _errorText = null;
              // }
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
                obscureText: widget.isPassword == true &&
                        AdminController.isVisibility.value == false
                    ? true
                    : false,
                keyboardType: widget.isLongTxt == true
                    ? TextInputType.multiline
                    : widget.isNumberInt! || widget.isNumberDouble!
                        ? TextInputType.number
                        : TextInputType.text,
                minLines: 1,
                maxLines: widget.isPassword == true ? 1 : 3,
                inputFormatters: [
                  if (widget.isMobile == true) MobileNumberFormatter(),
                  if (widget.isMobile == true)
                    LengthLimitingTextInputFormatter(11),
                  if (widget.isMobile == true)
                    FilteringTextInputFormatter.digitsOnly,
                  if (widget.isNumberDouble == true)
                    // FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  if (widget.isNumberInt == true)
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  // if(widget.isNumber == true)
                  //   ThousandSeparatorInputFormatter(),
                  if (widget.isMobile == true)
                    FilteringTextInputFormatter.deny(
                      RegExp(r'^0+'),
                    ),
                ],
                initialValue: widget.initValue,
                // style: TextStyle(color: widget.isLoginPage == false ? MainController.isLightMode.value == true ? whiteColor:primaryDark:primaryDark),
                style: TextStyle(
                    color: widget.isLoginPage == false
                        ? MainController.isLightMode.value == true
                            ? whiteColor
                            : primaryDark
                        : primaryDark),
                onChanged: (value) {
                  // if(widget.isNumberInt == true){
                  //   text.value = int.parse('${value!}');
                  // }
                  // else if(widget.isNumberDouble == true){
                  //   text.value = double.parse('${value!}');
                  // }
                  // else {
                  //   text.value = value!;
                  // }
                  // ViewController.request[widget.column['name']] = value;
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

                  prefixIcon: widget.isPassword == true
                      ? Obx(() {
                          return InkWell(
                              onTap: () {
                                setState(() {
                                  AdminController.isVisibility.value =
                                      !AdminController.isVisibility.value;
                                });
                              },
                              child: Icon(
                                AdminController.isVisibility.value == true
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 15,
                                color: MainController.isLightMode.value == true
                                    ? whiteColor
                                    : primaryDark,
                              ));
                        })
                      : null,
                  labelText: '${this.widget.lable}',
                  labelStyle: TextStyle(
                      color: widget.isLoginPage == false
                          ? MainController.isLightMode.value == true
                              ? whiteColor
                              : primaryDark
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
