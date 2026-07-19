import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_consumable_product_request_dto.freezed.dart';
part 'create_consumable_product_request_dto.g.dart';

@freezed
class CreateConsumableProductRequestDto with _$CreateConsumableProductRequestDto {
  const factory CreateConsumableProductRequestDto({
    required int groupId,
    String? brand,
    required String name,
    required double salePrice,
  }) = _CreateConsumableProductRequestDto;

  factory CreateConsumableProductRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateConsumableProductRequestDtoFromJson(json);
}
