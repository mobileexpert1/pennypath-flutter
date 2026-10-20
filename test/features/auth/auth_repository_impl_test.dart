import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypath/core/error/exceptions.dart';
import 'package:pennypath/core/error/failure.dart';
import 'package:pennypath/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:pennypath/features/auth/data/datasources/session_storage.dart';
import 'package:pennypath/features/auth/data/models/auth_session_dto.dart';
import 'package:pennypath/features/auth/data/models/user_dto.dart';
import 'package:pennypath/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pennypath/features/auth/domain/entities/user.dart';

import '../../helpers/fakes.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

AuthSessionDto _session(String token) => AuthSessionDto(
  accessToken: token,
  refreshToken: 'refresh-$token',
  expiresAt: DateTime.utc(2030),
  user: const UserDto(id: 'u1', name: 'Alex', email: 'alex@mail.com'),
);

void main() {
  late _MockRemote remote;
  late InMemorySecureStore secureStore;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    secureStore = InMemorySecureStore();
    repository = AuthRepositoryImpl(
      remote: remote,
      session: SessionStorage(secureStore),
      crashReporter: SilentCrashReporter(),
    );
  });

  test('signIn trims the email, stores the session and returns the user', () async {
    when(
      () => remote.signIn(email: 'alex@mail.com', password: 'pw'),
    ).thenAnswer((_) async => _session('a1'));

    final result = await repository.signIn(email: '  alex@mail.com ', password: 'pw');

    expect(result.valueOrNull, const User(id: 'u1', name: 'Alex', email: 'alex@mail.com'));
    expect(await repository.accessToken(), 'a1');
    expect(secureStore.values.keys, contains('auth_session'));
  });

  test('signIn maps data errors to failures and stores nothing', () async {
    when(
      () => remote.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(const InvalidCredentialsException());

    final result = await repository.signIn(email: 'a@b.co', password: 'x');

    expect(result.failureOrNull, const InvalidCredentialsFailure());
    expect(secureStore.values, isEmpty);
  });

  test('restoreSession works offline from the secure store', () async {
    when(
      () => remote.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => _session('a1'));
    await repository.signIn(email: 'alex@mail.com', password: 'pw');

    final restored = AuthRepositoryImpl(
      remote: remote,
      session: SessionStorage(secureStore),
      crashReporter: SilentCrashReporter(),
    );
    expect((await restored.restoreSession())?.id, 'u1');
  });

  test('refreshAccessToken rotates tokens; an unauthorized refresh returns null', () async {
    when(
      () => remote.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => _session('a1'));
    await repository.signIn(email: 'alex@mail.com', password: 'pw');

    when(() => remote.refresh('refresh-a1')).thenAnswer((_) async => _session('a2'));
    expect(await repository.refreshAccessToken(), 'a2');

    when(() => remote.refresh('refresh-a2')).thenThrow(const UnauthorizedException());
    expect(await repository.refreshAccessToken(), isNull);
  });

  test('signOut clears the session even when the server is unreachable', () async {
    when(
      () => remote.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => _session('a1'));
    when(() => remote.signOut(any())).thenThrow(const NetworkException());
    await repository.signIn(email: 'alex@mail.com', password: 'pw');

    await repository.signOut();

    expect(await repository.restoreSession(), isNull);
    expect(secureStore.values, isEmpty);
  });

  test('onSessionExpired clears the session and notifies listeners', () async {
    final expired = expectLater(repository.sessionExpired, emits(null));
    repository.onSessionExpired();
    await expired;
  });
}
