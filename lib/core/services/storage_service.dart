import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ISecureStorageService {
  Future<void> write(String key, String value);

  Future<String?> read(String key);

  Future<void> delete(String key);

  Future<void> clearAll();
}

class SecureStorageService implements ISecureStorageService {
  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
            resetOnError: true,
          ),
          wOptions: WindowsOptions(
            useBackwardCompatibility: false,
          ),
          mOptions: MacOsOptions(
            accessibility: KeychainAccessibility.unlocked,
            useDataProtectionKeyChain: true,
          ),
        );

  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String value) => _storage.write(
        key: key,
        value: value,
      );

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> clearAll() => _storage.deleteAll();
}