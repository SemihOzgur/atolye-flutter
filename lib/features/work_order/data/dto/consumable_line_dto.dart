import 'package:freezed_annotation/freezed_annotation.dart';

part 'consumable_line_dto.freezed.dart';
part 'consumable_line_dto.g.dart';

@freezed
class ConsumableLineDto with _$ConsumableLineDto {
  const factory ConsumableLineDto({
    required int consumableProductId,
    required int quantity,
  }) = _ConsumableLineDto;

  factory ConsumableLineDto.fromJson(Map<String, dynamic> json) =>
      _$ConsumableLineDtoFromJson(json);
}
