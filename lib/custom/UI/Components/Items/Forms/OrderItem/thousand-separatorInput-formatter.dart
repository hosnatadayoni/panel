import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat formatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String cleanText = newValue.text.replaceAll(',', '');
    if (cleanText.isEmpty) return newValue;

    int value = int.tryParse(cleanText) ?? 0;
    String newText = formatter.format(value);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
