import '../../../../core/error/result.dart';
import '../entities/user.dart';

abstract interface class AuthRepository {
  /// Returns the stored user without a network call, so the app opens offline.
  Future<User?> restoreSession();

  Future<Result<User>> signIn({required String email, required String password});

  Future<Result<User>> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();

  /// Emits when the session can no longer be refreshed.
  Stream<void> get sessionExpired;
}
