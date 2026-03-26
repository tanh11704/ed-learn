import '../entities/university.dart';
import '../entities/assessment_question.dart';

abstract class AssessmentRepository {
  Future<List<University>> getUniversities();
  Future<List<AssessmentQuestion>> getAssessmentQuestions();
}
