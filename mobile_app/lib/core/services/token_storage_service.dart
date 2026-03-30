import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  /// Lưu cặp token vào SharedPreferences
  Future<void> saveTokens(String accessToken, String? refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    if (refreshToken != null) {
      await prefs.setString(_refreshTokenKey, refreshToken);
    }
  }

  /// Lấy access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Lấy refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Xóa cả 2 token khi logout
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  /// Kiểm tra xem có token không
  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_accessTokenKey);
  }

  /// Lưu trạng thái hoàn thành bài test đầu vào theo email
  Future<void> setAssessmentCompleted(String email, bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getAssessmentKey(email);
    await prefs.setBool(key, completed);
  }

  /// Kiểm tra xem user đã hoàn thành bài test đầu vào chưa
  Future<bool> hasCompletedAssessment(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getAssessmentKey(email);
    return prefs.getBool(key) ?? false;
  }

  /// Xóa trạng thái assessment (dùng khi logout) - GHI CHÚ: Assessment status KHÔNG xóa
  /// vì user không cần làm lại assessment sau logout
  Future<void> clearAssessmentStatus() async {
    // Không xóa assessment status - lưu lâu dài cho user
    return;
  }

  /// Helper: Tạo key cho assessment status
  String _getAssessmentKey(String email) {
    return 'assessment_completed_${email.toLowerCase()}';
  }

  /// Lưu email của user hiện tại
  Future<void> saveCurrentUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    const currentUserEmailKey = 'current_user_email';
    await prefs.setString(currentUserEmailKey, email.toLowerCase());
  }

  /// Lấy email của user hiện tại
  Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    const currentUserEmailKey = 'current_user_email';
    return prefs.getString(currentUserEmailKey);
  }

  /// Xóa email user khi logout
  Future<void> clearCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    const currentUserEmailKey = 'current_user_email';
    await prefs.remove(currentUserEmailKey);
  }
}
