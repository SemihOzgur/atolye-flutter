import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../data/media_conversion_service.dart';
import '../../data/media_repository.dart';
import '../cubit/media_gallery_cubit.dart';
import '../cubit/media_gallery_state.dart';
import '../cubit/media_upload_cubit.dart';
import 'media_gallery_view.dart';
import 'mobile_media_upload_panel.dart';

/// Mobil detay ekranındaki medya bölümü — masaüstü [MediaSection] ile aynı
/// [MediaGalleryCubit]/[MediaUploadCubit] kompozisyonunu paylaşır (Analiz
/// §9.4). Yalnızca dosya seçim girişi ([MobileMediaUploadPanel]) ve galeri
/// grid yoğunluğu (3 sütun) mobile uyarlanmıştır.
class MobileMediaSection extends StatelessWidget {
  const MobileMediaSection({
    super.key,
    required this.workOrderId,
    required this.isOrderOpen,
  });

  final int workOrderId;
  final bool isOrderOpen;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MediaGalleryCubit>(
          create: (_) =>
              MediaGalleryCubit(getIt<IMediaRepository>(), workOrderId)..load(),
        ),
        BlocProvider<MediaUploadCubit>(
          create: (context) => MediaUploadCubit(
            getIt<IMediaRepository>(),
            getIt<IMediaConversionService>(),
            workOrderId,
          )..onUploadConfirmed = () {
              context.read<MediaGalleryCubit>().load();
            },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Medya', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppDimensions.spaceS),
          if (isOrderOpen)
            BlocBuilder<MediaGalleryCubit, MediaGalleryState>(
              builder: (context, state) {
                return MobileMediaUploadPanel(
                  existingMediaCount: state.items.length,
                );
              },
            ),
          const SizedBox(height: AppDimensions.spaceM),
          MediaGalleryView(canDelete: isOrderOpen, crossAxisCount: 3),
        ],
      ),
    );
  }
}
