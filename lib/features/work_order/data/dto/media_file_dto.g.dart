// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_file_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaFileDtoImpl _$$MediaFileDtoImplFromJson(Map<String, dynamic> json) =>
    _$MediaFileDtoImpl(
      id: (json['id'] as num).toInt(),
      mediaType: json['mediaType'] as String,
      stage: json['stage'] as String,
      viewUrl: json['viewUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MediaFileDtoImplToJson(_$MediaFileDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mediaType': instance.mediaType,
      'stage': instance.stage,
      'viewUrl': instance.viewUrl,
      'createdAt': instance.createdAt.toIso8601String(),
    };
