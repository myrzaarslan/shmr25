import 'package:drift/drift.dart';
import 'package:finance_app/data/source/local/drift_tables.dart';
import 'package:finance_app/data/source/local/database.dart';
import 'package:finance_app/domain/entities/backup_event.dart' as domain;
import 'dart:convert';

part 'backup_storage.g.dart';

@DriftAccessor(tables: [BackupEvents])
class BackupStorage extends DatabaseAccessor<AppDatabase> with _$BackupStorageMixin {
  BackupStorage(super.db);

  // Add or update event
  Future<void> upsertEvent(domain.BackupEvent event) async {
    final id = '${event.entityId}_${event.type.name}_${event.targetType.name}';
    await into(backupEvents).insertOnConflictUpdate(
      BackupEventsCompanion(
        id: Value(id),
        eventJson: Value(jsonEncode(event.toJson())),
        timestamp: Value(event.timestamp),
      ),
    );
  }

  // Remove event by id, type, and targetType
  Future<void> removeEvent(String entityId, domain.BackupEventType type, domain.BackupTargetType targetType) async {
    final id = '${entityId}_${type.name}_${targetType.name}';
    await (delete(backupEvents)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Get all events ordered by timestamp
  Future<List<domain.BackupEvent>> getAllEvents() async {
    final rows = await (select(backupEvents)..orderBy([(t) => OrderingTerm(expression: t.timestamp)])).get();
    return rows.map((row) => domain.BackupEvent.fromJson(jsonDecode(row.eventJson))).toList();
  }

  // Clear all events
  Future<void> clearAll() async {
    await delete(backupEvents).go();
  }
}
