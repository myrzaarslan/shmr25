// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountHistory _$AccountHistoryFromJson(Map<String, dynamic> json) =>
    _AccountHistory(
      accountId: (json['accountId'] as num).toInt(),
      accountName: json['accountName'] as String,
      currency: json['currency'] as String,
      currentBalance: json['currentBalance'] as String,
      history: (json['history'] as List<dynamic>)
          .map((e) => AccountHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccountHistoryToJson(_AccountHistory instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'accountName': instance.accountName,
      'currency': instance.currency,
      'currentBalance': instance.currentBalance,
      'history': instance.history,
    };

_AccountHistoryItem _$AccountHistoryItemFromJson(Map<String, dynamic> json) =>
    _AccountHistoryItem(
      id: (json['id'] as num).toInt(),
      accountId: (json['accountId'] as num).toInt(),
      changeType: json['changeType'] as String,
      previousState: BankAccount.fromJson(
        json['previousState'] as Map<String, dynamic>,
      ),
      newState: BankAccount.fromJson(json['newState'] as Map<String, dynamic>),
      changeTimestamp: DateTime.parse(json['changeTimestamp'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AccountHistoryItemToJson(_AccountHistoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'changeType': instance.changeType,
      'previousState': instance.previousState,
      'newState': instance.newState,
      'changeTimestamp': instance.changeTimestamp.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
