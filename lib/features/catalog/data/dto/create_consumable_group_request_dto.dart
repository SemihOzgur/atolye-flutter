import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_consumable_group_request_dto.freezed.dart';
part 'create_consumable_group_request_dto.g.dart';

@freezed
class CreateConsumableGroupRequestDto with _$CreateConsumableGroupRequestDto {
  const factory CreateConsumableGroupRequestDto({
    required String name,
  }) = _CreateConsumableGroupRequestDto;

  factory CreateConsumableGroupRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateConsumableGroupRequestDtoFromJson(json);
}
