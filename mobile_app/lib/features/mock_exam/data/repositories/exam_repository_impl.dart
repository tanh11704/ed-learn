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
  Future<ExamApiModel> getExam(String examId) => _remote.getExam(examId);

  @override
  Future<ExamSessionModel> startExamSession({
    required String examId,
    required int durationMinutes,
    int gradeLevel = 12,
    String? className,
  }) async {
    final session = await _remote.startSession(
      examId: examId,
      gradeLevel: gradeLevel,
      className: className,
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
    // No draft-answer endpoint yet; ignore failures and keep answers in Bloc state.
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
  }) {
    return _remote.submitSession(
      sessionId: sessionId,
      answers: answers,
    );
  }

  @override
  Future<ExamAttemptReview> getAttemptReview(String attemptId) {
    return _remote.getAttemptReview(attemptId);
  }

  @override
  Future<List<ExamAttemptSummary>> getMyAttempts() {
    return _remote.getMyAttempts();
  }
}
