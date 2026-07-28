import 'dart:typed_data';

/// Ham ESC/POS baytlarını fiziksel yazıcıya ileten arayüz. İki
/// implementasyon var: [WindowsRawPrinter] (Windows yazıcı kuyruğu, RAW
/// datatype) ve [NetworkPrinter] (LAN yazıcılar için TCP 9100 — sürücüsüz).
abstract class ReceiptPrinter {
  /// Sistemde kayıtlı yazıcı adlarını listeler (yalnızca RAW modda
  /// anlamlıdır; ağ modunda boş liste döner).
  Future<List<String>> listPrinters();

  /// [bytes]'ı [target]'a (RAW modda yazıcı adı, ağ modunda `host:port`)
  /// yazar. Başarısızlıkta anlaşılır bir hata mesajıyla exception fırlatır.
  Future<void> printRaw(String target, Uint8List bytes);
}

class ReceiptPrinterException implements Exception {
  ReceiptPrinterException(this.message);

  final String message;

  @override
  String toString() => message;
}
