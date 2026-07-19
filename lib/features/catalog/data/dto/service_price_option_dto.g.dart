// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_price_option_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServicePriceOptionDtoImpl _$$ServicePriceOptionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ServicePriceOptionDtoImpl(
      servicePriceId: (json['servicePriceId'] as num).toInt(),
      serviceName: json['serviceName'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$$ServicePriceOptionDtoImplToJson(
        _$ServicePriceOptionDtoImpl instance) =>
    <String, dynamic>{
      'servicePriceId': instance.servicePriceId,
      'serviceName': instance.serviceName,
      'price': instance.price,
    };
