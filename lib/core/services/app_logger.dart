import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

abstract interface class AppLogger {
  void debug(String message);
  void info(String message);
  void warning(String message, [Object? error]);
  void error(String message, [Object? error, StackTrace? stackTrace]);
}

/// Logs to the developer console in debug builds only, so nothing leaks in release.
class ConsoleLogger implements AppLogger {
  const ConsoleLogger({this.enabled = !kReleaseMode});

  final bool enabled;

  @override
  void debug(String message) => _log(message, 500);

  @override
  void info(String message) => _log(message, 800);

  @override
  void warning(String message, [Object? error]) => _log(message, 900, error);

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(message, 1000, error, stackTrace);

  void _log(String message, int level, [Object? error, StackTrace? stack]) {
    if (!enabled) return;
    developer.log(message, name: 'pennypath', level: level, error: error, stackTrace: stack);
  }
}
