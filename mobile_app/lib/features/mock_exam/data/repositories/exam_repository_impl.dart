import '../datasources/exam_remote_datasource.dart';
import '../models/exam_api_model.dart';
import '../models/exam_session_models.dart';
import 'exam_repository.dart';

class ExamRepositoryImpl implements ExamRepository {
  ExamRepositoryImpl({ExamRemoteDataSource? remoteDataSource})
      : _remote = remoteDataSource ?? ExamRemoteDataSourceImpl();

  final ExamRemoteDataSource _remote;

  @override
  Future<List<ExamApiModel>> getAvailableExams() => _remote.getAvailableExams();

  @override
  Future<ExamSessionModel> startExamSession({
    required String examId,
    required int durationMinutes,
  }) async {
    final session = await _remote.startSession(
      examId: examId,
      durationMinutes: durationMinutes,
    );
    if (session.questions.isEmpty) {
      throw Exception('Đề thi chưa có câu hỏi');
    }
    return session;
  }

  @override
  Future<void> saveDraftAnswer({
    required String sessionId,
    required String questionId,
    required String optionId,
  }) async {
    try {
      await _remote.saveDraftAnswer(
        sessionId: sessionId,
        questionId: questionId,
        optionId: optionId,
      );
    } catch (_) {}
  }

  @override
  Future<ExamSubmissionResult> submitExam({
    required String sessionId,
    required List<({String questionId, String optionId})> answers,
  }) async {
    return _remote.submitSession(
      sessionId: sessionId,
      answers: answers,
    );
  }
}
