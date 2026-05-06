import '../../domain/repositories/home_repository.dart';
import '../models/user_model.dart';
import '../models/user_streak_model.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserModel> getUserInfo() async {
    return await remoteDataSource.getUserInfo();
  }

  @override
  Future<UserStreakModel> getUserStreak() async {
    return await remoteDataSource.getUserStreak();
  }
}