import '../../domain/entities/user_entity.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  UserEntity toEntity() {
    return UserEntity(id: id, name: name, email: email);
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(id: entity.id, name: entity.name, email: entity.email);
  }
}
