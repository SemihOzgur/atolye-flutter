import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_work_order_status_request_dto.freezed.dart';
part 'update_work_order_status_request_dto.g.dart';

@freezed
class UpdateWorkOrderStatusRequestDto with _$UpdateWorkOrderStatusRequestDto {
  const factory UpdateWorkOrderStatusRequestDto({
    required String newStatus,
    String? note,
  }) = _UpdateWorkOrderStatusRequestDto;

  factory UpdateWorkOrderStatusRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateWorkOrderStatusRequestDtoFromJson(json);
}
