import '../../../domain/models/transaction.dart';

abstract class TransactionEvent {}

class LoadTransactionsForToday extends TransactionEvent {
  final int accountId;
  final bool isIncome;

  LoadTransactionsForToday({required this.accountId, required this.isIncome});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadTransactionsForToday &&
          runtimeType == other.runtimeType &&
          accountId == other.accountId &&
          isIncome == other.isIncome;

  @override
  int get hashCode => accountId.hashCode ^ isIncome.hashCode;
}

class LoadTransactionsForPeriod extends TransactionEvent {
  final int accountId;
  final bool isIncome;
  final DateTime startDate;
  final DateTime endDate;
  final String sortBy;

  LoadTransactionsForPeriod({
    required this.accountId,
    required this.isIncome,
    required this.startDate,
    required this.endDate,
    this.sortBy = 'date',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadTransactionsForPeriod &&
          runtimeType == other.runtimeType &&
          accountId == other.accountId &&
          isIncome == other.isIncome &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          sortBy == other.sortBy;

  @override
  int get hashCode =>
      accountId.hashCode ^
      isIncome.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      sortBy.hashCode;
}

class AddTransaction extends TransactionEvent {
  final CreateTransactionRequest request;

  AddTransaction(this.request);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddTransaction &&
          runtimeType == other.runtimeType &&
          request == other.request;

  @override
  int get hashCode => request.hashCode;
}

class UpdateTransaction extends TransactionEvent {
  final int id;
  final UpdateTransactionRequest request;

  UpdateTransaction(this.id, this.request);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateTransaction &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          request == other.request;

  @override
  int get hashCode => id.hashCode ^ request.hashCode;
}

class DeleteTransaction extends TransactionEvent {
  final int id;

  DeleteTransaction(this.id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteTransaction &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
