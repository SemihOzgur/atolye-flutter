import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/backup/data/backup_repository.dart';
import 'package:leather_care_admin/features/backup/presentation/cubit/backup_cubit.dart';
import 'package:leather_care_admin/features/backup/presentation/widgets/backup_section.dart';

import '../../fakes/fake_backup_repository.dart';

void main() {
  late FakeBackupRepository repository;

  setUp(() {
    repository = FakeBackupRepository();
    if (getIt.isRegistered<IBackupRepository>()) {
      getIt.unregister<IBackupRepository>();
    }
    getIt.registerLazySingleton<IBackupRepository>(() => repository);
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget buildSubject() {
    return MaterialApp(
      theme: AppTheme.light(),
      home: const Scaffold(body: BackupSection()),
    );
  }

  testWidgets('shows the download button and the weekly reminder note', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    expect(find.text('Son Veritabanı Yedeğini İndir'), findsOneWidget);
    expect(find.text('Haftada bir indirilmesi önerilir.'), findsOneWidget);
  });

  testWidgets('shows the filename and location after a successful download', (
    tester,
  ) async {
    repository.fileNameToReturn = 'db-2026-01-01.sql.gz';

    await tester.pumpWidget(buildSubject());

    final context = tester.element(find.byType(ElevatedButton));
    await context.read<BackupCubit>().download('/tmp/backup.sql.gz');
    await tester.pumpAndSettle();

    expect(
      find.textContaining('İndirildi: db-2026-01-01.sql.gz'),
      findsOneWidget,
    );
    expect(find.textContaining('/tmp/backup.sql.gz'), findsOneWidget);
  });

  testWidgets('shows the friendly message for a 404 (no backup yet)', (
    tester,
  ) async {
    repository.exceptionToThrow = ApiException(
      message: 'Not Found',
      statusCode: 404,
    );

    await tester.pumpWidget(buildSubject());

    final context = tester.element(find.byType(ElevatedButton));
    await context.read<BackupCubit>().download('/tmp/backup.sql.gz');
    await tester.pumpAndSettle();

    expect(find.text('Henüz yedek alınmamış.'), findsOneWidget);
  });
}
