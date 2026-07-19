import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/media/presentation/cubit/media_upload_cubit.dart';
import 'package:leather_care_admin/features/media/presentation/widgets/media_upload_panel.dart';

import '../../fakes/fake_media_conversion_service.dart';
import '../../fakes/fake_media_repository.dart';

void main() {
  late MediaUploadCubit cubit;

  setUp(() {
    cubit = MediaUploadCubit(
      FakeMediaRepository(),
      FakeMediaConversionService(),
      7,
    );
  });

  Widget buildSubject({int existingMediaCount = 0}) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: BlocProvider<MediaUploadCubit>.value(
          value: cubit,
          child: MediaUploadPanel(existingMediaCount: existingMediaCount),
        ),
      ),
    );
  }

  testWidgets('shows stage dropdown, pick button, and the 0/20 counter', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    expect(find.text('Öncesi'), findsOneWidget);
    expect(find.text('Dosya Seç'), findsOneWidget);
    expect(find.text('0/20'), findsOneWidget);

    final pickButton = tester.widget<OutlinedButton>(
      find.ancestor(
        of: find.text('Dosya Seç'),
        matching: find.byType(OutlinedButton),
      ),
    );
    expect(pickButton.onPressed, isNotNull);
  });

  testWidgets('disables the pick button once the 20-media limit is reached', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(existingMediaCount: 20));

    expect(find.text('20/20'), findsOneWidget);

    final pickButton = tester.widget<OutlinedButton>(
      find.ancestor(
        of: find.text('Dosya Seç'),
        matching: find.byType(OutlinedButton),
      ),
    );
    expect(pickButton.onPressed, isNull);
  });

  testWidgets('shows an error task tile with a retry button', (tester) async {
    await tester.pumpWidget(buildSubject());

    await cubit.enqueueFiles(['/tmp/document.pdf'], 'BEFORE');
    await tester.pumpAndSettle();

    expect(find.text('document.pdf'), findsOneWidget);
    expect(find.text('Desteklenmeyen dosya formatı. JPEG, PNG, HEIC, MP4 veya MOV kullanın.'), findsOneWidget);
    expect(find.text('Tekrar Dene'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
  });

  testWidgets('tapping Tekrar Dene retries the failed task', (tester) async {
    await tester.pumpWidget(buildSubject());

    await cubit.enqueueFiles(['/tmp/document.pdf'], 'BEFORE');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tekrar Dene'));
    await tester.pumpAndSettle();

    expect(find.text('document.pdf'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
  });

  testWidgets('changing the stage dropdown updates the selection', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    await tester.tap(find.text('Öncesi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sonrası').last);
    await tester.pumpAndSettle();

    expect(find.text('Sonrası'), findsOneWidget);
  });
}
