// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_work_order_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateWorkOrderRequestDtoImpl _$$CreateWorkOrderRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateWorkOrderRequestDtoImpl(
      customerId: (json['customerId'] as num).toInt(),
      categoryId: (json['categoryId'] as num).toInt(),
      brand: json['brand'] as String?,
      color: json['color'] as String?,
      material: json['material'] as String?,
      description: json['description'] as String?,
      existingDamages: json['existingDamages'] as String?,
      estimatedDeliveryDate: json['estimatedDeliveryDate'] == null
          ? null
          : DateTime.parse(json['estimatedDeliveryDate'] as String),
      servicePriceIds: (json['servicePriceIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      consumables: (json['consumables'] as List<dynamic>?)
              ?.map(
                  (e) => ConsumableLineDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ConsumableLineDto>[],
      price: (json['price'] as num).toDouble(),
      hasPrepayment: json['hasPrepayment'] as bool,
      prepaymentAmount: (json['prepaymentAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CreateWorkOrderRequestDtoImplToJson(
        _$CreateWorkOrderRequestDtoImpl instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'categoryId': instance.categoryId,
      'brand': instance.brand,
      'color': instance.color,
      'material': instance.material,
      'description': instance.description,
      'existingDamages': instance.existingDamages,
      'estimatedDeliveryDate':
          instance.estimatedDeliveryDate?.toIso8601String(),
      'servicePriceIds': instance.servicePriceIds,
      'consumables': instance.consumables,
      'price': instance.price,
      'hasPrepayment': instance.hasPrepayment,
      'prepaymentAmount': instance.prepaymentAmount,
    };
