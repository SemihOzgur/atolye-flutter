import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../customer/data/dto/customer_dto.dart';
import 'media_file_dto.dart';
import 'status_log_dto.dart';
import 'work_order_consumable_item_dto.dart';
import 'work_order_service_item_dto.dart';
import 'work_order_sms_item_dto.dart';

part 'work_order_dto.freezed.dart';
part 'work_order_dto.g.dart';

@freezed
class WorkOrderDto with _$WorkOrderDto {
  const factory WorkOrderDto({
    required int id,
    required String orderNumber,
    required CustomerDto customer,
    required int categoryId,
    required String categoryPath,
    String? brand,
    String? color,
    String? material,
    String? description,
    String? existingDamages,
    DateTime? estimatedDeliveryDate,
    @Default(<WorkOrderServiceItemDto>[])
    List<WorkOrderServiceItemDto> services,
    @Default(<WorkOrderConsumableItemDto>[])
    List<WorkOrderConsumableItemDto> consumables,
    required double suggestedPrice,
    required double price,
    required bool hasPrepayment,
    double? prepaymentAmount,
    required double remainingAmount,
    required String status,
    required bool socialMediaConsent,
    required String trackingUrl,
    DateTime? deliveredAt,
    double? finalPaymentAmount,
    @Default(<MediaFileDto>[]) List<MediaFileDto> media,
    @Default(<StatusLogDto>[]) List<StatusLogDto> statusHistory,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(<WorkOrderSmsItemDto>[]) List<WorkOrderSmsItemDto> smsHistory,
  }) = _WorkOrderDto;

  factory WorkOrderDto.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderDtoFromJson(json);
}
