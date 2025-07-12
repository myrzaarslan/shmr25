import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/models/transaction.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';
import '../../constants/sort_field.dart';

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
          .where((tx) => tx.category.isIncome == event.isIncome)
          .toList();

      print('Loaded transactions from local DB:');
      for (final tx in transactions) {
        print('id= [32m [1m [4m${tx.id} [0m, date=${tx.transactionDate}, isIncome=${tx.category.isIncome}, amount=${tx.amount}, categoryId=${tx.category.id}');
      }
      print('Filtered transactions for today (isIncome=${event.isIncome}):');
      for (final tx in filteredTransactions) {
        print('id=${tx.id}, date=${tx.transactionDate}, isIncome=${tx.category.isIncome}, amount=${tx.amount}, categoryId=${tx.category.id}');
      }

      final totalAmount = _calculateTotalAmount(filteredTransactions);

      // Check if we're in offline mode
      final isOffline = await _transactionRepository.hasUnsyncedEvents();

      if (state is TransactionLoaded) {
        final current = state as TransactionLoaded;

        emit(
          current.copyWith(
            incomeTransactions: event.isIncome
                ? filteredTransactions
                : current.incomeTransactions,
            expenseTransactions: event.isIncome
                ? current.expenseTransactions
                : filteredTransactions,
            totalIncomeAmount: event.isIncome
                ? totalAmount
                : current.totalIncomeAmount,
            totalExpenseAmount: event.isIncome
                ? current.totalExpenseAmount
                : totalAmount,
            isOffline: isOffline,
          ),
        );
      } else {
        emit(
          TransactionLoaded(
            incomeTransactions: event.isIncome ? filteredTransactions : [],
            expenseTransactions: event.isIncome ? [] : filteredTransactions,
            totalIncomeAmount: event.isIncome ? totalAmount : 0.0,
            totalExpenseAmount: event.isIncome ? 0.0 : totalAmount,
            isOffline: isOffline,
          ),
        );
      }
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
          .where((tx) => tx.category.isIncome == event.isIncome)
          .toList();

      // Сортировка
      if (event.sortBy == SortField.amount) {
        filteredTransactions.sort(
          (a, b) => double.parse(b.amount).compareTo(double.parse(a.amount)),
        );
      } else if (event.sortBy == SortField.date) {
        filteredTransactions.sort(
          (a, b) => b.transactionDate.compareTo(a.transactionDate),
        );
      }

      final totalAmount = _calculateTotalAmount(filteredTransactions);

      // Check if we're in offline mode
      final isOffline = await _transactionRepository.hasUnsyncedEvents();

      if (state is TransactionLoaded) {
        final current = state as TransactionLoaded;

        emit(
          current.copyWith(
            incomeTransactions: event.isIncome
                ? filteredTransactions
                : current.incomeTransactions,
            expenseTransactions: event.isIncome
                ? current.expenseTransactions
                : filteredTransactions,
            totalIncomeAmount: event.isIncome
                ? totalAmount
                : current.totalIncomeAmount,
            totalExpenseAmount: event.isIncome
                ? current.totalExpenseAmount
                : totalAmount,
            sortBy: event.sortBy,
            isOffline: isOffline,
          ),
        );
      } else {
        emit(
          TransactionLoaded(
            incomeTransactions: event.isIncome ? filteredTransactions : [],
            expenseTransactions: event.isIncome ? [] : filteredTransactions,
            totalIncomeAmount: event.isIncome ? totalAmount : 0.0,
            totalExpenseAmount: event.isIncome ? 0.0 : totalAmount,
            sortBy: event.sortBy,
            isOffline: isOffline,
          ),
        );
      }
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
      
      // Check if we're in offline mode after operation
      final isOffline = await _transactionRepository.hasUnsyncedEvents();
      
      if (isOffline) {
        emit(TransactionOperationSuccess('Транзакция добавлена (офлайн режим)'));
      } else {
        emit(TransactionOperationSuccess('Транзакция успешно добавлена'));
      }
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
      
      // Check if we're in offline mode after operation
      final isOffline = await _transactionRepository.hasUnsyncedEvents();
      
      if (isOffline) {
        emit(TransactionOperationSuccess('Транзакция обновлена (офлайн режим)'));
      } else {
        emit(TransactionOperationSuccess('Транзакция успешно обновлена'));
      }
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
      
      // Check if we're in offline mode after operation
      final isOffline = await _transactionRepository.hasUnsyncedEvents();
      
      if (isOffline) {
        emit(TransactionOperationSuccess('Транзакция удалена (офлайн режим)'));
      } else {
        emit(TransactionOperationSuccess('Транзакция успешно удалена'));
      }
    } catch (e) {
      emit(TransactionError('Ошибка удаления транзакции: ${e.toString()}'));
    }
  }

  double _calculateTotalAmount(List<TransactionWithDetails> transactions) {
    return transactions.fold(0.0, (sum, tx) {
      return sum + double.parse(tx.amount);
    });
  }
}
