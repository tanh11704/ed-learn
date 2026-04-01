import '../entities/university.dart';
import '../entities/assessment_question.dart';

abstract class AssessmentRepository {
  Future<List<University>> getUniversities();
  Future<List<AssessmentQuestion>> getAssessmentQuestions();
  Future<List<Map<String, dynamic>>> getCourses();
  Future<List<Map<String, dynamic>>> getQuestions(String courseId);
  Future<List<Map<String, dynamic>>> getMockExams();
}
