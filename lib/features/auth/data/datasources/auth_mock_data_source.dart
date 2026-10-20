import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/mock/demo_account.dart';
import '../../../../core/mock/mock_network.dart';
import '../../../../core/storage/local_database.dart';
import '../models/auth_session_dto.dart';
import '../models/user_dto.dart';
import 'auth_remote_data_source.dart';

/// An on-device fake server. Passwords are salted and hashed even here.
class AuthMockDataSource implements AuthRemoteDataSource {
  AuthMockDataSource({required this._database, required this._network, Random? random})
    : _random = random ?? Random.secure();

  static const _usersCollection = 'mock_server_users';
  static const _hashRounds = 10000;

  final LocalDatabase _database;
  final MockNetwork _network;
  final Random _random;

  @override
  Future<AuthSessionDto> signIn({required String email, required String password}) async {
    await _network.roundTrip();
    final users = await _users();
    final record = await users.get(_key(email));
    if (record == null || _hash(password, record['salt'] as String) != record['passwordHash']) {
      throw const InvalidCredentialsException();
    }
    return _issueSession(UserDto.fromJson(record));
  }

  @override
  Future<AuthSessionDto> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await _network.roundTrip();
    final users = await _users();
    if (await users.get(_key(email)) != null) throw const EmailInUseException();
    final user = UserDto(id: const Uuid().v4(), name: name, email: email.trim());
    await _saveUser(users, user, password);
    return _issueSession(user);
  }

  @override
  Future<AuthSessionDto> refresh(String refreshToken) async {
    await _network.roundTrip();
    throw const UnauthorizedException('Mock sessions do not expire');
  }

  @override
  Future<void> signOut(String refreshToken) => _network.roundTrip();

  Future<LocalCollection> _users() async {
    final users = await _database.collection(_usersCollection);
    if (await users.get(_key(DemoAccount.email)) == null) {
      await _saveUser(
        users,
        const UserDto(id: 'demo-user', name: DemoAccount.name, email: DemoAccount.email),
        DemoAccount.password,
      );
    }
    return users;
  }

  Future<void> _saveUser(LocalCollection users, UserDto user, String password) {
    final salt = _token(16);
    return users.put(_key(user.email), {
      ...user.toJson(),
      'salt': salt,
      'passwordHash': _hash(password, salt),
    });
  }

  AuthSessionDto _issueSession(UserDto user) => AuthSessionDto(
    accessToken: _token(32),
    refreshToken: _token(32),
    expiresAt: DateTime.now().toUtc().add(const Duration(days: 30)),
    user: user,
  );

  String _key(String email) => email.trim().toLowerCase();

  String _token(int bytes) =>
      base64UrlEncode(List<int>.generate(bytes, (_) => _random.nextInt(256)));

  String _hash(String password, String salt) {
    List<int> digest = utf8.encode('$salt:$password');
    for (var i = 0; i < _hashRounds; i++) {
      digest = sha256.convert(digest).bytes;
    }
    return base64Encode(digest);
  }
}
