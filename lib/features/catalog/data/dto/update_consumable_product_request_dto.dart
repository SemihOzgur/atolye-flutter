import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_consumable_product_request_dto.freezed.dart';
part 'update_consumable_product_request_dto.g.dart';

@freezed
class UpdateConsumableProductRequestDto with _$UpdateConsumableProductRequestDto {
  const factory UpdateConsumableProductRequestDto({
    String? brand,
    required String name,
    required double salePrice,
    required bool isActive,
  }) = _UpdateConsumableProductRequestDto;

  factory UpdateConsumableProductRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateConsumableProductRequestDtoFromJson(json);
}
