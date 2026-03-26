// đây là nơi nhận AuthEvent từ UI, xử lý logic xác thực (ví dụ: gọi API) và phát ra AuthState tương ứng để UI cập nhật giao diện
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({AuthRepository? repository})
      : _repository = repository ?? AuthRepositoryImpl(AuthRemoteDataSource()),
        super(const AuthState.initial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _repository;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await _repository.login(email: event.email.trim(), password: event.password.trim());
      emit(state.copyWith(status: AuthStatus.authenticated));
    } catch (error) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        message: error.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await _repository.register(
        name: event.name.trim(),
        email: event.email.trim(),
        password: event.password.trim(),
      );
      emit(state.copyWith(status: AuthStatus.authenticated));
    } catch (error) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        message: error.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }
}
