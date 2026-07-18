import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_order_list_item_dto.freezed.dart';
part 'work_order_list_item_dto.g.dart';

@freezed
class WorkOrderListItemDto with _$WorkOrderListItemDto {
  const factory WorkOrderListItemDto({
    required int id,
    required String orderNumber,
    required String customerFullName,
    required String customerPhone,
    required String categoryPath,
    String? brand,
    required String status,
    required double price,
    required double remainingAmount,
    DateTime? estimatedDeliveryDate,
    required DateTime createdAt,
  }) = _WorkOrderListItemDto;

  factory WorkOrderListItemDto.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderListItemDtoFromJson(json);
}
