import '../../../../core/domain/user_data_store.dart';
import '../../../../core/services/analytics_service.dart';
import '../repositories/auth_repository.dart';

/// Syncs pending changes, ends the session and wipes every user-scoped store.
class SignOut {
  const SignOut({
    required this._auth,
    required this._userData,
    required this._analytics,
    this.flushTimeout = const Duration(seconds: 5),
  });

  final AuthRepository _auth;
  final List<UserDataStore> _userData;
  final AnalyticsService _analytics;
  final Duration flushTimeout;

  Future<void> call() async {
    await Future.wait(_userData.map(_flushQuietly));
    await _auth.signOut();
    await Future.wait(_userData.map((store) => store.clearUserData()));
    await _analytics.logEvent(AnalyticsEvent.signOut);
    await _analytics.setUserId(null);
  }

  Future<void> _flushQuietly(UserDataStore store) async {
    try {
      await store.flush().timeout(flushTimeout);
    } catch (_) {
      // Best effort: signing out must never be blocked by an upload.
    }
  }
}
