// đây là nơi nhận AuthEvent từ UI, xử lý logic xác thực (ví dụ: gọi API) và phát ra AuthState tương ứng để UI cập nhật giao diện
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/services/token_storage_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteDataSource remoteDataSource;

  AuthBloc(this.remoteDataSource)
      : super(const AuthState.initial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final email = event.email.trim();
      final password = event.password.trim();

      if (email.isEmpty || password.isEmpty) {
        emit(state.copyWith(
          status: AuthStatus.failure,
          message: 'Vui lòng nhập đầy đủ thông tin.',
        ));
        return;
      }

      // Gọi API login
      final response = await remoteDataSource.login(email, password);
      
      // Lưu token vào SharedPreferences
      final tokenStorage = TokenStorageService();
      await tokenStorage.saveTokens(response.accessToken, response.refreshToken);

      emit(state.copyWith(status: AuthStatus.authenticated));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        message: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final name = event.name.trim();
      final email = event.email.trim();
      final password = event.password.trim();

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        emit(state.copyWith(
          status: AuthStatus.failure,
          message: 'Vui lòng nhập đầy đủ thông tin.',
        ));
        return;
      }

      // Gọi API register
      final response = await remoteDataSource.register(name, email, password);
      
      // Lưu token vào SharedPreferences
      final tokenStorage = TokenStorageService();
      await tokenStorage.saveTokens(response.accessToken, response.refreshToken);

      emit(state.copyWith(status: AuthStatus.authenticated));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        message: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    try {
      final tokenStorage = TokenStorageService();
      final accessToken = await tokenStorage.getAccessToken();
      final refreshToken = await tokenStorage.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        // Token không tồn tại, xóa luôn
        await tokenStorage.clearTokens();
        await tokenStorage.clearCurrentUserEmail();
        // Giữ assessment status để lần sau đăng nhập không phải làm lại
        emit(state.copyWith(status: AuthStatus.unauthenticated));
        return;
      }

      // Gọi API logout
      await remoteDataSource.logout(accessToken, refreshToken);
      
      // Xóa token và email user hiện tại
      await tokenStorage.clearTokens();
      await tokenStorage.clearCurrentUserEmail();
      // Giữ assessment status để lần sau đăng nhập không phải làm lại
      
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    } catch (e) {
      // Dù API logout fail, vẫn xóa token local
      final tokenStorage = TokenStorageService();
      await tokenStorage.clearTokens();
      await tokenStorage.clearCurrentUserEmail();
      // Giữ assessment status để lần sau đăng nhập không phải làm lại
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }
}
