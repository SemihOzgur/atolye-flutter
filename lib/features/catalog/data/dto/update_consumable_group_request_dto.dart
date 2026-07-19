import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_consumable_group_request_dto.freezed.dart';
part 'update_consumable_group_request_dto.g.dart';

@freezed
class UpdateConsumableGroupRequestDto with _$UpdateConsumableGroupRequestDto {
  const factory UpdateConsumableGroupRequestDto({
    required String name,
    required bool isActive,
  }) = _UpdateConsumableGroupRequestDto;

  factory UpdateConsumableGroupRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateConsumableGroupRequestDtoFromJson(json);
}
