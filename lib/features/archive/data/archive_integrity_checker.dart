import 'dart:io';

import 'package:crypto/crypto.dart';

class ArchiveIntegrityChecker {
  Future<String> computeMd5(File file) async {
    final digest = await md5.bind(file.openRead()).first;
    return digest.toString();
  }

  /// MinIO multipart-upload ETags contain a `-partCount` suffix and are not
  /// plain MD5 hashes, so they can never match a local hash.
  bool matches(String localMd5Hex, String? etag) {
    if (etag == null || etag.contains('-')) return false;
    return localMd5Hex.toLowerCase() == etag.toLowerCase();
  }
}
