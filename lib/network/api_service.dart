import 'package:dio/dio.dart';
import 'package:finance_app/domain/models/transaction.dart';
import 'package:finance_app/domain/models/bank_account.dart';
import 'package:finance_app/domain/models/category.dart';
import 'package:finance_app/domain/models/account_history.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  // Transaction endpoints
  Future<Transaction> createTransaction(CreateTransactionRequest request) async {
    final response = await _dio.post('/transactions', data: {
      'accountId': request.accountId,
      'categoryId': request.categoryId,
      'amount': request.amount,
      'transactionDate': request.transactionDate.toIso8601String(),
      'comment': request.comment,
    });
    return Transaction.fromJson(response.data);
  }

  Future<TransactionWithDetails> getTransactionById(int id) async {
    final response = await _dio.get('/transactions/$id');
    return TransactionWithDetails.fromJson(response.data);
  }

  Future<TransactionWithDetails> updateTransaction(
    int id,
    UpdateTransactionRequest request,
  ) async {
    final response = await _dio.put('/transactions/$id', data: {
      'accountId': request.accountId,
      'categoryId': request.categoryId,
      'amount': request.amount,
      'transactionDate': request.transactionDate.toIso8601String(),
      'comment': request.comment,
    });
    return TransactionWithDetails.fromJson(response.data);
  }

  Future<void> deleteTransaction(int id) async {
    await _dio.delete('/transactions/$id');
  }

  Future<List<TransactionWithDetails>> getTransactionsByAccountAndPeriod(
    int accountId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null) {
      queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
    }

    final response = await _dio.get(
      '/transactions/account/$accountId/period',
      queryParameters: queryParams,
    );
    
    return (response.data as List)
        .map((json) => TransactionWithDetails.fromJson(json))
        .toList();
  }

  // Account endpoints
  Future<List<BankAccount>> getAllAccounts() async {
    final response = await _dio.get('/accounts');
    return (response.data as List)
        .map((json) => BankAccount.fromJson(json))
        .toList();
  }

  Future<BankAccount> createAccount(CreateBankAccountRequest request) async {
    final response = await _dio.post('/accounts', data: {
      'name': request.name,
      'balance': request.balance,
      'currency': request.currency,
    });
    return BankAccount.fromJson(response.data);
  }

  Future<BankAccountWithStats> getAccountById(int id) async {
    final response = await _dio.get('/accounts/$id');
    return BankAccountWithStats.fromJson(response.data);
  }

  Future<BankAccount> updateAccount(
    int id,
    UpdateBankAccountRequest request,
  ) async {
    final response = await _dio.put('/accounts/$id', data: {
      'name': request.name,
      'balance': request.balance,
      'currency': request.currency,
    });
    return BankAccount.fromJson(response.data);
  }

  Future<void> deleteAccount(int id) async {
    await _dio.delete('/accounts/$id');
  }

  Future<AccountHistory> getAccountHistory(int id) async {
    final response = await _dio.get('/accounts/$id/history');
    return AccountHistory.fromJson(response.data);
  }

  // Category endpoints
  Future<List<Category>> getAllCategories() async {
    final response = await _dio.get('/categories');
    return (response.data as List)
        .map((json) => Category.fromJson(json))
        .toList();
  }

  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    final response = await _dio.get('/categories/type/$isIncome');
    return (response.data as List)
        .map((json) => Category.fromJson(json))
        .toList();
  }
}
