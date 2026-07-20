import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/byte_size_formatter.dart';
import '../../../../core/widgets/skeleton_list_tile.dart';
import '../../../backup/presentation/widgets/backup_section.dart';
import '../../data/archive_integrity_checker.dart';
import '../../data/archive_repository.dart';
import '../../data/dto/archive_candidate_dto.dart';
import '../cubit/archive_cubit.dart';
import '../cubit/archive_state.dart';
import '../cubit/archive_task.dart';

const _statusLabels = <String, String>{
  'DELIVERED': 'Teslim Edildi',
  'CANCELLED': 'İptal',
};

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArchiveCubit>(
      create: (_) => ArchiveCubit(
        getIt<IArchiveRepository>(),
        ArchiveIntegrityChecker(),
      )..loadCandidates(),
      child: const _ArchiveView(),
    );
  }
}

class _ArchiveView extends StatefulWidget {
  const _ArchiveView();

  @override
  State<_ArchiveView> createState() => _ArchiveViewState();
}

class _ArchiveViewState extends State<_ArchiveView> {
  final _daysController = TextEditingController(text: '90');

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  Future<void> _pickTargetFolder(BuildContext context) async {
    final path = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Arşiv Klasörünü Seç',
    );
    if (path != null && context.mounted) {
      context.read<ArchiveCubit>().setTargetRoot(path);
    }
  }

  Future<void> _confirmAndArchive(
    BuildContext context,
    ArchiveState state,
  ) async {
    final selectedMediaCount = state.candidates
        .where((c) => state.selectedWorkOrderIds.contains(c.workOrderId))
        .fold<int>(0, (sum, c) => sum + c.mediaCount);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Arşivle'),
        content: Text(
          'Doğrulanan $selectedMediaCount medya sunucudan KALICI olarak '
          'silinecek. Devam edilsin mi?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Devam Et'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<ArchiveCubit>().archiveSelected();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Arşiv & Yedek',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppDimensions.spaceM),
          const Text(
            'Arşiv indirildikten sonra bu dosyaların tek kopyası şirket '
            'bilgisayarındadır. Harici disk / ikinci kopya önerilir.',
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          const BackupSection(),
          const SizedBox(height: AppDimensions.spaceL),
          Text('Medya Arşivi', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppDimensions.spaceM),
          Row(
            children: [
              SizedBox(
                width: 180,
                child: TextField(
                  controller: _daysController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Gün eşiği (olderThanDays)',
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              ElevatedButton(
                onPressed: () {
                  final days = int.tryParse(_daysController.text) ?? 90;
                  context.read<ArchiveCubit>().loadCandidates(
                        olderThanDays: days,
                      );
                },
                child: const Text('Adayları Listele'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceM),
          BlocBuilder<ArchiveCubit, ArchiveState>(
            builder: (context, state) {
              return Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _pickTargetFolder(context),
                    icon: const Icon(Icons.folder_open_rounded),
                    label: Text(
                      state.targetRootPath == null
                          ? 'Hedef Klasör Seç'
                          : 'Klasör: ${state.targetRootPath}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  ElevatedButton(
                    onPressed: state.canArchive
                        ? () => _confirmAndArchive(context, state)
                        : null,
                    child: state.isArchiving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Arşivle'),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppDimensions.spaceL),
          BlocBuilder<ArchiveCubit, ArchiveState>(
            builder: (context, state) {
              if (state.listStatus == ArchiveListStatus.error) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.errorMessage ?? 'Adaylar yüklenemedi.',
                        style: const TextStyle(color: AppColors.error),
                      ),
                      const SizedBox(height: AppDimensions.spaceM),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<ArchiveCubit>().loadCandidates(),
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                );
              }

              if (state.listStatus == ArchiveListStatus.loading) {
                return const SkeletonList(count: 4);
              }

              if (state.candidates.isEmpty) {
                return const Center(
                  child: Text('Arşivlenebilir iş emri yok.'),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...state.candidates.map(
                    (candidate) => _CandidateRow(
                      candidate: candidate,
                      selected: state.selectedWorkOrderIds
                          .contains(candidate.workOrderId),
                      onToggle: state.isArchiving
                          ? null
                          : () => context
                              .read<ArchiveCubit>()
                              .toggleSelection(candidate.workOrderId),
                    ),
                  ),
                  if (state.tasks.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.spaceL),
                    Text(
                      'Arşivleme Sonuçları',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppDimensions.spaceS),
                    ...state.tasks.map((task) => _TaskTile(task: task)),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CandidateRow extends StatelessWidget {
  const _CandidateRow({
    required this.candidate,
    required this.selected,
    required this.onToggle,
  });

  final ArchiveCandidateDto candidate;
  final bool selected;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        value: selected,
        onChanged: onToggle == null ? null : (_) => onToggle!(),
        title: Row(
          children: [
            Text(candidate.orderNumber),
            const SizedBox(width: AppDimensions.spaceS),
            Text(
              _statusLabels[candidate.status] ?? candidate.status,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            if (candidate.hasSocialMediaConsent) ...[
              const SizedBox(width: AppDimensions.spaceS),
              const Tooltip(
                message:
                    'Bu iş sosyal medya listesinde görünüyor; arşivlenince '
                    'oradan da düşer.',
                child: Icon(
                  Icons.campaign_rounded,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          'Kapanış: ${DateFormat('dd.MM.yyyy').format(candidate.closedAt.toLocal())} · '
          '${candidate.mediaCount} medya · '
          '${ByteSizeFormatter.format(candidate.totalSizeBytes)}',
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task});

  final ArchiveTask task;

  String get _statusLabel {
    switch (task.status) {
      case ArchiveTaskStatus.queued:
        return 'Bekliyor';
      case ArchiveTaskStatus.exporting:
        return 'Medya listesi alınıyor';
      case ArchiveTaskStatus.downloading:
        return 'İndiriliyor: ${task.currentFileName ?? ''}';
      case ArchiveTaskStatus.confirming:
        return 'Sunucuya bildiriliyor';
      case ArchiveTaskStatus.done:
        return task.resultSummary ?? 'Tamamlandı';
      case ArchiveTaskStatus.error:
        return task.errorMessage ?? 'Hata';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == ArchiveTaskStatus.done;
    final isError = task.status == ArchiveTaskStatus.error;

    return Card(
      child: ListTile(
        leading: Icon(
          isDone
              ? Icons.check_circle_rounded
              : isError
                  ? Icons.error_outline_rounded
                  : Icons.hourglass_top_rounded,
          color: isDone
              ? AppColors.success
              : isError
                  ? AppColors.error
                  : AppColors.primary,
        ),
        title: Text(task.orderNumber),
        subtitle: Text(
          _statusLabel,
          style: TextStyle(color: isError ? AppColors.error : null),
        ),
      ),
    );
  }
}
