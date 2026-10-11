import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/features/receipt/data/dto/create_receipt_request_dto.dart';
import 'package:leather_care_admin/features/receipt/data/dto/receipt_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/consumable_line_dto.dart';

import '../fakes/receipt_fixtures.dart';

void main() {
  test('ReceiptDto parses the backend ReceiptResponse shape', () {
    final dto = ReceiptDto.fromJson(receiptJson());

    expect(dto.receiptNumber, 'FS-2026-000042');
    expect(dto.items, hasLength(2));
    expect(dto.items.first.serviceNames, ['Bakım ve Boya']);
    expect(dto.items.first.estimatedDeliveryDate, DateTime(2026, 10, 15));
    expect(dto.items.last.brand, 'Puma');
    expect(dto.smsHistory.single.smsType, 'ORDER_RECEIVED');
    expect(dto.remainingAmount, 1200);
  });

  test('CreateReceiptRequestDto serializes nested items and date-only', () {
    final request = CreateReceiptRequestDto(
      customerId: 1,
      estimatedDeliveryDate: DateTime(2026, 10, 15),
      prepaymentAmount: 300,
      items: const [
        ReceiptItemRequestDto(
          categoryId: 9,
          brand: 'Nike',
          servicePriceIds: [3],
          consumables: [ConsumableLineDto(consumableProductId: 5, quantity: 2)],
          price: 1000,
        ),
      ],
    );

    // Dio jsonEncode ile gönderir — iç içe nesneler toJson'a gitmeli
    final json = jsonDecode(jsonEncode(request.toJson())) as Map<String, dynamic>;
    expect(json['estimatedDeliveryDate'], '2026-10-15');
    expect(json['prepaymentAmount'], 300);
    final item = (json['items'] as List).single as Map<String, dynamic>;
    expect(item['categoryId'], 9);
    expect(item['servicePriceIds'], [3]);
    expect((item['consumables'] as List).single, {
      'consumableProductId': 5,
      'quantity': 2,
    });
  });
}
