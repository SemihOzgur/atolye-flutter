import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../app/app_startup_controller.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/security/finance_lock_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../data/dashboard_repository.dart';
import '../../data/dto/dashboard_summary_dto.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/daily_operations_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/disk_usage_card.dart';
import '../widgets/overdue_ready_card.dart';
import '../widgets/pin_dialog.dart';
import '../widgets/revenue_summary_card.dart';
import '../widgets/status_distribution_card.dart';
import '../widgets/summary_card.dart';

const double _wideBreakpoint = 900;

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

  bool _isEmpty(DashboardSummaryDto summary) {
    return summary.receivedCount == 0 &&
        summary.inProgressCount == 0 &&
        summary.readyCount == 0 &&
        summary.receivedTodayCount == 0 &&
        summary.deliveredTodayCount == 0 &&
        summary.dailyRevenue == 0 &&
        summary.monthlyRevenue == 0;
  }

  Future<void> _handleUnlockTap(
    BuildContext context,
    FinanceLockController financeLock,
  ) async {
    final hasPin = await financeLock.hasPin();
    if (!context.mounted) return;
    await PinDialog.show(
      context,
      mode: hasPin ? PinDialogMode.verify : PinDialogMode.setup,
      controller: financeLock,
      onForgotPin: () => getIt<AppStartupController>().logout(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final financeLock = getIt<FinanceLockController>();

    return ListenableBuilder(
      listenable: financeLock,
      builder: (context, _) {
        return BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            final summary = state.summary;

            if (summary == null) {
              if (state.status == DashboardStatus.error) {
                return _ErrorView(
                  message:
                      state.errorMessage ?? 'Dashboard verileri yüklenemedi.',
                  onRetry: () => context.read<DashboardCubit>().load(),
                );
              }
              return const _DashboardSkeleton();
            }

            final isRefreshing = state.status == DashboardStatus.loading;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardHeader(
                    isRefreshing: isRefreshing,
                    lastUpdatedAt: state.lastUpdatedAt,
                    onRefresh: () => context.read<DashboardCubit>().load(),
                  ),
                  if (_isEmpty(summary)) ...[
                    const SizedBox(height: AppDimensions.spaceS),
                    const Text(
                      'Henüz dashboard verisi bulunmuyor. İlk iş emriniz '
                      'oluşturulduğunda burada görünmeye başlayacak.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                  const SizedBox(height: AppDimensions.spaceL),
                  _KpiGroup(
                    title: 'İş Durumu',
                    cards: [
                      SummaryCard(
                        label: 'Teslim Alınan',
                        count: summary.receivedCount,
                        icon: Icons.inventory_2_outlined,
                        description: 'Toplam açık iş',
                        accentColor: AppColors.textMuted,
                      ),
                      SummaryCard(
                        label: 'İşlemde',
                        count: summary.inProgressCount,
                        icon: Icons.settings_outlined,
                        description: 'Aktif iş emri',
                        accentColor: AppColors.primary,
                      ),
                      SummaryCard(
                        label: 'Hazır',
                        count: summary.readyCount,
                        icon: Icons.check_circle_outline_rounded,
                        description: 'Teslime hazır',
                        accentColor: AppColors.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spaceL),
                  _KpiGroup(
                    title: 'Bugün',
                    cards: [
                      SummaryCard(
                        label: 'Bugün Alınan',
                        count: summary.receivedTodayCount,
                        icon: Icons.login_rounded,
                        description: 'Bugün teslim alınan',
                        accentColor: AppColors.primary,
                      ),
                      SummaryCard(
                        label: 'Bugün Teslim',
                        count: summary.deliveredTodayCount,
                        icon: Icons.logout_rounded,
                        description: 'Bugün teslim edilen',
                        accentColor: AppColors.success,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spaceL),
                  _KpiGroup(
                    title: 'Finans',
                    cards: [
                      SummaryCard(
                        label: 'Günlük Ciro',
                        value: CurrencyFormatter.format(summary.dailyRevenue),
                        icon: Icons.payments_outlined,
                        description: 'Bugünkü toplam tahsilat',
                        accentColor: AppColors.success,
                        masked: !financeLock.isUnlocked,
                        onTap: financeLock.isUnlocked
                            ? null
                            : () => _handleUnlockTap(context, financeLock),
                      ),
                      SummaryCard(
                        label: 'Aylık Ciro',
                        value: CurrencyFormatter.format(summary.monthlyRevenue),
                        icon: Icons.trending_up_rounded,
                        description: 'Bu ayki toplam tahsilat',
                        accentColor: AppColors.success,
                        masked: !financeLock.isUnlocked,
                        onTap: financeLock.isUnlocked
                            ? null
                            : () => _handleUnlockTap(context, financeLock),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spaceL),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final statusCard = StatusDistributionCard(
                        receivedCount: summary.receivedCount,
                        inProgressCount: summary.inProgressCount,
                        readyCount: summary.readyCount,
                      );
                      final operationsCard = DailyOperationsCard(
                        receivedToday: summary.receivedTodayCount,
                        deliveredToday: summary.deliveredTodayCount,
                      );

                      if (constraints.maxWidth < _wideBreakpoint) {
                        return Column(
                          children: [
                            statusCard,
                            const SizedBox(height: AppDimensions.spaceM),
                            operationsCard,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: statusCard),
                          const SizedBox(width: AppDimensions.spaceM),
                          Expanded(flex: 2, child: operationsCard),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  RevenueSummaryCard(
                    dailyRevenue: summary.dailyRevenue,
                    monthlyRevenue: summary.monthlyRevenue,
                    masked: !financeLock.isUnlocked,
                    onTap: financeLock.isUnlocked
                        ? null
                        : () => _handleUnlockTap(context, financeLock),
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final diskCard = DiskUsageCard(
                        usageBytes: summary.diskUsageBytes,
                        isWarning: state.isDiskWarning,
                        onArchiveTap: () => context.go(AppRoutes.archive),
                      );

                      if (!state.hasOverdueReadyItems) {
                        return diskCard;
                      }

                      final overdueCard = OverdueReadyCard(
                        overdueCount: summary.readyWaitingOverdueCount,
                        onTap: () =>
                            context.go('${AppRoutes.workOrders}?status=READY'),
                      );

                      if (constraints.maxWidth < _wideBreakpoint) {
                        return Column(
                          children: [
                            overdueCard,
                            const SizedBox(height: AppDimensions.spaceM),
                            diskCard,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: overdueCard),
                          const SizedBox(width: AppDimensions.spaceM),
                          Expanded(child: diskCard),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _KpiGroup extends StatelessWidget {
  const _KpiGroup({required this.title, required this.cards});

  final String title;
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        LayoutBuilder(
          builder: (context, constraints) {
            const minCardWidth = 200.0;
            const spacing = AppDimensions.spaceM;

            final maxColumns =
                ((constraints.maxWidth + spacing) / (minCardWidth + spacing))
                    .floor();
            final columns = maxColumns.clamp(1, cards.length);
            final cardWidth =
                (constraints.maxWidth - spacing * (columns - 1)) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final card in cards)
                  SizedBox(width: cardWidth, child: card),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonBox(width: 180, height: 24),
                    SizedBox(height: AppDimensions.spaceXs),
                    SkeletonBox(width: 260, height: 14),
                  ],
                ),
              ),
              const SkeletonBox(width: 100, height: 36, borderRadius: 8),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceL),
          Wrap(
            spacing: AppDimensions.spaceM,
            runSpacing: AppDimensions.spaceM,
            children: List.generate(7, (_) => const _SummaryCardSkeleton()),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          const _SkeletonCardBlock(height: 180),
          const SizedBox(height: AppDimensions.spaceM),
          const _SkeletonCardBlock(height: 100),
          const SizedBox(height: AppDimensions.spaceM),
          const _SkeletonCardBlock(height: 90),
        ],
      ),
    );
  }
}

class _SummaryCardSkeleton extends StatelessWidget {
  const _SummaryCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDecorations.borderRadiusXl,
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SkeletonBox(width: 90, height: 14),
          SizedBox(height: AppDimensions.spaceM),
          SkeletonBox(width: 60, height: 32),
        ],
      ),
    );
  }
}

class _SkeletonCardBlock extends StatelessWidget {
  const _SkeletonCardBlock({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDecorations.borderRadiusXl,
        border: Border.all(color: AppColors.border),
      ),
      child: const Align(
        alignment: Alignment.topLeft,
        child: SkeletonBox(width: 160, height: 18),
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
          const Icon(Icons.error_outline_rounded,
              color: AppColors.error, size: 40),
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
