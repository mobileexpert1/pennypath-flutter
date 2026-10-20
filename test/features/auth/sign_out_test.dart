import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypath/core/domain/user_data_store.dart';
import 'package:pennypath/core/services/analytics_service.dart';
import 'package:pennypath/features/auth/domain/repositories/auth_repository.dart';
import 'package:pennypath/features/auth/domain/usecases/sign_out.dart';

import '../../helpers/fakes.dart';

class _MockAuth extends Mock implements AuthRepository {}

class _MockStore extends Mock implements UserDataStore {}

void main() {
  late _MockAuth auth;
  late _MockStore store;
  late FakeAnalytics analytics;

  setUp(() {
    auth = _MockAuth();
    store = _MockStore();
    analytics = FakeAnalytics()..userId = 'u1';
    when(() => auth.signOut()).thenAnswer((_) async {});
    when(() => store.clearUserData()).thenAnswer((_) async {});
  });

  SignOut build({Duration timeout = const Duration(seconds: 5)}) =>
      SignOut(auth: auth, userData: [store], analytics: analytics, flushTimeout: timeout);

  test('flushes, signs out and then wipes user data in order', () async {
    when(() => store.flush()).thenAnswer((_) async {});

    await build().call();

    verifyInOrder([() => store.flush(), () => auth.signOut(), () => store.clearUserData()]);
    expect(analytics.events, [AnalyticsEvent.signOut]);
    expect(analytics.userId, isNull);
  });

  test('still signs out when flushing hangs or fails', () async {
    when(() => store.flush()).thenAnswer((_) => Future<void>.delayed(const Duration(hours: 1)));
    await build(timeout: const Duration(milliseconds: 10)).call();

    when(() => store.flush()).thenThrow(Exception('offline'));
    await build().call();

    verify(() => store.clearUserData()).called(2);
  });
}
