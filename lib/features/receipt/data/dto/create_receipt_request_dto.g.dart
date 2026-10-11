// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_receipt_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateReceiptRequestDtoImpl _$$CreateReceiptRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateReceiptRequestDtoImpl(
      customerId: (json['customerId'] as num).toInt(),
      estimatedDeliveryDate:
          dateOnlyFromJson(json['estimatedDeliveryDate'] as String?),
      items: (json['items'] as List<dynamic>)
          .map((e) => ReceiptItemRequestDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      prepaymentAmount: (json['prepaymentAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CreateReceiptRequestDtoImplToJson(
        _$CreateReceiptRequestDtoImpl instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'estimatedDeliveryDate': dateOnlyToJson(instance.estimatedDeliveryDate),
      'items': instance.items,
      'prepaymentAmount': instance.prepaymentAmount,
    };

_$ReceiptItemRequestDtoImpl _$$ReceiptItemRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReceiptItemRequestDtoImpl(
      categoryId: (json['categoryId'] as num).toInt(),
      brand: json['brand'] as String?,
      color: json['color'] as String?,
      material: json['material'] as String?,
      description: json['description'] as String?,
      existingDamages: json['existingDamages'] as String?,
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
    );

Map<String, dynamic> _$$ReceiptItemRequestDtoImplToJson(
        _$ReceiptItemRequestDtoImpl instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'brand': instance.brand,
      'color': instance.color,
      'material': instance.material,
      'description': instance.description,
      'existingDamages': instance.existingDamages,
      'servicePriceIds': instance.servicePriceIds,
      'consumables': instance.consumables,
      'price': instance.price,
    };
