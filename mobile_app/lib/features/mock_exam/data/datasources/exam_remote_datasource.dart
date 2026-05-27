import 'dart:convert';

import 'package:mobile_app/core/network/api_client.dart';

import '../models/exam_api_model.dart';
import '../models/exam_session_models.dart';

abstract class ExamRemoteDataSource {
  Future<List<ExamApiModel>> getAvailableExams();
  Future<ExamSessionModel> startSession({
    required String examId,
    required int durationMinutes,
  });
  Future<ExamSessionModel> getSession(String sessionId);
  Future<void> saveDraftAnswer({
    required String sessionId,
    required String questionId,
    required String optionId,
  });
  Future<ExamSubmissionResult> submitSession({
    required String sessionId,
    required List<({String questionId, String optionId})> answers,
  });
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
      'Không thể tải danh sách đề thi',
      statusCode: response.statusCode,
    );
  }

  @override
  Future<ExamSessionModel> startSession({
    required String examId,
    required int durationMinutes,
  }) async {
    if (!_isUuid(examId)) {
      throw Exception('Offline exam does not have a backend UUID');
    }

    final response = await _client.post(
      '/exams/$examId/attempts',
      body: const {'gradeLevel': 12},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final session = ExamSessionModel.fromJson(
        json,
        examId: examId,
        fallbackDurationMinutes: durationMinutes,
      );
      if (session.questions.isNotEmpty) {
        return _ensureSessionId(session, examId);
      }
    }

    throw Exception('Không thể bắt đầu phiên thi: ${response.statusCode}');
  }

  @override
  Future<ExamSessionModel> getSession(String sessionId) async {
    final response = await _client.get('/exams/attempts/$sessionId');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ExamSessionModel.fromJson(json, examId: json['examId']?.toString() ?? '');
    }
    throw Exception('Get session failed: ${response.statusCode}');
  }

  @override
  Future<void> saveDraftAnswer({
    required String sessionId,
    required String questionId,
    required String optionId,
  }) async {
    return;
  }

  @override
  Future<ExamSubmissionResult> submitSession({
    required String sessionId,
    required List<({String questionId, String optionId})> answers,
  }) async {
    final body = {
      'answers': answers
          .map(
            (a) => {
              'questionId': a.questionId,
              'selectedOptionId': a.optionId,
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
      return const ExamSubmissionResult(
        status: 'SUBMITTED',
        message: 'Nộp bài thành công',
      );
    }

    throw Exception('Submit exam failed: ${response.statusCode}');
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

  ExamSessionModel _ensureSessionId(ExamSessionModel session, String examId) {
    if (session.sessionId.isNotEmpty) return session;
    return ExamSessionModel(
      sessionId: 'local-$examId-${DateTime.now().millisecondsSinceEpoch}',
      examId: session.examId.isNotEmpty ? session.examId : examId,
      durationMinutes: session.durationMinutes,
      questions: session.questions,
    );
  }

  bool _isUuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }
}
