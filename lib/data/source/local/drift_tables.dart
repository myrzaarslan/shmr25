import 'package:drift/drift.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer()();
  IntColumn get categoryId => integer()();
  TextColumn get amount => text()();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get comment => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get emoji => text()();
  IntColumn get backgroundColor => integer()();
  BoolColumn get isIncome => boolean()();
}

class BankAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get name => text()();
  TextColumn get balance => text()();
  TextColumn get currency => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class AccountHistories extends Table {
  IntColumn get accountId => integer()();
  TextColumn get accountName => text()();
  TextColumn get currency => text()();
  TextColumn get currentBalance => text()();
}

class AccountHistoryItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer()();
  TextColumn get changeType => text()();
  IntColumn get previousStateId => integer().nullable()();
  IntColumn get newStateId => integer().nullable()();
  DateTimeColumn get changeTimestamp => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
}

class AccountStates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get balance => text()();
  TextColumn get currency => text()();
}

class BackupEvents extends Table {
  TextColumn get id => text()();
  TextColumn get eventJson => text()();
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
