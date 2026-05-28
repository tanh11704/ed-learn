import '../models/exam_api_model.dart';
import '../models/exam_session_models.dart';

abstract class ExamRepository {
  Future<List<ExamApiModel>> getAvailableExams();
  Future<ExamApiModel> getExam(String examId);
  Future<ExamSessionModel> startExamSession({
    required String examId,
    required int durationMinutes,
    int gradeLevel = 12,
    String? className,
  });
  Future<void> saveDraftAnswer({
    required String sessionId,
    required String questionId,
    required String optionId,
  });
  Future<ExamSubmissionResult> submitExam({
    required String sessionId,
    required List<({String questionId, String optionId})> answers,
  });
  Future<ExamAttemptReview> getAttemptReview(String attemptId);
  Future<List<ExamAttemptSummary>> getMyAttempts();
}
