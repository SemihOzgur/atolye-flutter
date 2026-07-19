class ByteSizeFormatter {
  ByteSizeFormatter._();

  static const int _bytesPerKb = 1024;
  static const int _bytesPerMb = 1024 * 1024;
  static const int _bytesPerGb = 1024 * 1024 * 1024;

  static String formatGb(int bytes) {
    final gb = bytes / _bytesPerGb;
    return '${gb.toStringAsFixed(1)} GB';
  }

  /// Human-readable size using the largest fitting unit (KB/MB/GB).
  static String format(int bytes) {
    if (bytes >= _bytesPerGb) {
      return '${(bytes / _bytesPerGb).toStringAsFixed(1)} GB';
    }
    if (bytes >= _bytesPerMb) {
      return '${(bytes / _bytesPerMb).toStringAsFixed(1)} MB';
    }
    if (bytes >= _bytesPerKb) {
      return '${(bytes / _bytesPerKb).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }
}
