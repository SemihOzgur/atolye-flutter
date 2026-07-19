// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkOrderDtoImpl _$$WorkOrderDtoImplFromJson(Map<String, dynamic> json) =>
    _$WorkOrderDtoImpl(
      id: (json['id'] as num).toInt(),
      orderNumber: json['orderNumber'] as String,
      customer: CustomerDto.fromJson(json['customer'] as Map<String, dynamic>),
      categoryId: (json['categoryId'] as num).toInt(),
      categoryPath: json['categoryPath'] as String,
      brand: json['brand'] as String?,
      color: json['color'] as String?,
      material: json['material'] as String?,
      description: json['description'] as String?,
      existingDamages: json['existingDamages'] as String?,
      estimatedDeliveryDate: json['estimatedDeliveryDate'] == null
          ? null
          : DateTime.parse(json['estimatedDeliveryDate'] as String),
      services: (json['services'] as List<dynamic>?)
              ?.map((e) =>
                  WorkOrderServiceItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WorkOrderServiceItemDto>[],
      consumables: (json['consumables'] as List<dynamic>?)
              ?.map((e) => WorkOrderConsumableItemDto.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const <WorkOrderConsumableItemDto>[],
      suggestedPrice: (json['suggestedPrice'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      hasPrepayment: json['hasPrepayment'] as bool,
      prepaymentAmount: (json['prepaymentAmount'] as num?)?.toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      status: json['status'] as String,
      socialMediaConsent: json['socialMediaConsent'] as bool,
      trackingUrl: json['trackingUrl'] as String,
      deliveredAt: json['deliveredAt'] == null
          ? null
          : DateTime.parse(json['deliveredAt'] as String),
      finalPaymentAmount: (json['finalPaymentAmount'] as num?)?.toDouble(),
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => MediaFileDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MediaFileDto>[],
      statusHistory: (json['statusHistory'] as List<dynamic>?)
              ?.map((e) => StatusLogDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <StatusLogDto>[],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      smsHistory: (json['smsHistory'] as List<dynamic>?)
              ?.map((e) =>
                  WorkOrderSmsItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WorkOrderSmsItemDto>[],
    );

Map<String, dynamic> _$$WorkOrderDtoImplToJson(_$WorkOrderDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'customer': instance.customer,
      'categoryId': instance.categoryId,
      'categoryPath': instance.categoryPath,
      'brand': instance.brand,
      'color': instance.color,
      'material': instance.material,
      'description': instance.description,
      'existingDamages': instance.existingDamages,
      'estimatedDeliveryDate':
          instance.estimatedDeliveryDate?.toIso8601String(),
      'services': instance.services,
      'consumables': instance.consumables,
      'suggestedPrice': instance.suggestedPrice,
      'price': instance.price,
      'hasPrepayment': instance.hasPrepayment,
      'prepaymentAmount': instance.prepaymentAmount,
      'remainingAmount': instance.remainingAmount,
      'status': instance.status,
      'socialMediaConsent': instance.socialMediaConsent,
      'trackingUrl': instance.trackingUrl,
      'deliveredAt': instance.deliveredAt?.toIso8601String(),
      'finalPaymentAmount': instance.finalPaymentAmount,
      'media': instance.media,
      'statusHistory': instance.statusHistory,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'smsHistory': instance.smsHistory,
    };
