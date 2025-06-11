// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
  id: (json['id'] as num).toInt(),
  accountId: (json['accountId'] as num).toInt(),
  categoryId: (json['categoryId'] as num).toInt(),
  amount: json['amount'] as String,
  transactionDate: DateTime.parse(json['transactionDate'] as String),
  comment: json['comment'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'categoryId': instance.categoryId,
      'amount': instance.amount,
      'transactionDate': instance.transactionDate.toIso8601String(),
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_TransactionWithDetails _$TransactionWithDetailsFromJson(
  Map<String, dynamic> json,
) => _TransactionWithDetails(
  id: (json['id'] as num).toInt(),
  account: BankAccount.fromJson(json['account'] as Map<String, dynamic>),
  category: Category.fromJson(json['category'] as Map<String, dynamic>),
  amount: json['amount'] as String,
  transactionDate: DateTime.parse(json['transactionDate'] as String),
  comment: json['comment'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TransactionWithDetailsToJson(
  _TransactionWithDetails instance,
) => <String, dynamic>{
  'id': instance.id,
  'account': instance.account,
  'category': instance.category,
  'amount': instance.amount,
  'transactionDate': instance.transactionDate.toIso8601String(),
  'comment': instance.comment,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_CreateTransactionRequest _$CreateTransactionRequestFromJson(
  Map<String, dynamic> json,
) => _CreateTransactionRequest(
  accountId: (json['accountId'] as num).toInt(),
  categoryId: (json['categoryId'] as num).toInt(),
  amount: json['amount'] as String,
  transactionDate: DateTime.parse(json['transactionDate'] as String),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$CreateTransactionRequestToJson(
  _CreateTransactionRequest instance,
) => <String, dynamic>{
  'accountId': instance.accountId,
  'categoryId': instance.categoryId,
  'amount': instance.amount,
  'transactionDate': instance.transactionDate.toIso8601String(),
  'comment': instance.comment,
};

_UpdateTransactionRequest _$UpdateTransactionRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateTransactionRequest(
  accountId: (json['accountId'] as num).toInt(),
  categoryId: (json['categoryId'] as num).toInt(),
  amount: json['amount'] as String,
  transactionDate: DateTime.parse(json['transactionDate'] as String),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$UpdateTransactionRequestToJson(
  _UpdateTransactionRequest instance,
) => <String, dynamic>{
  'accountId': instance.accountId,
  'categoryId': instance.categoryId,
  'amount': instance.amount,
  'transactionDate': instance.transactionDate.toIso8601String(),
  'comment': instance.comment,
};
