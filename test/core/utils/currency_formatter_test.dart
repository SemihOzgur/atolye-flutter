import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/utils/currency_formatter.dart';

void main() {
  test('formats small amounts with two decimals', () {
    expect(CurrencyFormatter.format(0), '0,00 ₺');
    expect(CurrencyFormatter.format(1250.5), '1.250,50 ₺');
  });

  test('groups thousands for large amounts', () {
    expect(CurrencyFormatter.format(34500), '34.500,00 ₺');
    expect(CurrencyFormatter.format(1234567.89), '1.234.567,89 ₺');
  });

  test('rounds half up away from zero', () {
    expect(CurrencyFormatter.format(10.005), '10,01 ₺');
    expect(CurrencyFormatter.format(-10.005), '-10,01 ₺');
  });

  test('throws for non-finite values', () {
    expect(
      () => CurrencyFormatter.format(double.nan),
      throwsArgumentError,
    );
  });
}
