import 'package:freezed_annotation/freezed_annotation.dart';

part 'upsert_service_price_request_dto.freezed.dart';
part 'upsert_service_price_request_dto.g.dart';

@freezed
class UpsertServicePriceRequestDto with _$UpsertServicePriceRequestDto {
  const factory UpsertServicePriceRequestDto({
    required int categoryId,
    required int serviceTypeId,
    required double price,
    required bool isActive,
  }) = _UpsertServicePriceRequestDto;

  factory UpsertServicePriceRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpsertServicePriceRequestDtoFromJson(json);
}
