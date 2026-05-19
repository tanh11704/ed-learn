import '../../data/models/top_course_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/user_streak_model.dart';
import '../../data/models/user_task_model.dart';

abstract class HomeRepository {
  Future<UserModel> getUserInfo();
  Future<UserStreakModel> getUserStreak();
  Future<List<TopCourseModel>> getTopCourses();
  Future<List<UserTaskModel>> getTodayTasks();
  Future<void> completeTask(String taskId);
}
