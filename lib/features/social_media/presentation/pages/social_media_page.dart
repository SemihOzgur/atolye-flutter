import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/video_preview_player.dart';
import '../../../work_order/data/dto/media_file_dto.dart';
import '../../data/dto/social_media_item_dto.dart';
import '../../data/social_media_repository.dart';
import '../cubit/social_media_cubit.dart';
import '../cubit/social_media_state.dart';

class SocialMediaPage extends StatelessWidget {
  const SocialMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SocialMediaCubit>(
      create: (_) =>
          SocialMediaCubit(getIt<ISocialMediaRepository>())..load(),
      child: const _SocialMediaView(),
    );
  }
}

class _SocialMediaView extends StatelessWidget {
  const _SocialMediaView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sosyal Medya', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppDimensions.spaceL),
        Expanded(
          child: BlocBuilder<SocialMediaCubit, SocialMediaState>(
            builder: (context, state) {
              if (state.status == SocialMediaStatus.error) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.errorMessage ?? 'İçerik yüklenemedi.',
                        style: const TextStyle(color: AppColors.error),
                      ),
                      const SizedBox(height: AppDimensions.spaceM),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<SocialMediaCubit>().load(),
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                );
              }

              if (state.status == SocialMediaStatus.loading &&
                  state.items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.items.isEmpty) {
                return const Center(
                  child: Text('İzin vermiş müşteri içeriği yok.'),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppDimensions.spaceM),
                      itemBuilder: (context, index) =>
                          _SocialMediaItemCard(item: state.items[index]),
                    ),
                  ),
                  if (state.totalCount > state.pageSize) ...[
                    const SizedBox(height: AppDimensions.spaceS),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: state.hasPreviousPage
                              ? () => context
                                  .read<SocialMediaCubit>()
                                  .load(page: state.page - 1)
                              : null,
                          icon: const Icon(Icons.chevron_left_rounded),
                        ),
                        Text('Sayfa ${state.page}'),
                        IconButton(
                          onPressed: state.hasNextPage
                              ? () => context
                                  .read<SocialMediaCubit>()
                                  .load(page: state.page + 1)
                              : null,
                          icon: const Icon(Icons.chevron_right_rounded),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SocialMediaItemCard extends StatelessWidget {
  const _SocialMediaItemCard({required this.item});

  final SocialMediaItemDto item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () =>
                  context.go('${AppRoutes.workOrders}/${item.workOrderId}'),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.orderNumber,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '${item.categoryPath}'
                          '${item.brand != null ? ' · ${item.brand}' : ''}',
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            _MediaStrip(label: 'Öncesi', media: item.beforeMedia),
            const SizedBox(height: AppDimensions.spaceS),
            _MediaStrip(label: 'Sonrası', media: item.afterMedia),
          ],
        ),
      ),
    );
  }
}

class _MediaStrip extends StatelessWidget {
  const _MediaStrip({required this.label, required this.media});

  final String label;
  final List<MediaFileDto> media;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXxs),
        if (media.isEmpty)
          const Text(
            'Medya yok.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          )
        else
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: media.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppDimensions.spaceS),
              itemBuilder: (context, index) =>
                  _MediaThumbnail(media: media[index]),
            ),
          ),
      ],
    );
  }
}

class _MediaThumbnail extends StatelessWidget {
  const _MediaThumbnail({required this.media});

  final MediaFileDto media;

  bool get _isVideo => media.mediaType == 'VIDEO';

  void _openPreview(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        child: SizedBox(
          width: 640,
          height: 400,
          child: _isVideo
              ? VideoPreviewPlayer(url: media.viewUrl)
              : Image.network(
                  media.viewUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image_outlined)),
                ),
        ),
      ),
    );
  }

  Future<void> _download(BuildContext context) async {
    final extension = _isVideo ? 'mp4' : 'jpg';
    final savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Medyayı Kaydet',
      fileName: 'media_${media.id}.$extension',
    );

    if (savePath == null || !context.mounted) {
      return;
    }

    final error = await context
        .read<SocialMediaCubit>()
        .downloadMedia(media.viewUrl, savePath);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? 'İndirildi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 88,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            key: ValueKey('media-thumbnail-${media.id}'),
            onTap: () => _openPreview(context),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isVideo
                  ? const Center(
                      child: Icon(
                        Icons.play_circle_outline_rounded,
                        size: 28,
                        color: AppColors.primary,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        media.viewUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: InkWell(
              onTap: () => _download(context),
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.download_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
