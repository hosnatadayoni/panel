import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class MobileNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {

    if (newValue.text.isEmpty) {
      return newValue;
    }

    if (newValue.text.startsWith('0')) {
      return oldValue;
    }

    if (!newValue.text.startsWith('9')) {
      return oldValue;
    }

    if (newValue.text.length > 11) {
      return TextEditingValue(
        text: newValue.text.substring(0, 11),
        selection: TextSelection.collapsed(offset: 11),
      );
    }

    return newValue;
  }
}
