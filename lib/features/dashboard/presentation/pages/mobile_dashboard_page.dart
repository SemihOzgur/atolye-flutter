import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../data/dashboard_repository.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/daily_operations_card.dart';
import '../widgets/revenue_summary_card.dart';
import '../widgets/status_distribution_card.dart';
import '../widgets/summary_card.dart';

/// Mobil kabuk Dashboard'ı — mevcut [DashboardCubit]'i yeniden kullanır
/// (API mobil için yeterli). Masaüstünden farkları: ikişerli kart düzeni +
/// grafikler, `RefreshIndicator`, Disk/Arşiv kartları gizli. Finans
/// bilgileri PIN gerektirmez (yalnızca mobil) — dokunuldukça maskelenir/
/// gösterilir, oturum boyunca (sayfa açıkken) hatırlanır.
class MobileDashboardPage extends StatelessWidget {
  const MobileDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardCubit>(
      create: (_) => DashboardCubit(getIt<IDashboardRepository>())..load(),
      child: const _MobileDashboardView(),
    );
  }
}

class _MobileDashboardView extends StatefulWidget {
  const _MobileDashboardView();

  @override
  State<_MobileDashboardView> createState() => _MobileDashboardViewState();
}

class _MobileDashboardViewState extends State<_MobileDashboardView> {
  bool _financeRevealed = false;

  void _toggleFinanceReveal() {
    setState(() => _financeRevealed = !_financeRevealed);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => context.read<DashboardCubit>().load(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            child: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DashboardState state) {
    final summary = state.summary;

    if (summary == null) {
      if (state.status == DashboardStatus.error) {
        return _ErrorView(
          message: state.errorMessage ?? 'Dashboard verileri yüklenemedi.',
          onRetry: () => context.read<DashboardCubit>().load(),
        );
      }
      return const _MobileDashboardSkeleton();
    }

    final financeMasked = !_financeRevealed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('İş Durumu'),
        const SizedBox(height: AppDimensions.spaceS),
        _PairedCards(
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
        const SizedBox(height: AppDimensions.spaceM),
        StatusDistributionCard(
          receivedCount: summary.receivedCount,
          inProgressCount: summary.inProgressCount,
          readyCount: summary.readyCount,
        ),
        const SizedBox(height: AppDimensions.spaceL),
        const _SectionLabel('Bugün'),
        const SizedBox(height: AppDimensions.spaceS),
        _PairedCards(
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
        const SizedBox(height: AppDimensions.spaceM),
        DailyOperationsCard(
          receivedToday: summary.receivedTodayCount,
          deliveredToday: summary.deliveredTodayCount,
        ),
        const SizedBox(height: AppDimensions.spaceL),
        const _SectionLabel('Finans'),
        const SizedBox(height: AppDimensions.spaceS),
        _PairedCards(
          cards: [
            SummaryCard(
              label: 'Günlük Ciro',
              value: CurrencyFormatter.format(summary.dailyRevenue),
              icon: Icons.payments_outlined,
              description: 'Bugünkü toplam tahsilat',
              accentColor: AppColors.success,
              masked: financeMasked,
              onTap: _toggleFinanceReveal,
            ),
            SummaryCard(
              label: 'Aylık Ciro',
              value: CurrencyFormatter.format(summary.monthlyRevenue),
              icon: Icons.trending_up_rounded,
              description: 'Bu ayki toplam tahsilat',
              accentColor: AppColors.success,
              masked: financeMasked,
              onTap: _toggleFinanceReveal,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceM),
        RevenueSummaryCard(
          dailyRevenue: summary.dailyRevenue,
          monthlyRevenue: summary.monthlyRevenue,
          masked: financeMasked,
          onTap: _toggleFinanceReveal,
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textMuted,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }
}

/// KPI kartlarını ikişerli satırlar halinde dizer (tek tek tam genişlik
/// yerine); tek sayıda kart kalırsa son satır tam genişlik olur.
class _PairedCards extends StatelessWidget {
  const _PairedCards({required this.cards});

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < cards.length; i += 2) {
      final hasPair = i + 1 < cards.length;
      if (rows.isNotEmpty) {
        rows.add(const SizedBox(height: AppDimensions.spaceM));
      }
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: cards[i]),
            if (hasPair) ...[
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(child: cards[i + 1]),
            ],
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

class _MobileDashboardSkeleton extends StatelessWidget {
  const _MobileDashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (_) => const Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.spaceM),
          child: Row(
            children: [
              Expanded(child: SkeletonBox(width: double.infinity, height: 96)),
              SizedBox(width: AppDimensions.spaceM),
              Expanded(child: SkeletonBox(width: double.infinity, height: 96)),
            ],
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.spaceXl),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 40,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: AppDimensions.spaceM),
          ElevatedButton(onPressed: onRetry, child: const Text('Tekrar Dene')),
        ],
      ),
    );
  }
}
