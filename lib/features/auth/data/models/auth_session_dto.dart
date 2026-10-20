import '../../../../core/storage/local_database.dart';
import 'user_dto.dart';

class AuthSessionDto {
  const AuthSessionDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
  });

  /// Accepts the API shape (`expiresIn` seconds) and the stored shape (`expiresAt`).
  factory AuthSessionDto.fromJson(JsonMap json, {DateTime? now}) {
    final expiresAt = json['expiresAt'] as String?;
    return AuthSessionDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: expiresAt != null
          ? DateTime.parse(expiresAt)
          : (now ?? DateTime.now()).toUtc().add(
              Duration(seconds: (json['expiresIn'] as num?)?.toInt() ?? 900),
            ),
      user: UserDto.fromJson(json['user'] as JsonMap),
    );
  }

  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final UserDto user;

  JsonMap toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'expiresAt': expiresAt.toUtc().toIso8601String(),
    'user': user.toJson(),
  };
}
