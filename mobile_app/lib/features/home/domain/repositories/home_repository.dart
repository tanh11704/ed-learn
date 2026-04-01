
import '../../data/models/user_model.dart';

abstract class HomeRepository {
  Future<UserModel> getUserInfo();
}