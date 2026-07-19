import 'package:freezed_annotation/freezed_annotation.dart';

part 'deliver_work_order_request_dto.freezed.dart';
part 'deliver_work_order_request_dto.g.dart';

@freezed
class DeliverWorkOrderRequestDto with _$DeliverWorkOrderRequestDto {
  const factory DeliverWorkOrderRequestDto({
    required double finalPaymentAmount,
  }) = _DeliverWorkOrderRequestDto;

  factory DeliverWorkOrderRequestDto.fromJson(Map<String, dynamic> json) =>
      _$DeliverWorkOrderRequestDtoFromJson(json);
}
