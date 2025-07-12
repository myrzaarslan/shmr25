import 'package:finance_app/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../domain/models/transaction.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/add_transaction_fab.dart';
import 'transaction_edit_page.dart';
import 'transaction_history_page.dart';
import 'add_transaction_page.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../data/repositories/drift_transaction_repository.dart';
import '../widgets/offline_banner.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';

class TransactionsScreen extends StatefulWidget {
  final bool isIncome;
  final int accountId;

  const TransactionsScreen({
    super.key,
    required this.isIncome,
    this.accountId = 144,
  });

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  bool _syncing = false;
  bool _isOffline = false;
  Set<int> _unsyncedIds = {};

  @override
  void initState() {
    super.initState();
    _syncAndLoadTransactions();
  }

  Future<void> _syncAndLoadTransactions() async {
    setState(() {
      _syncing = true;
      _isOffline = false;
    });
    final repo = context.read<TransactionRepository>();
    if (repo is DriftTransactionRepository) {
      try {
        await repo.syncFromApi();
        _unsyncedIds = await repo.getUnsyncedTransactionIds();
      } catch (e) {
        setState(() => _isOffline = true);
        await OfflineBanner.showErrorDialog(context, e.toString());
      }
    }
    setState(() => _syncing = false);
    _loadTransactions();
  }

  void _loadTransactions() {
    context.read<TransactionBloc>().add(
      LoadTransactionsForToday(
        accountId: widget.accountId,
        isIncome: widget.isIncome,
      ),
    );
  }

  void _editTransaction(TransactionWithDetails transaction) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TransactionEditPage(isEdit: true, transaction: transaction),
      ),
    );
    if (result == true) {
      _loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = context.watch<ConnectivityProvider>().isOffline || _isOffline;
    return Scaffold(
      appBar: Appbar(
        title: widget.isIncome ? 'Доходы сегодня' : 'Расходы сегодня',
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 24, color: Colors.black),
            onPressed: _syncAndLoadTransactions,
            tooltip: 'Обновить',
          ),
          IconButton(
            icon: Icon(Icons.history, size: 24, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionHistoryPage(
                    isIncome: widget.isIncome,
                    accountId: widget.accountId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          OfflineBanner(isOffline: isOffline),
          Expanded(
            child: _syncing
                ? const Center(child: CircularProgressIndicator())
                : BlocConsumer<TransactionBloc, TransactionState>(
                    listener: (context, state) async {
                      if (state is TransactionError) {
                        setState(() => _isOffline = true);
                        await OfflineBanner.showErrorDialog(context, state.message);
                      } else if (state is TransactionOperationSuccess) {
                        setState(() => _isOffline = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.green,
                          ),
                        );
                        _loadTransactions();
                      }
                    },
                    builder: (context, state) {
                      if (state is TransactionLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is TransactionError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error, size: 64, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                'Произошла ошибка',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(state.message),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadTransactions,
                                child: const Text('Повторить'),
                              ),
                            ],
                          ),
                        );
                      }
                      if (state is TransactionLoaded) {
                        final txs = widget.isIncome
                            ? (state.incomeTransactions ?? [])
                            : (state.expenseTransactions ?? []);
                        final total = widget.isIncome
                            ? state.totalIncomeAmount
                            : state.totalExpenseAmount;
                        return Column(
                          children: [
                            _TotalSection(totalAmount: total, isIncome: widget.isIncome),
                            const Divider(height: 1),
                            Expanded(
                              child: txs.isEmpty
                                  ? _EmptyState(isIncome: widget.isIncome)
                                  : ListView.builder(
                                      itemCount: txs.length,
                                      itemBuilder: (context, index) {
                                        final tx = txs[index];
                                        return TransactionListItem(
                                          transaction: tx,
                                          isUnsynced: _unsyncedIds.contains(tx.id),
                                          onTap: () {
                                            _editTransaction(tx);
                                          },
                                        );
                                      },
                                    ),
                            ),
                          ],
                        );
                      }
                      return _EmptyState(isIncome: widget.isIncome);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: AddTransactionFab(
        isIncome: widget.isIncome,
        accountId: widget.accountId,
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionPage(
                isIncome: widget.isIncome,
                accountId: widget.accountId,
              ),
            ),
          );
          if (result == true) {
            _loadTransactions();
          }
        },
      ),
    );
  }
}

class _TotalSection extends StatelessWidget {
  final double totalAmount;
  final bool isIncome;

  const _TotalSection({required this.totalAmount, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Всего',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            '${totalAmount.toStringAsFixed(0)} ₽',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isIncome;

  const _EmptyState({required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isIncome ? Icons.trending_up : Icons.trending_down,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            isIncome ? 'Нет доходов за сегодня' : 'Нет расходов за сегодня',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Добавьте первую транзакцию',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
