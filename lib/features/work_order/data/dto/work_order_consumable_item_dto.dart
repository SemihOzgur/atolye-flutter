import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_order_consumable_item_dto.freezed.dart';
part 'work_order_consumable_item_dto.g.dart';

@freezed
class WorkOrderConsumableItemDto with _$WorkOrderConsumableItemDto {
  const factory WorkOrderConsumableItemDto({
    required int consumableProductId,
    required String productName,
    required int quantity,
    required double unitPriceSnapshot,
    required double lineTotal,
  }) = _WorkOrderConsumableItemDto;

  factory WorkOrderConsumableItemDto.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderConsumableItemDtoFromJson(json);
}
