/// Cấu hình API backend EdLearn (OpenAPI: https://api.phuocanh.me/v3/api-docs)
class ApiConfig {
  static const String baseUrl = 'https://api.phuocanh.me/api/v1';
  static const String aiServiceBaseUrl = 'http://192.168.1.5:8001';
  static const String aiServiceKey = 'dev-ai-service-key';
  static const Duration requestTimeout = Duration(seconds: 15);
}
