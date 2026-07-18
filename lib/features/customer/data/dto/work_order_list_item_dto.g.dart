// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order_list_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkOrderListItemDtoImpl _$$WorkOrderListItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkOrderListItemDtoImpl(
      id: (json['id'] as num).toInt(),
      orderNumber: json['orderNumber'] as String,
      customerFullName: json['customerFullName'] as String,
      customerPhone: json['customerPhone'] as String,
      categoryPath: json['categoryPath'] as String,
      brand: json['brand'] as String?,
      status: json['status'] as String,
      price: (json['price'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      estimatedDeliveryDate: json['estimatedDeliveryDate'] == null
          ? null
          : DateTime.parse(json['estimatedDeliveryDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$WorkOrderListItemDtoImplToJson(
        _$WorkOrderListItemDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'customerFullName': instance.customerFullName,
      'customerPhone': instance.customerPhone,
      'categoryPath': instance.categoryPath,
      'brand': instance.brand,
      'status': instance.status,
      'price': instance.price,
      'remainingAmount': instance.remainingAmount,
      'estimatedDeliveryDate':
          instance.estimatedDeliveryDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
