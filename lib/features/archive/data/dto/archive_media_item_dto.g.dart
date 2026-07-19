// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_media_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArchiveMediaItemDtoImpl _$$ArchiveMediaItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ArchiveMediaItemDtoImpl(
      mediaId: (json['mediaId'] as num).toInt(),
      stage: json['stage'] as String,
      mediaType: json['mediaType'] as String,
      fileName: json['fileName'] as String,
      sizeBytes: (json['sizeBytes'] as num).toInt(),
      downloadUrl: json['downloadUrl'] as String,
    );

Map<String, dynamic> _$$ArchiveMediaItemDtoImplToJson(
        _$ArchiveMediaItemDtoImpl instance) =>
    <String, dynamic>{
      'mediaId': instance.mediaId,
      'stage': instance.stage,
      'mediaType': instance.mediaType,
      'fileName': instance.fileName,
      'sizeBytes': instance.sizeBytes,
      'downloadUrl': instance.downloadUrl,
    };
