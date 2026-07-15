import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'core/di/injection.dart';
import 'core/services/diagnostics_logger.dart';
import 'core/services/window_guard_service.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_decorations.dart';
import 'core/theme/app_dimensions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      title: 'Leather Care Admin',
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
    'Leather Care Admin uygulaması başlatıldı.',
  );

  runApp(const LeatherCareAdminApp());
}

class LeatherCareAdminApp extends StatelessWidget {
  const LeatherCareAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceElevated,
      onPrimary: AppColors.textPrimary,
      onSecondary: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Leather Care Admin',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfaceElevated,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppDecorations.borderRadiusXl,
            side: const BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceMuted,
          hintStyle: const TextStyle(color: AppColors.hint),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          border: AppDecorations.outlineBorder,
          enabledBorder: AppDecorations.outlineBorder,
          focusedBorder: OutlineInputBorder(
            borderRadius: AppDecorations.borderRadiusM,
            borderSide: const BorderSide(
              color: AppColors.secondary,
              width: 1.4,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            disabledBackgroundColor: AppColors.border,
            minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: AppDecorations.borderRadiusL,
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: AppDimensions.fontTitle,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          headlineMedium: TextStyle(
            fontSize: AppDimensions.fontSection,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: AppDimensions.fontBody,
            color: AppColors.textSecondary,
          ),
          bodyMedium: TextStyle(
            fontSize: AppDimensions.fontCaption,
            color: AppColors.textMuted,
          ),
        ),
      ),
      home: const LoginPlaceholderPage(),
    );
  }
}

class LoginPlaceholderPage extends StatelessWidget {
  const LoginPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              Color(0xFF121813),
              Color(0xFF1A241D),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.loginCardMaxWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceXl),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spaceXl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppDimensions.space2xl + AppDimensions.spaceL,
                        height: AppDimensions.space2xl + AppDimensions.spaceL,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.16),
                          borderRadius: AppDecorations.borderRadiusL,
                        ),
                        child: const Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceL),
                      Text(
                        'Giriş',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: AppDimensions.spaceS),
                      Text(
                        'Leather Care Admin paneline hoş geldiniz. Bu ekran daha sonra auth feature altındaki gerçek giriş akışına bağlanacak.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppDimensions.spaceXl),
                      const TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Kullanıcı adı',
                          hintText: 'Yakında bağlanacak',
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceM),
                      const TextField(
                        enabled: false,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Şifre',
                          hintText: 'Yakında bağlanacak',
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceL),
                      ElevatedButton(
                        onPressed: null,
                        child: const Text('Giriş Yap'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
