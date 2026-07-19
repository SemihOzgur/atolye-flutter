import 'package:freezed_annotation/freezed_annotation.dart';

part 'archive_candidate_dto.freezed.dart';
part 'archive_candidate_dto.g.dart';

@freezed
class ArchiveCandidateDto with _$ArchiveCandidateDto {
  const factory ArchiveCandidateDto({
    required int workOrderId,
    required String orderNumber,
    required String status,
    required DateTime closedAt,
    required int mediaCount,
    required int totalSizeBytes,
    required bool hasSocialMediaConsent,
  }) = _ArchiveCandidateDto;

  factory ArchiveCandidateDto.fromJson(Map<String, dynamic> json) =>
      _$ArchiveCandidateDtoFromJson(json);
}
