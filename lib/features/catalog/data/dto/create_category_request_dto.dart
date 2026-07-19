import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_category_request_dto.freezed.dart';
part 'create_category_request_dto.g.dart';

@freezed
class CreateCategoryRequestDto with _$CreateCategoryRequestDto {
  const factory CreateCategoryRequestDto({
    int? parentId,
    required String name,
    required int sortOrder,
  }) = _CreateCategoryRequestDto;

  factory CreateCategoryRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateCategoryRequestDtoFromJson(json);
}
