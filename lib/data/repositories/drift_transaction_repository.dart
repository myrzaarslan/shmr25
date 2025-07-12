import 'package:finance_app/data/source/local/database.dart' as db;
import 'package:finance_app/domain/repositories/transaction_repository.dart';
import 'package:finance_app/domain/entities/backup_event.dart';
import 'package:finance_app/data/source/local/backup_storage.dart';
import 'package:finance_app/network/api_service.dart';
import 'package:drift/drift.dart';
import 'package:finance_app/domain/models/transaction.dart';
import 'package:finance_app/domain/models/bank_account.dart';
import 'package:finance_app/domain/models/category.dart';

class DriftTransactionRepository implements TransactionRepository {
  final db.AppDatabase _db;
  final BackupStorage _backupStorage;
  final ApiService _apiService;

  DriftTransactionRepository(this._db, this._apiService)
      : _backupStorage = BackupStorage(_db);

  @override
  Future<Transaction> createTransaction(
    CreateTransactionRequest request,
  ) async {
    final now = DateTime.now();

    // 1. Save to local database first (offline-first)
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
    // Debug print all transactions after insert
    final allRows = await _db.select(_db.transactions).get();
    print('All transactions after insert:');
    for (final row in allRows) {
      print('id=${row.id}, accountId=${row.accountId}, categoryId=${row.categoryId}, amount=${row.amount}, date=${row.transactionDate}');
    }

    final transaction = Transaction(
      id: id,
      accountId: request.accountId,
      categoryId: request.categoryId,
      amount: request.amount,
      transactionDate: request.transactionDate,
      comment: request.comment,
      createdAt: now,
      updatedAt: now,
    );

    // 2. Add to backup storage for sync
    final backupEvent = BackupEvent(
      entityId: id.toString(),
      type: BackupEventType.create,
      targetType: BackupTargetType.transaction,
      transaction: transaction,
      timestamp: now,
    );
    await _backupStorage.upsertEvent(backupEvent);

    // 3. Try to sync with backend
    try {
      final syncedTransaction = await _apiService.createTransaction(request);
      
      // Update local transaction with server data
      await _db.update(_db.transactions).replace(
        db.TransactionsCompanion(
          id: Value(syncedTransaction.id),
          accountId: Value(syncedTransaction.accountId),
          categoryId: Value(syncedTransaction.categoryId),
          amount: Value(syncedTransaction.amount),
          transactionDate: Value(syncedTransaction.transactionDate),
          comment: Value(syncedTransaction.comment),
          createdAt: Value(syncedTransaction.createdAt),
          updatedAt: Value(syncedTransaction.updatedAt),
        ),
      );

      // Remove from backup storage on successful sync
      await _backupStorage.removeEvent(id.toString(), BackupEventType.create, BackupTargetType.transaction);
      
      return syncedTransaction;
    } catch (e) {
      // If sync fails, throw error to UI but keep local transaction
      print('Failed to sync transaction to backend: $e');
      throw Exception('Failed to sync transaction: $e');
    }
  }

  @override
  Future<TransactionWithDetails> getTransactionById(int id) async {
    // 1. Try to sync backup events first
    await _syncBackupEvents();

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

    // 1. Update local database first
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

    // 2. Add to backup storage for sync
    final backupEvent = BackupEvent(
      entityId: id.toString(),
      type: BackupEventType.update,
      targetType: BackupTargetType.transaction,
      transaction: Transaction(
        id: id,
        accountId: request.accountId,
        categoryId: request.categoryId,
        amount: request.amount,
        transactionDate: request.transactionDate,
        comment: request.comment,
        createdAt: now,
        updatedAt: now,
      ),
      timestamp: now,
    );
    await _backupStorage.upsertEvent(backupEvent);

    // 3. Try to sync with backend
    try {
      final syncedTransaction = await _apiService.updateTransaction(id, request);
      
      // Remove from backup storage on successful sync
      await _backupStorage.removeEvent(id.toString(), BackupEventType.update, BackupTargetType.transaction);
      
      return syncedTransaction;
    } catch (e) {
      // If sync fails, throw error to UI but keep local transaction
      print('Failed to sync transaction update to backend: $e');
      throw Exception('Failed to sync transaction update: $e');
    }
  }

  @override
  Future<void> deleteTransaction(int id) async {
    // 1. Add to backup storage for sync
    final backupEvent = BackupEvent(
      entityId: id.toString(),
      type: BackupEventType.delete,
      targetType: BackupTargetType.transaction,
      timestamp: DateTime.now(),
    );
    await _backupStorage.upsertEvent(backupEvent);

    // 2. Delete from local database
    await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();

    // 3. Try to sync with backend
    try {
      await _apiService.deleteTransaction(id);
      
      // Remove from backup storage on successful sync
      await _backupStorage.removeEvent(id.toString(), BackupEventType.delete, BackupTargetType.transaction);
    } catch (e) {
      // If sync fails, throw error to UI but keep in backup storage
      print('Failed to sync transaction deletion to backend: $e');
      throw Exception('Failed to sync transaction deletion: $e');
    }
  }

  @override
  Future<List<TransactionWithDetails>> getTransactionsByAccountAndPeriod(
    int accountId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // 1. Try to sync backup events first
    await _syncBackupEvents();

    final query = _db.select(_db.transactions)
      ..where((t) => t.accountId.equals(accountId));

    if (startDate != null) {
      query.where((t) => t.transactionDate.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where((t) => t.transactionDate.isSmallerOrEqualValue(endDate));
    }

    final rows = await query.get();
    print('Transactions loaded for account $accountId, start=$startDate, end=$endDate:');
    for (final row in rows) {
      print('id=${row.id}, accountId=${row.accountId}, categoryId=${row.categoryId}, amount=${row.amount}, date=${row.transactionDate}');
    }

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

  /// Sync all backup events with the backend
  Future<void> _syncBackupEvents() async {
    final events = await _backupStorage.getAllEvents();
    
    for (final event in events) {
      try {
        switch (event.type) {
          case BackupEventType.create:
            if (event.transaction != null) {
              final request = CreateTransactionRequest(
                accountId: event.transaction!.accountId,
                categoryId: event.transaction!.categoryId,
                amount: event.transaction!.amount,
                transactionDate: event.transaction!.transactionDate,
                comment: event.transaction!.comment,
              );
              await _apiService.createTransaction(request);
              await _backupStorage.removeEvent(
                event.entityId,
                event.type,
                BackupTargetType.transaction,
              );
            }
            break;
          case BackupEventType.update:
            if (event.transaction != null) {
              final request = UpdateTransactionRequest(
                accountId: event.transaction!.accountId,
                categoryId: event.transaction!.categoryId,
                amount: event.transaction!.amount,
                transactionDate: event.transaction!.transactionDate,
                comment: event.transaction!.comment,
              );
              await _apiService.updateTransaction(
                int.parse(event.entityId),
                request,
              );
              await _backupStorage.removeEvent(
                event.entityId,
                event.type,
                BackupTargetType.transaction,
              );
            }
            break;
          case BackupEventType.delete:
            await _apiService.deleteTransaction(int.parse(event.entityId));
            await _backupStorage.removeEvent(
              event.entityId,
              event.type,
              BackupTargetType.transaction,
            );
            break;
        }
      } catch (e) {
        // If sync fails for an event, keep it in backup for later retry
        print('Failed to sync backup event: $e');
      }
    }
  }

  /// Check if there are unsynced events (for offline mode detection)
  @override
  Future<bool> hasUnsyncedEvents() async {
    final events = await _backupStorage.getAllEvents();
    return events.isNotEmpty;
  }

  /// Returns a set of transaction IDs that are unsynced (in backup storage)
  Future<Set<int>> getUnsyncedTransactionIds() async {
    final events = await _backupStorage.getAllEvents();
    return events
      .where((e) => e.targetType == BackupTargetType.transaction)
      .map((e) => int.tryParse(e.entityId))
      .whereType<int>()
      .toSet();
  }

  /// Sync transactions from API to local database
  Future<void> syncFromApi() async {
    try {
      // Get all accounts first to map them
      final accounts = await (_db.select(_db.bankAccounts)).get();
      final accountMap = {for (var a in accounts) a.id: a};
      
      // Get all categories first to map them
      final categories = await (_db.select(_db.categories)).get();
      final categoryMap = {for (var c in categories) c.id: c};
      
      // Get transactions from API for each account
      for (final account in accounts) {
        try {
          final apiTransactions = await _apiService.getTransactionsByAccountAndPeriod(account.id);
          
          for (final apiTransaction in apiTransactions) {
            try {
              // Check if transaction already exists locally
              final existing = await (_db.select(_db.transactions)..where((t) => t.id.equals(apiTransaction.id))).getSingleOrNull();
              
              if (existing == null) {
                // Insert new transaction
                await _db.into(_db.transactions).insertOnConflictUpdate(
                  db.TransactionsCompanion(
                    id: Value(apiTransaction.id),
                    accountId: Value(apiTransaction.account.id),
                    categoryId: Value(apiTransaction.category.id),
                    amount: Value(apiTransaction.amount),
                    transactionDate: Value(apiTransaction.transactionDate),
                    comment: Value(apiTransaction.comment),
                    createdAt: Value(apiTransaction.createdAt),
                    updatedAt: Value(apiTransaction.updatedAt),
                  ),
                );
              }
            } catch (e) {
              print('Failed to process transaction ${apiTransaction.id} for account ${account.id}: $e');
              // Continue with next transaction
            }
          }
        } catch (e) {
          print('Failed to sync transactions for account ${account.id}: $e');
        }
      }
      
      print('Synced transactions from API');
    } catch (e) {
      print('Failed to sync transactions from API: $e');
    }
  }
}
