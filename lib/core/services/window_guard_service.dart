import 'dart:async';
import 'dart:io';

import 'package:window_manager/window_manager.dart';

typedef DirtyCloseCallback = Future<void> Function();

class WindowGuardService with WindowListener {
  WindowGuardService._internal();

  static final WindowGuardService instance = WindowGuardService._internal();

  bool _isFormDirty = false;
  bool _isAttached = false;
  DirtyCloseCallback? _onDirtyCloseRequested;

  /// window_manager yalnızca masaüstünde (Windows/macOS) implemente
  /// edilmiştir — mobilde "pencere kapatma" kavramı yok, çağrı
  /// MissingPluginException fırlatır.
  static bool get _isSupportedPlatform =>
      Platform.isWindows || Platform.isMacOS;

  Future<void> initialize({DirtyCloseCallback? onDirtyCloseRequested}) async {
    _onDirtyCloseRequested = onDirtyCloseRequested;

    if (!_isSupportedPlatform || _isAttached) {
      return;
    }

    windowManager.addListener(this);
    await windowManager.setPreventClose(true);
    _isAttached = true;
  }

  Future<void> dispose() async {
    if (!_isAttached) {
      return;
    }

    windowManager.removeListener(this);
    await windowManager.setPreventClose(false);
    _isAttached = false;
  }

  void setFormDirty(bool isDirty) {
    _isFormDirty = isDirty;
  }

  void setOnDirtyCloseRequested(DirtyCloseCallback? callback) {
    _onDirtyCloseRequested = callback;
  }

  @override
  void onWindowClose() {
    if (_isFormDirty) {
      unawaited(_onDirtyCloseRequested?.call());
      return;
    }

    unawaited(_closeWindow());
  }

  Future<void> _closeWindow() async {
    await windowManager.setPreventClose(false);
    await windowManager.destroy();
  }
}
