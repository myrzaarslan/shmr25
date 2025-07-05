import 'package:finance_app/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/add_transaction_fab.dart';
import 'add_transaction_page.dart';
import 'transaction_history_page.dart';
import '../../constants/assets.dart';

class TransactionsScreen extends StatefulWidget {
  final bool isIncome;
  final int accountId;

  const TransactionsScreen({
    super.key,
    required this.isIncome,
    this.accountId = 1,
  });

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: widget.isIncome ? 'Доходы сегодня' : 'Расходы сегодня',
        actions: [
          IconButton(
            icon: Icon(Icons.history, size: 24, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionHistoryScreen(
                    isIncome: widget.isIncome,
                    accountId: widget.accountId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is TransactionOperationSuccess) {
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
            return Column(
              children: [
                _TotalSection(
                  totalAmount: state.totalAmount,
                  isIncome: widget.isIncome,
                ),
                const Divider(height: 1),
                Expanded(
                  child: state.transactions.isEmpty
                      ? _EmptyState(isIncome: widget.isIncome)
                      : ListView.builder(
                          itemCount: state.transactions.length,
                          itemBuilder: (context, index) {
                            return TransactionListItem(
                              transaction: state.transactions[index],
                              onTap: () {
                                // TODO
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
      floatingActionButton: AddTransactionFab(
        isIncome: widget.isIncome,
        accountId: widget.accountId,
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(
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
