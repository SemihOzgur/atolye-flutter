import 'package:freezed_annotation/freezed_annotation.dart';

part 'archive_confirm_request_dto.freezed.dart';
part 'archive_confirm_request_dto.g.dart';

@freezed
class ArchiveConfirmRequestDto with _$ArchiveConfirmRequestDto {
  const factory ArchiveConfirmRequestDto({
    required List<int> verifiedMediaIds,
  }) = _ArchiveConfirmRequestDto;

  factory ArchiveConfirmRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ArchiveConfirmRequestDtoFromJson(json);
}
