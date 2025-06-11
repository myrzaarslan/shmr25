import 'package:freezed_annotation/freezed_annotation.dart';
import 'bank_account.dart';
import 'category.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required int accountId,
    required int categoryId,
    required String amount,
    required DateTime transactionDate,
    String? comment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

@freezed
abstract class TransactionWithDetails with _$TransactionWithDetails {
  const factory TransactionWithDetails({
    required int id,
    required BankAccount account,
    required Category category,
    required String amount,
    required DateTime transactionDate,
    String? comment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TransactionWithDetails;

  factory TransactionWithDetails.fromJson(Map<String, dynamic> json) =>
      _$TransactionWithDetailsFromJson(json);
}

@freezed
abstract class CreateTransactionRequest with _$CreateTransactionRequest {
  const factory CreateTransactionRequest({
    required int accountId,
    required int categoryId,
    required String amount,
    required DateTime transactionDate,
    String? comment,
  }) = _CreateTransactionRequest;

  factory CreateTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTransactionRequestFromJson(json);
}

@freezed
abstract class UpdateTransactionRequest with _$UpdateTransactionRequest {
  const factory UpdateTransactionRequest({
    required int accountId,
    required int categoryId,
    required String amount,
    required DateTime transactionDate,
    String? comment,
  }) = _UpdateTransactionRequest;

  factory UpdateTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTransactionRequestFromJson(json);
}
