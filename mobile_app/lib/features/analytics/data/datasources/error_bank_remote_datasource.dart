import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/core/services/token_storage_service.dart';
import '../models/error_bank_models.dart';

abstract class ErrorBankRemoteDataSource {
  Future<List<ErrorBankCard>> getDueCards({int limit});
  Future<void> reviewCard({required String id, required int quality});
}

class ErrorBankRemoteDataSourceImpl implements ErrorBankRemoteDataSource {
  final String baseUrl = 'https://api.phuocanh.me/api/v1';

  @override
  Future<List<ErrorBankCard>> getDueCards({int limit = 50}) async {
    try {
      final tokenStorage = TokenStorageService();
      final accessToken = await tokenStorage.getAccessToken();

      if (accessToken == null) {
        throw Exception('Access token not found. Please login again.');
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/learning/error-bank/due?limit=$limit'),
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

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as List<dynamic>;
        return jsonResponse
            .map((item) => ErrorBankCard.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - token expired or invalid');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Get error bank failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<void> reviewCard({required String id, required int quality}) async {
    try {
      final tokenStorage = TokenStorageService();
      final accessToken = await tokenStorage.getAccessToken();

      if (accessToken == null) {
        throw Exception('Access token not found. Please login again.');
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/learning/error-bank/$id/review'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode({'quality': quality}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - token expired or invalid');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Review error bank failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
