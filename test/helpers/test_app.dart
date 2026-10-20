import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/app/app.dart';
import 'package:pennypath/app/di/core_providers.dart';
import 'package:pennypath/core/config/app_config.dart';
import 'package:pennypath/core/l10n/generated/app_localizations.dart';
import 'package:pennypath/core/mock/mock_network.dart';
import 'package:pennypath/core/theme/app_theme.dart';

import 'fakes.dart';

const mockConfig = AppConfig(
  environment: 'test',
  backend: BackendMode.mock,
  apiBaseUrl: '',
  certificatePins: {},
);

/// Real app wiring with in-memory storage and an instant mock backend.
class TestEnvironment {
  final keyValueStore = InMemoryKeyValueStore();
  final secureStore = InMemorySecureStore();
  final database = InMemoryLocalDatabase();
  final biometrics = FakeBiometricService();
  final analytics = FakeAnalytics();
  bool offline = false;
  DateTime now = DateTime(2026, 10, 20, 10);

  List<Override> get overrides => [
    appConfigProvider.overrideWithValue(mockConfig),
    keyValueStoreProvider.overrideWithValue(keyValueStore),
    localDatabaseProvider.overrideWithValue(database),
    secureStoreProvider.overrideWithValue(secureStore),
    biometricServiceProvider.overrideWithValue(biometrics),
    analyticsProvider.overrideWithValue(analytics),
    crashReporterProvider.overrideWithValue(SilentCrashReporter()),
    clockProvider.overrideWithValue(() => now),
    mockNetworkProvider.overrideWithValue(
      MockNetwork(isOffline: () => offline, latency: Duration.zero),
    ),
  ];
}

extension PumpX on WidgetTester {
  /// iPhone-sized viewport so full forms are on screen.
  void usePhoneViewport() {
    view
      ..physicalSize = const Size(1170, 2532)
      ..devicePixelRatio = 3;
    addTearDown(view.reset);
  }

  Future<void> pumpPennypath(TestEnvironment env) async {
    usePhoneViewport();
    await pumpWidget(
      ProviderScope(overrides: env.overrides, retry: (_, _) => null, child: const PennypathApp()),
    );
    await pumpAndSettle();
  }

  /// Pumps a single widget with theme, localisation and providers.
  Future<void> pumpScreen(Widget child, {List<Override> overrides = const []}) async {
    usePhoneViewport();
    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        retry: (_, _) => null,
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: child,
        ),
      ),
    );
    await pumpAndSettle();
  }
}
