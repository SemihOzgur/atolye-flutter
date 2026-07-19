import 'package:freezed_annotation/freezed_annotation.dart';

import 'consumable_line_dto.dart';

part 'update_work_order_request_dto.freezed.dart';
part 'update_work_order_request_dto.g.dart';

@freezed
class UpdateWorkOrderRequestDto with _$UpdateWorkOrderRequestDto {
  const factory UpdateWorkOrderRequestDto({
    String? brand,
    String? color,
    String? material,
    String? description,
    String? existingDamages,
    DateTime? estimatedDeliveryDate,
    @Default(<int>[]) List<int> servicePriceIds,
    @Default(<ConsumableLineDto>[]) List<ConsumableLineDto> consumables,
    required double price,
    required bool hasPrepayment,
    double? prepaymentAmount,
    required DateTime updatedAt,
  }) = _UpdateWorkOrderRequestDto;

  factory UpdateWorkOrderRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateWorkOrderRequestDtoFromJson(json);
}
