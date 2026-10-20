import 'dart:async';

import 'package:pennypath/core/services/analytics_service.dart';
import 'package:pennypath/core/services/biometric_service.dart';
import 'package:pennypath/core/services/crash_reporter.dart';
import 'package:pennypath/core/storage/key_value_store.dart';
import 'package:pennypath/core/storage/local_database.dart';
import 'package:pennypath/core/storage/secure_store.dart';

class InMemoryLocalDatabase implements LocalDatabase {
  final _collections = <String, InMemoryCollection>{};

  @override
  Future<LocalCollection> collection(String name) async =>
      _collections.putIfAbsent(name, InMemoryCollection.new);
}

class InMemoryCollection implements LocalCollection {
  final _items = <String, JsonMap>{};
  final _changes = StreamController<void>.broadcast(sync: true);

  @override
  Future<JsonMap?> get(String id) async => _items[id];

  @override
  Future<List<JsonMap>> getAll() async => _items.values.toList();

  @override
  Future<void> put(String id, JsonMap value) async {
    _items[id] = Map.of(value);
    _changes.add(null);
  }

  @override
  Future<void> delete(String id) async {
    _items.remove(id);
    _changes.add(null);
  }

  @override
  Future<void> clear() async {
    _items.clear();
    _changes.add(null);
  }

  @override
  Stream<void> watch() => _changes.stream;
}

class InMemoryKeyValueStore implements KeyValueStore {
  final values = <String, Object>{};

  @override
  String? getString(String key) => values[key] as String?;

  @override
  bool? getBool(String key) => values[key] as bool?;

  @override
  Future<void> setString(String key, String value) async => values[key] = value;

  @override
  Future<void> setBool(String key, {required bool value}) async => values[key] = value;

  @override
  Future<void> remove(String key) async => values.remove(key);
}

class InMemorySecureStore implements SecureStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}

class FakeBiometricService implements BiometricService {
  FakeBiometricService({this.available = true, this.succeeds = true});

  bool available;
  bool succeeds;
  int prompts = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate(String reason) async {
    prompts++;
    return succeeds;
  }
}

class FakeAnalytics implements AnalyticsService {
  final events = <String>[];
  String? userId;

  @override
  Future<void> logEvent(String name, [Map<String, Object> parameters = const {}]) async =>
      events.add(name);

  @override
  Future<void> setUserId(String? userId) async => this.userId = userId;
}

class SilentCrashReporter implements CrashReporter {
  final errors = <Object>[];

  @override
  Future<void> recordError(Object error, StackTrace? stackTrace, {bool fatal = false}) async =>
      errors.add(error);

  @override
  Future<void> setUserId(String? userId) async {}
}
