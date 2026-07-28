import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/utils/date_only_json.dart';

void main() {
  group('dateOnlyToJson', () {
    test('returns null for null input', () {
      expect(dateOnlyToJson(null), isNull);
    });

    test('pads single-digit month and day', () {
      expect(dateOnlyToJson(DateTime(2026, 8, 5)), '2026-08-05');
    });

    test('handles year boundaries', () {
      expect(dateOnlyToJson(DateTime(2026, 1, 1)), '2026-01-01');
      expect(dateOnlyToJson(DateTime(2026, 12, 31)), '2026-12-31');
    });

    test('does not emit a time component', () {
      final value = dateOnlyToJson(DateTime(2026, 7, 28, 23, 30));
      expect(value, '2026-07-28');
      expect(value, isNot(contains('T')));
    });
  });

  group('dateOnlyFromJson', () {
    test('returns null for null input', () {
      expect(dateOnlyFromJson(null), isNull);
    });

    test('parses a yyyy-MM-dd string', () {
      final result = dateOnlyFromJson('2026-08-05');
      expect(result, DateTime(2026, 8, 5));
    });
  });

  test('round-trips through toJson/fromJson without drift', () {
    final original = DateTime(2026, 8, 5);
    final roundTripped = dateOnlyFromJson(dateOnlyToJson(original));
    expect(roundTripped, original);
  });
}
