// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_price_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServicePriceDtoImpl _$$ServicePriceDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ServicePriceDtoImpl(
      id: (json['id'] as num).toInt(),
      categoryId: (json['categoryId'] as num).toInt(),
      categoryPath: json['categoryPath'] as String,
      serviceTypeId: (json['serviceTypeId'] as num).toInt(),
      serviceName: json['serviceName'] as String,
      price: (json['price'] as num).toDouble(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$$ServicePriceDtoImplToJson(
        _$ServicePriceDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'categoryPath': instance.categoryPath,
      'serviceTypeId': instance.serviceTypeId,
      'serviceName': instance.serviceName,
      'price': instance.price,
      'isActive': instance.isActive,
    };
