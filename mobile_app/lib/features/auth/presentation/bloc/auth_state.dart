import 'package:equatable/equatable.dart';
// các trạng thái của quá trình xác thực người dùng, bao gồm: mặc định, đang xử lý, đăng nhập OK, chưa đăng nhập hoặc đã logout, lỗi
enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.message,
  });

  final AuthStatus status;
  final String? message;
  // trạng thái mặc định khi khởi tạo, chưa có hành động nào được thực hiện
  const AuthState.initial() : this(status: AuthStatus.initial);
  
  AuthState copyWith({
    AuthStatus? status,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
