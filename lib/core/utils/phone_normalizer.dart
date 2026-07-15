class PhoneNormalizer {
  PhoneNormalizer._();

  static final RegExp _invalidCharacters = RegExp(r'[^0-9+\s().-]');

  static String normalize(String rawPhone) {
    final trimmed = rawPhone.trim();

    if (trimmed.isEmpty) {
      throw const FormatException(
        'Telefon numarası boş olamaz. Örnek: 05321234567 veya +905321234567.',
      );
    }

    if (_invalidCharacters.hasMatch(trimmed)) {
      throw const FormatException(
        'Telefon numarası yalnızca rakam, boşluk, parantez ve "+" karakterleri içerebilir.',
      );
    }

    final digitsOnly = trimmed.replaceAll(RegExp(r'[\s().-]'), '');
    if (digitsOnly.isEmpty) {
      throw const FormatException(
        'Telefon numarası geçersiz. Örnek formatlar: 05321234567, 5321234567, +905321234567.',
      );
    }

    final normalizedDigits = _extractLocalMobileDigits(digitsOnly);

    if (normalizedDigits.length != 10) {
      throw const FormatException(
        'Telefon numarası eksik ya da fazla haneli. Beklenen uzunluk: 10 hane mobil numara.',
      );
    }

    if (!RegExp(r'^5\d{9}$').hasMatch(normalizedDigits)) {
      throw const FormatException(
        'Yalnızca 5 ile başlayan Türk mobil numaraları kabul edilir. Örnek: 05321234567.',
      );
    }

    return '+90$normalizedDigits';
  }

  static String _extractLocalMobileDigits(String value) {
    if (value.startsWith('+90')) {
      return value.substring(3);
    }

    if (value.startsWith('0090')) {
      return value.substring(4);
    }

    if (value.startsWith('90') && value.length > 2) {
      return value.substring(2);
    }

    if (value.startsWith('0') && value.length > 1) {
      return value.substring(1);
    }

    return value;
  }
}
