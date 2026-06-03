/// Cấu hình API backend EdLearn.
class ApiConfig {
  static const String _baseUrl = String.fromEnvironment('API_BASE_URL');
  static const String _aiServiceBaseUrl = String.fromEnvironment(
    'AI_SERVICE_BASE_URL',
  );
  static const String _aiServiceKey = String.fromEnvironment('AI_SERVICE_KEY');

  static String get baseUrl =>
      _normalizeUrl(_requiredValue(_baseUrl, 'API_BASE_URL'));
  static String get aiServiceBaseUrl =>
      _normalizeUrl(_requiredValue(_aiServiceBaseUrl, 'AI_SERVICE_BASE_URL'));
  static String get aiServiceKey =>
      _requiredValue(_aiServiceKey, 'AI_SERVICE_KEY');
  static const Duration requestTimeout = Duration(seconds: 15);

  static String _requiredValue(String value, String name) {
    if (value.trim().isEmpty) {
      throw StateError(
        'Missing $name. Run Flutter with --dart-define-from-file=.env',
      );
    }
    return value;
  }

  static String _normalizeUrl(String value) {
    return value.trim().replaceFirst(RegExp(r'/+$'), '');
  }
}
