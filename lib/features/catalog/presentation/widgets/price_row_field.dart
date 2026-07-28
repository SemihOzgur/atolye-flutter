import 'package:flutter/material.dart';

import '../../../../core/utils/tr_decimal.dart';

/// Fiyat matrisi satırındaki tek bir fiyat alanı. Kendi
/// [TextEditingController]'ını yönetir; parent tarafından yalnızca
/// `serviceTypeId` ile `key`'lenmesi gerekir (fiyat DEĞERİ key'e katılmaz).
/// Böylece her tuş vuruşunda tetiklenen cubit emit'i widget state'ini
/// sıfırlamaz — controller yalnızca [resetToken] değiştiğinde (kategori
/// değişimi veya kaydet-sonrası yeniden yükleme) sunucu değeriyle tazelenir.
class PriceRowField extends StatefulWidget {
  const PriceRowField({
    super.key,
    required this.initialPrice,
    required this.resetToken,
    required this.onValidChanged,
    required this.onValidityChanged,
  });

  final double initialPrice;
  final int resetToken;
  final ValueChanged<double> onValidChanged;
  final ValueChanged<bool> onValidityChanged;

  @override
  State<PriceRowField> createState() => _PriceRowFieldState();
}

class _PriceRowFieldState extends State<PriceRowField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialPrice.toStringAsFixed(2));
  String? _errorText;

  @override
  void didUpdateWidget(covariant PriceRowField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resetToken != widget.resetToken) {
      _controller.text = widget.initialPrice.toStringAsFixed(2);
      if (_errorText != null) {
        setState(() => _errorText = null);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    final parsed = parseTrDecimal(value);
    if (parsed == null) {
      widget.onValidityChanged(false);
      if (_errorText == null) {
        setState(() => _errorText = 'Geçersiz tutar');
      }
      return;
    }

    widget.onValidityChanged(true);
    widget.onValidChanged(parsed);
    if (_errorText != null) {
      setState(() => _errorText = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [trDecimalInputFormatter],
      decoration: InputDecoration(
        suffixText: '₺',
        errorText: _errorText,
      ),
      onChanged: _handleChanged,
    );
  }
}
