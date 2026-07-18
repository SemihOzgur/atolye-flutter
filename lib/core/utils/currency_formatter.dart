class CurrencyFormatter {
  CurrencyFormatter._();

  static const int _fractionDigits = 2;
  static const int _roundingDigits = 15;

  static String format(double amount) {
    if (!amount.isFinite) {
      throw ArgumentError.value(
        amount,
        'amount',
        'Sonsuz veya NaN değerler biçimlendirilemez.',
      );
    }

    final isNegative = amount < 0;
    final absoluteText = amount.abs().toStringAsFixed(_roundingDigits);
    final parts = absoluteText.split('.');
    final wholePart = BigInt.parse(parts[0]);
    final fractionText = parts.length > 1 ? parts[1] : '';

    final leadingFraction = fractionText.padRight(_roundingDigits, '0');
    final major = wholePart * BigInt.from(100);
    final cents = BigInt.from(int.parse(leadingFraction.substring(0, 2)));
    final shouldRoundUp = int.parse(leadingFraction.substring(2, 3)) >= 5;

    final roundedTotalCents =
        major + cents + (shouldRoundUp ? BigInt.one : BigInt.zero);
    final roundedWhole = roundedTotalCents ~/ BigInt.from(100);
    final roundedCents = roundedTotalCents % BigInt.from(100);

    final sign = isNegative && roundedTotalCents != BigInt.zero ? '-' : '';
    final formattedWhole = _groupThousands(roundedWhole);
    final formattedFraction =
        roundedCents.toString().padLeft(_fractionDigits, '0');

    return '$sign$formattedWhole,$formattedFraction ₺';
  }

  static String _groupThousands(BigInt value) {
    final digits = value.toString();
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      final remaining = digits.length - i;
      if (i > 0 && remaining % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }

    return buffer.toString();
  }
}
