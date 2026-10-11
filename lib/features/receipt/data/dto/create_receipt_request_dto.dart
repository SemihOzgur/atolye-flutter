// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_only_json.dart';
import '../../../work_order/data/dto/consumable_line_dto.dart';

part 'create_receipt_request_dto.freezed.dart';
part 'create_receipt_request_dto.g.dart';

/// POST /api/receipts — kapora fiş toplamı üzerinden girilir (null = yok);
/// tahmini teslim tüm kalemlere uygulanır.
@freezed
class CreateReceiptRequestDto with _$CreateReceiptRequestDto {
  const factory CreateReceiptRequestDto({
    required int customerId,
    @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
    DateTime? estimatedDeliveryDate,
    required List<ReceiptItemRequestDto> items,
    double? prepaymentAmount,
  }) = _CreateReceiptRequestDto;

  factory CreateReceiptRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateReceiptRequestDtoFromJson(json);
}

@freezed
class ReceiptItemRequestDto with _$ReceiptItemRequestDto {
  const factory ReceiptItemRequestDto({
    required int categoryId,
    String? brand,
    String? color,
    String? material,
    String? description,
    String? existingDamages,
    @Default(<int>[]) List<int> servicePriceIds,
    @Default(<ConsumableLineDto>[]) List<ConsumableLineDto> consumables,
    required double price,
  }) = _ReceiptItemRequestDto;

  factory ReceiptItemRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptItemRequestDtoFromJson(json);
}
