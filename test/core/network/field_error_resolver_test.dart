import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/field_error_resolver.dart';

void main() {
  test('resolves model-binding style key (\$.field)', () {
    final resolver = FieldErrorResolver({
      r'$.estimatedDeliveryDate': ['The JSON value could not be converted.'],
    });

    expect(
      resolver.errorFor('estimatedDeliveryDate'),
      'The JSON value could not be converted.',
    );
  });

  test('resolves FluentValidation PascalCase key', () {
    final resolver = FieldErrorResolver({
      'PrepaymentAmount': ['Kapora fiyatı aşamaz.'],
    });

    expect(resolver.errorFor('prepaymentAmount'), 'Kapora fiyatı aşamaz.');
  });

  test('resolves already-camelCase key', () {
    final resolver = FieldErrorResolver({
      'price': ['Price must be non-negative.'],
    });

    expect(resolver.errorFor('price'), 'Price must be non-negative.');
  });

  test('joins multiple messages for the same field with newline', () {
    final resolver = FieldErrorResolver({
      'Brand': ['Message one.', 'Message two.'],
    });

    expect(resolver.errorFor('brand'), 'Message one.\nMessage two.');
  });

  test('returns null when no matching key exists', () {
    final resolver = FieldErrorResolver({
      'SomeOtherField': ['irrelevant'],
    });

    expect(resolver.errorFor('brand'), isNull);
  });

  test('returns null for an empty map', () {
    final resolver = FieldErrorResolver(const {});
    expect(resolver.errorFor('brand'), isNull);
    expect(resolver.hasAny, isFalse);
  });

  test('hasAny reflects whether the map is non-empty', () {
    final resolver = FieldErrorResolver({
      'Brand': ['required'],
    });
    expect(resolver.hasAny, isTrue);
  });
}
