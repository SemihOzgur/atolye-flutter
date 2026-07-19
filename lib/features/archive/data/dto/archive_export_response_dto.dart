import 'package:freezed_annotation/freezed_annotation.dart';

import 'archive_media_item_dto.dart';

part 'archive_export_response_dto.freezed.dart';
part 'archive_export_response_dto.g.dart';

@freezed
class ArchiveExportResponseDto with _$ArchiveExportResponseDto {
  const factory ArchiveExportResponseDto({
    required int workOrderId,
    required List<ArchiveMediaItemDto> items,
  }) = _ArchiveExportResponseDto;

  factory ArchiveExportResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ArchiveExportResponseDtoFromJson(json);
}
