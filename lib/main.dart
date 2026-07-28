import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:leather_care_admin/core/services/storage_service.dart';
import 'package:leather_care_admin/core/services/window_guard_service.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';
import 'app/app.dart';
import 'core/di/injection.dart';
import 'core/services/diagnostics_logger.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_dimensions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Video önizleme yalnızca masaüstü kabukta kullanılır; mobilde
  // gereksiz yere APK/IPA boyutunu büyütmemek için atlanır.
  if (Platform.isWindows || Platform.isMacOS) {
    MediaKit.ensureInitialized();
  }

  await setupLocator();

  final diagnosticsLogger = getIt<DiagnosticsLogger>();
  await diagnosticsLogger.initialize();

  final windowGuardService = getIt<WindowGuardService>();
  await windowGuardService.initialize(
    onDirtyCloseRequested: () async {
      await diagnosticsLogger.log(
        'WARN',
        'Kaydedilmemiş değişiklikler nedeniyle kapatma isteği engellendi.',
      );
    },
  );

  if (Platform.isWindows || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(
        AppDimensions.windowMinWidth,
        AppDimensions.windowMinHeight,
      ),
      minimumSize: Size(
        AppDimensions.windowMinWidth,
        AppDimensions.windowMinHeight,
      ),
      center: true,
      backgroundColor: AppColors.background,
      skipTaskbar: false,
      title: 'DoTiKa',
    );

    await windowManager.waitUntilReadyToShow(
      windowOptions,
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    );
  }

  await diagnosticsLogger.log(
    'INFO',
    'DoTiKa uygulaması başlatıldı.',
  );

  runApp(const LeatherCareAdminApp());
}

class LeatherCareAdminApp extends StatelessWidget {
  const LeatherCareAdminApp({super.key, this.storageService});

  final ISecureStorageService? storageService;

  @override
  Widget build(BuildContext context) {
    return LeatherCareApp(storageService: storageService);
  }
}
