import 'package:flutter/services.dart';

class TwoDecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text;

    // اجازه پاک کردن کامل
    if (text.isEmpty) {
      return newValue;
    }

    // فقط اعداد و نقطه
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(text)) {
      return oldValue;
    }

    // اگر اعشار دارد
    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts.length > 2) {
        return oldValue;
      }

      // بیش از دو رقم اعشار
      if (parts[1].length > 2) {
        return oldValue;
      }
    }

    return newValue;
  }
}
