import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:finance_app/domain/models/transaction.dart';
import 'package:finance_app/domain/models/bank_account.dart';
import 'package:finance_app/domain/models/category.dart';

part 'backup_event.freezed.dart';
part 'backup_event.g.dart';

// JSON converters for complex types
class TransactionConverter implements JsonConverter<Transaction?, Map<String, dynamic>?> {
  const TransactionConverter();

  @override
  Transaction? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Transaction.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(Transaction? transaction) {
    return transaction?.toJson();
  }
}

class BankAccountConverter implements JsonConverter<BankAccount?, Map<String, dynamic>?> {
  const BankAccountConverter();

  @override
  BankAccount? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return BankAccount.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(BankAccount? bankAccount) {
    return bankAccount?.toJson();
  }
}

class CategoryConverter implements JsonConverter<Category?, Map<String, dynamic>?> {
  const CategoryConverter();

  @override
  Category? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Category.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(Category? category) {
    return category?.toJson();
  }
}

enum BackupEventType { create, update, delete }
enum BackupTargetType { transaction, account, category }

@freezed
abstract class BackupEvent with _$BackupEvent {
  const factory BackupEvent({
    required String entityId,
    required BackupEventType type,
    required BackupTargetType targetType,
    @TransactionConverter() Transaction? transaction,
    @BankAccountConverter() BankAccount? bankAccount,
    @CategoryConverter() Category? category,
    required DateTime timestamp,
  }) = _BackupEvent;

  factory BackupEvent.fromJson(Map<String, dynamic> json) => _$BackupEventFromJson(json);
}

// For enum serialization
const backupEventTypeEnumMap = {
  BackupEventType.create: 'create',
  BackupEventType.update: 'update',
  BackupEventType.delete: 'delete',
};
const backupTargetTypeEnumMap = {
  BackupTargetType.transaction: 'transaction',
  BackupTargetType.account: 'account',
  BackupTargetType.category: 'category',
};