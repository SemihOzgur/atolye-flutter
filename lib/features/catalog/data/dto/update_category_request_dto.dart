import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_category_request_dto.freezed.dart';
part 'update_category_request_dto.g.dart';

@freezed
class UpdateCategoryRequestDto with _$UpdateCategoryRequestDto {
  const factory UpdateCategoryRequestDto({
    required String name,
    required int sortOrder,
    required bool isActive,
  }) = _UpdateCategoryRequestDto;

  factory UpdateCategoryRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateCategoryRequestDtoFromJson(json);
}
