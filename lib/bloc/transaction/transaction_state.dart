import 'package:finance_app/constants/sort_field.dart';
import '../../../domain/models/transaction.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionWithDetails> incomeTransactions;
  final List<TransactionWithDetails> expenseTransactions;
  final double totalIncomeAmount;
  final double totalExpenseAmount;
  final SortField sortBy;
  final bool isOffline; // Add offline mode detection

  TransactionLoaded({
    required this.incomeTransactions,
    required this.expenseTransactions,
    required this.totalIncomeAmount,
    required this.totalExpenseAmount,
    this.sortBy = SortField.date,
    this.isOffline = false, // Default to online mode
  });

  TransactionLoaded copyWith({
    List<TransactionWithDetails>? incomeTransactions,
    List<TransactionWithDetails>? expenseTransactions,
    double? totalIncomeAmount,
    double? totalExpenseAmount,
    SortField? sortBy,
    bool? isOffline,
  }) {
    return TransactionLoaded(
      incomeTransactions: incomeTransactions ?? this.incomeTransactions,
      expenseTransactions: expenseTransactions ?? this.expenseTransactions,
      totalIncomeAmount: totalIncomeAmount ?? this.totalIncomeAmount,
      totalExpenseAmount: totalExpenseAmount ?? this.totalExpenseAmount,
      sortBy: sortBy ?? this.sortBy,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TransactionLoaded &&
            runtimeType == other.runtimeType &&
            incomeTransactions == other.incomeTransactions &&
            expenseTransactions == other.expenseTransactions &&
            totalIncomeAmount == other.totalIncomeAmount &&
            totalExpenseAmount == other.totalExpenseAmount &&
            sortBy == other.sortBy &&
            isOffline == other.isOffline;
  }

  @override
  int get hashCode =>
      incomeTransactions.hashCode ^
      expenseTransactions.hashCode ^
      totalIncomeAmount.hashCode ^
      totalExpenseAmount.hashCode ^
      sortBy.hashCode ^
      isOffline.hashCode;
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
