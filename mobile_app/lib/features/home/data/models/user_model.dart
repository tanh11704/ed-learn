import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String? role;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['userId'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? json['fullName'] ?? '',
      avatar: json['avatar'],
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'role': role,
    };
  }

  @override
  List<Object?> get props => [id, email, name, avatar, role];
}
