import 'dart:convert';

import 'package:mobile_app/core/network/api_client.dart';
import '../models/user_model.dart';
import '../models/user_streak_model.dart';

abstract class HomeRemoteDataSource {
  Future<UserModel> getUserInfo();
  Future<UserStreakModel> getUserStreak();
  Future<UserModel> updateUserProfile({required String fullName});
}

class HomeRemoteDatasourceImpl implements HomeRemoteDataSource {
  HomeRemoteDatasourceImpl({ApiClient? apiClient})
    : _client = apiClient ?? ApiClient();

  final ApiClient _client;

  @override
  Future<UserModel> getUserInfo() async {
    try {
      final response = await _client.get('/users/me');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return UserModel.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - token expired or invalid');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Get user info failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<UserStreakModel> getUserStreak() async {
    try {
      final response = await _client.get('/user-streaks/me');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return UserStreakModel.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - token expired or invalid');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Get user streak failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<UserModel> updateUserProfile({required String fullName}) async {
    try {
      final response = await _client.put(
        '/users/me',
        body: {'fullName': fullName.trim()},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return UserModel.fromJson(jsonResponse);
      } else if (response.statusCode == 400) {
        throw Exception('Dữ liệu không hợp lệ');
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception('Cập nhật hồ sơ thất bại: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error: $e');
    }
  }
}
