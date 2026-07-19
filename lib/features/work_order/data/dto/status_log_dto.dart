import 'package:freezed_annotation/freezed_annotation.dart';

part 'status_log_dto.freezed.dart';
part 'status_log_dto.g.dart';

@freezed
class StatusLogDto with _$StatusLogDto {
  const factory StatusLogDto({
    String? oldStatus,
    required String newStatus,
    required String changedBy,
    required DateTime changedAt,
  }) = _StatusLogDto;

  factory StatusLogDto.fromJson(Map<String, dynamic> json) =>
      _$StatusLogDtoFromJson(json);
}
