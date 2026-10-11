// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReceiptDtoImpl _$$ReceiptDtoImplFromJson(Map<String, dynamic> json) =>
    _$ReceiptDtoImpl(
      id: (json['id'] as num).toInt(),
      receiptNumber: json['receiptNumber'] as String,
      customer: CustomerDto.fromJson(json['customer'] as Map<String, dynamic>),
      trackingUrl: json['trackingUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      prepaymentAmount: (json['prepaymentAmount'] as num).toDouble(),
      collectedAmount: (json['collectedAmount'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      readyCount: (json['readyCount'] as num).toInt(),
      activeCount: (json['activeCount'] as num).toInt(),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ReceiptItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ReceiptItemDto>[],
      smsHistory: (json['smsHistory'] as List<dynamic>?)
              ?.map((e) =>
                  WorkOrderSmsItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WorkOrderSmsItemDto>[],
    );

Map<String, dynamic> _$$ReceiptDtoImplToJson(_$ReceiptDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'receiptNumber': instance.receiptNumber,
      'customer': instance.customer,
      'trackingUrl': instance.trackingUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'totalPrice': instance.totalPrice,
      'prepaymentAmount': instance.prepaymentAmount,
      'collectedAmount': instance.collectedAmount,
      'remainingAmount': instance.remainingAmount,
      'readyCount': instance.readyCount,
      'activeCount': instance.activeCount,
      'items': instance.items,
      'smsHistory': instance.smsHistory,
    };

_$ReceiptItemDtoImpl _$$ReceiptItemDtoImplFromJson(Map<String, dynamic> json) =>
    _$ReceiptItemDtoImpl(
      id: (json['id'] as num).toInt(),
      orderNumber: json['orderNumber'] as String,
      categoryPath: json['categoryPath'] as String,
      brand: json['brand'] as String?,
      color: json['color'] as String?,
      material: json['material'] as String?,
      description: json['description'] as String?,
      existingDamages: json['existingDamages'] as String?,
      estimatedDeliveryDate:
          dateOnlyFromJson(json['estimatedDeliveryDate'] as String?),
      serviceNames: (json['serviceNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      consumableNames: (json['consumableNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      price: (json['price'] as num).toDouble(),
      prepaymentAmount: (json['prepaymentAmount'] as num?)?.toDouble(),
      finalPaymentAmount: (json['finalPaymentAmount'] as num?)?.toDouble(),
      status: json['status'] as String,
      mediaCount: (json['mediaCount'] as num).toInt(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ReceiptItemDtoImplToJson(
        _$ReceiptItemDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'categoryPath': instance.categoryPath,
      'brand': instance.brand,
      'color': instance.color,
      'material': instance.material,
      'description': instance.description,
      'existingDamages': instance.existingDamages,
      'estimatedDeliveryDate': dateOnlyToJson(instance.estimatedDeliveryDate),
      'serviceNames': instance.serviceNames,
      'consumableNames': instance.consumableNames,
      'price': instance.price,
      'prepaymentAmount': instance.prepaymentAmount,
      'finalPaymentAmount': instance.finalPaymentAmount,
      'status': instance.status,
      'mediaCount': instance.mediaCount,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
