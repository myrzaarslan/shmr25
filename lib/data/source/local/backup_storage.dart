import 'package:drift/drift.dart';
import 'package:finance_app/data/source/local/drift_tables.dart';
import 'package:finance_app/data/source/local/database.dart' show AppDatabase;
import 'package:finance_app/domain/entities/backup_event.dart';
import 'dart:convert';

part 'backup_storage.g.dart';

@DriftAccessor(tables: [BackupEvents])
class BackupStorage extends DatabaseAccessor<AppDatabase> with _$BackupStorageMixin {
  BackupStorage(AppDatabase db) : super(db);

  // Add or update event
  Future<void> upsertEvent(BackupEvent event) async {
    final id = '${event.transactionId}_${event.type.name}';
    await into(backupEvents).insertOnConflictUpdate(
      BackupEventsCompanion(
        id: Value(id),
        eventJson: Value(jsonEncode(event.toJson())),
        timestamp: Value(event.timestamp),
      ),
    );
  }

  // Remove event by id and type
  Future<void> removeEvent(String transactionId, BackupEventType type) async {
    final id = '${transactionId}_${type.name}';
    await (delete(backupEvents)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Get all events ordered by timestamp
  Future<List<BackupEvent>> getAllEvents() async {
    final rows = await (select(backupEvents)..orderBy([(t) => OrderingTerm(expression: t.timestamp)])).get();
    return rows.map((row) => BackupEvent.fromJson(jsonDecode(row.eventJson))).toList();
  }

  // Clear all events
  Future<void> clearAll() async {
    await delete(backupEvents).go();
  }
}
