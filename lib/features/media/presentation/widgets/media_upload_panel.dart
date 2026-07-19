import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../cubit/media_upload_cubit.dart';
import '../cubit/media_upload_state.dart';
import '../cubit/upload_task.dart';

const List<String> _allowedExtensions = [
  'jpg',
  'jpeg',
  'png',
  'heic',
  'mp4',
  'mov',
];

const _stages = <String, String>{
  'BEFORE': 'Öncesi',
  'AFTER': 'Sonrası',
  'DETAIL': 'Detay',
};

class MediaUploadPanel extends StatefulWidget {
  const MediaUploadPanel({
    super.key,
    required this.existingMediaCount,
  });

  final int existingMediaCount;

  @override
  State<MediaUploadPanel> createState() => _MediaUploadPanelState();
}

class _MediaUploadPanelState extends State<MediaUploadPanel> {
  String _selectedStage = 'BEFORE';

  Future<void> _pickFiles(BuildContext context, int remainingSlots) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
    );

    if (result == null || result.paths.isEmpty) {
      return;
    }

    var paths = result.paths.whereType<String>().toList();
    if (paths.length > remainingSlots) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'İş emri başına en fazla 20 medya eklenebilir. '
              'Yalnızca ilk $remainingSlots dosya eklendi.',
            ),
          ),
        );
      }
      paths = paths.take(remainingSlots).toList();
    }

    if (context.mounted) {
      await context.read<MediaUploadCubit>().enqueueFiles(paths, _selectedStage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaUploadCubit, MediaUploadState>(
      builder: (context, state) {
        final totalCount = widget.existingMediaCount + state.completedCount;
        final remainingSlots = 20 - totalCount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedStage,
                  items: _stages.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedStage = value);
                    }
                  },
                ),
                const SizedBox(width: AppDimensions.spaceM),
                OutlinedButton.icon(
                  onPressed: remainingSlots > 0
                      ? () => _pickFiles(context, remainingSlots)
                      : null,
                  icon: const Icon(Icons.upload_file_rounded),
                  label: const Text('Dosya Seç'),
                ),
                const SizedBox(width: AppDimensions.spaceM),
                Text(
                  '$totalCount/20',
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
            if (state.tasks.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spaceM),
              ...state.tasks.map((task) => _UploadTaskTile(task: task)),
            ],
          ],
        );
      },
    );
  }
}

class _UploadTaskTile extends StatelessWidget {
  const _UploadTaskTile({required this.task});

  final UploadTask task;

  String get _statusLabel {
    switch (task.status) {
      case UploadTaskStatus.queued:
        return 'Bekliyor';
      case UploadTaskStatus.converting:
        return 'Dönüştürülüyor';
      case UploadTaskStatus.uploading:
        return 'Yükleniyor';
      case UploadTaskStatus.confirming:
        return 'Doğrulanıyor';
      case UploadTaskStatus.done:
        return 'Tamam';
      case UploadTaskStatus.error:
        return task.errorMessage ?? 'Hata';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isError = task.status == UploadTaskStatus.error;
    final isDone = task.status == UploadTaskStatus.done;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceXs),
      child: Row(
        children: [
          Icon(
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
            size: 20,
          ),
          const SizedBox(width: AppDimensions.spaceS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.fileName, overflow: TextOverflow.ellipsis),
                Text(
                  _statusLabel,
                  style: TextStyle(
                    color: isError ? AppColors.error : AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                if (task.status == UploadTaskStatus.uploading)
                  LinearProgressIndicator(value: task.progress),
              ],
            ),
          ),
          if (isError)
            TextButton(
              onPressed: () =>
                  context.read<MediaUploadCubit>().retry(task.id),
              child: const Text('Tekrar Dene'),
            ),
        ],
      ),
    );
  }
}
