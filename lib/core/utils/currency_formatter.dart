import 'package:intl/intl.dart';

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

    final numberFormatter = NumberFormat.decimalPattern('tr_TR');
    final sign = isNegative && roundedTotalCents != BigInt.zero ? '-' : '';
    final formattedWhole = numberFormatter.format(roundedWhole);
    final formattedFraction =
        roundedCents.toString().padLeft(_fractionDigits, '0');

    return '$sign$formattedWhole,$formattedFraction ₺';
  }
}
