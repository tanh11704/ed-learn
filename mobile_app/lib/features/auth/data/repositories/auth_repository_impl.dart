import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Future<UserProfile> login({required String email, required String password}) async {
    final user = await _remote.login(email: email, password: password);
    if (user == null) {
      throw Exception('Email hoặc mật khẩu không đúng.');
    }
    return user;
  }

  @override
  Future<UserProfile> register({required String name, required String email, required String password}) async {
    return _remote.register(name: name, email: email, password: password);
  }
}
