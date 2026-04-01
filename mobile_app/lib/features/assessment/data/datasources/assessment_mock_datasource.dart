import '../models/assessment_mock_data.dart';

abstract class AssessmentRemoteDataSource {
  Future<List<Map<String, dynamic>>> getUniversities();
  Future<List<Map<String, dynamic>>> getCourses();
  Future<List<Map<String, dynamic>>> getQuestions(String courseId);
  Future<List<Map<String, dynamic>>> getMockExams();
}

class AssessmentMockDatasourceImpl implements AssessmentRemoteDataSource {
  @override
  Future<List<Map<String, dynamic>>> getUniversities() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    return MockAssessmentData.universities;
  }

  @override
  Future<List<Map<String, dynamic>>> getCourses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockAssessmentData.courses;
  }

  @override
  Future<List<Map<String, dynamic>>> getQuestions(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockAssessmentData.questions
        .where((q) => q['courseId'] == courseId)
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getMockExams() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockAssessmentData.mockExams;
  }
}
