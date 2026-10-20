import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/auth_providers.dart';
import '../../../../app/di/core_providers.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/analytics_service.dart';
import '../../domain/entities/user.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, User?>(AuthController.new);

/// Holds the signed-in user. `null` means signed out.
class AuthController extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final repository = ref.watch(authRepositoryProvider);
    final subscription = repository.sessionExpired.listen((_) => unawaited(signOut()));
    ref.onDispose(subscription.cancel);

    final user = await repository.restoreSession();
    await _identify(user);
    return user;
  }

  /// Returns a failure for the form to show; state only changes on success.
  Future<Failure?> signIn({required String email, required String password}) => _authenticate(
    () => ref.read(authRepositoryProvider).signIn(email: email, password: password),
    AnalyticsEvent.signIn,
  );

  Future<Failure?> signUp({
    required String name,
    required String email,
    required String password,
  }) => _authenticate(
    () => ref.read(authRepositoryProvider).signUp(name: name, email: email, password: password),
    AnalyticsEvent.signUp,
  );

  Future<void> signOut() async {
    await ref.read(signOutProvider).call();
    await ref.read(crashReporterProvider).setUserId(null);
    state = const AsyncData(null);
  }

  Future<Failure?> _authenticate(Future<Result<User>> Function() action, String event) async {
    final result = await action();
    switch (result) {
      case Success(:final value):
        await _identify(value);
        await ref.read(analyticsProvider).logEvent(event);
        state = AsyncData(value);
        return null;
      case Err(:final failure):
        return failure;
    }
  }

  Future<void> _identify(User? user) async {
    await ref.read(analyticsProvider).setUserId(user?.id);
    await ref.read(crashReporterProvider).setUserId(user?.id);
  }
}
