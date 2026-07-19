import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_service_type_request_dto.freezed.dart';
part 'update_service_type_request_dto.g.dart';

@freezed
class UpdateServiceTypeRequestDto with _$UpdateServiceTypeRequestDto {
  const factory UpdateServiceTypeRequestDto({
    required String name,
    required int sortOrder,
    required bool isActive,
  }) = _UpdateServiceTypeRequestDto;

  factory UpdateServiceTypeRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateServiceTypeRequestDtoFromJson(json);
}
