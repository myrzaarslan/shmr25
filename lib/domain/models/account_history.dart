import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_history.freezed.dart';
part 'account_history.g.dart';

@freezed
abstract class AccountHistory with _$AccountHistory {
  const factory AccountHistory({
    required int accountId,
    required String accountName,
    required String currency,
    required String currentBalance,
    required List<AccountHistoryItem> history,
  }) = _AccountHistory;

  factory AccountHistory.fromJson(Map<String, dynamic> json) =>
      _$AccountHistoryFromJson(json);
}

@freezed
abstract class AccountHistoryItem with _$AccountHistoryItem {
  const factory AccountHistoryItem({
    required int id,
    required int accountId,
    required String changeType,
    required AccountState previousState,
    required AccountState newState,
    required DateTime changeTimestamp,
    required DateTime createdAt,
  }) = _AccountHistoryItem;

  factory AccountHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$AccountHistoryItemFromJson(json);
}

@freezed
abstract class AccountState with _$AccountState {
  const factory AccountState({
    required int id,
    required String name,
    required String balance,
    required String currency,
  }) = _AccountState;

  factory AccountState.fromJson(Map<String, dynamic> json) =>
      _$AccountStateFromJson(json);
}
