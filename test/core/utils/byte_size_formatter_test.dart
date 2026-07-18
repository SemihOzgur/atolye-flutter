import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/utils/byte_size_formatter.dart';

void main() {
  test('formats bytes as GB with one decimal', () {
    expect(ByteSizeFormatter.formatGb(0), '0.0 GB');
    expect(ByteSizeFormatter.formatGb(1024 * 1024 * 1024), '1.0 GB');
    expect(
      ByteSizeFormatter.formatGb((1.5 * 1024 * 1024 * 1024).round()),
      '1.5 GB',
    );
    expect(
      ByteSizeFormatter.formatGb(107374182400),
      '100.0 GB',
    );
  });
}
