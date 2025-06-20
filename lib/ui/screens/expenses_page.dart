import 'package:flutter/material.dart';
import 'transactions_page.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionsScreen(isIncome: false);
  }
}
