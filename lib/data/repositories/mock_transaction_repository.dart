import '../../domain/models/transaction.dart';
import '../../domain/models/bank_account.dart';
import '../../domain/models/category.dart';
import '../../domain/repositories/transaction_repository.dart';

class MockTransactionRepository implements TransactionRepository {
  static final List<TransactionWithDetails> _transactions = [
    TransactionWithDetails(
      id: 1,
      account: BankAccount(
        id: 1,
        userId: 1,
        name: 'Основной счёт',
        balance: '150000.00',
        currency: 'RUB',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      category: const Category(
        id: 1,
        name: 'Зарплата',
        emoji: '💰',
        isIncome: true,
        backgroundColor: 0xFFCFE8A9,
      ),
      amount: '80000.00',
      transactionDate: DateTime.now().subtract(const Duration(days: 1)),
      comment: 'Зарплата за месяц',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TransactionWithDetails(
      id: 2,
      account: BankAccount(
        id: 1,
        userId: 1,
        name: 'Основной счёт',
        balance: '150000.00',
        currency: 'RUB',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      category: const Category(
        id: 5,
        name: 'Продукты',
        emoji: '🛒',
        isIncome: false,
        backgroundColor: 0xFFE8A9A9,
      ),
      amount: '5000.00',
      transactionDate: DateTime.now().subtract(const Duration(hours: 2)),
      comment: 'Покупки в супермаркете',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  @override
  Future<Transaction> createTransaction(
    CreateTransactionRequest request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newTransaction = Transaction(
      id: _transactions.length + 1,
      accountId: request.accountId,
      categoryId: request.categoryId,
      amount: request.amount,
      transactionDate: request.transactionDate,
      comment: request.comment,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return newTransaction;
  }

  @override
  Future<TransactionWithDetails> getTransactionById(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _transactions.firstWhere((transaction) => transaction.id == id);
  }

  @override
  Future<TransactionWithDetails> updateTransaction(
    int id,
    UpdateTransactionRequest request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final index = _transactions.indexWhere(
      (transaction) => transaction.id == id,
    );
    if (index != -1) {
      _transactions[index] = _transactions[index].copyWith(
        amount: request.amount,
        transactionDate: request.transactionDate,
        comment: request.comment,
        updatedAt: DateTime.now(),
      );
      return _transactions[index];
    }
    throw Exception('Transaction not found');
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _transactions.removeWhere((transaction) => transaction.id == id);
  }

  @override
  Future<List<TransactionWithDetails>> getTransactionsByAccountAndPeriod(
    int accountId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final now = DateTime.now();
    final start = startDate ?? DateTime(now.year, now.month, 1);
    final end = endDate ?? DateTime(now.year, now.month + 1, 0);

    return _transactions
        .where(
          (transaction) =>
              transaction.account.id == accountId &&
              transaction.transactionDate.isAfter(start) &&
              transaction.transactionDate.isBefore(end),
        )
        .toList();
  }
}
