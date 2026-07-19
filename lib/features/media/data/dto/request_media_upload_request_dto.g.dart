// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_media_upload_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestMediaUploadRequestDtoImpl _$$RequestMediaUploadRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$RequestMediaUploadRequestDtoImpl(
      mediaType: json['mediaType'] as String,
      stage: json['stage'] as String,
      fileName: json['fileName'] as String,
      mimeType: json['mimeType'] as String,
      sizeBytes: (json['sizeBytes'] as num).toInt(),
    );

Map<String, dynamic> _$$RequestMediaUploadRequestDtoImplToJson(
        _$RequestMediaUploadRequestDtoImpl instance) =>
    <String, dynamic>{
      'mediaType': instance.mediaType,
      'stage': instance.stage,
      'fileName': instance.fileName,
      'mimeType': instance.mimeType,
      'sizeBytes': instance.sizeBytes,
    };
