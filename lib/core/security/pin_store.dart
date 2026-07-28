import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import '../constants/storage_keys.dart';
import '../services/storage_service.dart';

/// Finans kilidi PIN'inin yerel saklanması. PIN düz metin olarak hiçbir
/// yerde tutulmaz — yalnızca rastgele salt + SHA-256 hash secure storage'da.
class PinStore {
  PinStore(this._storage);

  final ISecureStorageService _storage;

  Future<bool> hasPin() async {
    final hash = await _storage.read(StorageKeys.financePinHash);
    return hash != null && hash.isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    final salt = _generateSalt();
    await _storage.write(StorageKeys.financePinSalt, salt);
    await _storage.write(StorageKeys.financePinHash, _hash(pin, salt));
  }

  Future<bool> verify(String pin) async {
    final salt = await _storage.read(StorageKeys.financePinSalt);
    final storedHash = await _storage.read(StorageKeys.financePinHash);
    if (salt == null || storedHash == null) {
      return false;
    }
    return _hash(pin, salt) == storedHash;
  }

  Future<void> clear() async {
    await _storage.delete(StorageKeys.financePinHash);
    await _storage.delete(StorageKeys.financePinSalt);
  }

  String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  String _hash(String pin, String salt) =>
      sha256.convert(utf8.encode('$salt$pin')).toString();
}
