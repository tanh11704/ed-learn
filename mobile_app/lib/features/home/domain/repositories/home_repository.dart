
import '../../data/models/user_model.dart';
import '../../data/models/user_streak_model.dart';

abstract class HomeRepository {
  Future<UserModel> getUserInfo();
  Future<UserStreakModel> getUserStreak();
}