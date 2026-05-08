import '../../data/models/error_bank_models.dart';

abstract class ErrorBankRepository {
  Future<List<ErrorBankCard>> getDueCards({int limit});
  Future<void> reviewCard({required String id, required int quality});
}
