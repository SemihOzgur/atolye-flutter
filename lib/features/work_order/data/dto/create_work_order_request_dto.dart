import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_only_json.dart';
import 'consumable_line_dto.dart';

part 'create_work_order_request_dto.freezed.dart';
part 'create_work_order_request_dto.g.dart';

@freezed
class CreateWorkOrderRequestDto with _$CreateWorkOrderRequestDto {
  const factory CreateWorkOrderRequestDto({
    required int customerId,
    required int categoryId,
    String? brand,
    String? color,
    String? material,
    String? description,
    String? existingDamages,
    // ignore: invalid_annotation_target
    @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
    DateTime? estimatedDeliveryDate,
    @Default(<int>[]) List<int> servicePriceIds,
    @Default(<ConsumableLineDto>[]) List<ConsumableLineDto> consumables,
    required double price,
    required bool hasPrepayment,
    double? prepaymentAmount,
  }) = _CreateWorkOrderRequestDto;

  factory CreateWorkOrderRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateWorkOrderRequestDtoFromJson(json);
}
