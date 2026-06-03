import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:mobile_app/core/network/api_config.dart';

import '../models/ai_solver_solution_model.dart';

class AiSolverRemoteDataSource {
  final http.Client _client;

  AiSolverRemoteDataSource({http.Client? client})
    : _client = client ?? http.Client();

  Future<AiSolverSolution> solveImage({
    required File image,
    String subject = 'math',
    String gradeLevel = '12',
    String language = 'vi',
    String mode = 'single_question',
    String? courseId,
    String? lessonId,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.aiServiceBaseUrl}/api/v1/solver/solve-image'),
    );

    request.headers['X-AI-Service-Key'] = ApiConfig.aiServiceKey;
    request.fields.addAll({
      'subject': subject,
      'grade_level': gradeLevel,
      'language': language,
      'mode': mode,
      if (courseId != null && courseId.isNotEmpty) 'course_id': courseId,
      if (lessonId != null && lessonId.isNotEmpty) 'lesson_id': lessonId,
    });

    final mimeType =
        lookupMimeType(image.path) ?? _fallbackMimeType(image.path);
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType.parse(mimeType),
      ),
    );

    final streamedResponse = await _client
        .send(request)
        .timeout(ApiConfig.requestTimeout);
    final response = await http.Response.fromStream(streamedResponse);
    final body = response.body.isEmpty ? null : jsonDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_errorMessage(response.statusCode, body));
    }

    return AiSolverSolution.fromJson(body as Map<String, dynamic>);
  }

  String _errorMessage(int statusCode, Object? body) {
    if (body is Map<String, dynamic>) {
      final message = body['message'] ?? body['error'] ?? body['detail'];
      if (message != null) return message.toString();
    }
    if (statusCode == 401) return 'Không có quyền gọi AI service.';
    if (statusCode == 400) {
      return 'AI service không nhận định dạng ảnh. Hãy thử ảnh JPG, PNG hoặc WEBP rõ nét.';
    }
    if (statusCode == 413) {
      return 'Ảnh quá lớn, vui lòng thử lại với ảnh đã nén.';
    }
    if (statusCode == 502) {
      return 'AI chưa trả về đúng định dạng. Vui lòng thử lại.';
    }
    if (statusCode == 503) {
      return 'AI đang bận hoặc quá thời gian xử lý. Vui lòng thử lại sau.';
    }
    return 'AI Solver lỗi HTTP $statusCode.';
  }

  String _fallbackMimeType(String path) {
    final lowerPath = path.toLowerCase();
    if (lowerPath.endsWith('.png')) return 'image/png';
    if (lowerPath.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
