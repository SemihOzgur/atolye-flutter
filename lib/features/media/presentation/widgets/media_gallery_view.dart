import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/video_preview_player.dart';
import '../../../work_order/data/dto/media_file_dto.dart';
import '../cubit/media_gallery_cubit.dart';
import '../cubit/media_gallery_state.dart';

const _stageTabs = <String>['BEFORE', 'AFTER', 'DETAIL'];
const _stageLabels = <String, String>{
  'BEFORE': 'Öncesi',
  'AFTER': 'Sonrası',
  'DETAIL': 'Detay',
};

class MediaGalleryView extends StatelessWidget {
  const MediaGalleryView({super.key, required this.canDelete});

  final bool canDelete;

  Future<void> _confirmDelete(BuildContext context, MediaFileDto media) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Medyayı Sil'),
        content: const Text(
          'Bu medya kalıcı olarak silinecek. SMS zaten gönderildiyse '
          'tekrar gönderilmez. Emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final error = await context.read<MediaGalleryCubit>().delete(media.id);
      if (error != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  void _openVideo(BuildContext context, String url) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        child: SizedBox(
          width: 640,
          height: 400,
          child: VideoPreviewPlayer(url: url),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaGalleryCubit, MediaGalleryState>(
      builder: (context, state) {
        if (state.status == MediaGalleryStatus.error) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.errorMessage ?? 'Medya yüklenemedi.',
                style: const TextStyle(color: AppColors.error),
              ),
              TextButton(
                onPressed: () => context.read<MediaGalleryCubit>().load(),
                child: const Text('Tekrar Dene'),
              ),
            ],
          );
        }

        if (state.status == MediaGalleryStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return DefaultTabController(
          length: _stageTabs.length,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                isScrollable: true,
                tabs: _stageTabs
                    .map((stage) => Tab(text: _stageLabels[stage]))
                    .toList(),
              ),
              SizedBox(
                height: 220,
                child: TabBarView(
                  children: _stageTabs.map((stage) {
                    final items = state.forStage(stage);
                    if (items.isEmpty) {
                      return const Center(
                        child: Text(
                          'Bu aşamada medya yok.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(AppDimensions.spaceS),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: AppDimensions.spaceS,
                        crossAxisSpacing: AppDimensions.spaceS,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final media = items[index];
                        return _MediaTile(
                          media: media,
                          canDelete: canDelete,
                          onTapVideo: () => _openVideo(context, media.viewUrl),
                          onDelete: () => _confirmDelete(context, media),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MediaTile extends StatelessWidget {
  const _MediaTile({
    required this.media,
    required this.canDelete,
    required this.onTapVideo,
    required this.onDelete,
  });

  final MediaFileDto media;
  final bool canDelete;
  final VoidCallback onTapVideo;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isVideo = media.mediaType == 'VIDEO';

    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: isVideo ? onTapVideo : null,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: isVideo
                ? const Center(
                    child: Icon(
                      Icons.play_circle_outline_rounded,
                      size: 32,
                      color: AppColors.primary,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      media.viewUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.broken_image_outlined)),
                    ),
                  ),
          ),
        ),
        if (canDelete)
          Positioned(
            top: 2,
            right: 2,
            child: InkWell(
              onTap: onDelete,
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.error,
                child: Icon(Icons.close_rounded, size: 14, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
