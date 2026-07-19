import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/catalog/data/catalog_repository.dart';
import '../../features/customer/data/customer_repository.dart';
import '../../features/dashboard/data/dashboard_repository.dart';
import '../../features/work_order/data/work_order_repository.dart';
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

  if (!getIt.isRegistered<IAuthRepository>()) {
    getIt.registerLazySingleton<IAuthRepository>(
      () => AuthRepository(getIt<Dio>(), getIt<ISecureStorageService>()),
    );
  }

  if (!getIt.isRegistered<IDashboardRepository>()) {
    getIt.registerLazySingleton<IDashboardRepository>(
      () => DashboardRepository(getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<ICustomerRepository>()) {
    getIt.registerLazySingleton<ICustomerRepository>(
      () => CustomerRepository(getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<ICatalogRepository>()) {
    getIt.registerLazySingleton<ICatalogRepository>(
      () => CatalogRepository(getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<IWorkOrderRepository>()) {
    getIt.registerLazySingleton<IWorkOrderRepository>(
      () => WorkOrderRepository(getIt<Dio>()),
    );
  }
}
