import 'package:equatable/equatable.dart';

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
