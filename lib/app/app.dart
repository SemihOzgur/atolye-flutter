import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  late final ISecureStorageService _storageService;
  late final AppStartupController _startupController;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _storageService = widget.storageService ?? SecureStorageService();
    _startupController = AppStartupController(_storageService);
    _router = buildAppRouter(_startupController);
    unawaited(_startupController.initialize());
  }

  @override
  void dispose() {
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