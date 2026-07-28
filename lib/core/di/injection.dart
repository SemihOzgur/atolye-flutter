import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/archive/data/archive_repository.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/backup/data/backup_repository.dart';
import '../../features/catalog/data/catalog_repository.dart';
import '../../features/customer/data/customer_repository.dart';
import '../../features/dashboard/data/dashboard_repository.dart';
import '../../features/media/data/media_conversion_service.dart';
import '../../features/media/data/media_repository.dart';
import '../../features/receipt_printing/application/receipt_print_service.dart';
import '../../features/social_media/data/social_media_repository.dart';
import '../../features/work_order/data/work_order_repository.dart';
import '../network/dio_client.dart';
import '../security/finance_lock_controller.dart';
import '../security/pin_store.dart';
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

  if (!getIt.isRegistered<IMediaRepository>()) {
    getIt.registerLazySingleton<IMediaRepository>(
      () => MediaRepository(getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<IMediaConversionService>()) {
    getIt.registerLazySingleton<IMediaConversionService>(
      MediaConversionService.new,
    );
  }

  if (!getIt.isRegistered<ISocialMediaRepository>()) {
    getIt.registerLazySingleton<ISocialMediaRepository>(
      () => SocialMediaRepository(getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<IArchiveRepository>()) {
    getIt.registerLazySingleton<IArchiveRepository>(
      () => ArchiveRepository(getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<IBackupRepository>()) {
    getIt.registerLazySingleton<IBackupRepository>(
      () => BackupRepository(getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<ReceiptPrintService>()) {
    getIt.registerLazySingleton<ReceiptPrintService>(
      () => ReceiptPrintService(getIt<ISecureStorageService>()),
  if (!getIt.isRegistered<FinanceLockController>()) {
    getIt.registerLazySingleton<FinanceLockController>(
      () => FinanceLockController(PinStore(getIt<ISecureStorageService>())),
    );
  }
}
