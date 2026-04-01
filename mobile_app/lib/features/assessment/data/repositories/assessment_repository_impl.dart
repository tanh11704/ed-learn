import '../../domain/entities/university.dart';
import '../../domain/repositories/assessment_repository.dart';
import '../../domain/entities/assessment_question.dart';
import '../datasources/assessment_mock_datasource.dart';

class AssessmentRepositoryImpl implements AssessmentRepository {
  final AssessmentMockDatasourceImpl _mockDataSource;

  AssessmentRepositoryImpl({AssessmentMockDatasourceImpl? mockDataSource})
      : _mockDataSource = mockDataSource ?? AssessmentMockDatasourceImpl();

  @override
  Future<List<University>> getUniversities() async {
    final data = await _mockDataSource.getUniversities();
    return data
        .map((item) => University(
              id: item['id'] as String,
              name: item['name'] as String,
              location: item['location'] as String,
              logoUrl: item['logo'] as String?,
            ))
        .toList();
  }

  @override
  Future<List<AssessmentQuestion>> getAssessmentQuestions() async {
    final data = await _mockDataSource.getQuestions('course1');
    return data
        .map((item) => AssessmentQuestion(
              id: int.parse(item['id'].toString().replaceAll('q', '')),
              content: item['content'] as String,
              options: List<String>.from(item['options'] as List),
              correctAnswer: item['correctAnswer'] as String,
              explanation: item['explanation'] as String,
            ))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getCourses() async {
    return await _mockDataSource.getCourses();
  }

  @override
  Future<List<Map<String, dynamic>>> getQuestions(String courseId) async {
    return await _mockDataSource.getQuestions(courseId);
  }

  @override
  Future<List<Map<String, dynamic>>> getMockExams() async {
    return await _mockDataSource.getMockExams();
  }
}
