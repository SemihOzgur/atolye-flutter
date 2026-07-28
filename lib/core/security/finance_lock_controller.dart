import 'dart:async';

import 'package:flutter/foundation.dart';

import 'pin_store.dart';

enum PinVerifyResult { ok, wrong, lockedOut }

/// Dashboard finans kartlarının PIN kilidi. **İstemci tarafı görsel
/// korumadır** — API'yi çağırabilen herkes veriyi yine alabilir; amaç
/// yalnızca ortak ekrana bakan kişilerden ciroyu gizlemektir.
///
/// Bellek içi durum: uygulama her açılışta/logout'ta kilitli başlar
/// (kalıcı değildir). Yalnızca PIN'in hash+salt'ı secure storage'da kalır.
class FinanceLockController extends ChangeNotifier {
  FinanceLockController(
    this._pinStore, {
    this.autoLock = const Duration(minutes: 5),
    this.lockoutDuration = const Duration(seconds: 60),
    this.maxAttempts = 5,
  });

  final PinStore _pinStore;
  final Duration autoLock;
  final Duration lockoutDuration;
  final int maxAttempts;

  bool _isUnlocked = false;
  int _failedAttempts = 0;
  DateTime? _lockoutUntil;
  Timer? _autoLockTimer;
  Timer? _lockoutTimer;

  bool get isUnlocked => _isUnlocked;
  int get failedAttempts => _failedAttempts;
  DateTime? get lockoutUntil => _lockoutUntil;
  bool get isLockedOut => _lockoutUntil != null;

  Future<bool> hasPin() => _pinStore.hasPin();

  Future<void> setPinAndUnlock(String pin) async {
    await _pinStore.setPin(pin);
    _unlock();
  }

  Future<PinVerifyResult> unlock(String pin) async {
    if (isLockedOut) {
      return PinVerifyResult.lockedOut;
    }

    final isCorrect = await _pinStore.verify(pin);
    if (isCorrect) {
      _failedAttempts = 0;
      _unlock();
      return PinVerifyResult.ok;
    }

    _failedAttempts++;
    if (_failedAttempts >= maxAttempts) {
      _startLockout();
    }
    notifyListeners();
    return PinVerifyResult.wrong;
  }

  void _startLockout() {
    _lockoutUntil = DateTime.now().add(lockoutDuration);
    _lockoutTimer?.cancel();
    _lockoutTimer = Timer(lockoutDuration, () {
      _lockoutUntil = null;
      _failedAttempts = 0;
      notifyListeners();
    });
  }

  void _unlock() {
    _isUnlocked = true;
    _autoLockTimer?.cancel();
    _autoLockTimer = Timer(autoLock, lock);
    notifyListeners();
  }

  /// Kilitler: 5 dk zamanlayıcısı dolduğunda, sayfadan/oturumdan çıkışta
  /// çağrılır. Zaten kilitliyse no-op (gereksiz notifyListeners yok).
  void lock() {
    _autoLockTimer?.cancel();
    _autoLockTimer = null;
    if (_isUnlocked) {
      _isUnlocked = false;
      notifyListeners();
    }
  }

  /// "PIN'i unuttum" akışı: PIN silinir, kilit ve deneme sayaçları
  /// sıfırlanır. Çağıran taraf ardından oturumu kapatmalıdır (yeniden
  /// login = kimlik kanıtı).
  Future<void> resetPin() async {
    await _pinStore.clear();
    _lockoutTimer?.cancel();
    _lockoutTimer = null;
    _lockoutUntil = null;
    _failedAttempts = 0;
    lock();
  }

  @override
  void dispose() {
    _autoLockTimer?.cancel();
    _lockoutTimer?.cancel();
    super.dispose();
  }
}
