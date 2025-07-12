import 'package:drift/drift.dart';
import '../source/local/database.dart' as db;
import '../source/local/backup_storage.dart';
import '../../network/api_service.dart';
import '../../domain/repositories/bank_account_repository.dart';
import '../../domain/models/bank_account.dart';
import '../../domain/models/account_history.dart';
import '../../domain/entities/backup_event.dart';

class DriftBankAccountRepository implements BankAccountRepository {
  final db.AppDatabase _database;
  final ApiService _apiService;
  final BackupStorage _backupStorage;

  DriftBankAccountRepository(this._database, this._apiService)
      : _backupStorage = BackupStorage(_database);

  @override
  Future<List<BankAccount>> getAllAccounts() async {
    final accounts = await (_database.select(_database.bankAccounts)).get();
    return accounts.map((a) => BankAccount(
      id: a.id,
      userId: a.userId,
      name: a.name,
      balance: a.balance,
      currency: a.currency,
      createdAt: a.createdAt,
      updatedAt: a.updatedAt,
    )).toList();
  }

  @override
  Future<BankAccount> createAccount(CreateBankAccountRequest request) async {
    final now = DateTime.now();
    
    try {
      // 1. Save to local database
      final id = await _database.into(_database.bankAccounts).insert(
        db.BankAccountsCompanion.insert(
          userId: 0, // Will be set by API
          name: request.name,
          balance: request.balance,
          currency: request.currency,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final createdAccount = BankAccount(
        id: id,
        userId: 0,
        name: request.name,
        balance: request.balance,
        currency: request.currency,
        createdAt: now,
        updatedAt: now,
      );

      // 2. Add to backup storage for sync
      final backupEvent = BackupEvent(
        entityId: id.toString(),
        type: BackupEventType.create,
        targetType: BackupTargetType.account,
        bankAccount: createdAccount,
        timestamp: now,
      );
      await _backupStorage.upsertEvent(backupEvent);

      return createdAccount;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BankAccountWithStats> getAccountById(int id) async {
    final account = await (_database.select(_database.bankAccounts)..where((a) => a.id.equals(id))).getSingleOrNull();
    if (account == null) throw Exception('Account not found');
    
    return BankAccountWithStats(
      id: account.id,
      name: account.name,
      balance: account.balance,
      currency: account.currency,
      incomeStats: [], // TODO: Implement stats
      expenseStats: [], // TODO: Implement stats
      createdAt: account.createdAt,
      updatedAt: account.updatedAt,
    );
  }

  @override
  Future<BankAccount> updateAccount(int id, UpdateBankAccountRequest request) async {
    try {
      // 1. Update local database
      await (_database.update(_database.bankAccounts)..where((a) => a.id.equals(id))).write(
        db.BankAccountsCompanion(
          name: Value(request.name),
          balance: Value(request.balance),
          currency: Value(request.currency),
          updatedAt: Value(DateTime.now()),
        ),
      );

      final updatedAccount = BankAccount(
        id: id,
        userId: 0, // Will be updated from API
        name: request.name,
        balance: request.balance,
        currency: request.currency,
        createdAt: DateTime.now(), // Will be updated from API
        updatedAt: DateTime.now(),
      );

      // 2. Add to backup storage for sync
      final backupEvent = BackupEvent(
        entityId: id.toString(),
        type: BackupEventType.update,
        targetType: BackupTargetType.account,
        bankAccount: updatedAccount,
        timestamp: DateTime.now(),
      );
      await _backupStorage.upsertEvent(backupEvent);

      return updatedAccount;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AccountHistory> getAccountHistory(int id) async {
    // TODO: Implement local account history
    throw UnimplementedError('Account history not implemented yet');
  }

  @override
  Future<void> syncWithBackend() async {
    final events = await _backupStorage.getAllEvents();
    
    for (final event in events) {
      if (event.targetType != BackupTargetType.account) continue;
      
      try {
        switch (event.type) {
          case BackupEventType.create:
            if (event.bankAccount != null) {
              final request = CreateBankAccountRequest(
                name: event.bankAccount!.name,
                balance: event.bankAccount!.balance,
                currency: event.bankAccount!.currency,
              );
              await _apiService.createAccount(request);
              await _backupStorage.removeEvent(
                event.entityId,
                event.type,
                BackupTargetType.account,
              );
            }
            break;
          case BackupEventType.update:
            if (event.bankAccount != null) {
              final request = UpdateBankAccountRequest(
                name: event.bankAccount!.name,
                balance: event.bankAccount!.balance,
                currency: event.bankAccount!.currency,
              );
              await _apiService.updateAccount(
                int.parse(event.entityId),
                request,
              );
              await _backupStorage.removeEvent(
                event.entityId,
                event.type,
                BackupTargetType.account,
              );
            }
            break;
          case BackupEventType.delete:
            // Note: API service doesn't have deleteAccount method yet
            print('Account deletion sync not implemented yet');
            await _backupStorage.removeEvent(
              event.entityId,
              event.type,
              BackupTargetType.account,
            );
            break;
        }
      } catch (e) {
        print('Failed to sync account event: $e');
      }
    }
  }

  /// Sync accounts from API to local database
  Future<void> syncFromApi() async {
    try {
      final apiAccounts = await _apiService.getAllAccounts();
      
      // Clear existing accounts and insert new ones from API
      await (_database.delete(_database.bankAccounts)).go();
      
      for (final account in apiAccounts) {
        await _database.into(_database.bankAccounts).insertOnConflictUpdate(
          db.BankAccountsCompanion(
            id: Value(account.id),
            userId: Value(account.userId),
            name: Value(account.name),
            balance: Value(account.balance),
            currency: Value(account.currency),
            createdAt: Value(account.createdAt),
            updatedAt: Value(account.updatedAt),
          ),
        );
      }
      
      print('Synced ${apiAccounts.length} accounts from API');
    } catch (e) {
      print('Failed to sync accounts from API: $e');
    }
  }
}
