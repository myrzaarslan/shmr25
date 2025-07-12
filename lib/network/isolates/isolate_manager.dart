import 'package:worker_manager/worker_manager.dart';
import '../../domain/models/transaction.dart';
import '../../domain/models/bank_account.dart';
import '../../domain/models/category.dart';
import 'json_deserializer.dart';

/// Manages JSON deserialization using isolates
class IsolateManager {
  static final IsolateManager _instance = IsolateManager._internal();
  factory IsolateManager() => _instance;
  IsolateManager._internal();

  /// Initialize the worker manager
  static Future<void> initialize() async {
    await workerManager.init();
  }

  /// Dispose the worker manager
  static Future<void> dispose() async {
    await workerManager.dispose();
  }

  /// Parse transactions in isolate
  static Future<List<TransactionWithDetails>> parseTransactionsInIsolate(List<dynamic> jsonList) async {
    try {
      final cancelable = workerManager.execute<List<TransactionWithDetails>>(
        () async {
          return JsonDeserializer.parseTransactions(jsonList);
        },
        priority: WorkPriority.immediately,
      );
      
      return await cancelable;
    } catch (e) {
      print('Error parsing transactions in isolate: $e');
      // Fallback to main thread parsing
      return JsonDeserializer.parseTransactions(jsonList);
    }
  }

  /// Parse accounts in isolate
  static Future<List<BankAccount>> parseAccountsInIsolate(List<dynamic> jsonList) async {
    try {
      final cancelable = workerManager.execute<List<BankAccount>>(
        () async {
          return JsonDeserializer.parseAccounts(jsonList);
        },
        priority: WorkPriority.immediately,
      );
      
      return await cancelable;
    } catch (e) {
      print('Error parsing accounts in isolate: $e');
      // Fallback to main thread parsing
      return JsonDeserializer.parseAccounts(jsonList);
    }
  }

  /// Parse categories in isolate
  static Future<List<Category>> parseCategoriesInIsolate(List<dynamic> jsonList) async {
    try {
      final cancelable = workerManager.execute<List<Category>>(
        () async {
          return JsonDeserializer.parseCategories(jsonList);
        },
        priority: WorkPriority.immediately,
      );
      
      return await cancelable;
    } catch (e) {
      print('Error parsing categories in isolate: $e');
      // Fallback to main thread parsing
      return JsonDeserializer.parseCategories(jsonList);
    }
  }

  /// Parse single transaction in isolate
  static Future<TransactionWithDetails> parseSingleTransactionInIsolate(Map<String, dynamic> json) async {
    try {
      final cancelable = workerManager.execute<TransactionWithDetails>(
        () async {
          return JsonDeserializer.parseSingleTransaction(json);
        },
        priority: WorkPriority.immediately,
      );
      
      return await cancelable;
    } catch (e) {
      print('Error parsing single transaction in isolate: $e');
      // Fallback to main thread parsing
      return JsonDeserializer.parseSingleTransaction(json);
    }
  }

  /// Parse single account in isolate
  static Future<BankAccount> parseSingleAccountInIsolate(Map<String, dynamic> json) async {
    try {
      final cancelable = workerManager.execute<BankAccount>(
        () async {
          return JsonDeserializer.parseSingleAccount(json);
        },
        priority: WorkPriority.immediately,
      );
      
      return await cancelable;
    } catch (e) {
      print('Error parsing single account in isolate: $e');
      // Fallback to main thread parsing
      return JsonDeserializer.parseSingleAccount(json);
    }
  }

  /// Parse single category in isolate
  static Future<Category> parseSingleCategoryInIsolate(Map<String, dynamic> json) async {
    try {
      final cancelable = workerManager.execute<Category>(
        () async {
          return JsonDeserializer.parseSingleCategory(json);
        },
        priority: WorkPriority.immediately,
      );
      
      return await cancelable;
    } catch (e) {
      print('Error parsing single category in isolate: $e');
      // Fallback to main thread parsing
      return JsonDeserializer.parseSingleCategory(json);
    }
  }
} 