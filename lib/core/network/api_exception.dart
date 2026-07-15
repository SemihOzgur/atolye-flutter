import 'dart:async';

import 'package:dio/dio.dart';

import '../services/diagnostics_logger.dart';

class ApiException implements Exception {
  ApiException({
    required this.message,
    this.errorCode,
    this.statusCode,
  });

  final String message;
  final String? errorCode;
  final int? statusCode;

  factory ApiException.fromDioException(DioException e) {
    final parsed = _parseProblemDetails(e.response?.data);

    final exception = ApiException(
      message: parsed.message ?? _fallbackMessageFor(e),
      errorCode: parsed.errorCode,
      statusCode: e.response?.statusCode,
    );

    unawaited(
      DiagnosticsLogger.instance.log(
        'ERROR',
        'API Exception: ${exception.message}',
        e,
        e.stackTrace,
      ),
    );

    return exception;
  }

  static String _fallbackMessageFor(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return 'İstek zaman aşımına uğradı. Lütfen bağlantınızı kontrol edip tekrar deneyin.';
      case DioExceptionType.connectionError:
        return 'Sunucuya bağlanılamadı. Ağ bağlantınızı kontrol edin.';
      case DioExceptionType.badResponse:
        return 'İstek sunucu tarafından işlenemedi.';
      case DioExceptionType.cancel:
        return 'İstek iptal edildi.';
      case DioExceptionType.badCertificate:
        return 'Güvenlik sertifikası doğrulanamadı.';
      case DioExceptionType.unknown:
        return 'Beklenmeyen bir ağ hatası oluştu.';
    }
  }

  static _ProblemDetails _parseProblemDetails(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['detail']?.toString() ?? data['title']?.toString();
      final errorCode = data['errorCode']?.toString();
      return _ProblemDetails(message: message, errorCode: errorCode);
    }

    if (data is Map) {
      final normalized = data.map<String, dynamic>(
        (key, value) => MapEntry(key.toString(), value),
      );
      final message =
          normalized['detail']?.toString() ?? normalized['title']?.toString();
      final errorCode = normalized['errorCode']?.toString();
      return _ProblemDetails(message: message, errorCode: errorCode);
    }

    return const _ProblemDetails();
  }
}

class _ProblemDetails {
  const _ProblemDetails({this.message, this.errorCode});

  final String? message;
  final String? errorCode;
}
