import 'package:finance_app/bloc/transaction/transaction_bloc.dart';
import 'package:finance_app/bloc/transaction/transaction_event.dart';
import 'package:finance_app/bloc/transaction/transaction_state.dart';
import 'package:finance_app/data/repositories/mock_category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/mock_transaction_repository.dart';
import '../widgets/app_bar.dart';
import '../../constants/sort_field.dart';
import '../../constants/assets.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final bool isIncome;
  final int accountId;

  const TransactionHistoryScreen({
    super.key,
    required this.isIncome,
    this.accountId = 1,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionBloc(
        transactionRepository: MockTransactionRepository(),
        categoryRepository: MockCategoryRepository(),
      ),
      child: TransactionHistoryView(isIncome: isIncome, accountId: accountId),
    );
  }
}

class TransactionHistoryView extends StatefulWidget {
  final bool isIncome;
  final int accountId;

  const TransactionHistoryView({
    super.key,
    required this.isIncome,
    this.accountId = 1,
  });

  @override
  State<TransactionHistoryView> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<TransactionHistoryView> {
  late DateTime startDate;
  late DateTime endDate;
  String selectedSort = 'По дате';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    startDate = DateTime(now.year, now.month - 1, now.day);
    endDate = now;
    _loadTransactions();
  }

  void _loadTransactions() {
    context.read<TransactionBloc>().add(
      LoadTransactionsForPeriod(
        accountId: widget.accountId,
        isIncome: widget.isIncome,
        startDate: startDate,
        endDate: endDate,
        sortBy: selectedSort == 'По дате' ? SortField.date : SortField.amount,
      ),
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      if (isStart) {
        startDate = picked;
        if (startDate.isAfter(endDate)) endDate = startDate;
      } else {
        endDate = picked;
        if (endDate.isBefore(startDate)) startDate = endDate;
      }
      _loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: widget.isIncome ? 'История доходов' : 'История расходов',
        leading: IconButton(
          icon: SvgPicture.asset(
            AppAssets.backArrow,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          _TransactionFilterPanel(
            startDate: startDate,
            endDate: endDate,
            selectedSort: selectedSort,
            isIncome: widget.isIncome,
            onStartDateTap: () => _pickDate(isStart: true),
            onEndDateTap: () => _pickDate(isStart: false),
            onSortChange: (value) {
              setState(() => selectedSort = value);
              _loadTransactions();
            },
          ),
          Expanded(child: _TransactionListView(isIncome: widget.isIncome)),
        ],
      ),
    );
  }
}

class _TransactionFilterPanel extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String selectedSort;
  final VoidCallback onStartDateTap;
  final VoidCallback onEndDateTap;
  final ValueChanged<String> onSortChange;
  final bool isIncome;

  const _TransactionFilterPanel({
    required this.startDate,
    required this.endDate,
    required this.selectedSort,
    required this.onStartDateTap,
    required this.onEndDateTap,
    required this.onSortChange,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8F5E9),
      child: Column(
        children: [
          ListTile(
            title: const Text('Начало'),
            trailing: Text(DateFormat('dd.MM.yyyy').format(startDate)),
            onTap: onStartDateTap,
          ),
          ListTile(
            title: const Text('Конец'),
            trailing: Text(DateFormat('dd.MM.yyyy').format(endDate)),
            onTap: onEndDateTap,
          ),
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state is! TransactionLoaded) return const SizedBox.shrink();
              return Column(
                children: [
                  ListTile(
                    title: const Text('Сортировка'),
                    trailing: DropdownButton<String>(
                      value: selectedSort,
                      items: ['По дате', 'По сумме']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) onSortChange(value);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Сумма'),
                    trailing: Text(
                      '${state.totalAmount.toStringAsFixed(2)} ₽',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TransactionListView extends StatelessWidget {
  final bool isIncome;

  const _TransactionListView({required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TransactionError) {
          return Center(child: Text(state.message));
        }
        if (state is TransactionLoaded) {
          if (state.transactions.isEmpty) {
            return const Center(child: Text('Нет транзакций за период'));
          }
          return ListView.builder(
            itemCount: state.transactions.length,
            itemBuilder: (_, index) {
              final t = state.transactions[index];
              final amountColor = isIncome ? Colors.green : Colors.red;
              return ListTile(
                leading: Text(
                  t.category.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(t.category.name),
                subtitle: Text(t.comment ?? ''),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isIncome ? '+' : '-'} ${NumberFormat.currency(locale: 'ru_RU', symbol: '₽').format(double.parse(t.amount))}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: amountColor,
                      ),
                    ),
                    Text(
                      DateFormat('dd.MM.yyyy HH:mm').format(t.transactionDate),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
