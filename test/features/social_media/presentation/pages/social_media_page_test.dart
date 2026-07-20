import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:leather_care_admin/app/app_routes.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/network/paged_response.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/core/widgets/skeleton_box.dart';
import 'package:leather_care_admin/features/social_media/data/dto/social_media_item_dto.dart';
import 'package:leather_care_admin/features/social_media/data/social_media_repository.dart';
import 'package:leather_care_admin/features/social_media/presentation/pages/social_media_page.dart';
import 'package:leather_care_admin/features/work_order/data/dto/media_file_dto.dart';

import '../../fakes/fake_social_media_repository.dart';

void main() {
  late FakeSocialMediaRepository repository;

  setUp(() {
    repository = FakeSocialMediaRepository();
    if (getIt.isRegistered<ISocialMediaRepository>()) {
      getIt.unregister<ISocialMediaRepository>();
    }
    getIt.registerLazySingleton<ISocialMediaRepository>(() => repository);
  });

  tearDown(() async {
    await getIt.reset();
  });

  SocialMediaItemDto buildItem({
    required int workOrderId,
    List<MediaFileDto> beforeMedia = const [],
    List<MediaFileDto> afterMedia = const [],
  }) {
    return SocialMediaItemDto(
      workOrderId: workOrderId,
      orderNumber: 'WO-2026-000$workOrderId',
      status: 'READY',
      categoryPath: 'Kadın > Ayakkabı > Sneakers',
      brand: 'Nike',
      socialMediaConsentAt: DateTime(2026, 1, 1),
      beforeMedia: beforeMedia,
      afterMedia: afterMedia,
    );
  }

  MediaFileDto buildMedia({required int id, String mediaType = 'PHOTO'}) {
    return MediaFileDto(
      id: id,
      mediaType: mediaType,
      stage: 'BEFORE',
      viewUrl: 'https://minio.local/view/$id',
      createdAt: DateTime(2026, 1, 1),
    );
  }

  Widget buildSubject() {
    final router = GoRouter(
      initialLocation: AppRoutes.socialMedia,
      routes: [
        GoRoute(
          path: AppRoutes.socialMedia,
          builder: (context, state) => const Scaffold(body: SocialMediaPage()),
        ),
        GoRoute(
          path: '${AppRoutes.workOrders}/:id',
          builder: (context, state) => Scaffold(
            body: Text('work-order-detail-${state.pathParameters['id']}'),
          ),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router, theme: AppTheme.light());
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
      message: 'Unauthorized',
      detail: 'Oturum süresi doldu.',
      statusCode: 401,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Oturum süresi doldu.'), findsOneWidget);
    expect(find.text('Tekrar Dene'), findsOneWidget);
  });

  testWidgets('shows the empty state when no items are returned', (
    tester,
  ) async {
    repository.pageToReturn = const PagedResponse(
      items: [],
      page: 1,
      pageSize: 20,
      totalCount: 0,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('İzin vermiş müşteri içeriği yok.'), findsOneWidget);
  });

  testWidgets('renders a card with order info and before/after media', (
    tester,
  ) async {
    repository.pageToReturn = PagedResponse(
      items: [
        buildItem(
          workOrderId: 7,
          beforeMedia: [buildMedia(id: 1)],
          afterMedia: [buildMedia(id: 2, mediaType: 'VIDEO')],
        ),
      ],
      page: 1,
      pageSize: 20,
      totalCount: 1,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('WO-2026-0007'), findsOneWidget);
    expect(
      find.text('Kadın > Ayakkabı > Sneakers · Nike'),
      findsOneWidget,
    );
    expect(find.text('Öncesi'), findsOneWidget);
    expect(find.text('Sonrası'), findsOneWidget);
    expect(find.byIcon(Icons.play_circle_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.download_rounded), findsNWidgets(2));
  });

  testWidgets('shows Medya yok for a stage with no media', (tester) async {
    repository.pageToReturn = PagedResponse(
      items: [buildItem(workOrderId: 7)],
      page: 1,
      pageSize: 20,
      totalCount: 1,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Medya yok.'), findsNWidgets(2));
  });

  testWidgets('tapping the card header navigates to the work order detail', (
    tester,
  ) async {
    repository.pageToReturn = PagedResponse(
      items: [buildItem(workOrderId: 7)],
      page: 1,
      pageSize: 20,
      totalCount: 1,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.text('WO-2026-0007'));
    await tester.pumpAndSettle();

    expect(find.text('work-order-detail-7'), findsOneWidget);
  });

  testWidgets('tapping a photo thumbnail opens a preview dialog', (
    tester,
  ) async {
    repository.pageToReturn = PagedResponse(
      items: [
        buildItem(workOrderId: 7, beforeMedia: [buildMedia(id: 1)]),
      ],
      page: 1,
      pageSize: 20,
      totalCount: 1,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('media-thumbnail-1')));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
  });

  testWidgets('shows pagination controls when totalCount exceeds pageSize', (
    tester,
  ) async {
    repository.pageToReturn = PagedResponse(
      items: [buildItem(workOrderId: 7)],
      page: 1,
      pageSize: 1,
      totalCount: 2,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Sayfa 1'), findsOneWidget);
    final nextButton = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.chevron_right_rounded),
    );
    expect(nextButton.onPressed, isNotNull);
    final prevButton = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.chevron_left_rounded),
    );
    expect(prevButton.onPressed, isNull);
  });
}
