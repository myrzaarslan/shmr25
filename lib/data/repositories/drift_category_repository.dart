import 'package:drift/drift.dart';
import '../source/local/database.dart' as db;
import '../source/local/backup_storage.dart';
import '../../network/api_service.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/models/category.dart';
import '../../domain/entities/backup_event.dart';

class DriftCategoryRepository implements CategoryRepository {
  final db.AppDatabase _database;
  final ApiService _apiService;
  final BackupStorage _backupStorage;

  DriftCategoryRepository(this._database, this._apiService)
      : _backupStorage = BackupStorage(_database);

  @override
  Future<List<Category>> getAllCategories() async {
    final categories = await (_database.select(_database.categories)).get();
    return categories.map((c) => Category(
      id: c.id,
      name: c.name,
      emoji: c.emoji,
      backgroundColor: c.backgroundColor,
      isIncome: c.isIncome,
    )).toList();
  }

  @override
  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    final categories = await (_database.select(_database.categories)..where((c) => c.isIncome.equals(isIncome))).get();
    return categories.map((c) => Category(
      id: c.id,
      name: c.name,
      emoji: c.emoji,
      backgroundColor: c.backgroundColor,
      isIncome: c.isIncome,
    )).toList();
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    final category = await (_database.select(_database.categories)..where((c) => c.id.equals(id))).getSingleOrNull();
    if (category == null) return null;
    
    return Category(
      id: category.id,
      name: category.name,
      emoji: category.emoji,
      backgroundColor: category.backgroundColor,
      isIncome: category.isIncome,
    );
  }

  @override
  Future<Category> createCategory(Category category) async {
    final now = DateTime.now();
    
    try {
      // 1. Save to local database
      final id = await _database.into(_database.categories).insert(
        db.CategoriesCompanion.insert(
          name: category.name,
          emoji: category.emoji,
          backgroundColor: category.backgroundColor,
          isIncome: category.isIncome,
        ),
      );

      final createdCategory = Category(
        id: id,
        name: category.name,
        emoji: category.emoji,
        backgroundColor: category.backgroundColor,
        isIncome: category.isIncome,
      );

      // 2. Add to backup storage for sync
      final backupEvent = BackupEvent(
        entityId: id.toString(),
        type: BackupEventType.create,
        targetType: BackupTargetType.category,
        category: createdCategory,
        timestamp: now,
      );
      await _backupStorage.upsertEvent(backupEvent);

      return createdCategory;
    } catch (e) {
      // If local save fails, rethrow
      rethrow;
    }
  }

  @override
  Future<Category> updateCategory(Category category) async {
    try {
      // 1. Update local database
      await (_database.update(_database.categories)..where((c) => c.id.equals(category.id))).write(
        db.CategoriesCompanion(
          name: Value(category.name),
          emoji: Value(category.emoji),
          backgroundColor: Value(category.backgroundColor),
          isIncome: Value(category.isIncome),
        ),
      );

      // 2. Add to backup storage for sync
      final backupEvent = BackupEvent(
        entityId: category.id.toString(),
        type: BackupEventType.update,
        targetType: BackupTargetType.category,
        category: category,
        timestamp: DateTime.now(),
      );
      await _backupStorage.upsertEvent(backupEvent);

      return category;
    } catch (e) {
      // If local update fails, rethrow
      rethrow;
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    try {
      // 1. Delete from local database
      await (_database.delete(_database.categories)..where((c) => c.id.equals(id))).go();

      // 2. Add to backup storage for sync
      final backupEvent = BackupEvent(
        entityId: id.toString(),
        type: BackupEventType.delete,
        targetType: BackupTargetType.category,
        timestamp: DateTime.now(),
      );
      await _backupStorage.upsertEvent(backupEvent);
    } catch (e) {
      // If local delete fails, rethrow
      rethrow;
    }
  }

  @override
  Future<void> syncWithBackend() async {
    final events = await _backupStorage.getAllEvents();
    
    for (final event in events) {
      if (event.targetType != BackupTargetType.category) continue;
      
      try {
        switch (event.type) {
          case BackupEventType.create:
            if (event.category != null) {
              // Note: API service doesn't have createCategory method yet
              // This would need to be implemented in ApiService
              print('Category creation sync not implemented yet');
              await _backupStorage.removeEvent(
                event.entityId,
                event.type,
                BackupTargetType.category,
              );
            }
            break;
          case BackupEventType.update:
            if (event.category != null) {
              // Note: API service doesn't have updateCategory method yet
              // This would need to be implemented in ApiService
              print('Category update sync not implemented yet');
              await _backupStorage.removeEvent(
                event.entityId,
                event.type,
                BackupTargetType.category,
              );
            }
            break;
          case BackupEventType.delete:
            // Note: API service doesn't have deleteCategory method yet
            // This would need to be implemented in ApiService
            print('Category deletion sync not implemented yet');
            await _backupStorage.removeEvent(
              event.entityId,
              event.type,
              BackupTargetType.category,
            );
            break;
        }
      } catch (e) {
        // If sync fails, keep in backup storage for later sync
        print('Failed to sync category event: $e');
      }
    }
  }

  /// Sync categories from API to local database
  Future<void> syncFromApi() async {
    try {
      final apiCategories = await _apiService.getAllCategories();
      
      // Clear existing categories and insert new ones from API
      await (_database.delete(_database.categories)).go();
      
      for (final category in apiCategories) {
        await _database.into(_database.categories).insert(
          db.CategoriesCompanion.insert(
            id: Value(category.id),
            name: category.name,
            emoji: category.emoji,
            backgroundColor: category.backgroundColor,
            isIncome: category.isIncome,
          ),
        );
      }
      
      print('Synced ${apiCategories.length} categories from API');
    } catch (e) {
      print('Failed to sync categories from API: $e');
    }
  }
} 