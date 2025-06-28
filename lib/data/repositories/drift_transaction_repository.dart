import 'package:finance_app/data/source/local/database.dart' as db;
import 'package:finance_app/domain/repositories/transaction_repository.dart';
import 'package:drift/drift.dart';
import 'package:finance_app/domain/models/transaction.dart';
import 'package:finance_app/domain/models/bank_account.dart';
import 'package:finance_app/domain/models/category.dart';

class DriftTransactionRepository implements TransactionRepository {
  final db.AppDatabase _db;
  DriftTransactionRepository(this._db);

  @override
  Future<Transaction> createTransaction(
    CreateTransactionRequest request,
  ) async {
    final now = DateTime.now();

    final entry = db.TransactionsCompanion(
      accountId: Value(request.accountId),
      categoryId: Value(request.categoryId),
      amount: Value(request.amount),
      transactionDate: Value(request.transactionDate),
      comment: Value(request.comment),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    final id = await _db.into(_db.transactions).insert(entry);

    return Transaction(
      id: id,
      accountId: request.accountId,
      categoryId: request.categoryId,
      amount: request.amount,
      transactionDate: request.transactionDate,
      comment: request.comment,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<TransactionWithDetails> getTransactionById(int id) async {
    final transaction = await (_db.select(
      _db.transactions,
    )..where((t) => t.id.equals(id))).getSingle();

    final account = await (_db.select(
      _db.bankAccounts,
    )..where((a) => a.id.equals(transaction.accountId))).getSingle();

    final category = await (_db.select(
      _db.categories,
    )..where((c) => c.id.equals(transaction.categoryId))).getSingle();
    return TransactionWithDetails(
      id: transaction.id,
      account: BankAccount(
        id: account.id,
        userId: account.userId,
        name: account.name,
        balance: account.balance,
        currency: account.currency,
        createdAt: account.createdAt,
        updatedAt: account.updatedAt,
      ),
      category: Category(
        id: category.id,
        name: category.name,
        emoji: category.emoji,
        backgroundColor: category.backgroundColor,
        isIncome: category.isIncome,
      ),
      amount: transaction.amount,
      transactionDate: transaction.transactionDate,
      comment: transaction.comment,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
    );
  }

  @override
  Future<TransactionWithDetails> updateTransaction(
    int id,
    UpdateTransactionRequest request,
  ) async {
    final now = DateTime.now();

    await _db
        .update(_db.transactions)
        .replace(
          db.TransactionsCompanion(
            id: Value(id),
            accountId: Value(request.accountId),
            categoryId: Value(request.categoryId),
            amount: Value(request.amount),
            transactionDate: Value(request.transactionDate),
            comment: Value(request.comment),
            updatedAt: Value(now),
          ),
        );

    final transaction = await getTransactionById(id);
    return transaction;
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<TransactionWithDetails>> getTransactionsByAccountAndPeriod(
    int accountId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final query = _db.select(_db.transactions)
      ..where((t) => t.accountId.equals(accountId));

    if (startDate != null) {
      query.where((t) => t.transactionDate.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where((t) => t.transactionDate.isSmallerOrEqualValue(endDate));
    }

    final rows = await query.get();

    final result = <TransactionWithDetails>[];
    for (final row in rows) {
      final account = await (_db.select(
        _db.bankAccounts,
      )..where((a) => a.id.equals(row.accountId))).getSingle();

      final category = await (_db.select(
        _db.categories,
      )..where((c) => c.id.equals(row.categoryId))).getSingle();

      result.add(
        TransactionWithDetails(
          id: row.id,
          account: BankAccount(
            id: account.id,
            userId: account.userId,
            name: account.name,
            balance: account.balance,
            currency: account.currency,
            createdAt: account.createdAt,
            updatedAt: account.updatedAt,
          ),
          category: Category(
            id: category.id,
            name: category.name,
            emoji: category.emoji,
            backgroundColor: category.backgroundColor,
            isIncome: category.isIncome,
          ),
          amount: row.amount,
          transactionDate: row.transactionDate,
          comment: row.comment,
          createdAt: row.createdAt,
          updatedAt: row.updatedAt,
        ),
      );
    }

    return result;
  }
}
