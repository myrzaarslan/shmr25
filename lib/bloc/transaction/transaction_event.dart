import '../../../domain/models/transaction.dart';
import '../../constants/sort_field.dart';

abstract class TransactionEvent {}

class LoadTransactionsForToday extends TransactionEvent {
  final int accountId;
  final bool isIncome;

  LoadTransactionsForToday({required this.accountId, required this.isIncome});

  @override
  bool operator ==(Object other) =>
      other is LoadTransactionsForToday &&
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
  final SortField sortBy;

  LoadTransactionsForPeriod({
    required this.accountId,
    required this.isIncome,
    required this.startDate,
    required this.endDate,
    this.sortBy = SortField.date,
  });

  @override
  bool operator ==(Object other) =>
      other is LoadTransactionsForPeriod &&
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
      other is AddTransaction && request == other.request;

  @override
  int get hashCode => request.hashCode;
}

class UpdateTransaction extends TransactionEvent {
  final int id;
  final UpdateTransactionRequest request;

  UpdateTransaction(this.id, this.request);

  @override
  bool operator ==(Object other) =>
      other is UpdateTransaction && id == other.id && request == other.request;

  @override
  int get hashCode => id.hashCode ^ request.hashCode;
}

class DeleteTransaction extends TransactionEvent {
  final int id;

  DeleteTransaction(this.id);

  @override
  bool operator ==(Object other) =>
      other is DeleteTransaction && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
