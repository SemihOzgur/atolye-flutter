import 'package:flutter/foundation.dart';

import '../core/constants/storage_keys.dart';
import '../core/services/storage_service.dart';

enum AppLaunchState { loading, unauthenticated, authenticated }

class AppStartupController extends ChangeNotifier {
  AppStartupController(this._storageService);

  final ISecureStorageService _storageService;

  AppLaunchState _state = AppLaunchState.loading;

  AppLaunchState get state => _state;

  bool get isBootstrapped => _state != AppLaunchState.loading;

  Future<void> initialize() async {
    final token = await _storageService.read(StorageKeys.authToken);
    _state = token != null && token.isNotEmpty
        ? AppLaunchState.authenticated
        : AppLaunchState.unauthenticated;
    notifyListeners();
  }

  void markAuthenticated() {
    _state = AppLaunchState.authenticated;
    notifyListeners();
  }

  void handleUnauthorized() {
    _state = AppLaunchState.unauthenticated;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storageService.delete(StorageKeys.authToken);
    _state = AppLaunchState.unauthenticated;
    notifyListeners();
  }
}