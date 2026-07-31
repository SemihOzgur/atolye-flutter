import 'dart:typed_data';

/// UTF-8 (Dart String) → CP857 (Türkçe DOS kod sayfası) byte dönüşümü.
///
/// Yazıcıya `ESC t 0x12` (CP857 seç) komutundan sonra gönderilecek metin
/// bu kod sayfasında olmalıdır — XP-Q807K'nin CP857 sayfa numarası sahada
/// doğrulanmalı (bkz. F4-QA1). Tablo dışı karakter '?' ile değiştirilir.
class Cp857Encoder {
  const Cp857Encoder();

  static const Map<String, int> _turkishChars = {
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

  static int get turkishCharacterCount => _turkishChars.length;

  /// Türkçe karakterlere atanan ham CP857 byte değerleri, sırayla
  /// ç,Ç,ğ,Ğ,ı,İ,ö,Ö,ş,Ş,ü,Ü — kod sayfası tanı testi için (bkz.
  /// `EscPosBuilder.buildCodepageDiagnostic`).
  static Uint8List get turkishByteValues =>
      Uint8List.fromList(_turkishChars.values.toList());

  Uint8List encode(String text) {
    final bytes = Uint8List(text.length);
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      final mapped = _turkishChars[char];
      if (mapped != null) {
        bytes[i] = mapped;
      } else {
        final codeUnit = char.codeUnitAt(0);
        bytes[i] = codeUnit < 128 ? codeUnit : 0x3F; // '?'
      }
    }
    return bytes;
  }
}
