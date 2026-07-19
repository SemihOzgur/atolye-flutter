// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_confirm_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArchiveConfirmRequestDtoImpl _$$ArchiveConfirmRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ArchiveConfirmRequestDtoImpl(
      verifiedMediaIds: (json['verifiedMediaIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$$ArchiveConfirmRequestDtoImplToJson(
        _$ArchiveConfirmRequestDtoImpl instance) =>
    <String, dynamic>{
      'verifiedMediaIds': instance.verifiedMediaIds,
    };
