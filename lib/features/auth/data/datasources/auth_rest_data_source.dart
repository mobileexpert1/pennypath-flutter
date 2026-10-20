import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_session_dto.dart';
import 'auth_remote_data_source.dart';

/// Uses a client without the auth interceptor to avoid refresh loops.
class AuthRestDataSource implements AuthRemoteDataSource {
  const AuthRestDataSource(this._api);

  final ApiClient _api;

  @override
  Future<AuthSessionDto> signIn({required String email, required String password}) async {
    try {
      return await _session('/auth/login', {'email': email, 'password': password});
    } on UnauthorizedException {
      throw const InvalidCredentialsException();
    }
  }

  @override
  Future<AuthSessionDto> signUp({
    required String name,
    required String email,
    required String password,
  }) => _session('/auth/register', {'name': name, 'email': email, 'password': password});

  @override
  Future<AuthSessionDto> refresh(String refreshToken) =>
      _session('/auth/refresh', {'refreshToken': refreshToken});

  @override
  Future<void> signOut(String refreshToken) =>
      _api.post<void>('/auth/logout', body: {'refreshToken': refreshToken});

  Future<AuthSessionDto> _session(String path, Json body) async =>
      AuthSessionDto.fromJson(await _api.post<Json>(path, body: body));
}
