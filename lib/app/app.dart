import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../core/network/auth_interceptor.dart';
import '../core/services/storage_service.dart';
import '../core/theme/app_theme.dart';
import 'app_router.dart';
import 'app_startup_controller.dart';

class LeatherCareApp extends StatefulWidget {
  const LeatherCareApp({super.key, this.storageService});

  final ISecureStorageService? storageService;

  @override
  State<LeatherCareApp> createState() => _LeatherCareAppState();
}

class _LeatherCareAppState extends State<LeatherCareApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  late final ISecureStorageService _storageService;
  late final AppStartupController _startupController;
  late final GoRouter _router;
  late final StreamSubscription<void> _sessionExpiredSubscription;

  @override
  void initState() {
    super.initState();
    _storageService = widget.storageService ?? SecureStorageService();
    _startupController = AppStartupController(_storageService);
    if (getIt.isRegistered<AppStartupController>()) {
      getIt.unregister<AppStartupController>();
    }
    getIt.registerSingleton<AppStartupController>(_startupController);
    _router = buildAppRouter(_startupController, navigatorKey: _navigatorKey);
    _sessionExpiredSubscription =
        AuthInterceptor.logoutStreamController.stream.listen((_) {
      _startupController.handleUnauthorized();
      _showSessionExpiredDialog();
    });
    unawaited(_startupController.initialize());
  }

  void _showSessionExpiredDialog() {
    final context = _navigatorKey.currentState?.context;
    if (context == null) {
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Oturum süresi doldu'),
        content: const Text(
          'Oturum süreniz doldu, lütfen tekrar giriş yapın.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _sessionExpiredSubscription.cancel();
    if (getIt.isRegistered<AppStartupController>()) {
      getIt.unregister<AppStartupController>();
    }
    _startupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'DoTiKa Admin',
      theme: AppTheme.light(),
      routerConfig: _router,
    );
  }
}
