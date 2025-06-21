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
    TransactionWithDetails(
      id: 3,
      account: BankAccount(
        id: 1,
        userId: 1,
        name: 'Основной счёт',
        balance: '150000.00',
        currency: 'RUB',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      category: const Category(id: 6, name: 'Транспорт', emoji: '🚗', isIncome: false, backgroundColor: 0xFFCFE8A9),
      amount: '350.00',
      transactionDate: DateTime.now().subtract(const Duration(hours: 5)),
      comment: 'Такси',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    TransactionWithDetails(
      id: 4,
      account: BankAccount(
        id: 1,
        userId: 1,
        name: 'Основной счёт',
        balance: '150000.00',
        currency: 'RUB',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      category: const Category(id: 2, name: 'Подработка', emoji: '💻', isIncome: true, backgroundColor: 0xFF80D2C4),
      amount: '15000.00',
      transactionDate: DateTime.now().subtract(const Duration(days: 3)),
      comment: 'Фриланс проект',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    TransactionWithDetails(
      id: 5,
      account: BankAccount(
        id: 1,
        userId: 1,
        name: 'Основной счёт',
        balance: '150000.00',
        currency: 'RUB',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      category: const Category(id: 7, name: 'Развлечения', emoji: '🎬', isIncome: false, backgroundColor: 0xFF80D2C4),
      amount: '1200.00',
      transactionDate: DateTime.now().subtract(const Duration(days: 4)),
      comment: 'Кино',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    TransactionWithDetails(
      id: 6,
      account: BankAccount(
        id: 1,
        userId: 1,
        name: 'Основной счёт',
        balance: '150000.00',
        currency: 'RUB',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      category: const Category(id: 12, name: 'Спорт', emoji: '🏋️', isIncome: false, backgroundColor: 0xFF81A2CA),
      amount: '2500.00',
      transactionDate: DateTime.now().subtract(const Duration(days: 10)),
      comment: 'Абонемент в зал',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    TransactionWithDetails(
      id: 7,
      account: BankAccount(
        id: 1,
        userId: 1,
        name: 'Основной счёт',
        balance: '150000.00',
        currency: 'RUB',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      category: const Category(id: 4, name: 'Подарки', emoji: '🎁', isIncome: true, backgroundColor: 0xFFE8A9A9),
      amount: '5000.00',
      transactionDate: DateTime.now(),
      comment: 'Подарок на день рождения',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    )
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

    final start = startDate ?? DateTime.now().subtract(const Duration(days: 30));
    final end = endDate ?? DateTime.now();

    return _transactions.where((transaction) {
      return transaction.account.id == accountId &&
          !transaction.transactionDate.isBefore(start) &&
          !transaction.transactionDate.isAfter(end);
    }).toList();
  }
}
