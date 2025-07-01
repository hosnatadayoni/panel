import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class ThousandSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {

    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    String formattedText = _formatWithThousandSeparator(newText);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatWithThousandSeparator(String value) {
    if (value.isEmpty) return '';
    final int number = int.parse(value);
    return NumberFormat('#,###').format(number);
  }
}