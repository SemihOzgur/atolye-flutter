import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_service_type_request_dto.freezed.dart';
part 'create_service_type_request_dto.g.dart';

@freezed
class CreateServiceTypeRequestDto with _$CreateServiceTypeRequestDto {
  const factory CreateServiceTypeRequestDto({
    required String name,
    required int sortOrder,
  }) = _CreateServiceTypeRequestDto;

  factory CreateServiceTypeRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateServiceTypeRequestDtoFromJson(json);
}
