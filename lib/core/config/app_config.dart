import 'package:flutter/foundation.dart';

enum BackendMode { mock, rest }

/// Build-time configuration, supplied with `--dart-define-from-file`.
@immutable
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.backend,
    required this.apiBaseUrl,
    required this.certificatePins,
  });

  factory AppConfig.fromEnvironment() {
    const env = String.fromEnvironment('APP_ENV', defaultValue: 'demo');
    const backend = String.fromEnvironment('BACKEND', defaultValue: 'mock');
    const baseUrl = String.fromEnvironment('API_BASE_URL');
    const pins = String.fromEnvironment('CERT_PINS');

    final config = AppConfig(
      environment: env,
      backend: BackendMode.values.firstWhere(
        (mode) => mode.name == backend,
        orElse: () => throw StateError('Unknown BACKEND "$backend"'),
      ),
      apiBaseUrl: baseUrl,
      certificatePins: pins
          .split(',')
          .map((pin) => pin.trim())
          .where((pin) => pin.isNotEmpty)
          .toSet(),
    );
    config.validate();
    return config;
  }

  final String environment;
  final BackendMode backend;
  final String apiBaseUrl;

  /// Base64 SHA-256 fingerprints of trusted server certificates.
  final Set<String> certificatePins;

  bool get isMock => backend == BackendMode.mock;

  void validate() {
    if (backend != BackendMode.rest) return;
    final uri = Uri.tryParse(apiBaseUrl);
    if (uri == null || !uri.hasAuthority) {
      throw StateError('API_BASE_URL is required when BACKEND=rest');
    }
    final isLocal = uri.host == 'localhost' || uri.host == '10.0.2.2';
    if (uri.scheme != 'https' && !(kDebugMode && isLocal)) {
      throw StateError('API_BASE_URL must use https');
    }
  }
}
