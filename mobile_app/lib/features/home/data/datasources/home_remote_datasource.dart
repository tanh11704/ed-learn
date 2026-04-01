import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/core/services/token_storage_service.dart';
import '../models/user_model.dart';

abstract class HomeRemoteDataSource {
  Future<UserModel> getUserInfo();
}

class HomeRemoteDatasourceImpl implements HomeRemoteDataSource {
  final String baseUrl = 'https://api.phuocanh.me/api/v1';

  HomeRemoteDatasourceImpl();
  
  // Hàm lấy thông tin người dùng, sử dụng accessToken để xác thực
  @override
  Future<UserModel> getUserInfo() async {
    try {
      // Lấy token từ TokenStorageService
      final tokenStorage = TokenStorageService();
      final accessToken = await tokenStorage.getAccessToken();

      if (accessToken == null) {
        throw Exception('Access token not found. Please login again.');
      }

      final response = await http
          .get(
            // Gọi API để lấy thông tin người dùng
            Uri.parse('$baseUrl/users/me'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
          );
      // Xử lý phản hồi từ API
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
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
}
