import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../domain/models/transaction.dart';
import '../../domain/models/category.dart';
import '../../domain/models/bank_account.dart';
import '../widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/bank_account_repository.dart';

class TransactionEditPage extends StatefulWidget {
  final bool isEdit;
  final TransactionWithDetails? transaction;
  const TransactionEditPage({super.key, required this.isEdit, this.transaction});

  @override
  State<TransactionEditPage> createState() => _TransactionEditPageState();
}

class _TransactionEditPageState extends State<TransactionEditPage> {
  final _amountController = TextEditingController();
  final _commentController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  Category? _selectedCategory;
  BankAccount? _selectedAccount;
  bool _isIncome = false;
  List<Category> _categories = [];
  List<BankAccount> _accounts = [];
  bool _loading = true;
  late String _decimalSeparator;
  bool _didInitFields = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _decimalSeparator = NumberFormat.simpleCurrency(locale: Localizations.localeOf(context).toString()).symbols.DECIMAL_SEP;
    if (!_didInitFields) {
      _initializeFields();
      _didInitFields = true;
    }
  }

  Future<void> _loadData() async {
    final categoryRepo = context.read<CategoryRepository>();
    final accountRepo = context.read<BankAccountRepository>();
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
      _amountController.text = tx.amount.replaceAll('.', _decimalSeparator);
      _commentController.text = tx.comment ?? '';
      _selectedDate = tx.transactionDate;
      _selectedTime = TimeOfDay.fromDateTime(tx.transactionDate);
      _selectedCategory = tx.category;
      _selectedAccount = tx.account;
      _isIncome = tx.category.isIncome;
    } else {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
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
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _selectCategory() {
    final filtered = _categories.where((c) => c.isIncome == _isIncome).toList();
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final category = filtered[index];
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
    );
  }

  void _selectAccount() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
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
    );
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
    final repo = context.read<TransactionRepository>();
    final amount = _amountController.text.trim().replaceAll(_decimalSeparator, '.');
    final comment = _commentController.text.trim().isEmpty ? null : _commentController.text.trim();
    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
    try {
      if (widget.isEdit && widget.transaction != null) {
        await repo.updateTransaction(
          widget.transaction!.id,
          UpdateTransactionRequest(
            accountId: _selectedAccount!.id,
            categoryId: _selectedCategory!.id,
            amount: amount,
            transactionDate: dateTime,
            comment: comment,
          ),
        );
      } else {
        await repo.createTransaction(
          CreateTransactionRequest(
            accountId: _selectedAccount!.id,
            categoryId: _selectedCategory!.id,
            amount: amount,
            transactionDate: dateTime,
            comment: comment,
          ),
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTransaction() async {
    if (!widget.isEdit || widget.transaction == null) return;
    final repo = context.read<TransactionRepository>();
    try {
      await repo.deleteTransaction(widget.transaction!.id);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final dateStr = _selectedDate != null ? DateFormat('dd.MM.yyyy').format(_selectedDate!) : '';
    final timeStr = _selectedTime != null ? _selectedTime!.format(context) : '';
    final decimalSeparator = _decimalSeparator;
    return Scaffold(
      appBar: Appbar(
        title: widget.isEdit ? 'Мои расходы' : ( _isIncome ? 'Мои доходы' : 'Мои расходы'),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.black),
            onPressed: _saveTransaction,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Счёт'),
              subtitle: Text(_selectedAccount?.name ?? ''),
              trailing: const Icon(Icons.chevron_right),
              onTap: _selectAccount,
            ),
            const Divider(height: 0),
            ListTile(
              title: const Text('Статья'),
              subtitle: Text(_selectedCategory?.name ?? ''),
              trailing: const Icon(Icons.chevron_right),
              onTap: _selectCategory,
            ),
            const Divider(height: 0),
            ListTile(
              title: const Text('Сумма'),
              subtitle: TextField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  _AmountInputFormatter(decimalSeparator),
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Divider(height: 0),
            ListTile(
              title: const Text('Дата'),
              subtitle: Text(dateStr),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(), // Ограничение по текущей дате
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
            ),
            const Divider(height: 0),
            ListTile(
              title: const Text('Время'),
              subtitle: Text(timeStr),
              trailing: const Icon(Icons.chevron_right),
              onTap: _selectTime,
            ),
            const Divider(height: 0),
            ListTile(
              title: const Text('Комментарий'),
              subtitle: TextField(
                controller: _commentController,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Комментарий',
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (widget.isEdit)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[300],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _deleteTransaction,
                    child: const Text('Удалить расход'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// --- Formatter for amount field ---
class _AmountInputFormatter extends TextInputFormatter {
  final String separator;
  _AmountInputFormatter(this.separator);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    // Only digits and one separator
    final reg = RegExp('[0-9${RegExp.escape(separator)}]');
    String filtered = '';
    int sepCount = 0;
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (char == separator) {
        if (sepCount == 0) {
          filtered += char;
          sepCount++;
        }
      } else if (reg.hasMatch(char)) {
        filtered += char;
      }
    }
    // Only one separator allowed
    if (filtered.split(separator).length > 2) {
      filtered = filtered.replaceFirst(separator, '');
    }
    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
} 