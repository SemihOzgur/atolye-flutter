import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'receipt_printer.dart';

/// LAN'a bağlı yazıcılar için sürücüsüz yol: ESC/POS baytları doğrudan
/// yazıcının 9100 numaralı ham yazdırma soketine yazılır. [target]
/// `host` veya `host:port` biçiminde olmalıdır (port verilmezse 9100).
class NetworkPrinter implements ReceiptPrinter {
  const NetworkPrinter({this.connectTimeout = const Duration(seconds: 5)});

  final Duration connectTimeout;

  static const int defaultPort = 9100;

  @override
  Future<List<String>> listPrinters() async => const [];

  @override
  Future<void> printRaw(String target, Uint8List bytes) async {
    final parts = target.split(':');
    final host = parts.first.trim();
    final port = parts.length > 1
        ? int.tryParse(parts[1]) ?? defaultPort
        : defaultPort;

    if (host.isEmpty) {
      throw ReceiptPrinterException('Yazıcı ağ adresi boş olamaz.');
    }

    Socket socket;
    try {
      socket = await Socket.connect(host, port, timeout: connectTimeout);
    } on SocketException catch (e) {
      throw ReceiptPrinterException(
        'Yazıcıya ($host:$port) ağ üzerinden bağlanılamadı: ${e.message}',
      );
    } on TimeoutException {
      throw ReceiptPrinterException(
        'Yazıcıya ($host:$port) bağlantı zaman aşımına uğradı.',
      );
    }

    try {
      socket.add(bytes);
      await socket.flush();
    } on SocketException catch (e) {
      throw ReceiptPrinterException('Yazdırma verisi gönderilemedi: ${e.message}');
    } finally {
      await socket.close();
      socket.destroy();
    }
  }
}
