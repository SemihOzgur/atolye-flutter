import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_order_sms_item_dto.freezed.dart';
part 'work_order_sms_item_dto.g.dart';

@freezed
class WorkOrderSmsItemDto with _$WorkOrderSmsItemDto {
  const factory WorkOrderSmsItemDto({
    required String smsType,
    required String status,
    required DateTime createdAt,
    String? errorMessage,
  }) = _WorkOrderSmsItemDto;

  factory WorkOrderSmsItemDto.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderSmsItemDtoFromJson(json);
}
