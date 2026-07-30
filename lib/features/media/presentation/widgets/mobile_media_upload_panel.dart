import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../cubit/media_upload_cubit.dart';
import '../cubit/media_upload_state.dart';
import '../cubit/upload_task.dart';

const _stages = <String, String>{
  'BEFORE': 'Öncesi',
  'AFTER': 'Sonrası',
  'DETAIL': 'Detay',
};

/// Mobil medya ekleme paneli — masaüstü [MediaUploadPanel] ile aynı
/// [MediaUploadCubit] hattını (classify → convert → request-upload → PUT →
/// confirm) paylaşır (Analiz §9.2/§3.1). Tek fark dosya kaynağı: masaüstünde
/// `file_picker` (yerel disk), burada kamera + galeri (`image_picker`) —
/// kullanıcı kararı gereği (bu sprint Android-only, sıkıştırma/dönüşüm yok).
class MobileMediaUploadPanel extends StatefulWidget {
  const MobileMediaUploadPanel({
    super.key,
    required this.existingMediaCount,
  });

  final int existingMediaCount;

  @override
  State<MobileMediaUploadPanel> createState() =>
      _MobileMediaUploadPanelState();
}

class _MobileMediaUploadPanelState extends State<MobileMediaUploadPanel> {
  String _selectedStage = 'BEFORE';
  final _picker = ImagePicker();

  Future<void> _enqueue(BuildContext context, List<XFile> files) async {
    if (files.isEmpty) return;
    final paths = files.map((file) => file.path).toList();
    await context.read<MediaUploadCubit>().enqueueFiles(paths, _selectedStage);
  }

  Future<void> _captureFromCamera(BuildContext context) async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file == null || !context.mounted) return;
    await _enqueue(context, [file]);
  }

  Future<void> _recordVideo(BuildContext context) async {
    final file = await _picker.pickVideo(source: ImageSource.camera);
    if (file == null || !context.mounted) return;
    await _enqueue(context, [file]);
  }

  Future<void> _pickFromGallery(
    BuildContext context,
    int remainingSlots,
  ) async {
    final files = await _picker.pickMultipleMedia();
    if (files.isEmpty || !context.mounted) return;

    var selected = files;
    if (selected.length > remainingSlots) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'İş emri başına en fazla 20 medya eklenebilir. '
            'Yalnızca ilk $remainingSlots dosya eklendi.',
          ),
        ),
      );
      selected = selected.take(remainingSlots).toList();
    }

    await _enqueue(context, selected);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaUploadCubit, MediaUploadState>(
      builder: (context, state) {
        // Kuyruktaki (hatalı olmayan) task'lar da limite dahil edilir —
        // Analiz §9.4/Risk 12: yalnızca `done` sayan sayaç, sunucu 20
        // limitine takılmadan önce kullanıcının fazla dosya seçmesine izin
        // veriyordu.
        final inFlightCount = state.tasks
            .where((task) => task.status != UploadTaskStatus.error)
            .length;
        final totalCount = widget.existingMediaCount + inFlightCount;
        final remainingSlots = 20 - totalCount;
        final canAdd = remainingSlots > 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
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
                ),
                const SizedBox(width: AppDimensions.spaceM),
                Text(
                  '$totalCount/20',
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Wrap(
              spacing: AppDimensions.spaceS,
              runSpacing: AppDimensions.spaceS,
              children: [
                OutlinedButton.icon(
                  onPressed: canAdd ? () => _captureFromCamera(context) : null,
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Fotoğraf Çek'),
                ),
                OutlinedButton.icon(
                  onPressed: canAdd ? () => _recordVideo(context) : null,
                  icon: const Icon(Icons.videocam_outlined),
                  label: const Text('Video Çek'),
                ),
                OutlinedButton.icon(
                  onPressed: canAdd
                      ? () => _pickFromGallery(context, remainingSlots)
                      : null,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Galeriden Seç'),
                ),
              ],
            ),
            if (state.tasks.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spaceM),
              ...state.tasks.map((task) => _MobileUploadTaskTile(task: task)),
            ],
          ],
        );
      },
    );
  }
}

class _MobileUploadTaskTile extends StatelessWidget {
  const _MobileUploadTaskTile({required this.task});

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
