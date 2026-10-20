import 'package:intl/intl.dart';

/// Formats and parses amounts held in minor units (2 decimal places).
class MoneyFormatter {
  MoneyFormatter({required String locale, required String currencyCode})
    : _currency = NumberFormat.simpleCurrency(locale: locale, name: currencyCode),
      _compact = NumberFormat.compactSimpleCurrency(locale: locale, name: currencyCode),
      _decimal = NumberFormat.decimalPatternDigits(locale: locale, decimalDigits: 2);

  final NumberFormat _currency;
  final NumberFormat _compact;
  final NumberFormat _decimal;

  static final _input = RegExp(r'^\d+([.,]\d{0,2})?$');

  String get symbol => _currency.currencySymbol;

  String get decimalSeparator => _decimal.symbols.DECIMAL_SEP;

  String format(int minor, {bool signed = false}) {
    final text = _currency.format(minor.abs() / 100);
    if (minor < 0) return '−$text';
    return signed && minor > 0 ? '+$text' : text;
  }

  String compact(int minor) => _compact.format(minor / 100);

  /// Plain number for editing, e.g. `12.5` → "12.50" or "12,50".
  String toInput(int minor) =>
      _decimal.format(minor / 100).replaceAll(_decimal.symbols.GROUP_SEP, '');

  /// Accepts "12", "12.5" or "12,50" without floating point rounding.
  static int? parse(String input) {
    final text = input.trim();
    if (!_input.hasMatch(text)) return null;
    final parts = text.split(RegExp('[.,]'));
    final whole = int.tryParse(parts.first);
    if (whole == null) return null;
    final fraction = parts.length > 1 ? parts[1].padRight(2, '0') : '00';
    return whole * 100 + int.parse(fraction);
  }
}
