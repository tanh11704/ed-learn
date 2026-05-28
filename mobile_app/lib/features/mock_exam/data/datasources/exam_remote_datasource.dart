import 'dart:convert';

import 'package:mobile_app/core/network/api_client.dart';

import '../models/exam_api_model.dart';
import '../models/exam_session_models.dart';

abstract class ExamRemoteDataSource {
  Future<List<ExamApiModel>> getAvailableExams();
  Future<ExamApiModel> getExam(String examId);
  Future<ExamSessionModel> startSession({
    required String examId,
    required int gradeLevel,
    String? className,
    required int durationMinutes,
  });
  Future<ExamSessionModel> getSession(String attemptId);
  Future<void> saveDraftAnswer({
    required String sessionId,
    required String questionId,
    required String optionId,
  });
  Future<ExamSubmissionResult> submitSession({
    required String sessionId,
    required List<({String questionId, String optionId})> answers,
  });
  Future<ExamAttemptReview> getAttemptReview(String attemptId);
  Future<List<ExamAttemptSummary>> getMyAttempts();
}

class ExamRemoteDataSourceImpl implements ExamRemoteDataSource {
  ExamRemoteDataSourceImpl({ApiClient? apiClient})
      : _client = apiClient ?? ApiClient();

  final ApiClient _client;

  @override
  Future<List<ExamApiModel>> getAvailableExams() async {
    final response = await _client.get('/exams');
    if (response.statusCode == 200) {
      return _parseExamList(response.body);
    }

    throw ApiException(
      _errorMessage(response.body, fallback: 'Không thể tải danh sách đề thi'),
      statusCode: response.statusCode,
    );
  }

  @override
  Future<ExamApiModel> getExam(String examId) async {
    _validateUuid(examId, 'examId');

    final response = await _client.get('/exams/$examId');
    if (response.statusCode == 200) {
      return ExamApiModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw ApiException(
      _errorMessage(response.body, fallback: 'Không thể tải thông tin đề thi'),
      statusCode: response.statusCode,
    );
  }

  @override
  Future<ExamSessionModel> startSession({
    required String examId,
    required int gradeLevel,
    String? className,
    required int durationMinutes,
  }) async {
    _validateUuid(examId, 'examId');
    if (gradeLevel < 1 || gradeLevel > 12) {
      throw const ApiException('Khối lớp phải từ 1 đến 12', statusCode: 400);
    }

    final body = <String, dynamic>{'gradeLevel': gradeLevel};
    if (className != null && className.trim().isNotEmpty) {
      body['className'] = className.trim();
    }

    final response = await _client.post(
      '/exams/$examId/attempts',
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ExamSessionModel.fromJson(
        json,
        examId: examId,
        fallbackDurationMinutes: durationMinutes,
      );
    }

    throw ApiException(
      _errorMessage(response.body, fallback: 'Không thể bắt đầu phiên thi'),
      statusCode: response.statusCode,
    );
  }

  @override
  Future<ExamSessionModel> getSession(String attemptId) async {
    _validateUuid(attemptId, 'attemptId');

    final response = await _client.get('/exams/attempts/$attemptId');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ExamSessionModel.fromJson(
        json,
        examId: (json['examId'] ?? '').toString(),
      );
    }

    throw ApiException(
      _errorMessage(response.body, fallback: 'Không thể khôi phục bài thi'),
      statusCode: response.statusCode,
    );
  }

  @override
  Future<void> saveDraftAnswer({
    required String sessionId,
    required String questionId,
    required String optionId,
  }) async {
    // Backend hiện chưa có draft-answer API. Mobile giữ đáp án trong state local.
  }

  @override
  Future<ExamSubmissionResult> submitSession({
    required String sessionId,
    required List<({String questionId, String optionId})> answers,
  }) async {
    _validateUuid(sessionId, 'attemptId');

    final body = {
      'answers': answers
          .map(
            (a) => {
              'questionId': a.questionId,
              'selectedOptionId': a.optionId,
              'answerText': null,
            },
          )
          .toList(),
    };

    final response = await _client.post(
      '/exams/attempts/$sessionId/submit',
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      if (json is Map<String, dynamic>) {
        return ExamSubmissionResult.fromJson(json);
      }
      return ExamSubmissionResult(
        submissionId: sessionId,
        status: 'SUBMITTED',
        message: 'Nộp bài thành công',
      );
    }

    throw ApiException(
      _errorMessage(response.body, fallback: 'Không thể nộp bài thi'),
      statusCode: response.statusCode,
    );
  }

  @override
  Future<ExamAttemptReview> getAttemptReview(String attemptId) async {
    _validateUuid(attemptId, 'attemptId');

    final response = await _client.get('/exams/attempts/$attemptId/review');
    if (response.statusCode == 200) {
      return ExamAttemptReview.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw ApiException(
      _errorMessage(response.body, fallback: 'Không thể tải đáp án chi tiết'),
      statusCode: response.statusCode,
    );
  }

  @override
  Future<List<ExamAttemptSummary>> getMyAttempts() async {
    final response = await _client.get('/exams/attempts/me');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final list = decoded is List
          ? decoded
          : (decoded is Map ? decoded['content'] as List? : null) ?? [];
      return list
          .map((e) => ExamAttemptSummary.fromJson(e as Map<String, dynamic>))
          .where((e) => e.id.isNotEmpty)
          .toList();
    }

    throw ApiException(
      _errorMessage(response.body, fallback: 'Không thể tải lịch sử làm bài'),
      statusCode: response.statusCode,
    );
  }

  List<ExamApiModel> _parseExamList(String body) {
    final decoded = jsonDecode(body);
    final list = decoded is List
        ? decoded
        : (decoded is Map ? decoded['content'] as List? : null) ?? [];
    return list
        .map((e) => ExamApiModel.fromJson(e as Map<String, dynamic>))
        .where((e) => e.id.isNotEmpty)
        .toList();
  }

  void _validateUuid(String value, String fieldName) {
    if (!_isUuid(value)) {
      throw ApiException(
        '$fieldName không hợp lệ. Vui lòng tải lại danh sách đề thi.',
        statusCode: 400,
      );
    }
  }

  bool _isUuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }

  String _errorMessage(String body, {required String fallback}) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'] ?? decoded['error'];
        if (message != null && message.toString().trim().isNotEmpty) {
          return message.toString();
        }
      }
    } catch (_) {}
    return fallback;
  }
}
