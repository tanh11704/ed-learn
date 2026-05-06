import '../../data/models/user_badge_models.dart';

abstract class UserBadgeRepository {
  Future<PageUserBadgeResponse> getMyBadges({int page, int size});
}
