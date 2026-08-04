import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_dto.dart';
import 'package:leather_care_admin/features/receipt_printing/domain/receipt_data.dart';
import 'package:leather_care_admin/features/work_order/data/dto/work_order_consumable_item_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/work_order_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/work_order_service_item_dto.dart';

WorkOrderDto _baseWorkOrder({
  String phone = '+905321234567',
  String? brand,
  String status = 'RECEIVED',
  List<WorkOrderServiceItemDto> services = const [],
  List<WorkOrderConsumableItemDto> consumables = const [],
  double price = 100,
  bool hasPrepayment = false,
  double? prepaymentAmount,
  double remainingAmount = 100,
}) {
  return WorkOrderDto(
    id: 1,
    orderNumber: 'WO-2026-000123',
    customer: CustomerDto(
      id: 1,
      firstName: 'Ayşe',
      lastName: 'Yılmaz',
      phone: phone,
      iysConsentStatus: 'APPROVED',
      createdAt: DateTime(2026, 1, 1),
    ),
    categoryId: 3,
    categoryPath: 'Kadın > Ayakkabı > Sneakers',
    brand: brand,
    services: services,
    consumables: consumables,
    suggestedPrice: price,
    price: price,
    hasPrepayment: hasPrepayment,
    prepaymentAmount: prepaymentAmount,
    remainingAmount: remainingAmount,
    status: status,
    socialMediaConsent: false,
    trackingUrl: 'https://dotikadbm.com/t/abc',
    createdAt: DateTime(2026, 7, 12, 10, 30),
    updatedAt: DateTime(2026, 7, 12, 10, 30),
  );
}

void main() {
  group('ReceiptData.fromWorkOrder', () {
    test('carries the order number as the barcode content', () {
      final data = ReceiptData.fromWorkOrder(
        _baseWorkOrder(),
        maskPhone: false,
        printedAt: DateTime(2026, 7, 12),
      );

      expect(data.orderNumber, 'WO-2026-000123');
    });

    test('masks the phone when maskPhone is true', () {
      final data = ReceiptData.fromWorkOrder(
        _baseWorkOrder(phone: '+905321234567'),
        maskPhone: true,
        printedAt: DateTime(2026, 7, 12),
      );

      expect(data.phone, '0532 *** ** 67');
    });

    test('keeps the raw phone when maskPhone is false', () {
      final data = ReceiptData.fromWorkOrder(
        _baseWorkOrder(phone: '+905321234567'),
        maskPhone: false,
        printedAt: DateTime(2026, 7, 12),
      );

      expect(data.phone, '+905321234567');
    });

    test('leaves null fields (e.g. brand) as null — no placeholder text', () {
      final data = ReceiptData.fromWorkOrder(
        _baseWorkOrder(brand: null),
        maskPhone: false,
        printedAt: DateTime(2026, 7, 12),
      );

      expect(data.brand, isNull);
    });

    test('maps status to the same TR label as WorkOrderStatusBadge', () {
      final data = ReceiptData.fromWorkOrder(
        _baseWorkOrder(status: 'READY'),
        maskPhone: false,
        printedAt: DateTime(2026, 7, 12),
      );

      expect(data.statusLabel, 'Hazır');
    });

    test('combines first and last name', () {
      final data = ReceiptData.fromWorkOrder(
        _baseWorkOrder(),
        maskPhone: false,
        printedAt: DateTime(2026, 7, 12),
      );

      expect(data.customerName, 'Ayşe Yılmaz');
    });

    test('maps service and consumable names, defaulting to empty lists', () {
      final withoutLines = ReceiptData.fromWorkOrder(
        _baseWorkOrder(),
        maskPhone: false,
        printedAt: DateTime(2026, 7, 12),
      );
      expect(withoutLines.serviceNames, isEmpty);
      expect(withoutLines.consumableNames, isEmpty);

      final withLines = ReceiptData.fromWorkOrder(
        _baseWorkOrder(
          services: const [
            WorkOrderServiceItemDto(serviceName: 'Boyama', priceSnapshot: 200),
          ],
          consumables: const [
            WorkOrderConsumableItemDto(
              consumableProductId: 1,
              productName: 'Deri Boya',
              quantity: 1,
              unitPriceSnapshot: 50,
              lineTotal: 50,
            ),
          ],
        ),
        maskPhone: false,
        printedAt: DateTime(2026, 7, 12),
      );
      expect(withLines.serviceNames, ['Boyama']);
      expect(withLines.consumableNames, ['Deri Boya']);
    });

    test('totalPrice mirrors price and remainingAmount mirrors server value',
        () {
      final data = ReceiptData.fromWorkOrder(
        _baseWorkOrder(price: 2400, remainingAmount: 1900),
        maskPhone: false,
        printedAt: DateTime(2026, 7, 12),
      );

      expect(data.totalPrice, 2400);
      expect(data.remainingAmount, 1900);
    });

    test('prepaymentAmount is null when hasPrepayment is false, even if '
        'the DTO carries a stale value', () {
      final data = ReceiptData.fromWorkOrder(
        _baseWorkOrder(hasPrepayment: false, prepaymentAmount: null),
        maskPhone: false,
        printedAt: DateTime(2026, 7, 12),
      );

      expect(data.prepaymentAmount, isNull);
    });

    test('prepaymentAmount is carried when hasPrepayment is true', () {
      final data = ReceiptData.fromWorkOrder(
        _baseWorkOrder(hasPrepayment: true, prepaymentAmount: 500),
        maskPhone: false,
        printedAt: DateTime(2026, 7, 12),
      );

      expect(data.prepaymentAmount, 500);
    });
  });

  group('maskPhoneNumber', () {
    test('masks an E.164 Turkish mobile number', () {
      expect(maskPhoneNumber('+905321234567'), '0532 *** ** 67');
    });

    test('masks a local-format number starting with 0', () {
      expect(maskPhoneNumber('05321234567'), '0532 *** ** 67');
    });

    test('masks a 10-digit number without leading 0', () {
      expect(maskPhoneNumber('5321234567'), '0532 *** ** 67');
    });

    test('returns the input unchanged for an unexpected length', () {
      expect(maskPhoneNumber('123'), '123');
    });
  });
}
