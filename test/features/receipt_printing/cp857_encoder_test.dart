import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/features/receipt_printing/data/escpos/cp857_encoder.dart';

void main() {
  const encoder = Cp857Encoder();

  test('passes ASCII characters through unchanged', () {
    final result = encoder.encode('WO-2026-000123');
    expect(result, 'WO-2026-000123'.codeUnits);
  });

  group('Turkish character mapping', () {
    const expected = {
      'ç': 0x87,
      'Ç': 0x80,
      'ğ': 0xA7,
      'Ğ': 0xA6,
      'ı': 0x8D,
      'İ': 0x98,
      'ö': 0x94,
      'Ö': 0x99,
      'ş': 0x9F,
      'Ş': 0x9E,
      'ü': 0x81,
      'Ü': 0x9A,
    };

    for (final entry in expected.entries) {
      test('maps "${entry.key}" to 0x${entry.value.toRadixString(16)}', () {
        final result = encoder.encode(entry.key);
        expect(result, [entry.value]);
      });
    }

    test('all 12 required Turkish characters are covered', () {
      expect(Cp857Encoder.turkishCharacterCount, 12);
    });
  });

  test('encodes a full Turkish pangram-style sentence', () {
    final result = encoder.encode('çğıöşü ÇĞİÖŞÜ');
    expect(
      result,
      [0x87, 0xA7, 0x8D, 0x94, 0x9F, 0x81, 0x20, 0x80, 0xA6, 0x98, 0x99, 0x9E, 0x9A],
    );
  });

  test('replaces an unmapped extended character with "?"', () {
    final result = encoder.encode('日');
    expect(result, [0x3F]);
  });

  test('output length matches input character count', () {
    const text = 'İş Emri: çğıöşü';
    expect(encoder.encode(text).length, text.length);
  });
}
