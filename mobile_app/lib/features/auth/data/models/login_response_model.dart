import 'package:equatable/equatable.dart';

class LoginResponseModel extends Equatable {
  final String accessToken;
  final String? refreshToken;
  final UserModel user;

  const LoginResponseModel({
    required this.accessToken,
    this.refreshToken,
    required this.user,
  });
  // Factory constructor để tạo LoginResponseModel từ JSON, với khả năng xử lý các key khác nhau
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] ?? json['accessToken'] ?? "",
      refreshToken: json['refreshToken'] ?? json['refresh_token'],
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
  // chuyển LoginResponseModel thành JSON để gửi lên server hoặc lưu trữ
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }
  // props cho Equatable để so sánh
  @override
  List<Object?> get props => [accessToken, refreshToken, user];
}
 // Domain model cho User
class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
  });
  // Factory constructor để tạo UserModel từ JSON, với khả năng xử lý các key khác nhau
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['userId'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? json['fullName'] ?? '',
      avatar: json['avatar'],
    );
  }
  // chuyển UserModel thành JSON để gửi lên server hoặc lưu trữ
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'avatar': avatar};
  }
  // props cho Equatable để so sánh
  @override
  List<Object?> get props => [id, email, name, avatar];
}
