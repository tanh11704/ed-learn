import 'dart:convert';

import 'package:http/http.dart' as http;

import '../services/token_storage_service.dart';
import 'api_config.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;

  const ApiException(this.message, {this.statusCode});

  static const unauthorized = ApiException('Unauthorized', statusCode: 401);

  @override
  String toString() => message;
}

/// HTTP client dùng chung: gắn Bearer token và tự refresh khi 401.
class ApiClient {
  ApiClient({TokenStorageService? tokenStorage})
    : _tokenStorage = tokenStorage ?? TokenStorageService();

  final TokenStorageService _tokenStorage;

  Map<String, String> get _jsonHeaders => const {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<http.Response> get(
    String path, {
    bool auth = true,
    Map<String, String>? queryParameters,
  }) {
    return _send(
      (headers) => http.get(_uri(path, queryParameters), headers: headers),
      auth: auth,
    );
  }

  Future<http.Response> post(String path, {bool auth = true, Object? body}) {
    return _send(
      (headers) => http.post(
        _uri(path),
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      ),
      auth: auth,
    );
  }

  Future<http.Response> put(String path, {bool auth = true, Object? body}) {
    return _send(
      (headers) => http.put(
        _uri(path),
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      ),
      auth: auth,
    );
  }

  Future<http.Response> patch(String path, {bool auth = true, Object? body}) {
    return _send(
      (headers) => http.patch(
        _uri(path),
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      ),
      auth: auth,
    );
  }

  Uri _uri(String path, [Map<String, String>? queryParameters]) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return Uri.parse(
      '${ApiConfig.baseUrl}$normalized',
    ).replace(queryParameters: queryParameters);
  }

  Future<http.Response> _send(
    Future<http.Response> Function(Map<String, String> headers) request, {
    required bool auth,
  }) async {
    final headers = Map<String, String>.from(_jsonHeaders);

    if (auth) {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw ApiException.unauthorized;
      }
      headers['Authorization'] = 'Bearer $token';
    }

    var response = await request(headers).timeout(ApiConfig.requestTimeout);

    if (auth && response.statusCode == 401) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        final newToken = await _tokenStorage.getAccessToken();
        if (newToken != null) {
          headers['Authorization'] = 'Bearer $newToken';
          response = await request(headers).timeout(ApiConfig.requestTimeout);
        }
      }
    }

    return response;
  }

  Future<bool> _refreshAccessToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/auth/refresh'),
            headers: _jsonHeaders,
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode != 200) return false;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final accessToken = json['accessToken'] as String?;
      if (accessToken == null || accessToken.isEmpty) return false;

      final newRefresh = json['refreshToken'] as String? ?? refreshToken;
      await _tokenStorage.saveTokens(accessToken, newRefresh);
      return true;
    } catch (_) {
      return false;
    }
  }
}
