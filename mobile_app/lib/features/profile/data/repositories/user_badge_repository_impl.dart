import '../../domain/repositories/user_badge_repository.dart';
import '../datasources/user_badge_remote_datasource.dart';
import '../models/user_badge_models.dart';

class UserBadgeRepositoryImpl implements UserBadgeRepository {
  final UserBadgeRemoteDataSource remoteDataSource;

  UserBadgeRepositoryImpl(this.remoteDataSource);

  @override
  Future<PageUserBadgeResponse> getMyBadges({int page = 0, int size = 10}) {
    return remoteDataSource.getMyBadges(page: page, size: size);
  }
}
