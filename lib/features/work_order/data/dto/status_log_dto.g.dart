// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_log_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatusLogDtoImpl _$$StatusLogDtoImplFromJson(Map<String, dynamic> json) =>
    _$StatusLogDtoImpl(
      oldStatus: json['oldStatus'] as String?,
      newStatus: json['newStatus'] as String,
      changedBy: json['changedBy'] as String,
      changedAt: DateTime.parse(json['changedAt'] as String),
    );

Map<String, dynamic> _$$StatusLogDtoImplToJson(_$StatusLogDtoImpl instance) =>
    <String, dynamic>{
      'oldStatus': instance.oldStatus,
      'newStatus': instance.newStatus,
      'changedBy': instance.changedBy,
      'changedAt': instance.changedAt.toIso8601String(),
    };
