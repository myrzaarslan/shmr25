import '../models/transaction.dart';

abstract class TransactionRepository {
  Future<Transaction> createTransaction(CreateTransactionRequest request);
  Future<TransactionWithDetails> getTransactionById(int id);
  Future<TransactionWithDetails> updateTransaction(
    int id,
    UpdateTransactionRequest request,
  );
  Future<void> deleteTransaction(int id);
  Future<List<TransactionWithDetails>> getTransactionsByAccountAndPeriod(
    int accountId, {
    DateTime? startDate,
    DateTime? endDate,
  });
  
  /// Check if there are unsynced events (for offline mode detection)
  Future<bool> hasUnsyncedEvents();
}
