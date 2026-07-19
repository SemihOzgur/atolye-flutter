// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order_sms_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkOrderSmsItemDtoImpl _$$WorkOrderSmsItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkOrderSmsItemDtoImpl(
      smsType: json['smsType'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$WorkOrderSmsItemDtoImplToJson(
        _$WorkOrderSmsItemDtoImpl instance) =>
    <String, dynamic>{
      'smsType': instance.smsType,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'errorMessage': instance.errorMessage,
    };
