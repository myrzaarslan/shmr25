// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BankAccount _$BankAccountFromJson(Map<String, dynamic> json) => _BankAccount(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  name: json['name'] as String,
  balance: json['balance'] as String,
  currency: json['currency'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BankAccountToJson(_BankAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'balance': instance.balance,
      'currency': instance.currency,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_BankAccountWithStats _$BankAccountWithStatsFromJson(
  Map<String, dynamic> json,
) => _BankAccountWithStats(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  balance: json['balance'] as String,
  currency: json['currency'] as String,
  incomeStats: (json['incomeStats'] as List<dynamic>)
      .map((e) => CategoryStats.fromJson(e as Map<String, dynamic>))
      .toList(),
  expenseStats: (json['expenseStats'] as List<dynamic>)
      .map((e) => CategoryStats.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BankAccountWithStatsToJson(
  _BankAccountWithStats instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'balance': instance.balance,
  'currency': instance.currency,
  'incomeStats': instance.incomeStats,
  'expenseStats': instance.expenseStats,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_CategoryStats _$CategoryStatsFromJson(Map<String, dynamic> json) =>
    _CategoryStats(
      categoryId: (json['categoryId'] as num).toInt(),
      categoryName: json['categoryName'] as String,
      emoji: json['emoji'] as String,
      amount: json['amount'] as String,
    );

Map<String, dynamic> _$CategoryStatsToJson(_CategoryStats instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'emoji': instance.emoji,
      'amount': instance.amount,
    };

_CreateBankAccountRequest _$CreateBankAccountRequestFromJson(
  Map<String, dynamic> json,
) => _CreateBankAccountRequest(
  name: json['name'] as String,
  balance: json['balance'] as String,
  currency: json['currency'] as String,
);

Map<String, dynamic> _$CreateBankAccountRequestToJson(
  _CreateBankAccountRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'balance': instance.balance,
  'currency': instance.currency,
};

_UpdateBankAccountRequest _$UpdateBankAccountRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateBankAccountRequest(
  name: json['name'] as String,
  balance: json['balance'] as String,
  currency: json['currency'] as String,
);

Map<String, dynamic> _$UpdateBankAccountRequestToJson(
  _UpdateBankAccountRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'balance': instance.balance,
  'currency': instance.currency,
};
