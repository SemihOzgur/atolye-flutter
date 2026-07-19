// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumable_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConsumableProductDtoImpl _$$ConsumableProductDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConsumableProductDtoImpl(
      id: (json['id'] as num).toInt(),
      groupId: (json['groupId'] as num).toInt(),
      groupName: json['groupName'] as String,
      brand: json['brand'] as String?,
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      salePrice: (json['salePrice'] as num).toDouble(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$$ConsumableProductDtoImplToJson(
        _$ConsumableProductDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'brand': instance.brand,
      'name': instance.name,
      'displayName': instance.displayName,
      'salePrice': instance.salePrice,
      'isActive': instance.isActive,
    };
