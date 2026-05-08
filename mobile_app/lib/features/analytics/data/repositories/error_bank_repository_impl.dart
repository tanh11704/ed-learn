import '../../domain/repositories/error_bank_repository.dart';
import '../datasources/error_bank_remote_datasource.dart';
import '../models/error_bank_models.dart';

class ErrorBankRepositoryImpl implements ErrorBankRepository {
  final ErrorBankRemoteDataSource remoteDataSource;

  ErrorBankRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ErrorBankCard>> getDueCards({int limit = 50}) {
    return remoteDataSource.getDueCards(limit: limit);
  }

  @override
  Future<void> reviewCard({required String id, required int quality}) {
    return remoteDataSource.reviewCard(id: id, quality: quality);
  }
}
