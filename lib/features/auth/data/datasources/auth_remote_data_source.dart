import '../models/auth_session_dto.dart';

/// The only contract a new auth backend (REST, Firebase, Supabase…) must fulfil.
abstract interface class AuthRemoteDataSource {
  Future<AuthSessionDto> signIn({required String email, required String password});

  Future<AuthSessionDto> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthSessionDto> refresh(String refreshToken);

  Future<void> signOut(String refreshToken);
}
