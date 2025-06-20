import 'package:flutter/material.dart';
import '../../domain/models/transaction.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionWithDetails transaction;
  final VoidCallback? onTap;

  const TransactionListItem({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: transaction.category.isIncome
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            transaction.category.emoji,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
      title: Text(
        transaction.category.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatDateTime(transaction.transactionDate),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (transaction.comment != null && transaction.comment!.isNotEmpty)
            Text(
              transaction.comment!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatAmount(transaction.amount, transaction.category.isIncome),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: transaction.category.isIncome ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  String _formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute';
  }

  String _formatAmount(String amount, bool isIncome) {
    final parsed = double.tryParse(amount) ?? 0.0;
    return '${parsed.toStringAsFixed(2)} ₽';
  }
}
