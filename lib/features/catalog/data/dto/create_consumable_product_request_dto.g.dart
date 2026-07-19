// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_consumable_product_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateConsumableProductRequestDtoImpl
    _$$CreateConsumableProductRequestDtoImplFromJson(
            Map<String, dynamic> json) =>
        _$CreateConsumableProductRequestDtoImpl(
          groupId: (json['groupId'] as num).toInt(),
          brand: json['brand'] as String?,
          name: json['name'] as String,
          salePrice: (json['salePrice'] as num).toDouble(),
        );

Map<String, dynamic> _$$CreateConsumableProductRequestDtoImplToJson(
        _$CreateConsumableProductRequestDtoImpl instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'brand': instance.brand,
      'name': instance.name,
      'salePrice': instance.salePrice,
    };
