import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/core/utils/money_formatter.dart';

void main() {
  group('MoneyFormatter.parse', () {
    test('parses whole numbers and both decimal separators into minor units', () {
      expect(MoneyFormatter.parse('12'), 1200);
      expect(MoneyFormatter.parse('12.5'), 1250);
      expect(MoneyFormatter.parse('12,05'), 1205);
      expect(MoneyFormatter.parse(' 0.99 '), 99);
    });

    test('avoids floating point rounding errors', () {
      expect(MoneyFormatter.parse('0.29'), 29);
      expect(MoneyFormatter.parse('1.15'), 115);
    });

    test('rejects invalid input', () {
      for (final input in ['', 'abc', '1.234', '1,2,3', '-5', '1 000']) {
        expect(MoneyFormatter.parse(input), isNull, reason: input);
      }
    });
  });

  group('MoneyFormatter.format', () {
    test('formats per locale and currency', () {
      expect(MoneyFormatter(locale: 'en_US', currencyCode: 'USD').format(123456), r'$1,234.56');
      expect(MoneyFormatter(locale: 'de', currencyCode: 'EUR').format(123456), '1.234,56 €');
    });

    test('adds signs for negative and, optionally, positive amounts', () {
      final money = MoneyFormatter(locale: 'en_US', currencyCode: 'USD');
      expect(money.format(-500), r'−$5.00');
      expect(money.format(500, signed: true), r'+$5.00');
      expect(money.format(0, signed: true), r'$0.00');
    });

    test('toInput round-trips through parse', () {
      for (final locale in ['en_US', 'de', 'es']) {
        final money = MoneyFormatter(locale: locale, currencyCode: 'EUR');
        expect(MoneyFormatter.parse(money.toInput(123456)), 123456, reason: locale);
      }
    });
  });
}
