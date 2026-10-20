import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/config/app_config.dart';
import '../../core/mock/mock_network.dart';
import '../../core/network/api_client.dart';
import '../../core/network/auth_interceptor.dart';
import '../../core/network/dio_factory.dart';
import '../../core/services/analytics_service.dart';
import '../../core/services/app_logger.dart';
import '../../core/services/biometric_service.dart';
import '../../core/services/crash_reporter.dart';
import '../../core/storage/key_value_store.dart';
import '../../core/storage/local_database.dart';
import '../../core/storage/secure_store.dart';
import 'auth_providers.dart';

// Overridden in bootstrap once the async resources are ready.
final appConfigProvider = Provider<AppConfig>((_) => throw UnimplementedError());
final keyValueStoreProvider = Provider<KeyValueStore>((_) => throw UnimplementedError());
final localDatabaseProvider = Provider<LocalDatabase>((_) => throw UnimplementedError());

final secureStoreProvider = Provider<SecureStore>((_) => const FlutterSecureStore());
final loggerProvider = Provider<AppLogger>((_) => const ConsoleLogger());
final crashReporterProvider = Provider<CrashReporter>(
  (ref) => LoggerCrashReporter(ref.watch(loggerProvider)),
);
final analyticsProvider = Provider<AnalyticsService>(
  (ref) => LoggerAnalyticsService(ref.watch(loggerProvider)),
);
final biometricServiceProvider = Provider<BiometricService>((_) => LocalAuthBiometricService());

final clockProvider = Provider<DateTime Function()>((_) => DateTime.now);
final idGeneratorProvider = Provider<String Function()>((_) => const Uuid().v4);

final simulateOfflineProvider = NotifierProvider<SimulateOfflineController, bool>(
  SimulateOfflineController.new,
);

class SimulateOfflineController extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle({required bool offline}) => state = offline;
}

final mockNetworkProvider = Provider<MockNetwork>(
  (ref) => MockNetwork(isOffline: () => ref.read(simulateOfflineProvider)),
);

/// For unauthenticated calls (login, refresh) and auth retries.
final publicDioProvider = Provider<Dio>(
  (ref) => createDio(ref.watch(appConfigProvider), ref.watch(loggerProvider)),
);

final publicApiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(publicDioProvider)),
);

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = createDio(ref.watch(appConfigProvider), ref.watch(loggerProvider));
  dio.interceptors.insert(
    0,
    AuthInterceptor(
      tokens: ref.watch(accessTokenProvider),
      retryClient: ref.watch(publicDioProvider),
    ),
  );
  return ApiClient(dio);
});
