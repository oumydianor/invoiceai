import 'package:flutter/foundation.dart';

abstract interface class AppLogger {
  void debug(String message);
  void warning(String message, [Object? error, StackTrace? stackTrace]);
  void error(String message, Object error, StackTrace stackTrace);
}

final class DebugAppLogger implements AppLogger {
  const DebugAppLogger({required this.enabled});

  final bool enabled;

  @override
  void debug(String message) {
    if (enabled) debugPrint('[debug] $message');
  }

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    if (!enabled) return;
    debugPrint(
      '[warning] $message${error == null ? '' : ': ${error.runtimeType}'}',
    );
  }

  @override
  void error(String message, Object error, StackTrace stackTrace) {
    if (!enabled) return;
    debugPrint('[error] $message: ${error.runtimeType}');
  }
}
