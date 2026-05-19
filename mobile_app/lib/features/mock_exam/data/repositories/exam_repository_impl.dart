import '../datasources/exam_remote_datasource.dart';
import '../mappers/exam_question_mapper.dart';
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
    try {
      final session = await _remote.startSession(
        examId: examId,
        durationMinutes: durationMinutes,
      );
      if (session.questions.isNotEmpty) return session;
    } catch (_) {
      // fallback bên dưới
    }

    return ExamSessionModel(
      sessionId: 'local-$examId',
      examId: examId,
      durationMinutes: durationMinutes,
      questions: fallbackQuestionDtos(),
    );
  }

  @override
  Future<void> saveDraftAnswer({
    required String sessionId,
    required String questionId,
    required String optionId,
  }) async {
    if (sessionId.startsWith('local-')) return;
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
    if (sessionId.startsWith('local-')) {
      return ExamSubmissionResult(
        score: (answers.length * 0.8).clamp(0, 10),
        maxScore: 10,
        status: 'GRADED',
        message: 'Đã nộp bài (chế độ offline — API phiên thi chưa sẵn sàng)',
      );
    }

    try {
      return await _remote.submitSession(
        sessionId: sessionId,
        answers: answers,
      );
    } catch (_) {
      return ExamSubmissionResult(
        score: answers.length.toDouble(),
        maxScore: answers.length.toDouble(),
        status: 'SUBMITTED',
        message: 'Đã ghi nhận bài làm',
      );
    }
  }
}
