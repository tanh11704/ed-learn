import '../entities/user_profile.dart';

abstract class AuthRepository {
  Future<UserProfile> login({required String email, required String password});
  Future<UserProfile> register({required String name, required String email, required String password});
}
