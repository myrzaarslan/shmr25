import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'drift_tables.dart';
import 'package:finance_app/data/source/local/backup_storage.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Transactions,
    Categories,
    BankAccounts,
    AccountHistories,
    AccountHistoryItems,
    AccountStates,
    BackupEvents, // Register BackupEvents table
  ],
  daos: [
    BackupStorage, // Register BackupStorage DAO
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final path = p.join(dir.path, 'db.sqlite');
      return NativeDatabase(File(path));
    });
  }
}
