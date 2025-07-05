import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../domain/models/transaction.dart';
import '../../domain/models/category.dart';
import '../../domain/models/bank_account.dart';
import '../../data/repositories/mock_transaction_repository.dart';
import '../../data/repositories/mock_category_repository.dart';
import '../../data/repositories/mock_bank_account_repository.dart';

class TransactionEditPage extends StatefulWidget {
  final bool isEdit;
  final TransactionWithDetails? transaction; // null для создания

  const TransactionEditPage({
    super.key,
    required this.isEdit,
    this.transaction,
  });

  @override
  State<TransactionEditPage> createState() => _TransactionEditPageState();
}

class _TransactionEditPageState extends State<TransactionEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _commentController = TextEditingController();
  
  late DateTime _selectedDate;
  Category? _selectedCategory;
  BankAccount? _selectedAccount;
  bool _isIncome = false;
  
  List<Category> _categories = [];
  List<BankAccount> _accounts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _initializeFields();
  }

  Future<void> _loadData() async {
    final categoryRepo = MockCategoryRepository();
    final accountRepo = MockBankAccountRepository();
    
    final categories = await categoryRepo.getAllCategories();
    final accounts = await accountRepo.getAllAccounts();
    
    setState(() {
      _categories = categories;
      _accounts = accounts;
      _selectedAccount = accounts.isNotEmpty ? accounts.first : null;
      _loading = false;
    });
  }

  void _initializeFields() {
    if (widget.isEdit && widget.transaction != null) {
      final tx = widget.transaction!;
      _amountController.text = tx.amount;
      _commentController.text = tx.comment ?? '';
      _selectedDate = tx.transactionDate;
      _selectedCategory = tx.category;
      _selectedAccount = tx.account;
      _isIncome = tx.category.isIncome;
    } else {
      _selectedDate = DateTime.now();
      _isIncome = false;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // Ограничение: не позже текущего дня
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _selectCategory() {
    final incomeCategories = _categories.where((c) => c.isIncome == _isIncome).toList();
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Выберите категорию',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: incomeCategories.length,
              itemBuilder: (context, index) {
                final category = incomeCategories[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(category.backgroundColor),
                    child: Text(category.emoji, style: const TextStyle(fontSize: 20)),
                  ),
                  title: Text(category.name),
                  onTap: () {
                    setState(() => _selectedCategory = category);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _selectAccount() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Выберите счёт',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _accounts.length,
              itemBuilder: (context, index) {
                final account = _accounts[index];
                return ListTile(
                  leading: const CircleAvatar(child: Text('💰')),
                  title: Text(account.name),
                  subtitle: Text('${account.balance} ${account.currency}'),
                  onTap: () {
                    setState(() => _selectedAccount = account);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleType() {
    setState(() {
      _isIncome = !_isIncome;
      _selectedCategory = null; // Сбрасываем категорию при смене типа
    });
  }

  bool _validateForm() {
    if (_amountController.text.trim().isEmpty) return false;
    if (_selectedCategory == null) return false;
    if (_selectedAccount == null) return false;
    return true;
  }

  void _showValidationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: const Text('Пожалуйста, заполните все поля'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveTransaction() async {
    if (!_validateForm()) {
      _showValidationDialog();
      return;
    }

    final repo = MockTransactionRepository();
    final amount = _amountController.text.trim();
    final comment = _commentController.text.trim().isEmpty ? null : _commentController.text.trim();

    try {
      if (widget.isEdit && widget.transaction != null) {
        // Редактирование
        await repo.updateTransaction(
          widget.transaction!.id,
          UpdateTransactionRequest(
            accountId: _selectedAccount!.id,
            categoryId: _selectedCategory!.id,
            amount: amount,
            transactionDate: _selectedDate,
            comment: comment,
          ),
        );
      } else {
        // Создание
        await repo.createTransaction(
          CreateTransactionRequest(
            accountId: _selectedAccount!.id,
            categoryId: _selectedCategory!.id,
            amount: amount,
            transactionDate: _selectedDate,
            comment: comment,
          ),
        );
      }
      Navigator.pop(context, true); // Возвращаем true для обновления списка
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Редактировать операцию' : 'Новая операция'),
        actions: [
          TextButton(
            onPressed: _saveTransaction,
            child: const Text('Сохранить'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Переключатель Доход/Расход
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isIncome = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isIncome ? Colors.red[100] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text('Расход', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isIncome = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isIncome ? Colors.green[100] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text('Доход', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Счёт
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance),
                title: const Text('Счёт'),
                subtitle: Text(_selectedAccount?.name ?? 'Выберите счёт'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _selectAccount,
              ),
            ),
            const SizedBox(height: 8),
            
            // Категория
            Card(
              child: ListTile(
                leading: _selectedCategory != null
                    ? CircleAvatar(
                        backgroundColor: Color(_selectedCategory!.backgroundColor),
                        child: Text(_selectedCategory!.emoji, style: const TextStyle(fontSize: 20)),
                      )
                    : const Icon(Icons.category),
                title: const Text('Категория'),
                subtitle: Text(_selectedCategory?.name ?? 'Выберите категорию'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _selectCategory,
              ),
            ),
            const SizedBox(height: 8),
            
            // Сумма
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Сумма', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Только цифры и точка
                      ],
                      decoration: const InputDecoration(
                        hintText: '0.00',
                        border: OutlineInputBorder(),
                        prefixText: '₽ ',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Дата
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Дата'),
                subtitle: Text(DateFormat('dd.MM.yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _selectDate,
              ),
            ),
            const SizedBox(height: 8),
            
            // Комментарий
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Комментарий', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _commentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Комментарий',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 