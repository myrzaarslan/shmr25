import 'dart:convert';
import '../../domain/models/transaction.dart';
import '../../domain/models/bank_account.dart';
import '../../domain/models/category.dart';

/// Static methods for JSON deserialization that can be executed in isolates
class JsonDeserializer {
  /// Parse transactions from JSON in isolate
  static List<TransactionWithDetails> parseTransactions(List<dynamic> jsonList) {
    return jsonList.map((json) {
      try {
        return TransactionWithDetails.fromJson(json as Map<String, dynamic>);
      } catch (e) {
        print('Error parsing transaction: $e');
        rethrow;
      }
    }).toList();
  }

  /// Parse bank accounts from JSON in isolate
  static List<BankAccount> parseAccounts(List<dynamic> jsonList) {
    return jsonList.map((json) {
      try {
        return BankAccount.fromJson(json as Map<String, dynamic>);
      } catch (e) {
        print('Error parsing account: $e');
        rethrow;
      }
    }).toList();
  }

  /// Parse categories from JSON in isolate
  static List<Category> parseCategories(List<dynamic> jsonList) {
    return jsonList.map((json) {
      try {
        return Category.fromJson(json as Map<String, dynamic>);
      } catch (e) {
        print('Error parsing category: $e');
        rethrow;
      }
    }).toList();
  }

  /// Parse single transaction from JSON in isolate
  static TransactionWithDetails parseSingleTransaction(Map<String, dynamic> json) {
    try {
      return TransactionWithDetails.fromJson(json);
    } catch (e) {
      print('Error parsing single transaction: $e');
      rethrow;
    }
  }

  /// Parse single account from JSON in isolate
  static BankAccount parseSingleAccount(Map<String, dynamic> json) {
    try {
      return BankAccount.fromJson(json);
    } catch (e) {
      print('Error parsing single account: $e');
      rethrow;
    }
  }

  /// Parse single category from JSON in isolate
  static Category parseSingleCategory(Map<String, dynamic> json) {
    try {
      return Category.fromJson(json);
    } catch (e) {
      print('Error parsing single category: $e');
      rethrow;
    }
  }
} 