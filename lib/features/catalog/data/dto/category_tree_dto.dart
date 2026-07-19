import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_tree_dto.freezed.dart';
part 'category_tree_dto.g.dart';

@freezed
class CategoryTreeDto with _$CategoryTreeDto {
  const factory CategoryTreeDto({
    required int id,
    required String name,
    required int level,
    required bool isActive,
    @Default(<CategoryTreeDto>[]) List<CategoryTreeDto> children,
  }) = _CategoryTreeDto;

  factory CategoryTreeDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryTreeDtoFromJson(json);
}
