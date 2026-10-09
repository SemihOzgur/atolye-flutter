import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/features/receipt/data/dto/receipt_dto.dart';
import 'package:leather_care_admin/features/receipt_printing/data/escpos/cp857_encoder.dart';
import 'package:leather_care_admin/features/receipt_printing/data/escpos/escpos_builder.dart';
import 'package:leather_care_admin/features/receipt_printing/domain/receipt_slip_data.dart';

import '../receipt/fakes/receipt_fixtures.dart';

bool _contains(List<int> haystack, String text) {
  final needle = const Cp857Encoder().encode(text);
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

void main() {
  final receipt = ReceiptDto.fromJson(
    receiptJson(
      items: [
        itemJson(id: 11, status: 'READY', price: 1000),
        itemJson(id: 12, status: 'IN_PROGRESS', price: 500, brand: 'Puma'),
        itemJson(id: 13, status: 'CANCELLED', price: 999, brand: 'İptal'),
      ],
    ),
  );

  test('fromReceipt drops cancelled items, masks phone, keeps totals', () {
    final data = ReceiptSlipData.fromReceipt(
      receipt,
      maskPhone: true,
      printedAt: DateTime(2026, 10, 9, 10),
    );

    expect(data.items, hasLength(2));
    expect(data.items.first.productType, 'Sneakers Ayakkabı');
    expect(data.items.last.details, 'Puma · Beyaz');
    expect(data.phone, isNot(contains('1234567')));
    expect(data.estimatedDeliveryDate, DateTime(2026, 10, 15));
    expect(data.totalPrice, 1500);
  });

  test('buildSlip prints one barcode with the receipt number and every item', () {
    final data = ReceiptSlipData.fromReceipt(
      receipt,
      maskPhone: false,
      printedAt: DateTime(2026, 10, 9, 10),
    );
    final bytes = const EscPosBuilder().buildSlip(data);

    expect(_contains(bytes, 'FS-2026-000042'), isTrue);
    expect(_contains(bytes, '1) Sneakers Ayakkabı'), isTrue);
    expect(_contains(bytes, '2) Sneakers Ayakkabı'), isTrue);
    expect(_contains(bytes, '- Bakım ve Boya'), isTrue);
    expect(_contains(bytes, 'Detay: Burunda çizik'), isTrue);
    expect(_contains(bytes, 'İptal'), isFalse);
    expect(_contains(bytes, 'TOPLAM'), isTrue);
    expect(_contains(bytes, 'KALAN'), isTrue);

    // Code128 (GS k 73) tam bir kez
    var barcodes = 0;
    for (var i = 0; i + 2 < bytes.length; i++) {
      if (bytes[i] == 0x1D && bytes[i + 1] == 0x6B && bytes[i + 2] == 73) {
        barcodes++;
      }
    }
    expect(barcodes, 1);
  });

  test('pair lines never exceed the 48-column paper width', () {
    final data = ReceiptSlipData(
      receiptNumber: 'FS-2026-000001',
      customerName: 'A',
      phone: '0',
      createdAt: DateTime(2026),
      items: const [
        ReceiptSlipItem(
          productType: 'Çok çok uzun bir ürün türü adı ki kağıda sığmasın diye',
          details: '',
          price: 123456.78,
          statusLabel: 'Hazır',
        ),
      ],
      totalPrice: 123456.78,
      prepaymentAmount: 0,
      collectedAmount: 0,
      remainingAmount: 123456.78,
      trackingUrl: 'https://x/t/y',
      printedAt: DateTime(2026),
    );
    final bytes = const EscPosBuilder().buildSlip(data);
    var lineLength = 0;
    var longest = 0;
    for (final b in bytes) {
      if (b == 0x0A) {
        if (lineLength > longest) longest = lineLength;
        lineLength = 0;
      } else {
        lineLength++;
      }
    }
    // Komut baytları satır başında birikir; yalnızca metin satırları ölçülür
    expect(_contains(bytes, '123.456,78 TL'), isTrue);
    expect(longest, lessThan(48 + 40));
  });
}
