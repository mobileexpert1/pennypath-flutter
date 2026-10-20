import 'app_logger.dart';

/// Swap the implementation for Sentry or Crashlytics in the composition root.
abstract interface class CrashReporter {
  Future<void> recordError(Object error, StackTrace? stackTrace, {bool fatal});
  Future<void> setUserId(String? userId);
}

class LoggerCrashReporter implements CrashReporter {
  const LoggerCrashReporter(this._logger);

  final AppLogger _logger;

  @override
  Future<void> recordError(Object error, StackTrace? stackTrace, {bool fatal = false}) async =>
      _logger.error(fatal ? 'Fatal error' : 'Error', error, stackTrace);

  @override
  Future<void> setUserId(String? userId) async {}
}
