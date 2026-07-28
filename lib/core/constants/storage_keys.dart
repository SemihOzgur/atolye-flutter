class StorageKeys {
  StorageKeys._();

  static const String authToken = 'auth_token';

  /// Kayıtlı yazıcı ayarları (F4 — Fiş Yazdırma). Bağlantı modu
  /// 'raw' (Windows spooler) veya 'network' (TCP 9100) değerini alır.
  static const String selectedPrinterName = 'selected_printer_name';
  static const String printerConnectionMode = 'printer_connection_mode';
  static const String printerNetworkAddress = 'printer_network_address';
}
