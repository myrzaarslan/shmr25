import 'package:flutter/material.dart';
import 'transactions_page.dart';

class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionsScreen(isIncome: true);
  }
}
