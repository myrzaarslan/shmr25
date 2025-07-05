// import 'package:finance_app/data/source/local/database.dart' as db;
// import 'package:finance_app/domain/repositories/bank_account_repository.dart';
// import 'package:drift/drift.dart';
// import 'package:finance_app/domain/models/transaction.dart';
// import 'package:finance_app/domain/models/bank_account.dart';
// import 'package:finance_app/domain/models/category.dart';

// class DriftBankAccountRepository implements BankAccountRepository {
//   final db.AppDatabase _db;
//   DriftBankAccountRepository(this._db);

//   @override
//   Future<List<BankAccount>> getAllAccounts() async {
//     final rows = await _db.select(_db.bankAccounts).get();

//     final accounts = rows.map((row) {
//       return BankAccount(
//         id: row.id,
//         userId: row.userId,
//         name: row.name,
//         balance: row.balance,
//         currency: row.currency,
//         createdAt: row.createdAt,
//         updatedAt: row.updatedAt,
//       );
//     }).toList();

//     return accounts;
//   }

//   @override
//   Future<BankAccount> createAccount(CreateBankAccountRequest request) async {
//     final now = DateTime.now();

//     final userId = 1;

//     final entry = db.BankAccountsCompanion(
//       userId: Value(userId),
//       name: Value(request.name),
//       balance: Value(request.balance),
//       currency: Value(request.currency),
//       createdAt: Value(now),
//       updatedAt: Value(now),
//     );

//     final accountId = await _db.into(_db.bankAccounts).insert(entry);

//     return BankAccount(
//       id: accountId,
//       userId: userId,
//       name: request.name,
//       balance: request.balance,
//       currency: request.currency,
//       createdAt: now,
//       updatedAt: now,
//     );
//   }

//   @override
//   Future<BankAccountWithStats> getAccountById(int id) async {
//     final rows = (_db.select(_db.bankAccounts)..where((b) => b.id.equals(id))).getSingle();

//   }
// }
