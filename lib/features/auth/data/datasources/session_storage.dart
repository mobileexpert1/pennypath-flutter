import 'dart:convert';

import '../../../../core/storage/local_database.dart';
import '../../../../core/storage/secure_store.dart';
import '../models/auth_session_dto.dart';

/// Persists the session in the secure store with an in-memory cache.
class SessionStorage {
  SessionStorage(this._store);

  static const _key = 'auth_session';

  final SecureStore _store;
  AuthSessionDto? _cached;
  bool _loaded = false;

  Future<AuthSessionDto?> read() async {
    if (_loaded) return _cached;
    final raw = await _store.read(_key);
    _cached = raw == null ? null : AuthSessionDto.fromJson(jsonDecode(raw) as JsonMap);
    _loaded = true;
    return _cached;
  }

  Future<void> save(AuthSessionDto session) async {
    await _store.write(_key, jsonEncode(session.toJson()));
    _cached = session;
    _loaded = true;
  }

  Future<void> clear() async {
    await _store.delete(_key);
    _cached = null;
    _loaded = true;
  }
}
