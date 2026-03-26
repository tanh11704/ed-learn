import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/config/app_env.dart';
import '../models/user_profile_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: AppEnv.mockApiBaseUrl));

  final Dio _dio;

  Future<UserProfileModel?> login({required String email, required String password}) async {
    try {
      debugPrint('[AuthRemote] login request -> ${_dio.options.baseUrl}/users?email=$email');
      final response = await _dio.get('/users', queryParameters: {
        'email': email,
      });
      debugPrint('[AuthRemote] login response -> status=${response.statusCode} data=${response.data}');

      if (response.data is List && (response.data as List).isNotEmpty) {
        final data = (response.data as List).first as Map<String, dynamic>;
        final storedPassword = data['password']?.toString() ?? '';
        if (storedPassword == password) {
          return UserProfileModel.fromJson(data);
        }
        debugPrint('[AuthRemote] login password mismatch for $email');
        return null;
      }

      debugPrint('[AuthRemote] login user not found for $email');
      return null;
    } catch (error, stackTrace) {
      debugPrint('[AuthRemote] login error -> $error');
      debugPrint('[AuthRemote] login stack -> $stackTrace');
      rethrow;
    }
  }

  Future<UserProfileModel> register({required String name, required String email, required String password}) async {
    try {
      debugPrint('[AuthRemote] register check -> ${_dio.options.baseUrl}/users?email=$email');
      final existing = await _dio.get('/users', queryParameters: {
        'email': email,
      });
      debugPrint('[AuthRemote] register check response -> status=${existing.statusCode} data=${existing.data}');

      if (existing.data is List && (existing.data as List).isNotEmpty) {
        throw Exception('Email đã tồn tại.');
      }

      debugPrint('[AuthRemote] register request -> ${_dio.options.baseUrl}/users');
      final response = await _dio.post('/users', data: {
        'name': name,
        'email': email,
        'password': password,
        'avatar': 'https://i.pravatar.cc/150?img=68',
        'xp_points': 0,
        'streak_days': 0,
        'target_score': 0
      });
      debugPrint('[AuthRemote] register response -> status=${response.statusCode} data=${response.data}');

      return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (error, stackTrace) {
      debugPrint('[AuthRemote] register error -> $error');
      debugPrint('[AuthRemote] register stack -> $stackTrace');
      rethrow;
    }
  }
}
