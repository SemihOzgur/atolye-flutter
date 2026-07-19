// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_media_upload_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestMediaUploadResponseDtoImpl
    _$$RequestMediaUploadResponseDtoImplFromJson(Map<String, dynamic> json) =>
        _$RequestMediaUploadResponseDtoImpl(
          mediaFileId: (json['mediaFileId'] as num).toInt(),
          uploadUrl: json['uploadUrl'] as String,
          expiresAt: DateTime.parse(json['expiresAt'] as String),
        );

Map<String, dynamic> _$$RequestMediaUploadResponseDtoImplToJson(
        _$RequestMediaUploadResponseDtoImpl instance) =>
    <String, dynamic>{
      'mediaFileId': instance.mediaFileId,
      'uploadUrl': instance.uploadUrl,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };
