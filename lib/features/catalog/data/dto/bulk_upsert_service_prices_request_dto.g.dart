// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_upsert_service_prices_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BulkUpsertServicePricesRequestDtoImpl
    _$$BulkUpsertServicePricesRequestDtoImplFromJson(
            Map<String, dynamic> json) =>
        _$BulkUpsertServicePricesRequestDtoImpl(
          items: (json['items'] as List<dynamic>)
              .map((e) => UpsertServicePriceRequestDto.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$$BulkUpsertServicePricesRequestDtoImplToJson(
        _$BulkUpsertServicePricesRequestDtoImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
    };
