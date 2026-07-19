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

  test('format picks the largest fitting unit', () {
    expect(ByteSizeFormatter.format(512), '512 B');
    expect(ByteSizeFormatter.format(2048), '2.0 KB');
    expect(ByteSizeFormatter.format(5 * 1024 * 1024), '5.0 MB');
    expect(ByteSizeFormatter.format(2 * 1024 * 1024 * 1024), '2.0 GB');
  });
}
