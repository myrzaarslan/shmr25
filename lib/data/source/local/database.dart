import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'drift_tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Transactions,
    Categories,
    BankAccounts,
    AccountHistories,
    AccountHistoryItems,
    AccountStates,
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
