import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../data/backup_repository.dart';
import '../cubit/backup_cubit.dart';
import '../cubit/backup_state.dart';

class BackupSection extends StatelessWidget {
  const BackupSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BackupCubit>(
      create: (_) => BackupCubit(getIt<IBackupRepository>()),
      child: const _BackupSectionView(),
    );
  }
}

class _BackupSectionView extends StatelessWidget {
  const _BackupSectionView();

  Future<void> _download(BuildContext context) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Veritabanı Yedeğini Kaydet',
      fileName: 'db-$today.sql.gz',
    );

    if (savePath == null || !context.mounted) {
      return;
    }

    await context.read<BackupCubit>().download(savePath);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Veritabanı Yedeği',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppDimensions.spaceXs),
            const Text(
              'Haftada bir indirilmesi önerilir.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            BlocBuilder<BackupCubit, BackupState>(
              builder: (context, state) {
                final isDownloading =
                    state.status == BackupDownloadStatus.downloading;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: isDownloading ? null : () => _download(context),
                      icon: const Icon(Icons.cloud_download_rounded),
                      label: const Text('Son Veritabanı Yedeğini İndir'),
                    ),
                    if (isDownloading) ...[
                      const SizedBox(height: AppDimensions.spaceS),
                      LinearProgressIndicator(value: state.progress),
                    ],
                    if (state.status == BackupDownloadStatus.done) ...[
                      const SizedBox(height: AppDimensions.spaceS),
                      Text(
                        'İndirildi: ${state.fileName}\n${state.savedPath}',
                        style: const TextStyle(color: AppColors.success),
                      ),
                    ],
                    if (state.status == BackupDownloadStatus.error) ...[
                      const SizedBox(height: AppDimensions.spaceS),
                      Text(
                        state.errorMessage ?? 'İndirme başarısız oldu.',
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
