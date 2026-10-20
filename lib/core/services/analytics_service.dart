import 'app_logger.dart';

abstract final class AnalyticsEvent {
  static const signIn = 'sign_in';
  static const signUp = 'sign_up';
  static const signOut = 'sign_out';
  static const transactionSaved = 'transaction_saved';
  static const transactionDeleted = 'transaction_deleted';
}

/// Never pass personal data (emails, names, amounts) as parameters.
abstract interface class AnalyticsService {
  Future<void> logEvent(String name, [Map<String, Object> parameters]);
  Future<void> setUserId(String? userId);
}

class LoggerAnalyticsService implements AnalyticsService {
  const LoggerAnalyticsService(this._logger);

  final AppLogger _logger;

  @override
  Future<void> logEvent(String name, [Map<String, Object> parameters = const {}]) async =>
      _logger.debug('analytics: $name $parameters');

  @override
  Future<void> setUserId(String? userId) async {}
}
