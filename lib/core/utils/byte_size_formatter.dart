class ByteSizeFormatter {
  ByteSizeFormatter._();

  static const int _bytesPerGb = 1024 * 1024 * 1024;

  static String formatGb(int bytes) {
    final gb = bytes / _bytesPerGb;
    return '${gb.toStringAsFixed(1)} GB';
  }
}
