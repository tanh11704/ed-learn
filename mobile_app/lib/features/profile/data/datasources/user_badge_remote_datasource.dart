import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/services/token_storage_service.dart';
import '../models/user_badge_models.dart';

abstract class UserBadgeRemoteDataSource {
  Future<PageUserBadgeResponse> getMyBadges({int page, int size});
}

class UserBadgeRemoteDataSourceImpl implements UserBadgeRemoteDataSource {
  final String baseUrl = 'https://api.phuocanh.me/api/v1';

  @override
  Future<PageUserBadgeResponse> getMyBadges({int page = 0, int size = 10}) async {
    try {
      final tokenStorage = TokenStorageService();
      final accessToken = await tokenStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception('Access token not found. Please login again.');
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/user-badges/me?page=$page&size=$size'),
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
        final jsonResponse = jsonDecode(response.body);
        return PageUserBadgeResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - token expired or invalid');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Get badges failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
