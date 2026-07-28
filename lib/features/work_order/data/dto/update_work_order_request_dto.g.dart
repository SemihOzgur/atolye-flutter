// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_work_order_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateWorkOrderRequestDtoImpl _$$UpdateWorkOrderRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateWorkOrderRequestDtoImpl(
      brand: json['brand'] as String?,
      color: json['color'] as String?,
      material: json['material'] as String?,
      description: json['description'] as String?,
      existingDamages: json['existingDamages'] as String?,
      estimatedDeliveryDate:
          dateOnlyFromJson(json['estimatedDeliveryDate'] as String?),
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
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UpdateWorkOrderRequestDtoImplToJson(
        _$UpdateWorkOrderRequestDtoImpl instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'color': instance.color,
      'material': instance.material,
      'description': instance.description,
      'existingDamages': instance.existingDamages,
      'estimatedDeliveryDate': dateOnlyToJson(instance.estimatedDeliveryDate),
      'servicePriceIds': instance.servicePriceIds,
      'consumables': instance.consumables,
      'price': instance.price,
      'hasPrepayment': instance.hasPrepayment,
      'prepaymentAmount': instance.prepaymentAmount,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
