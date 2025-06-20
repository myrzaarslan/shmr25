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
            icon: SvgPicture.asset(
              'assets/icons/analysis.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
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
                _buildTotalSection(state.totalAmount),
                const Divider(height: 1),
                Expanded(
                  child: state.transactions.isEmpty
                      ? _buildEmptyState()
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

          return _buildEmptyState();
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

  Widget _buildTotalSection(double totalAmount) {
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
            _formatRuble(totalAmount),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.isIncome ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRuble(double value) {
    return '${value.toStringAsFixed(0)} ₽';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.isIncome ? Icons.trending_up : Icons.trending_down,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            widget.isIncome
                ? 'Нет доходов за сегодня'
                : 'Нет расходов за сегодня',
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
