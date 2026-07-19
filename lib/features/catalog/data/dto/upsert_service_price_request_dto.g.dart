// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_service_price_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpsertServicePriceRequestDtoImpl _$$UpsertServicePriceRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UpsertServicePriceRequestDtoImpl(
      categoryId: (json['categoryId'] as num).toInt(),
      serviceTypeId: (json['serviceTypeId'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$$UpsertServicePriceRequestDtoImplToJson(
        _$UpsertServicePriceRequestDtoImpl instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'serviceTypeId': instance.serviceTypeId,
      'price': instance.price,
      'isActive': instance.isActive,
    };
