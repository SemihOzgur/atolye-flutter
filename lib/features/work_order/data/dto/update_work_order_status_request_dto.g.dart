// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_work_order_status_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateWorkOrderStatusRequestDtoImpl
    _$$UpdateWorkOrderStatusRequestDtoImplFromJson(Map<String, dynamic> json) =>
        _$UpdateWorkOrderStatusRequestDtoImpl(
          newStatus: json['newStatus'] as String,
          note: json['note'] as String?,
        );

Map<String, dynamic> _$$UpdateWorkOrderStatusRequestDtoImplToJson(
        _$UpdateWorkOrderStatusRequestDtoImpl instance) =>
    <String, dynamic>{
      'newStatus': instance.newStatus,
      'note': instance.note,
    };
