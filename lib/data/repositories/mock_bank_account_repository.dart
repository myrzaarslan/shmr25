import '../../domain/models/bank_account.dart';
import '../../domain/models/account_history.dart';
import '../../domain/repositories/bank_account_repository.dart';

class MockBankAccountRepository implements BankAccountRepository {
  static final List<BankAccount> _accounts = [
    BankAccount(
      id: 1,
      userId: 1,
      name: 'Основной счёт',
      balance: '150000.00',
      currency: 'RUB',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    BankAccount(
      id: 2,
      userId: 1,
      name: 'Накопительный счёт',
      balance: '50000.00',
      currency: 'RUB',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<BankAccount>> getAllAccounts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _accounts;
  }

  @override
  Future<BankAccount> createAccount(CreateBankAccountRequest request) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newAccount = BankAccount(
      id: _accounts.length + 1,
      userId: 1,
      name: request.name,
      balance: request.balance,
      currency: request.currency,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _accounts.add(newAccount);
    return newAccount;
  }

  @override
  Future<BankAccountWithStats> getAccountById(int id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final account = _accounts.firstWhere((acc) => acc.id == id);

    return BankAccountWithStats(
      id: account.id,
      name: account.name,
      balance: account.balance,
      currency: account.currency,
      incomeStats: [
        const CategoryStats(
          categoryId: 1,
          categoryName: 'Зарплата',
          emoji: '💰',
          amount: '80000.00',
        ),
        const CategoryStats(
          categoryId: 2,
          categoryName: 'Подработка',
          emoji: '💻',
          amount: '20000.00',
        ),
      ],
      expenseStats: [
        const CategoryStats(
          categoryId: 5,
          categoryName: 'Продукты',
          emoji: '🛒',
          amount: '25000.00',
        ),
        const CategoryStats(
          categoryId: 6,
          categoryName: 'Транспорт',
          emoji: '🚗',
          amount: '15000.00',
        ),
      ],
      createdAt: account.createdAt,
      updatedAt: account.updatedAt,
    );
  }

  @override
  Future<BankAccount> updateAccount(
    int id,
    UpdateBankAccountRequest request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final index = _accounts.indexWhere((acc) => acc.id == id);
    if (index != -1) {
      _accounts[index] = _accounts[index].copyWith(
        name: request.name,
        balance: request.balance,
        currency: request.currency,
        updatedAt: DateTime.now(),
      );
      return _accounts[index];
    }
    throw Exception('Account not found');
  }

  @override
  Future<AccountHistory> getAccountHistory(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final account = _accounts.firstWhere((acc) => acc.id == id);

    return AccountHistory(
      accountId: account.id,
      accountName: account.name,
      currency: account.currency,
      currentBalance: account.balance,
      history: [
        AccountHistoryItem(
          id: 1,
          accountId: account.id,
          changeType: 'CREATION',
          previousState: account.copyWith(balance: '0.00'),
          newState: account,
          changeTimestamp: account.createdAt,
          createdAt: account.createdAt,
        ),
      ],
    );
  }
}
