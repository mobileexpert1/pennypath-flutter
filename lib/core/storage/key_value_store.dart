import 'package:shared_preferences/shared_preferences.dart';

/// Non-sensitive preferences only. Use [SecureStore] for secrets.
abstract interface class KeyValueStore {
  String? getString(String key);
  bool? getBool(String key);
  Future<void> setString(String key, String value);
  Future<void> setBool(String key, {required bool value});
  Future<void> remove(String key);
}

class SharedPreferencesStore implements KeyValueStore {
  SharedPreferencesStore._(this._prefs);

  static Future<SharedPreferencesStore> create() async => SharedPreferencesStore._(
    await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    ),
  );

  final SharedPreferencesWithCache _prefs;

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<void> setString(String key, String value) => _prefs.setString(key, value);

  @override
  Future<void> setBool(String key, {required bool value}) => _prefs.setBool(key, value);

  @override
  Future<void> remove(String key) => _prefs.remove(key);
}
