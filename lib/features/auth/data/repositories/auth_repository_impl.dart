import 'dart:async';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/guard.dart';
import '../../../../core/error/result.dart';
import '../../../../core/network/auth_interceptor.dart';
import '../../../../core/services/crash_reporter.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/session_storage.dart';
import '../models/auth_session_dto.dart';

class AuthRepositoryImpl implements AuthRepository, AccessTokenProvider {
  AuthRepositoryImpl({required this._remote, required this._session, required this._crashReporter});

  final AuthRemoteDataSource _remote;
  final SessionStorage _session;
  final CrashReporter _crashReporter;
  final _expired = StreamController<void>.broadcast();

  @override
  Stream<void> get sessionExpired => _expired.stream;

  @override
  Future<User?> restoreSession() async {
    try {
      return (await _session.read())?.user.toEntity();
    } on Exception catch (e, stack) {
      await _crashReporter.recordError(e, stack);
      await _session.clear();
      return null;
    }
  }

  @override
  Future<Result<User>> signIn({required String email, required String password}) =>
      _authenticate(() => _remote.signIn(email: email.trim(), password: password));

  @override
  Future<Result<User>> signUp({
    required String name,
    required String email,
    required String password,
  }) => _authenticate(
    () => _remote.signUp(name: name.trim(), email: email.trim(), password: password),
  );

  @override
  Future<void> signOut() async {
    final current = await _session.read();
    await _session.clear();
    if (current == null) return;
    try {
      await _remote.signOut(current.refreshToken);
    } on AppException {
      // Local sign-out must succeed even when the server is unreachable.
    }
  }

  @override
  Future<String?> accessToken() async => (await _session.read())?.accessToken;

  @override
  Future<String?> refreshAccessToken() async {
    final current = await _session.read();
    if (current == null) return null;
    try {
      final renewed = await _remote.refresh(current.refreshToken);
      await _session.save(renewed);
      return renewed.accessToken;
    } on UnauthorizedException {
      return null;
    } on AppException {
      // Offline: keep the session and let the request fail as a network error.
      return current.accessToken;
    }
  }

  @override
  void onSessionExpired() {
    unawaited(_session.clear());
    _expired.add(null);
  }

  Future<Result<User>> _authenticate(Future<AuthSessionDto> Function() call) => guard(() async {
    final session = await call();
    await _session.save(session);
    return session.user.toEntity();
  }, reporter: _crashReporter);
}
