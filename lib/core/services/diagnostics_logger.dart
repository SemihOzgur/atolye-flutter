import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DiagnosticsLogger {
  DiagnosticsLogger._internal();

  static final DiagnosticsLogger instance = DiagnosticsLogger._internal();

  static const String _logsFolderName = 'logs';
  static const String _logFileName = 'app_diagnostics.log';

  File? _logFile;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    final applicationSupportDirectory = await getApplicationSupportDirectory();
    final logsDirectory = Directory(
      '${applicationSupportDirectory.path}${Platform.pathSeparator}$_logsFolderName',
    );

    await logsDirectory.create(recursive: true);

    final logFile = File(
      '${logsDirectory.path}${Platform.pathSeparator}$_logFileName',
    );

    if (!await logFile.exists()) {
      await logFile.create(recursive: true);
    }

    _logFile = logFile;
    _isInitialized = true;
  }

  Future<void> log(
    String level,
    String message, [
    dynamic error,
    StackTrace? stack,
  ]) async {
    if (!_isInitialized || _logFile == null) {
      await initialize();
    }

    final timestamp = DateTime.now().toIso8601String();
    final buffer = StringBuffer()..writeln('[$timestamp] [$level] $message');

    if (error != null) {
      buffer.writeln('Hata: $error');
    }

    if (stack != null) {
      buffer.writeln('StackTrace:');
      buffer.writeln(stack);
    }

    buffer.writeln();

    await _logFile!.writeAsString(
      buffer.toString(),
      mode: FileMode.append,
      encoding: utf8,
    );
  }
}
