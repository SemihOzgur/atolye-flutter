import 'package:freezed_annotation/freezed_annotation.dart';

part 'consumable_group_dto.freezed.dart';
part 'consumable_group_dto.g.dart';

@freezed
class ConsumableGroupDto with _$ConsumableGroupDto {
  const factory ConsumableGroupDto({
    required int id,
    required String name,
    required bool isActive,
  }) = _ConsumableGroupDto;

  factory ConsumableGroupDto.fromJson(Map<String, dynamic> json) =>
      _$ConsumableGroupDtoFromJson(json);
}
