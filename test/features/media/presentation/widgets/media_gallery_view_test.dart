import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/core/widgets/skeleton_box.dart';
import 'package:leather_care_admin/features/media/presentation/cubit/media_gallery_cubit.dart';
import 'package:leather_care_admin/features/media/presentation/widgets/media_gallery_view.dart';
import 'package:leather_care_admin/features/work_order/data/dto/media_file_dto.dart';

import '../../fakes/fake_media_repository.dart';

void main() {
  late FakeMediaRepository repository;
  late MediaGalleryCubit cubit;

  setUp(() {
    repository = FakeMediaRepository();
    cubit = MediaGalleryCubit(repository, 7);
  });

  MediaFileDto buildMedia({
    required int id,
    required String stage,
    String mediaType = 'PHOTO',
  }) {
    return MediaFileDto(
      id: id,
      mediaType: mediaType,
      stage: stage,
      viewUrl: 'https://minio.local/view/$id',
      createdAt: DateTime(2026, 1, 1),
    );
  }

  Widget buildSubject({bool canDelete = true}) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: BlocProvider<MediaGalleryCubit>.value(
          value: cubit,
          child: MediaGalleryView(canDelete: canDelete),
        ),
      ),
    );
  }

  testWidgets('shows a skeleton loader before the first load resolves', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    expect(find.byType(SkeletonBox), findsWidgets);
  });

  testWidgets('shows the error message and a retry button on failure', (
    tester,
  ) async {
    repository.exceptionToThrow = ApiException(
      message: 'Internal Server Error',
      detail: 'Medya listesi alınamadı.',
      statusCode: 500,
    );
    await cubit.load();

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Medya listesi alınamadı.'), findsOneWidget);
    expect(find.text('Tekrar Dene'), findsOneWidget);
  });

  testWidgets('shows tabs and an empty-state message for a stage with no media', (
    tester,
  ) async {
    repository.mediaToReturn = [buildMedia(id: 1, stage: 'BEFORE')];
    await cubit.load();

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Öncesi'), findsOneWidget);
    expect(find.text('Sonrası'), findsOneWidget);
    expect(find.text('Detay'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);

    await tester.tap(find.text('Sonrası'));
    await tester.pumpAndSettle();

    expect(find.text('Bu aşamada medya yok.'), findsOneWidget);
  });

  testWidgets('hides the delete badge when canDelete is false', (tester) async {
    repository.mediaToReturn = [buildMedia(id: 1, stage: 'BEFORE')];
    await cubit.load();

    await tester.pumpWidget(buildSubject(canDelete: false));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });

  testWidgets('confirming delete calls the cubit and removes the item', (
    tester,
  ) async {
    repository.mediaToReturn = [buildMedia(id: 1, stage: 'BEFORE')];
    await cubit.load();

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Medyayı Sil'), findsOneWidget);

    repository.mediaToReturn = [];
    await tester.tap(find.widgetWithText(TextButton, 'Sil'));
    await tester.pumpAndSettle();

    expect(repository.lastDeletedMediaId, 1);
    expect(find.text('Bu aşamada medya yok.'), findsOneWidget);
  });

  testWidgets('cancelling the delete dialog does not delete anything', (
    tester,
  ) async {
    repository.mediaToReturn = [buildMedia(id: 1, stage: 'BEFORE')];
    await cubit.load();

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'Vazgeç'));
    await tester.pumpAndSettle();

    expect(repository.lastDeletedMediaId, isNull);
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('renders a play icon tile for video media instead of an image', (
    tester,
  ) async {
    repository.mediaToReturn = [
      buildMedia(id: 1, stage: 'BEFORE', mediaType: 'VIDEO'),
    ];
    await cubit.load();

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.play_circle_outline_rounded), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });
}
