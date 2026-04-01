import 'package:mobile_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mobile_app/features/auth/data/models/login_response_model.dart';
import 'package:mobile_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository{
    final AuthRemoteDataSource remoteDatasource;

    AuthRepositoryImpl(this.remoteDatasource);

    @override
  Future<LoginResponseModel> login(String email, String password) async {
    return await remoteDatasource.login(email, password);
  }
}