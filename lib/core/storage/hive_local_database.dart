import 'dart:async';
import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';

import '../error/exceptions.dart';
import 'local_database.dart';
import 'secure_store.dart';

/// AES-256 encrypted Hive storage. The key never leaves the secure store.
class HiveLocalDatabase implements LocalDatabase {
  HiveLocalDatabase._(this._cipher);

  static const _keyName = 'local_db_encryption_key';

  static Future<HiveLocalDatabase> open(SecureStore secureStore) async {
    await Hive.initFlutter();
    var encoded = await secureStore.read(_keyName);
    if (encoded == null) {
      encoded = base64UrlEncode(Hive.generateSecureKey());
      await secureStore.write(_keyName, encoded);
    }
    return HiveLocalDatabase._(HiveAesCipher(base64Url.decode(encoded)));
  }

  final HiveAesCipher _cipher;
  final _collections = <String, Future<LocalCollection>>{};

  @override
  Future<LocalCollection> collection(String name) => _collections.putIfAbsent(name, () async {
    try {
      final box = await Hive.openBox<String>(name, encryptionCipher: _cipher);
      return _HiveCollection(box);
    } on Exception catch (e) {
      throw StorageException('Could not open $name: $e');
    }
  });
}

class _HiveCollection implements LocalCollection {
  _HiveCollection(this._box);

  final Box<String> _box;

  @override
  Future<JsonMap?> get(String id) async => _decode(_box.get(id));

  @override
  Future<List<JsonMap>> getAll() async => _box.values.map(_decode).whereType<JsonMap>().toList();

  @override
  Future<void> put(String id, JsonMap value) => _box.put(id, jsonEncode(value));

  @override
  Future<void> delete(String id) => _box.delete(id);

  @override
  Future<void> clear() => _box.clear();

  @override
  Stream<void> watch() => _box.watch().map((_) {});

  JsonMap? _decode(String? raw) => raw == null ? null : jsonDecode(raw) as JsonMap;
}
