import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/transaction_repository.dart';
import '../../../domain/repositories/category_repository.dart';
import '../../domain/models/transaction.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionRepository;
  final CategoryRepository _categoryRepository;

  TransactionBloc({
    required TransactionRepository transactionRepository,
    required CategoryRepository categoryRepository,
  }) : _transactionRepository = transactionRepository,
       _categoryRepository = categoryRepository,
       super(TransactionInitial()) {
    on<LoadTransactionsForToday>(_onLoadTransactionsForToday);
    on<LoadTransactionsForPeriod>(_onLoadTransactionsForPeriod);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactionsForToday(
    LoadTransactionsForToday event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final transactions = await _transactionRepository
          .getTransactionsByAccountAndPeriod(
            event.accountId,
            startDate: startOfDay,
            endDate: endOfDay,
          );

      final filteredTransactions = transactions
          .where(
            (transaction) => transaction.category.isIncome == event.isIncome,
          )
          .toList();

      final totalAmount = _calculateTotalAmount(filteredTransactions);

      emit(
        TransactionLoaded(
          transactions: filteredTransactions,
          totalAmount: totalAmount,
        ),
      );
    } catch (e) {
      emit(TransactionError('Ошибка загрузки транзакций: ${e.toString()}'));
    }
  }

  Future<void> _onLoadTransactionsForPeriod(
    LoadTransactionsForPeriod event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final startOfDay = DateTime(
        event.startDate.year,
        event.startDate.month,
        event.startDate.day,
      );
      final endOfDay = DateTime(
        event.endDate.year,
        event.endDate.month,
        event.endDate.day,
        23,
        59,
        59,
      );

      final transactions = await _transactionRepository
          .getTransactionsByAccountAndPeriod(
            event.accountId,
            startDate: startOfDay,
            endDate: endOfDay,
          );

      var filteredTransactions = transactions
          .where(
            (transaction) => transaction.category.isIncome == event.isIncome,
          )
          .toList();

      // Сортировка
      if (event.sortBy == 'amount') {
        filteredTransactions.sort(
          (a, b) => double.parse(b.amount).compareTo(double.parse(a.amount)),
        );
      } else {
        filteredTransactions.sort(
          (a, b) => b.transactionDate.compareTo(a.transactionDate),
        );
      }

      final totalAmount = _calculateTotalAmount(filteredTransactions);

      emit(
        TransactionLoaded(
          transactions: filteredTransactions,
          totalAmount: totalAmount,
          sortBy: event.sortBy,
        ),
      );
    } catch (e) {
      emit(TransactionError('Ошибка загрузки транзакций: ${e.toString()}'));
    }
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await _transactionRepository.createTransaction(event.request);
      emit(TransactionOperationSuccess('Транзакция успешно добавлена'));
    } catch (e) {
      emit(TransactionError('Ошибка добавления транзакции: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await _transactionRepository.updateTransaction(event.id, event.request);
      emit(TransactionOperationSuccess('Транзакция успешно обновлена'));
    } catch (e) {
      emit(TransactionError('Ошибка обновления транзакции: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await _transactionRepository.deleteTransaction(event.id);
      emit(TransactionOperationSuccess('Транзакция успешно удалена'));
    } catch (e) {
      emit(TransactionError('Ошибка удаления транзакции: ${e.toString()}'));
    }
  }

  double _calculateTotalAmount(List<TransactionWithDetails> transactions) {
    return transactions.fold(0.0, (sum, transaction) {
      return sum + double.parse(transaction.amount);
    });
  }
}
