import 'dart:async';

import 'package:dio/dio.dart';

import '../services/diagnostics_logger.dart';

class ApiException implements Exception {
  ApiException({
    required this.message,
    this.title,
    this.detail,
    this.errorCode,
    this.statusCode,
    this.fieldErrors = const <String, List<String>>{},
  });

  final String message;
  final String? title;
  final String? detail;
  final String? errorCode;
  final int? statusCode;
  final Map<String, List<String>> fieldErrors;

  factory ApiException.fromDioException(DioException e) {
    final parsed = _parseProblemDetails(e.response?.data);

    final exception = ApiException(
      message: parsed.message ?? _fallbackMessageFor(e),
      title: parsed.title,
      detail: parsed.detail,
      errorCode: parsed.errorCode,
      statusCode: e.response?.statusCode,
      fieldErrors: parsed.fieldErrors,
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
      return _fromMap(data);
    }

    if (data is Map) {
      final normalized = data.map<String, dynamic>(
        (key, value) => MapEntry(key.toString(), value),
      );
      return _fromMap(normalized);
    }

    return const _ProblemDetails();
  }

  static _ProblemDetails _fromMap(Map<String, dynamic> map) {
    final title = map['title']?.toString();
    final detail = map['detail']?.toString();
    final errorCode = map['errorCode']?.toString();
    final errors = map['errors'];

    final fieldErrors = <String, List<String>>{};

    if (errors is Map) {
      for (final entry in errors.entries) {
        final key = entry.key.toString();
        final value = entry.value;

        if (value is Iterable) {
          fieldErrors[key] = value.map((item) => item.toString()).toList();
        } else if (value != null) {
          fieldErrors[key] = <String>[value.toString()];
        }
      }
    }

    return _ProblemDetails(
      message: detail ?? title,
      title: title,
      detail: detail,
      errorCode: errorCode,
      fieldErrors: fieldErrors,
    );
  }
}

class _ProblemDetails {
  const _ProblemDetails({
    this.message,
    this.title,
    this.detail,
    this.errorCode,
    this.fieldErrors = const <String, List<String>>{},
  });

  final String? message;
  final String? title;
  final String? detail;
  final String? errorCode;
  final Map<String, List<String>> fieldErrors;
}
