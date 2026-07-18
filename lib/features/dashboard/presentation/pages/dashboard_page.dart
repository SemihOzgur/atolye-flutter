import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/byte_size_formatter.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/dashboard_repository.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/summary_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardCubit>(
      create: (_) => DashboardCubit(getIt<IDashboardRepository>())..load(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final summary = state.summary;

        if (summary == null) {
          if (state.status == DashboardStatus.error) {
            return _ErrorView(
              message: state.errorMessage ?? 'Panel verileri alınamadı.',
              onRetry: () => context.read<DashboardCubit>().load(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (state.lastUpdatedAt != null)
                    Text(
                      'Son güncelleme: '
                      '${DateFormat('HH:mm:ss').format(state.lastUpdatedAt!)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  const Spacer(),
                  IconButton(
                    onPressed: state.status == DashboardStatus.loading
                        ? null
                        : () => context.read<DashboardCubit>().load(),
                    tooltip: 'Yenile',
                    icon: state.status == DashboardStatus.loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceM),
              Wrap(
                spacing: AppDimensions.spaceM,
                runSpacing: AppDimensions.spaceM,
                children: [
                  SummaryCard(
                    label: 'Teslim Alınan',
                    value: '${summary.receivedCount}',
                  ),
                  SummaryCard(
                    label: 'İşlemde',
                    value: '${summary.inProgressCount}',
                  ),
                  SummaryCard(
                    label: 'Hazır',
                    value: '${summary.readyCount}',
                  ),
                  SummaryCard(
                    label: 'Bugün Alınan',
                    value: '${summary.receivedTodayCount}',
                  ),
                  SummaryCard(
                    label: 'Bugün Teslim',
                    value: '${summary.deliveredTodayCount}',
                  ),
                  SummaryCard(
                    label: 'Günlük Ciro',
                    value: CurrencyFormatter.format(summary.dailyRevenue),
                  ),
                  SummaryCard(
                    label: 'Aylık Ciro',
                    value: CurrencyFormatter.format(summary.monthlyRevenue),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceL),
              if (state.hasOverdueReadyItems) ...[
                _AlertCard(
                  message:
                      '7+ gündür teslim bekleyen: '
                      '${summary.readyWaitingOverdueCount}',
                  onTap: () =>
                      context.go('${AppRoutes.workOrders}?status=READY'),
                ),
                const SizedBox(height: AppDimensions.spaceM),
              ],
              _DiskCard(
                usageLabel: ByteSizeFormatter.formatGb(summary.diskUsageBytes),
                isWarning: state.isDiskWarning,
                onArchiveTap: () => context.go(AppRoutes.archive),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.message, required this.onTap});

  final String message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppDecorations.borderRadiusXl,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spaceM),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: AppDecorations.borderRadiusXl,
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.error),
            const SizedBox(width: AppDimensions.spaceM),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: AppColors.error),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.error),
          ],
        ),
      ),
    );
  }
}

class _DiskCard extends StatelessWidget {
  const _DiskCard({
    required this.usageLabel,
    required this.isWarning,
    required this.onArchiveTap,
  });

  final String usageLabel;
  final bool isWarning;
  final VoidCallback onArchiveTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = isWarning ? AppColors.error : AppColors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDecorations.borderRadiusXl,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(Icons.storage_rounded, color: accentColor),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Disk Kullanımı', style: Theme.of(context).textTheme.bodyMedium),
                Text(usageLabel, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
          if (isWarning)
            TextButton(
              onPressed: onArchiveTap,
              child: const Text('Arşivleme önerilir'),
            ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 40),
          const SizedBox(height: AppDimensions.spaceM),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: AppDimensions.spaceM),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tekrar Dene'),
            ),
          ),
        ],
      ),
    );
  }
}
