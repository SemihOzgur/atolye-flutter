// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order_consumable_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkOrderConsumableItemDtoImpl _$$WorkOrderConsumableItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkOrderConsumableItemDtoImpl(
      consumableProductId: (json['consumableProductId'] as num).toInt(),
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPriceSnapshot: (json['unitPriceSnapshot'] as num).toDouble(),
      lineTotal: (json['lineTotal'] as num).toDouble(),
    );

Map<String, dynamic> _$$WorkOrderConsumableItemDtoImplToJson(
        _$WorkOrderConsumableItemDtoImpl instance) =>
    <String, dynamic>{
      'consumableProductId': instance.consumableProductId,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'unitPriceSnapshot': instance.unitPriceSnapshot,
      'lineTotal': instance.lineTotal,
    };
