import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/core/widgets/skeleton_list_tile.dart';
import 'package:leather_care_admin/features/archive/data/archive_repository.dart';
import 'package:leather_care_admin/features/archive/data/dto/archive_candidate_dto.dart';
import 'package:leather_care_admin/features/archive/presentation/cubit/archive_cubit.dart';
import 'package:leather_care_admin/features/archive/presentation/pages/archive_page.dart';
import 'package:leather_care_admin/features/backup/data/backup_repository.dart';

import '../../../backup/fakes/fake_backup_repository.dart';
import '../../fakes/fake_archive_repository.dart';

void main() {
  late FakeArchiveRepository repository;

  setUp(() {
    repository = FakeArchiveRepository();
    if (getIt.isRegistered<IArchiveRepository>()) {
      getIt.unregister<IArchiveRepository>();
    }
    getIt.registerLazySingleton<IArchiveRepository>(() => repository);

    if (getIt.isRegistered<IBackupRepository>()) {
      getIt.unregister<IBackupRepository>();
    }
    getIt.registerLazySingleton<IBackupRepository>(FakeBackupRepository.new);
  });

  tearDown(() async {
    await getIt.reset();
  });

  ArchiveCandidateDto buildCandidate({
    required int workOrderId,
    bool hasSocialMediaConsent = false,
  }) {
    return ArchiveCandidateDto(
      workOrderId: workOrderId,
      orderNumber: 'WO-2026-00000$workOrderId',
      status: 'DELIVERED',
      closedAt: DateTime(2026, 1, 15),
      mediaCount: 4,
      totalSizeBytes: 5 * 1024 * 1024,
      hasSocialMediaConsent: hasSocialMediaConsent,
    );
  }

  Widget buildSubject() {
    return MaterialApp(
      theme: AppTheme.light(),
      home: const Scaffold(body: ArchivePage()),
    );
  }

  testWidgets('shows a skeleton loader before the first load resolves', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    expect(find.byType(SkeletonListTile), findsWidgets);
  });

  testWidgets('shows the error message and a retry button on failure', (
    tester,
  ) async {
    repository.candidatesException = ApiException(
      message: 'Unauthorized',
      detail: 'Oturum süresi doldu.',
      statusCode: 401,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Oturum süresi doldu.'), findsOneWidget);
    expect(find.text('Tekrar Dene'), findsOneWidget);
  });

  testWidgets('shows the empty state when there are no candidates', (
    tester,
  ) async {
    repository.candidatesToReturn = const [];

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Arşivlenebilir iş emri yok.'), findsOneWidget);
  });

  testWidgets('renders a candidate row with order info and a consent badge', (
    tester,
  ) async {
    repository.candidatesToReturn = [
      buildCandidate(workOrderId: 7, hasSocialMediaConsent: true),
    ];

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('WO-2026-000007'), findsOneWidget);
    expect(find.text('Teslim Edildi'), findsOneWidget);
    expect(find.textContaining('15.01.2026'), findsOneWidget);
    expect(find.textContaining('4 medya'), findsOneWidget);
    expect(find.textContaining('5.0 MB'), findsOneWidget);
    expect(find.byIcon(Icons.campaign_rounded), findsOneWidget);
  });

  testWidgets('Adayları Listele requests the entered day threshold', (
    tester,
  ) async {
    repository.candidatesToReturn = [buildCandidate(workOrderId: 7)];

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '30');
    await tester.tap(find.text('Adayları Listele'));
    await tester.pumpAndSettle();

    expect(find.text('WO-2026-000007'), findsOneWidget);
  });

  testWidgets('Arşivle stays disabled until a candidate is selected', (
    tester,
  ) async {
    repository.candidatesToReturn = [buildCandidate(workOrderId: 7)];

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    ElevatedButton findArchiveButton() => tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Arşivle'),
        );

    expect(findArchiveButton().onPressed, isNull);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    // Selected but no target folder yet — still disabled.
    expect(findArchiveButton().onPressed, isNull);
  });

  testWidgets(
    'tapping Arşivle after a folder is set (via cubit) opens the confirmation dialog',
    (tester) async {
      repository.candidatesToReturn = [buildCandidate(workOrderId: 7)];

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(TextField));
      context.read<ArchiveCubit>().setTargetRoot('/tmp/archive-root');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Arşivle'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('KALICI olarak silinecek'),
        findsOneWidget,
      );
      expect(find.textContaining('Doğrulanan 4 medya'), findsOneWidget);
    },
  );
}
