import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/features/receipt_printing/data/escpos/cp857_encoder.dart';
import 'package:leather_care_admin/features/receipt_printing/data/escpos/escpos_builder.dart';
import 'package:leather_care_admin/features/receipt_printing/domain/receipt_data.dart';

/// `String.fromCharCodes` + `contains(...)`, CP857'ye kodlanmış Türkçe
/// karakterli metinlerle çalışmaz (bayt değerleri Unicode kod noktalarıyla
/// örtüşmez) — bu yardımcı beklenen metni aynı kod sayfasıyla kodlayıp
/// bayt dizisi içinde arar.
bool _containsCp857Text(List<int> bytes, String text) {
  return _containsSequence(bytes, const Cp857Encoder().encode(text));
}

bool _containsSequence(List<int> haystack, List<int> needle) {
  if (needle.isEmpty || needle.length > haystack.length) return false;
  for (var i = 0; i <= haystack.length - needle.length; i++) {
    var matched = true;
    for (var j = 0; j < needle.length; j++) {
      if (haystack[i + j] != needle[j]) {
        matched = false;
        break;
      }
    }
    if (matched) return true;
  }
  return false;
}

int _countSequence(List<int> haystack, List<int> needle) {
  var count = 0;
  for (var i = 0; i <= haystack.length - needle.length; i++) {
    var matched = true;
    for (var j = 0; j < needle.length; j++) {
      if (haystack[i + j] != needle[j]) {
        matched = false;
        break;
      }
    }
    if (matched) count++;
  }
  return count;
}

void main() {
  const builder = EscPosBuilder();

  final baseData = ReceiptData(
    orderNumber: 'WO-2026-000123',
    customerName: 'Ayşe Yılmaz',
    phone: '0532 *** ** 67',
    categoryPath: 'Kadın > Ayakkabı > Sneakers',
    createdAt: DateTime(2026, 7, 12, 10, 30),
    statusLabel: 'Teslim Alındı',
    printedAt: DateTime(2026, 7, 12, 10, 31),
    totalPrice: 100,
    remainingAmount: 100,
  );

  test('starts with init (ESC @) and CP857 selection (ESC t 57)', () {
    final bytes = builder.build(baseData);

    expect(bytes.sublist(0, 2), [0x1B, 0x40]);
    expect(bytes.sublist(2, 5), [0x1B, 0x74, 0x39]);
  });

  test('embeds the order number as Code128 barcode payload ({B prefix)', () {
    final bytes = builder.build(baseData);

    // GS k 73 n {B<orderNumber>
    final needle = [
      0x1D, 0x6B, 73, 16, // n = 2 ({B) + 14 (orderNumber length)
      0x7B, 0x42,
      ...'WO-2026-000123'.codeUnits,
    ];
    expect(_containsSequence(bytes, needle), isTrue);
  });

  test('includes the barcode height/width/HRI commands from the SDD spec', () {
    final bytes = builder.build(baseData);

    expect(_containsSequence(bytes, [0x1D, 0x68, 100]), isTrue); // GS h 100
    expect(_containsSequence(bytes, [0x1D, 0x77, 2]), isTrue); // GS w 2
    expect(_containsSequence(bytes, [0x1D, 0x48, 2]), isTrue); // GS H 2
  });

  test('ends with 4 line feeds and a partial cut (GS V 66 0)', () {
    final bytes = builder.build(baseData);

    expect(bytes.sublist(bytes.length - 4), [0x1D, 0x56, 0x42, 0x00]);
    final beforeCut = bytes.sublist(bytes.length - 8, bytes.length - 4);
    expect(beforeCut, [0x0A, 0x0A, 0x0A, 0x0A]);
  });

  test('null fields (brand/color/material) do not produce a line', () {
    final bytes = builder.build(baseData);
    final asLatin1 = String.fromCharCodes(bytes);

    expect(asLatin1.contains('Marka:'), isFalse);
    expect(asLatin1.contains('Renk:'), isFalse);
    expect(asLatin1.contains('Malzeme:'), isFalse);
  });

  test('a provided field produces exactly one labeled line', () {
    final data = ReceiptData(
      orderNumber: baseData.orderNumber,
      customerName: baseData.customerName,
      phone: baseData.phone,
      categoryPath: baseData.categoryPath,
      brand: 'Nike',
      createdAt: baseData.createdAt,
      statusLabel: baseData.statusLabel,
      printedAt: baseData.printedAt,
      totalPrice: baseData.totalPrice,
      remainingAmount: baseData.remainingAmount,
    );

    final bytes = builder.build(data);
    final asLatin1 = String.fromCharCodes(bytes);

    expect(_containsCp857Text(bytes, 'Deri Bakım Merkezi'), isTrue);
    expect(asLatin1.contains('Marka: Nike'), isTrue);
  });

  test('wraps long description text at the configured column width', () {
    final longWord = 'A' * 30;
    final data = ReceiptData(
      orderNumber: baseData.orderNumber,
      customerName: baseData.customerName,
      phone: baseData.phone,
      categoryPath: baseData.categoryPath,
      description: '$longWord $longWord $longWord',
      createdAt: baseData.createdAt,
      statusLabel: baseData.statusLabel,
      printedAt: baseData.printedAt,
      totalPrice: baseData.totalPrice,
      remainingAmount: baseData.remainingAmount,
    );

    final bytes = builder.build(data);
    final lines = String.fromCharCodes(bytes).split('\n');

    for (final line in lines) {
      expect(line.length, lessThanOrEqualTo(48));
    }
  });

  test('copies=2 produces two full receipts (two cut commands)', () {
    final bytes = builder.build(baseData, copies: 2);
    final cutCount = _countSequence(bytes, [0x1D, 0x56, 0x42, 0x00]);
    expect(cutCount, 2);
  });

  test('includeTrackingQr=false omits the QR store command', () {
    final data = ReceiptData(
      orderNumber: baseData.orderNumber,
      customerName: baseData.customerName,
      phone: baseData.phone,
      categoryPath: baseData.categoryPath,
      trackingUrl: 'https://dotikadbm.com/t/abc',
      createdAt: baseData.createdAt,
      statusLabel: baseData.statusLabel,
      printedAt: baseData.printedAt,
      totalPrice: baseData.totalPrice,
      remainingAmount: baseData.remainingAmount,
    );

    final bytes = builder.build(data);
    // GS ( k ... 0x31 0x50 (store data function) should not appear.
    expect(
      _containsSequence(bytes, [0x1D, 0x28, 0x6B]),
      isFalse,
    );
  });

  test('includeTrackingQr=true adds the QR model/store/print commands', () {
    final data = ReceiptData(
      orderNumber: baseData.orderNumber,
      customerName: baseData.customerName,
      phone: baseData.phone,
      categoryPath: baseData.categoryPath,
      trackingUrl: 'https://dotikadbm.com/t/abc',
      createdAt: baseData.createdAt,
      statusLabel: baseData.statusLabel,
      printedAt: baseData.printedAt,
      totalPrice: baseData.totalPrice,
      remainingAmount: baseData.remainingAmount,
    );

    final bytes = builder.build(data, includeTrackingQr: true);

    expect(
      _containsSequence(bytes, [0x1D, 0x28, 0x6B, 0x04, 0x00, 0x31, 0x41]),
      isTrue,
    ); // model select
    expect(
      _containsSequence(
          bytes, [0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x51, 0x30]),
      isTrue,
    ); // print
  });

  test('Turkish characters in text fields are CP857-encoded', () {
    final bytes = builder.build(baseData);
    // "Yılmaz" — ı(0x8D). Confirms non-ASCII text is not passed as raw UTF-8.
    expect(_containsSequence(bytes, [0x8D]), isTrue);
  });

  test('description and existingDamages print under separate headers', () {
    final data = ReceiptData(
      orderNumber: baseData.orderNumber,
      customerName: baseData.customerName,
      phone: baseData.phone,
      categoryPath: baseData.categoryPath,
      description: 'Ön kısımda açılma mevcut.',
      existingDamages: 'Taban yeniden yapıştırılacak.',
      createdAt: baseData.createdAt,
      statusLabel: baseData.statusLabel,
      printedAt: baseData.printedAt,
      totalPrice: baseData.totalPrice,
      remainingAmount: baseData.remainingAmount,
    );

    final bytes = builder.build(data);

    expect(_containsCp857Text(bytes, 'Açıklama'), isTrue);
    expect(_containsCp857Text(bytes, 'Ön kısımda açılma mevcut.'), isTrue);
    expect(_containsCp857Text(bytes, 'Detay'), isTrue);
    expect(
      _containsCp857Text(bytes, 'Taban yeniden yapıştırılacak.'),
      isTrue,
    );
    // No longer joined with ' / ' into a single combined block.
    expect(_containsCp857Text(bytes, ' / '), isFalse);
  });

  test('description/existingDamages headers are omitted when both are null',
      () {
    final bytes = builder.build(baseData);

    expect(_containsCp857Text(bytes, 'Açıklama'), isFalse);
    expect(_containsCp857Text(bytes, 'Detay'), isFalse);
  });

  test('serviceNames print under "Yapılan İşlemler" with a dash marker', () {
    final data = ReceiptData(
      orderNumber: baseData.orderNumber,
      customerName: baseData.customerName,
      phone: baseData.phone,
      categoryPath: baseData.categoryPath,
      createdAt: baseData.createdAt,
      statusLabel: baseData.statusLabel,
      printedAt: baseData.printedAt,
      serviceNames: const ['Boyama', 'Deri Bakımı'],
      totalPrice: baseData.totalPrice,
      remainingAmount: baseData.remainingAmount,
    );

    final bytes = builder.build(data);

    expect(_containsCp857Text(bytes, 'Yapılan İşlemler'), isTrue);
    expect(_containsCp857Text(bytes, '- Boyama'), isTrue);
    expect(_containsCp857Text(bytes, '- Deri Bakımı'), isTrue);
  });

  test('consumableNames print under "Sarf Malzemeleri" with a dash marker', () {
    final data = ReceiptData(
      orderNumber: baseData.orderNumber,
      customerName: baseData.customerName,
      phone: baseData.phone,
      categoryPath: baseData.categoryPath,
      createdAt: baseData.createdAt,
      statusLabel: baseData.statusLabel,
      printedAt: baseData.printedAt,
      consumableNames: const ['Deri Boya', 'Koruyucu Sprey'],
      totalPrice: baseData.totalPrice,
      remainingAmount: baseData.remainingAmount,
    );

    final asLatin1 = String.fromCharCodes(builder.build(data));

    expect(asLatin1.contains('Sarf Malzemeleri'), isTrue);
    expect(asLatin1.contains('- Deri Boya'), isTrue);
    expect(asLatin1.contains('- Koruyucu Sprey'), isTrue);
  });

  test('services/consumables sections are omitted when the lists are empty',
      () {
    final bytes = builder.build(baseData);

    expect(_containsCp857Text(bytes, 'Yapılan İşlemler'), isFalse);
    expect(_containsCp857Text(bytes, 'Sarf Malzemeleri'), isFalse);
  });

  test(
      'payment summary prints total and remaining, omitting prepayment '
      'when null', () {
    final data = ReceiptData(
      orderNumber: baseData.orderNumber,
      customerName: baseData.customerName,
      phone: baseData.phone,
      categoryPath: baseData.categoryPath,
      createdAt: baseData.createdAt,
      statusLabel: baseData.statusLabel,
      printedAt: baseData.printedAt,
      totalPrice: 2400,
      remainingAmount: 2400,
    );

    final bytes = builder.build(data);

    expect(_containsCp857Text(bytes, 'Toplam Hizmet'), isTrue);
    expect(_containsCp857Text(bytes, '2.400,00 TL'), isTrue);
    expect(_containsCp857Text(bytes, 'Ön Ödeme'), isFalse);
    expect(_containsCp857Text(bytes, 'Kalan Tutar'), isTrue);
  });

  test('payment summary includes prepayment when present', () {
    final data = ReceiptData(
      orderNumber: baseData.orderNumber,
      customerName: baseData.customerName,
      phone: baseData.phone,
      categoryPath: baseData.categoryPath,
      createdAt: baseData.createdAt,
      statusLabel: baseData.statusLabel,
      printedAt: baseData.printedAt,
      totalPrice: 2400,
      prepaymentAmount: 500,
      remainingAmount: 1900,
    );

    final bytes = builder.build(data);

    expect(_containsCp857Text(bytes, 'Ön Ödeme'), isTrue);
    expect(_containsCp857Text(bytes, '500,00 TL'), isTrue);
    expect(_containsCp857Text(bytes, 'Kalan Tutar'), isTrue);
    expect(_containsCp857Text(bytes, '1.900,00 TL'), isTrue);
  });

  test('new sections are inserted before the trailing feed+cut', () {
    final data = ReceiptData(
      orderNumber: baseData.orderNumber,
      customerName: baseData.customerName,
      phone: baseData.phone,
      categoryPath: baseData.categoryPath,
      createdAt: baseData.createdAt,
      statusLabel: baseData.statusLabel,
      printedAt: baseData.printedAt,
      serviceNames: const ['Boyama'],
      consumableNames: const ['Deri Boya'],
      totalPrice: 2400,
      prepaymentAmount: 500,
      remainingAmount: 1900,
    );

    final bytes = builder.build(data);

    expect(bytes.sublist(bytes.length - 4), [0x1D, 0x56, 0x42, 0x00]);
    final beforeCut = bytes.sublist(bytes.length - 8, bytes.length - 4);
    expect(beforeCut, [0x0A, 0x0A, 0x0A, 0x0A]);
  });
}
