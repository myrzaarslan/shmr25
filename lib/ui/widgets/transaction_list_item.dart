import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/transaction.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionWithDetails transaction;
  final VoidCallback? onTap;

  const TransactionListItem({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = transaction.category.isIncome ? Colors.green : Colors.red;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color(transaction.category.backgroundColor),
        child: Text(
          transaction.category.emoji,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      title: Text(
        transaction.category.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: transaction.comment != null && transaction.comment!.isNotEmpty
          ? Text(
              transaction.comment!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatAmount(transaction.amount, transaction.category.isIncome),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
      onTap: onTap,
    );
  }

  String _formatAmount(String amount, bool isIncome) {
    final parsed = double.tryParse(amount) ?? 0.0;
    final format = NumberFormat.currency(locale: 'ru_RU', symbol: '₽');
    final formatted = format.format(parsed);
    return '${isIncome ? '+' : '-'}${formatted}';
  }
}
