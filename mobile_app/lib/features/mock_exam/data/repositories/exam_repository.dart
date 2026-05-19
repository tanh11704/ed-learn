import '../models/exam_api_model.dart';
import '../models/exam_session_models.dart';

abstract class ExamRepository {
  Future<List<ExamApiModel>> getAvailableExams();
  Future<ExamSessionModel> startExamSession({
    required String examId,
    required int durationMinutes,
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
}
