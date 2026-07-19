// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order_service_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkOrderServiceItemDtoImpl _$$WorkOrderServiceItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkOrderServiceItemDtoImpl(
      servicePriceId: (json['servicePriceId'] as num?)?.toInt(),
      serviceName: json['serviceName'] as String,
      priceSnapshot: (json['priceSnapshot'] as num).toDouble(),
    );

Map<String, dynamic> _$$WorkOrderServiceItemDtoImplToJson(
        _$WorkOrderServiceItemDtoImpl instance) =>
    <String, dynamic>{
      'servicePriceId': instance.servicePriceId,
      'serviceName': instance.serviceName,
      'priceSnapshot': instance.priceSnapshot,
    };
