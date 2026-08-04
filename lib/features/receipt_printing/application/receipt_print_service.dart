import 'dart:typed_data';

import '../../../core/constants/storage_keys.dart';
import '../../../core/services/storage_service.dart';
import '../../work_order/data/dto/work_order_dto.dart';
import '../data/escpos/escpos_builder.dart';
import '../data/printer/network_printer.dart';
import '../data/printer/receipt_printer.dart';
import '../data/printer/windows_raw_printer.dart';
import '../domain/print_result.dart';
import '../domain/receipt_data.dart';

enum PrinterConnectionMode { raw, network }

class PrintOptions {
  const PrintOptions({
    this.copies = 1,
    this.maskPhone = true,
    this.includeTrackingQr = false,
  });

  final int copies;
  final bool maskPhone;
  final bool includeTrackingQr;
}

/// Yazdırma orkestrasyonu: yazıcı seçimi kalıcılığı, ESC/POS üretimi ve
/// seçili bağlantı moduna (RAW spooler / LAN soket) göre gönderim.
class ReceiptPrintService {
  ReceiptPrintService(
    this._storage, {
    EscPosBuilder? escPosBuilder,
    ReceiptPrinter? rawPrinter,
    ReceiptPrinter? networkPrinter,
  })  : _escPosBuilder = escPosBuilder ?? const EscPosBuilder(),
        _rawPrinter = rawPrinter ?? const WindowsRawPrinter(),
        _networkPrinter = networkPrinter ?? const NetworkPrinter();

  final ISecureStorageService _storage;
  final EscPosBuilder _escPosBuilder;
  final ReceiptPrinter _rawPrinter;
  final ReceiptPrinter _networkPrinter;

  /// RAW moddaki sistem yazıcılarını listeler (ağ modunda anlamlı değil).
  Future<List<String>> listPrinters() => _rawPrinter.listPrinters();

  Future<String?> selectedTarget() =>
      _storage.read(StorageKeys.selectedPrinterName);

  Future<PrinterConnectionMode> connectionMode() async {
    final raw = await _storage.read(StorageKeys.printerConnectionMode);
    return raw == 'network'
        ? PrinterConnectionMode.network
        : PrinterConnectionMode.raw;
  }

  Future<void> savePrinterSelection({
    required PrinterConnectionMode mode,
    required String target,
  }) async {
    await _storage.write(
      StorageKeys.printerConnectionMode,
      mode == PrinterConnectionMode.network ? 'network' : 'raw',
    );
    await _storage.write(StorageKeys.selectedPrinterName, target);
  }

  Future<PrintResult> printWorkOrderReceipt(
    WorkOrderDto workOrder,
    PrintOptions options,
  ) async {
    final data = ReceiptData.fromWorkOrder(
      workOrder,
      maskPhone: options.maskPhone,
      printedAt: DateTime.now(),
    );
    final bytes = _escPosBuilder.build(
      data,
      copies: options.copies,
      includeTrackingQr: options.includeTrackingQr,
    );
    return _sendToSelectedPrinter(bytes);
  }

  /// Kurulum/tanılama için: TR karakterler + örnek barkod içeren bir fiş.
  Future<PrintResult> printTestReceipt() async {
    final now = DateTime.now();
    final data = ReceiptData(
      orderNumber: 'WO-TEST-000001',
      customerName: 'Test Pangram ÇĞİÖŞÜ çğıöşü',
      phone: '0532 *** ** 67',
      categoryPath: 'Test > Tanılama Fişi',
      brand: 'Test Marka',
      color: 'Kahverengi',
      material: 'Deri',
      description: 'Bu bir test fişidir; Türkçe karakter ve barkod '
          'okunurluğunu doğrulamak için basılmıştır.',
      createdAt: now,
      statusLabel: 'Test',
      printedAt: now,
      serviceNames: const ['Boyama', 'Deri Bakımı'],
      consumableNames: const ['Deri Boya', 'Koruyucu Sprey'],
      totalPrice: 1000,
      prepaymentAmount: 250,
      remainingAmount: 750,
    );
    final bytes = _escPosBuilder.build(data);
    // GEÇİCİ: n=57 ("PC3846") satırının gerçekten CP857 byte'larını doğru
    // bastığı sahada teyit edilene kadar tanı bloğu ekleniyor (bkz.
    // EscPosBuilder.buildCodepageDiagnostic). Teyit sonrası kaldırılacak.
    final diagnostic = _escPosBuilder.buildCodepageDiagnostic();
    final combined = Uint8List.fromList([...bytes, ...diagnostic]);
    return _sendToSelectedPrinter(combined);
  }

  Future<PrintResult> _sendToSelectedPrinter(Uint8List bytes) async {
    final target = await selectedTarget();
    if (target == null || target.trim().isEmpty) {
      return PrintResult.failure(
        'Önce Yazıcı Ayarları\'ndan bir yazıcı seçin.',
      );
    }

    try {
      final mode = await connectionMode();
      final printer =
          mode == PrinterConnectionMode.network ? _networkPrinter : _rawPrinter;
      await printer.printRaw(target, bytes);
      return PrintResult.success();
    } on ReceiptPrinterException catch (e) {
      return PrintResult.failure(e.message);
    } catch (e) {
      return PrintResult.failure('Yazıcıya erişilemedi: $e');
    }
  }
}
