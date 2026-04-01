import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(String email, String password);
  Future<LoginResponseModel> register(String fullName, String email, String password);
  Future<LoginResponseModel> refreshToken(String refreshToken);
  Future<void> logout(String accessToken, String refreshToken);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDataSource {
    final String baseUrl = 'https://api.phuocanh.me/api/v1';

    @override
    Future<LoginResponseModel> login(String email, String password) async {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/login'),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception('Request timeout'),
        );
        if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return LoginResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid email or password');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<LoginResponseModel> register(String fullName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'fullName': fullName, 'email': email, 'password': password}),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return LoginResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 409) {
        throw Exception('Email already exists');
      } else if (response.statusCode == 400) {
        throw Exception('Invalid input data');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Register failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<LoginResponseModel> refreshToken(String refreshTokenValue) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'refreshToken': refreshTokenValue}),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return LoginResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Refresh token expired or invalid');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Refresh token failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<void> logout(String accessToken, String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'refreshToken': refreshToken}),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );
      if (response.statusCode == 200) {
        // Logout successful
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Logout failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
