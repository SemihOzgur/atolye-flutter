import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/utils/tr_decimal.dart';

void main() {
  group('parseTrDecimal', () {
    test('parses comma as decimal separator', () {
      expect(parseTrDecimal('12,5'), 12.5);
    });

    test('parses dot as decimal separator', () {
      expect(parseTrDecimal('12.5'), 12.5);
    });

    test('parses an integer without a separator', () {
      expect(parseTrDecimal('12'), 12);
    });

    test('trims surrounding whitespace', () {
      expect(parseTrDecimal(' 12,5 '), 12.5);
    });

    test('returns null for a trailing separator', () {
      expect(parseTrDecimal('12,'), isNull);
    });

    test('returns null for an empty string', () {
      expect(parseTrDecimal(''), isNull);
    });

    test('returns null for non-numeric input', () {
      expect(parseTrDecimal('abc'), isNull);
    });
  });

  group('trDecimalInputFormatter', () {
    TextEditingValue apply(String text) => trDecimalInputFormatter
        .formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(text: text, selection: TextSelection.collapsed(
            offset: text.length,
          )),
        );

    test('allows digits with up to two decimals', () {
      expect(apply('12,50').text, '12,50');
    });

    test('rejects a third decimal digit', () {
      expect(apply('12,505').text, isNot('12,505'));
    });
  });
}
