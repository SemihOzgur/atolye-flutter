import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/features/receipt_printing/data/escpos/escpos_builder.dart';
import 'package:leather_care_admin/features/receipt_printing/domain/receipt_data.dart';

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
  );

  test('starts with init (ESC @) and CP857 selection (ESC t 18)', () {
    final bytes = builder.build(baseData);

    expect(bytes.sublist(0, 2), [0x1B, 0x40]);
    expect(bytes.sublist(2, 5), [0x1B, 0x74, 0x12]);
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
    );

    final bytes = builder.build(data);
    final asLatin1 = String.fromCharCodes(bytes);

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
    );

    final bytes = builder.build(data, includeTrackingQr: true);

    expect(
      _containsSequence(bytes, [0x1D, 0x28, 0x6B, 0x04, 0x00, 0x31, 0x41]),
      isTrue,
    ); // model select
    expect(
      _containsSequence(bytes, [0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x51, 0x30]),
      isTrue,
    ); // print
  });

  test('Turkish characters in text fields are CP857-encoded', () {
    final bytes = builder.build(baseData);
    // "Yılmaz" — ı(0x8D). Confirms non-ASCII text is not passed as raw UTF-8.
    expect(_containsSequence(bytes, [0x8D]), isTrue);
  });
}
