import '../entities/solution_entities.dart';

abstract class SolutionRepository {
  Future<SolutionEntity> fetchSolution();
}
