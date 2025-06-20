import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  final bool isIncome;
  final int accountId;
  const AddTransactionScreen({
    super.key,
    required this.isIncome,
    required this.accountId,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Статьи')),
      body: Center(child: Text('Список статей')),
    );
  }
}
