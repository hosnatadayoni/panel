import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/mobile-format.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/thousand-separator-inputFormatter.dart';
import 'package:finance/custom/UI/Components/page-custom/order/thousand-seprator-input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class FormPriceTextField extends StatefulWidget {
  String? lable;
  String? hint;
  Function? onChange, updateChange , onEditingComplete;
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
  var controller;

  FormPriceTextField(
      {this.lable,
        this.hint,
        this.onChange,
        this.updateChange,
        this.onEditingComplete,
        this.initValue,
        this.fbKey,
        required this.name,
        this.column,
        this.isEmail,
        this.height = 50,
        this.controller
      });

  @override
  State<FormPriceTextField> createState() => _FormPriceTextFieldState();
}

class _FormPriceTextFieldState extends State<FormPriceTextField> {
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
        // وقتی کاربر از فیلد خارج شد
        if (widget.updateChange != null) {
          widget.updateChange!();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx((){
          return FormBuilder(
            key: widget.fbKey,
            child: SizedBox(
              height: widget.height,
              child: FormBuilderTextField(
                key: textFieldKey,
                focusNode: _focusNode,
                controller:widget.controller,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ThousandsSeparatorInputFormatter(),
                ],
                minLines: 1,
                maxLines: widget.isPassword == true ? 1 : 3,
                initialValue: widget.initValue,
                style: TextStyle(color: MainController.isLightMode.value == true ? whiteColor : primaryDark),
                onChanged: (value) {
                  if (widget.onChange != null) this.widget.onChange!(value);
                },
                onEditingComplete:() {
                  if (widget.onEditingComplete != null) this.widget.onEditingComplete!();
                },
                name: widget.name,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  labelText: '${this.widget.lable}',
                  labelStyle: TextStyle(
                      color: MainController.isLightMode.value == true
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
          );
        }),
        SizedBox(
          height: 5,
        ),
        Txt(
          '${_errorText != null ? _errorText : ''}',
          color: errorColor,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
