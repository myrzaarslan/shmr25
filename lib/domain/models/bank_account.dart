import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_account.freezed.dart';
part 'bank_account.g.dart';

@freezed
abstract class BankAccount with _$BankAccount {
  const factory BankAccount({
    required int id,
    required int userId,
    required String name,
    required String balance,
    required String currency,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BankAccount;

  factory BankAccount.fromJson(Map<String, dynamic> json) =>
      _$BankAccountFromJson(json);
}

@freezed
abstract class BankAccountWithStats with _$BankAccountWithStats {
  const factory BankAccountWithStats({
    required int id,
    required String name,
    required String balance,
    required String currency,
    required List<CategoryStats> incomeStats,
    required List<CategoryStats> expenseStats,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BankAccountWithStats;

  factory BankAccountWithStats.fromJson(Map<String, dynamic> json) =>
      _$BankAccountWithStatsFromJson(json);
}

@freezed
abstract class CategoryStats with _$CategoryStats {
  const factory CategoryStats({
    required int categoryId,
    required String categoryName,
    required String emoji,
    required String amount,
  }) = _CategoryStats;

  factory CategoryStats.fromJson(Map<String, dynamic> json) =>
      _$CategoryStatsFromJson(json);
}

@freezed
abstract class CreateBankAccountRequest with _$CreateBankAccountRequest {
  const factory CreateBankAccountRequest({
    required String name,
    required String balance,
    required String currency,
  }) = _CreateBankAccountRequest;

  factory CreateBankAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBankAccountRequestFromJson(json);
}

@freezed
abstract class UpdateBankAccountRequest with _$UpdateBankAccountRequest {
  const factory UpdateBankAccountRequest({
    required String name,
    required String balance,
    required String currency,
  }) = _UpdateBankAccountRequest;

  factory UpdateBankAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateBankAccountRequestFromJson(json);
}
