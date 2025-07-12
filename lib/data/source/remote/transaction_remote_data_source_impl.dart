import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:finance_app/domain/models/transaction.dart';
import 'transaction_remote_data_source.dart';

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;
  final _dateFormat = DateFormat('yyyy-MM-dd');

  TransactionRemoteDataSourceImpl(this.dio);

  @override
  Future<Transaction> createTransaction(
    CreateTransactionRequest request,
  ) async {
    final response = await dio.post('/transactions', data: request.toJson());
    return Transaction.fromJson(response.data);
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await dio.delete('/transactions/$id');
  }

  @override
  Future<TransactionWithDetails> getTransactionById(int id) async {
    final response = await dio.get('/transactions/$id');
    return TransactionWithDetails.fromJson(response.data);
  }

  @override
  Future<TransactionWithDetails> updateTransaction(
    int id,
    UpdateTransactionRequest request,
  ) async {
    final response = await dio.put('/transactions/$id', data: request.toJson());
    return TransactionWithDetails.fromJson(response.data);
  }

  @override
  Future<List<TransactionWithDetails>> getTransactionsByAccountAndPeriod(
    int accountId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final query = {
      if (startDate != null) 'startDate': _dateFormat.format(startDate),
      if (endDate != null) 'endDate': _dateFormat.format(endDate),
    };

    final response = await dio.get(
      '/transactions/account/$accountId/period',
      queryParameters: query,
    );
    final List data = response.data;
    return data.map((json) => TransactionWithDetails.fromJson(json)).toList();
  }
}
