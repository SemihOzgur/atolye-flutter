import 'package:flutter/services.dart';

/// Tam sayı veya en fazla 2 ondalık haneli sayı; ayraçtan sonra en az 1 hane
/// zorunludur. `double.tryParse` tek başına "12," girdisini "12." olarak
/// kabul edip sessizce 12.0 döner — bu, kullanıcının henüz tamamlamadığı bir
/// girdiyi tamamlanmış gibi göstererek "görünen ≠ gönderilen" riskini
/// yeniden yaratır; bu yüzden ayraçtan sonra hane şartı burada uygulanır.
final _trDecimalPattern = RegExp(r'^\d+([,.]\d{1,2})?$');

/// "12,5" | "12.5" | "12" → double; boş/geçersiz/tamamlanmamış girdi → null.
double? parseTrDecimal(String raw) {
  final trimmed = raw.trim();
  if (!_trDecimalPattern.hasMatch(trimmed)) {
    return null;
  }
  return double.tryParse(trimmed.replaceAll(',', '.'));
}

/// Rakam + en fazla bir ayraç (virgül veya nokta) + en fazla 2 ondalık hane.
final trDecimalInputFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'^\d*[,.]?\d{0,2}$'));
