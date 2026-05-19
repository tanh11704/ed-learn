import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../datasources/statistics_remote_datasource.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/top_course_model.dart';
import '../models/user_model.dart';
import '../models/user_streak_model.dart';
import '../models/user_task_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final TaskRemoteDataSource taskDataSource;
  final StatisticsRemoteDataSource statisticsDataSource;

  HomeRepositoryImpl(
    this.remoteDataSource, {
    TaskRemoteDataSource? taskDataSource,
    StatisticsRemoteDataSource? statisticsDataSource,
  })  : taskDataSource = taskDataSource ?? TaskRemoteDataSourceImpl(),
        statisticsDataSource =
            statisticsDataSource ?? StatisticsRemoteDataSourceImpl();

  @override
  Future<UserModel> getUserInfo() => remoteDataSource.getUserInfo();

  @override
  Future<UserStreakModel> getUserStreak() => remoteDataSource.getUserStreak();

  @override
  Future<List<TopCourseModel>> getTopCourses() =>
      statisticsDataSource.getTopCourses();

  @override
  Future<List<UserTaskModel>> getTodayTasks() =>
      taskDataSource.getTasksForDate(DateTime.now());

  @override
  Future<void> completeTask(String taskId) =>
      taskDataSource.markTaskCompleted(taskId);
}
