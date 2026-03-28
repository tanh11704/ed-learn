import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(String email, String password);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDataSource {
    final String baseUrl = 'http://api.phuocanh.me/api/v1';

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
}
