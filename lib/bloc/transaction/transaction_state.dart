import '../../../domain/models/transaction.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionWithDetails> transactions;
  final double totalAmount;
  final String sortBy;

  TransactionLoaded({
    required this.transactions,
    required this.totalAmount,
    this.sortBy = 'date',
  });

  TransactionLoaded copyWith({
    List<TransactionWithDetails>? transactions,
    double? totalAmount,
    String? sortBy,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? this.transactions,
      totalAmount: totalAmount ?? this.totalAmount,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TransactionLoaded &&
            runtimeType == other.runtimeType &&
            transactions == other.transactions &&
            totalAmount == other.totalAmount &&
            sortBy == other.sortBy;
  }

  @override
  int get hashCode =>
      transactions.hashCode ^ totalAmount.hashCode ^ sortBy.hashCode;
}

class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

class TransactionOperationSuccess extends TransactionState {
  final String message;

  TransactionOperationSuccess(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionOperationSuccess &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
