import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/features/archive/data/archive_integrity_checker.dart';

void main() {
  late ArchiveIntegrityChecker checker;
  late Directory tempDir;

  setUp(() async {
    checker = ArchiveIntegrityChecker();
    tempDir = await Directory.systemTemp.createTemp('archive_integrity_test');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('computeMd5 matches the known MD5 of "hello"', () async {
    final file = File('${tempDir.path}/hello.txt')
      ..writeAsBytesSync(utf8.encode('hello'));

    final hash = await checker.computeMd5(file);

    expect(hash, '5d41402abc4b2a76b9719d911017c592');
  });

  test('computeMd5 of an empty file matches the known empty MD5', () async {
    final file = File('${tempDir.path}/empty.txt')..writeAsBytesSync([]);

    final hash = await checker.computeMd5(file);

    expect(hash, 'd41d8cd98f00b204e9800998ecf8427e');
  });

  group('matches', () {
    test('returns true when the hash equals the ETag, case-insensitively', () {
      expect(
        checker.matches(
          '5d41402abc4b2a76b9719d911017c592',
          '5D41402ABC4B2A76B9719D911017C592',
        ),
        isTrue,
      );
    });

    test('returns false when the hash differs from the ETag', () {
      expect(
        checker.matches(
          '5d41402abc4b2a76b9719d911017c592',
          'd41d8cd98f00b204e9800998ecf8427e',
        ),
        isFalse,
      );
    });

    test('returns false when the ETag is null', () {
      expect(checker.matches('5d41402abc4b2a76b9719d911017c592', null), isFalse);
    });

    test('returns false for multipart-upload ETags (contain a dash)', () {
      expect(
        checker.matches(
          '5d41402abc4b2a76b9719d911017c592',
          '5d41402abc4b2a76b9719d911017c592-2',
        ),
        isFalse,
      );
    });
  });
}
