import 'package:flutter/widgets.dart';

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
    return const Placeholder();
  }
}
