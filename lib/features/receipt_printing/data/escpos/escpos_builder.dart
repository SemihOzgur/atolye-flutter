import 'dart:typed_data';

import '../../../../core/utils/currency_formatter.dart';
import '../../domain/receipt_data.dart';
import 'cp857_encoder.dart';

/// [ReceiptData] → ESC/POS byte dizisi. Saf fonksiyondur — IO yapmaz,
/// yalnızca byte üretir. 80mm kağıt / 576 nokta (203 dpi) / Font A 48
/// sütun varsayılır (SDD §F4.5).
///
/// Barkod komut baytları (`GS h 100`, `GS w 2`, `GS H 2`, `GS k 73`) ve
/// hizalama/boyut komutları SDD'de birebir verilmiştir. CP857 sayfa
/// numarası (`ESC t 57`) yazıcının kendi self-test çıktısında PC857 olarak
/// listelenen değer kullanılarak sahada doğrulanmıştır (bkz. F4-QA1). QR
/// modül/hata-düzeltme parametreleri yaygın ESC/POS varsayılanlarıdır —
/// farklı davranan bir yazıcı çıkarsa `buildCodepageDiagnostic()` ile
/// yeniden doğrulanabilir.
class EscPosBuilder {
  const EscPosBuilder({
    this.cp857Encoder = const Cp857Encoder(),
    this.columnWidth = 48,
  });

  final Cp857Encoder cp857Encoder;
  final int columnWidth;

  static const List<int> _init = [0x1B, 0x40]; // ESC @
  static const List<int> _selectCp857 = [0x1B, 0x74, 0x39]; // ESC t 57 (PC857, printer self-test)
  static const List<int> _cut = [0x1D, 0x56, 0x42, 0x00]; // GS V 66 0

  Uint8List build(
    ReceiptData data, {
    int copies = 1,
    bool includeTrackingQr = false,
  }) {
    final out = BytesBuilder();
    for (var i = 0; i < copies; i++) {
      out.add(_buildSingleCopy(data, includeTrackingQr: includeTrackingQr));
    }
    return out.toBytes();
  }

  /// TANI ARACI (F4-QA1): `_selectCp857`'nin bu yazıcıda doğru CP857
  /// bastığı sahada doğrulanmıştır (ESC t 57). Farklı bir yazıcı modeline
  /// geçilirse veya Türkçe karakterler tekrar bozuk basarsa, bu metot her
  /// aday kod sayfası numarası için ESC/POS baytlarını [Cp857Encoder]'ın
  /// Türkçe karakterlere atadığı ham byte değerleriyle basar; hangi "n="
  /// satırında Türkçe karakterler (çÇğĞıİöÖşŞüÜ) doğru görünüyorsa doğru
  /// kod sayfası odur.
  Uint8List buildCodepageDiagnostic() {
    const candidates = [
      0, 2, 3, 4, 5, 6, 13, 16, 17, 18, 19, 20, 21, 22, 32, 36, 57,
    ];
    final turkishBytes = Cp857Encoder.turkishByteValues;

    final out = BytesBuilder();
    out.add(_init);
    out.add(_line('--- KOD SAYFASI TESTI ---'));
    out.add(_line('cCgGiIoOsSuU (referans, ASCII)'));
    for (final n in candidates) {
      out.add([0x1B, 0x74, n]); // ESC t n
      out.add('n=$n: '.codeUnits);
      out.add(turkishBytes);
      out.add([0x0A]);
    }
    out.add(_feed(3));
    out.add(_cut);
    return out.toBytes();
  }

  Uint8List _buildSingleCopy(
    ReceiptData data, {
    required bool includeTrackingQr,
  }) {
    final out = BytesBuilder();
    out.add(_init);
    out.add(_selectCp857);

    // 1. Atölye adı (ortalı, çift boy)
    out.add(_align(1));
    out.add(_size(0x11));
    out.add(_line('DoTiKa'));

    // 2. orderNumber (ortalı, çift yükseklik) — barkod içeriği de bu
    out.add(_size(0x01));
    out.add(_line(data.orderNumber));

    // 3. Code128 barkod
    out.add(_size(0x00));
    out.add(_code128(data.orderNumber));
    out.add(_feed(1));

    // 4. Müşteri + telefon
    out.add(_align(0));
    out.add(_line('${data.customerName}  ${data.phone}'));

    // 5. Ürün bloğu — null alan satır olarak basılmaz
    out.add(_line(data.categoryPath));
    if (data.brand != null) out.add(_line('Marka: ${data.brand}'));
    if (data.color != null) out.add(_line('Renk: ${data.color}'));
    if (data.material != null) out.add(_line('Malzeme: ${data.material}'));

    // 6a. Açıklama (ayrı başlık, yalnızca doluysa)
    if (data.description != null && data.description!.trim().isNotEmpty) {
      out.add(_textBlock('Açıklama', data.description!));
    }

    // 6b. Detay (existingDamages, ayrı başlık, yalnızca doluysa)
    if (data.existingDamages != null &&
        data.existingDamages!.trim().isNotEmpty) {
      out.add(_textBlock('Detay', data.existingDamages!));
    }

    // 6c. Yapılan işlemler (yalnızca hizmet seçildiyse)
    if (data.serviceNames.isNotEmpty) {
      out.add(_listBlock('Yapılan İşlemler', data.serviceNames));
    }

    // 6d. Sarf malzemeleri (yalnızca sarf malzemesi kullanıldıysa)
    if (data.consumableNames.isNotEmpty) {
      out.add(_listBlock('Sarf Malzemeleri', data.consumableNames));
    }

    // 7. Kabul / tahmini teslim / durum / basım zamanı
    out.add(_line('Kabul: ${_formatDate(data.createdAt)}'));
    if (data.estimatedDeliveryDate != null) {
      out.add(
        _line('Tah. Teslim: ${_formatDate(data.estimatedDeliveryDate!)}'),
      );
    }
    out.add(_line('Durum: ${data.statusLabel}'));
    out.add(_line('Basim: ${_formatDateTime(data.printedAt)}'));

    // 7b. Ödeme özeti — toplam / (varsa) ön ödeme / kalan tutar
    out.add(_feed(1));
    out.add(_paymentSummary(data));

    // 8. Takip QR (opsiyonel)
    if (includeTrackingQr && data.trackingUrl != null) {
      out.add(_align(1));
      out.add(_qrCode(data.trackingUrl!));
      out.add(_feed(1));
      out.add(_align(0));
    }

    // 9. Boşluk + kısmi kesme
    out.add(_feed(4));
    out.add(_cut);

    return out.toBytes();
  }

  /// Başlık + serbest metin bloğu (Açıklama/Detay) — metin 48 sütuna
  /// sarmalanır, bloktan sonra ayırıcı bir boş satır bırakılır.
  List<int> _textBlock(String title, String content) {
    final out = <int>[];
    out.addAll(_line(title));
    for (final line in _wrap(content)) {
      out.addAll(_line(line));
    }
    out.addAll(_feed(1));
    return out;
  }

  /// Başlık + madde işaretli liste bloğu (Yapılan İşlemler/Sarf
  /// Malzemeleri) — CP857'de karşılığı olmayan "✓" yerine ASCII-güvenli
  /// "-" işareti kullanılır (baskı hatası riskini önler).
  List<int> _listBlock(String title, List<String> items) {
    final out = <int>[];
    out.addAll(_line(title));
    for (final item in items) {
      for (final line in _wrap('- $item')) {
        out.addAll(_line(line));
      }
    }
    out.addAll(_feed(1));
    return out;
  }

  /// Toplam hizmet / (varsa) ön ödeme / kalan tutar — `remainingAmount`
  /// sunucudan geldiği gibi basılır, istemci tarafında yeniden hesaplanmaz.
  List<int> _paymentSummary(ReceiptData data) {
    final out = <int>[];
    out.addAll(_line('Toplam Hizmet'));
    out.addAll(_line(CurrencyFormatter.format(data.totalPrice)));
    if (data.prepaymentAmount != null) {
      out.addAll(_feed(1));
      out.addAll(_line('Ön Ödeme'));
      out.addAll(_line(CurrencyFormatter.format(data.prepaymentAmount!)));
    }
    out.addAll(_feed(1));
    out.addAll(_line('Kalan Tutar'));
    out.addAll(_line(CurrencyFormatter.format(data.remainingAmount)));
    return out;
  }

  List<int> _align(int mode) => [0x1B, 0x61, mode]; // ESC a n
  List<int> _size(int n) => [0x1D, 0x21, n]; // GS ! n
  List<int> _feed(int lines) => List.filled(lines, 0x0A);

  List<int> _line(String value) => [
        ...cp857Encoder.encode(value),
        0x0A,
      ];

  List<int> _code128(String data) {
    // GS k 73 n {B<data>} — '{B' Code Set B seçer (alfanümerik).
    final payload = <int>[0x7B, 0x42, ...data.codeUnits];
    return [
      0x1D, 0x68, 100, // GS h 100 — yükseklik
      0x1D, 0x77, 2, // GS w 2 — modül genişliği
      0x1D, 0x48, 2, // GS H 2 — HRI altta
      0x1D, 0x6B, 73, payload.length, // GS k 73 n
      ...payload,
    ];
  }

  List<int> _qrCode(String data) {
    final bytes = data.codeUnits;
    final storeLen = bytes.length + 3;
    return [
      // Model 2
      0x1D, 0x28, 0x6B, 0x04, 0x00, 0x31, 0x41, 0x32, 0x00,
      // Modül boyutu 5
      0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x43, 0x05,
      // Hata düzeltme seviyesi M
      0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x45, 0x31,
      // Veri sakla
      0x1D, 0x28, 0x6B, storeLen & 0xFF, (storeLen >> 8) & 0xFF, 0x31, 0x50,
      0x30, ...bytes,
      // Yazdır
      0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x51, 0x30,
    ];
  }

  List<String> _wrap(String text) {
    if (text.trim().isEmpty) return const [];

    final words = text.split(RegExp(r'\s+'));
    final lines = <String>[];
    var current = StringBuffer();

    for (final word in words) {
      var remaining = word;
      while (remaining.length > columnWidth) {
        if (current.isNotEmpty) {
          lines.add(current.toString());
          current = StringBuffer();
        }
        lines.add(remaining.substring(0, columnWidth));
        remaining = remaining.substring(columnWidth);
      }

      if (current.isEmpty) {
        current.write(remaining);
      } else if (current.length + 1 + remaining.length <= columnWidth) {
        current.write(' ');
        current.write(remaining);
      } else {
        lines.add(current.toString());
        current = StringBuffer(remaining);
      }
    }
    if (current.isNotEmpty) lines.add(current.toString());
    return lines;
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${_pad2(local.day)}.${_pad2(local.month)}.${local.year}';
  }

  String _formatDateTime(DateTime date) {
    final local = date.toLocal();
    return '${_formatDate(date)} ${_pad2(local.hour)}:${_pad2(local.minute)}';
  }

  String _pad2(int n) => n.toString().padLeft(2, '0');
}
