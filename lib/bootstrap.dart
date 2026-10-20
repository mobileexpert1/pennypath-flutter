import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/di/core_providers.dart';
import 'core/config/app_config.dart';
import 'core/services/app_logger.dart';
import 'core/services/crash_reporter.dart';
import 'core/storage/hive_local_database.dart';
import 'core/storage/key_value_store.dart';
import 'core/storage/secure_store.dart';

/// Initialises async resources, wires global error handling, then runs the app.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  const logger = ConsoleLogger();
  const CrashReporter crashReporter = LoggerCrashReporter(logger);

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    unawaited(crashReporter.recordError(details.exception, details.stack, fatal: true));
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    unawaited(crashReporter.recordError(error, stack, fatal: true));
    return true;
  };

  const secureStore = FlutterSecureStore();
  final (keyValueStore, database) = await (
    SharedPreferencesStore.create(),
    HiveLocalDatabase.open(secureStore),
  ).wait;

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        keyValueStoreProvider.overrideWithValue(keyValueStore),
        localDatabaseProvider.overrideWithValue(database),
        secureStoreProvider.overrideWithValue(secureStore),
        loggerProvider.overrideWithValue(logger),
        crashReporterProvider.overrideWithValue(crashReporter),
      ],
      child: const PennypathApp(),
    ),
  );
}
