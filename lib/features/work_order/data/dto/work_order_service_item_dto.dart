import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_order_service_item_dto.freezed.dart';
part 'work_order_service_item_dto.g.dart';

@freezed
class WorkOrderServiceItemDto with _$WorkOrderServiceItemDto {
  const factory WorkOrderServiceItemDto({
    int? servicePriceId,
    required String serviceName,
    required double priceSnapshot,
  }) = _WorkOrderServiceItemDto;

  factory WorkOrderServiceItemDto.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderServiceItemDtoFromJson(json);
}
