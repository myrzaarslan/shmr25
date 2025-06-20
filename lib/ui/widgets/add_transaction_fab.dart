import 'package:flutter/material.dart';

class AddTransactionFab extends StatelessWidget {
  final bool isIncome;
  final int accountId;
  final VoidCallback onPressed;

  const AddTransactionFab({
    super.key,
    required this.isIncome,
    required this.accountId,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF2ECC71),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
