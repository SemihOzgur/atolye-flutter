// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_export_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArchiveExportResponseDtoImpl _$$ArchiveExportResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ArchiveExportResponseDtoImpl(
      workOrderId: (json['workOrderId'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => ArchiveMediaItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ArchiveExportResponseDtoImplToJson(
        _$ArchiveExportResponseDtoImpl instance) =>
    <String, dynamic>{
      'workOrderId': instance.workOrderId,
      'items': instance.items,
    };
