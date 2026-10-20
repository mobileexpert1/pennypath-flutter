import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypath/app/router/app_router.dart';
import 'package:pennypath/app/router/routes.dart';
import 'package:pennypath/features/auth/domain/entities/user.dart';

void main() {
  const user = User(id: 'u1', name: 'Alex', email: 'a@b.co');

  String? redirect(String location, AsyncValue<User?> auth, {bool locked = false}) =>
      resolveRedirect(location: location, auth: auth, locked: locked);

  test('shows the splash while the session is restored', () {
    expect(redirect(Routes.dashboard, const AsyncLoading()), Routes.splash);
    expect(redirect(Routes.splash, const AsyncLoading()), isNull);
  });

  test('signed-out users can only see the auth screen', () {
    expect(redirect(Routes.transactions, const AsyncData(null)), Routes.auth);
    expect(redirect(Routes.auth, const AsyncData(null)), isNull);
  });

  test('a locked app always goes to the lock screen', () {
    expect(redirect(Routes.settings, const AsyncData(user), locked: true), Routes.lock);
  });

  test('signed-in users leave gate screens and keep deep links', () {
    expect(redirect(Routes.auth, const AsyncData(user)), Routes.dashboard);
    expect(redirect(Routes.lock, const AsyncData(user)), Routes.dashboard);
    expect(redirect(Routes.editTransaction('42'), const AsyncData(user)), isNull);
  });
}
