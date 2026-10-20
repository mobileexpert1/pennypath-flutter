import '../../../../core/storage/local_database.dart';
import '../../domain/entities/user.dart';

class UserDto {
  const UserDto({required this.id, required this.name, required this.email});

  factory UserDto.fromJson(JsonMap json) => UserDto(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
  );

  final String id;
  final String name;
  final String email;

  JsonMap toJson() => {'id': id, 'name': name, 'email': email};

  User toEntity() => User(id: id, name: name, email: email);
}
