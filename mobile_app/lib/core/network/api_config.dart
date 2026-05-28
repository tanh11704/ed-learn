/// Cấu hình API backend EdLearn (OpenAPI: https://api.phuocanh.me/v3/api-docs)
class ApiConfig {
  static const String baseUrl = 'https://api.phuocanh.me/api/v1';
  static const String aiServiceBaseUrl = 'https://dena-catagenetic-sultrily.ngrok-free.dev/';
  static const String aiServiceKey = 'dev-ai-service-key';
  static const Duration requestTimeout = Duration(seconds: 15);
}
