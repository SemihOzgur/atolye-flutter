import 'package:freezed_annotation/freezed_annotation.dart';

import 'upsert_service_price_request_dto.dart';

part 'bulk_upsert_service_prices_request_dto.freezed.dart';
part 'bulk_upsert_service_prices_request_dto.g.dart';

@freezed
class BulkUpsertServicePricesRequestDto with _$BulkUpsertServicePricesRequestDto {
  const factory BulkUpsertServicePricesRequestDto({
    required List<UpsertServicePriceRequestDto> items,
  }) = _BulkUpsertServicePricesRequestDto;

  factory BulkUpsertServicePricesRequestDto.fromJson(Map<String, dynamic> json) =>
      _$BulkUpsertServicePricesRequestDtoFromJson(json);
}
