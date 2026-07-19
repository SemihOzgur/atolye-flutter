// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_candidate_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArchiveCandidateDtoImpl _$$ArchiveCandidateDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ArchiveCandidateDtoImpl(
      workOrderId: (json['workOrderId'] as num).toInt(),
      orderNumber: json['orderNumber'] as String,
      status: json['status'] as String,
      closedAt: DateTime.parse(json['closedAt'] as String),
      mediaCount: (json['mediaCount'] as num).toInt(),
      totalSizeBytes: (json['totalSizeBytes'] as num).toInt(),
      hasSocialMediaConsent: json['hasSocialMediaConsent'] as bool,
    );

Map<String, dynamic> _$$ArchiveCandidateDtoImplToJson(
        _$ArchiveCandidateDtoImpl instance) =>
    <String, dynamic>{
      'workOrderId': instance.workOrderId,
      'orderNumber': instance.orderNumber,
      'status': instance.status,
      'closedAt': instance.closedAt.toIso8601String(),
      'mediaCount': instance.mediaCount,
      'totalSizeBytes': instance.totalSizeBytes,
      'hasSocialMediaConsent': instance.hasSocialMediaConsent,
    };
