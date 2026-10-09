// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_only_json.dart';
import '../../../customer/data/dto/customer_dto.dart';
import '../../../work_order/data/dto/work_order_sms_item_dto.dart';

part 'receipt_dto.freezed.dart';
part 'receipt_dto.g.dart';

/// Fiş (çok kalemli teslim alma) — backend `ReceiptResponse`. Her kalem ayrı
/// bir iş emridir; toplamlar kalemlerden sunucuda hesaplanır.
@freezed
class ReceiptDto with _$ReceiptDto {
  const factory ReceiptDto({
    required int id,
    required String receiptNumber,
    required CustomerDto customer,
    required String trackingUrl,
    required DateTime createdAt,
    required double totalPrice,
    required double prepaymentAmount,
    required double collectedAmount,
    required double remainingAmount,
    required int readyCount,
    required int activeCount,
    @Default(<ReceiptItemDto>[]) List<ReceiptItemDto> items,
    @Default(<WorkOrderSmsItemDto>[]) List<WorkOrderSmsItemDto> smsHistory,
  }) = _ReceiptDto;

  factory ReceiptDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptDtoFromJson(json);
}

@freezed
class ReceiptItemDto with _$ReceiptItemDto {
  const factory ReceiptItemDto({
    required int id,
    required String orderNumber,
    required String categoryPath,
    String? brand,
    String? color,
    String? material,
    String? description,
    String? existingDamages,
    @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
    DateTime? estimatedDeliveryDate,
    @Default(<String>[]) List<String> serviceNames,
    @Default(<String>[]) List<String> consumableNames,
    required double price,
    double? prepaymentAmount,
    double? finalPaymentAmount,
    required String status,
    required int mediaCount,
    required DateTime updatedAt,
  }) = _ReceiptItemDto;

  factory ReceiptItemDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptItemDtoFromJson(json);
}
