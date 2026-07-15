import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../services/diagnostics_logger.dart';
import '../services/storage_service.dart';
import '../services/window_guard_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  if (!getIt.isRegistered<ISecureStorageService>()) {
    getIt.registerLazySingleton<ISecureStorageService>(
      SecureStorageService.new,
    );
  }

  if (!getIt.isRegistered<WindowGuardService>()) {
    getIt.registerSingleton<WindowGuardService>(WindowGuardService.instance);
  }

  if (!getIt.isRegistered<DiagnosticsLogger>()) {
    getIt.registerSingleton<DiagnosticsLogger>(DiagnosticsLogger.instance);
  }

  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(
      () => DioClient.create(getIt<ISecureStorageService>()),
    );
  }
}
