import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_summary_dto.freezed.dart';
part 'dashboard_summary_dto.g.dart';

@freezed
class DashboardSummaryDto with _$DashboardSummaryDto {
  const factory DashboardSummaryDto({
    required int receivedCount,
    required int inProgressCount,
    required int readyCount,
    required int receivedTodayCount,
    required int deliveredTodayCount,
    required double dailyRevenue,
    required double monthlyRevenue,
    required int readyWaitingOverdueCount,
    required int diskUsageBytes,
  }) = _DashboardSummaryDto;

  factory DashboardSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryDtoFromJson(json);
}
