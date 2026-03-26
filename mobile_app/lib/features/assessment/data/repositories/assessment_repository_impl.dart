import '../../domain/entities/university.dart';
import '../../domain/repositories/assessment_repository.dart';
import '../../domain/entities/assessment_question.dart';
import '../datasources/assessment_remote_data_source.dart';

class AssessmentRepositoryImpl implements AssessmentRepository {
  AssessmentRepositoryImpl(this._remote);

  final AssessmentRemoteDataSource _remote;

  @override
  Future<List<University>> getUniversities() async {
    return _remote.fetchUniversities();
  }

  @override
  Future<List<AssessmentQuestion>> getAssessmentQuestions() async {
    return _remote.fetchAssessmentQuestions();
  }
}
