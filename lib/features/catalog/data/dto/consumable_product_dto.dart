import 'package:freezed_annotation/freezed_annotation.dart';

part 'consumable_product_dto.freezed.dart';
part 'consumable_product_dto.g.dart';

@freezed
class ConsumableProductDto with _$ConsumableProductDto {
  const factory ConsumableProductDto({
    required int id,
    required int groupId,
    required String groupName,
    String? brand,
    required String name,
    required String displayName,
    required double salePrice,
    required bool isActive,
  }) = _ConsumableProductDto;

  factory ConsumableProductDto.fromJson(Map<String, dynamic> json) =>
      _$ConsumableProductDtoFromJson(json);
}
