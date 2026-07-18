import 'dart:async';

import 'package:dio/dio.dart';

import '../constants/storage_keys.dart';
import '../services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storageService);

  final ISecureStorageService _storageService;

  static final StreamController<void> logoutStreamController =
      StreamController<void>.broadcast();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storageService.read(StorageKeys.authToken);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _storageService.delete(StorageKeys.authToken);
      if (!logoutStreamController.isClosed) {
        logoutStreamController.add(null);
      }
    }

    handler.next(err);
  }
}
