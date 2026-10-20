import 'package:flutter/services.dart';

/// Ignores keystrokes that would make the text an invalid amount
/// (letters, a second separator, or more than two decimals).
class MoneyInputFormatter extends TextInputFormatter {
  static final _pattern = RegExp(r'^\d{0,10}([.,]\d{0,2})?$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) =>
      _pattern.hasMatch(newValue.text) ? newValue : oldValue;
}
