import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:finance_app/domain/models/transaction.dart';

part 'backup_event.freezed.dart';
part 'backup_event.g.dart';

enum BackupEventType { create, update, delete }

@freezed
abstract class BackupEvent with _$BackupEvent {
  const factory BackupEvent({
    required String transactionId,
    required BackupEventType type,
    Transaction? transaction,
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