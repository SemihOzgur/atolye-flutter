import '../../data/dto/dashboard_summary_dto.dart';

enum DashboardStatus { loading, loaded, error }

class DashboardState {
  const DashboardState({
    this.status = DashboardStatus.loading,
    this.summary,
    this.errorMessage,
    this.lastUpdatedAt,
  });

  static const int diskWarningThresholdBytes = 100 * 1024 * 1024 * 1024;

  final DashboardStatus status;
  final DashboardSummaryDto? summary;
  final String? errorMessage;
  final DateTime? lastUpdatedAt;

  bool get isDiskWarning =>
      (summary?.diskUsageBytes ?? 0) > diskWarningThresholdBytes;

  bool get hasOverdueReadyItems => (summary?.readyWaitingOverdueCount ?? 0) > 0;
}
