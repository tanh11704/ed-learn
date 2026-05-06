import 'package:equatable/equatable.dart';

class LoginResponseModel extends Equatable {
  final String accessToken;
  final String? refreshToken;
  final String? tokenType;

  const LoginResponseModel({
    required this.accessToken,
    this.refreshToken,
    this.tokenType,
  });
  // Factory constructor để tạo LoginResponseModel từ JSON, với khả năng xử lý các key khác nhau
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? json['refresh_token'],
      tokenType: json['tokenType'] ?? json['token_type'],
    );
  }
  // chuyển LoginResponseModel thành JSON để gửi lên server hoặc lưu trữ
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
    };
  }
  // props cho Equatable để so sánh
  @override
  List<Object?> get props => [accessToken, refreshToken, tokenType];
}
