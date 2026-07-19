// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_consumable_product_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateConsumableProductRequestDtoImpl
    _$$UpdateConsumableProductRequestDtoImplFromJson(
            Map<String, dynamic> json) =>
        _$UpdateConsumableProductRequestDtoImpl(
          brand: json['brand'] as String?,
          name: json['name'] as String,
          salePrice: (json['salePrice'] as num).toDouble(),
          isActive: json['isActive'] as bool,
        );

Map<String, dynamic> _$$UpdateConsumableProductRequestDtoImplToJson(
        _$UpdateConsumableProductRequestDtoImpl instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'name': instance.name,
      'salePrice': instance.salePrice,
      'isActive': instance.isActive,
    };
