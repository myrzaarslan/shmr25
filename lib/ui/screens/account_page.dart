import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../cubit/account/account_cubit.dart';
import '../../cubit/currency/currency_cubit.dart';
import '../../constants/currency_field.dart';
import '../../ui/widgets/app_bar.dart';
import '../../ui/widgets/account_chart.dart';
import '../../domain/repositories/bank_account_repository.dart';
import '../../domain/models/bank_account.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CurrencyCubit(),
      child: const _AccountView(),
    );
  }
}

class _AccountView extends StatefulWidget {
  const _AccountView();

  @override
  State<_AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<_AccountView> {
  bool _hidden = false;
  StreamSubscription? _accelSub;
  bool _down = false;
  List<double> _lastAccel = [0, 0, 0];
  static const double shakeThreshold = 15.0;

  final List<double> _days = List.filled(30, 0);
  final List<String> _labels = List.generate(
    30,
    (i) => '${(i + 1).toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}',
  );

  BankAccount? _account;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _accelSub = accelerometerEvents.listen(_handleAccel);
    _loadAccount();
    // Example: generate mock transactions
    for (int i = 0; i < _days.length; i++) {
      _days[i] = i % 2 == 0 ? i * 1000.0 : -i * 500.0;
    }
  }

  Future<void> _loadAccount() async {
    setState(() => _loading = true);
    final repo = context.read<BankAccountRepository>();
    final accounts = await repo.getAllAccounts();
    setState(() {
      _account = accounts.isNotEmpty ? accounts.first : null;
      _loading = false;
    });
  }

  void _handleAccel(AccelerometerEvent event) {
    final dx = event.x - _lastAccel[0];
    final dy = event.y - _lastAccel[1];
    final dz = event.z - _lastAccel[2];
    final delta = sqrt(dx * dx + dy * dy + dz * dz);
    _lastAccel = [event.x, event.y, event.z];

    if (delta > shakeThreshold) {
      setState(() => _hidden = !_hidden);
    }

    if (event.z < -6) {
      if (!_down) {
        _down = true;
        setState(() => _hidden = true);
      }
    } else if (event.z > 6) {
      if (_down) {
        _down = false;
        setState(() => _hidden = false);
      }
    }
  }

  Future<void> _showRenameDialog() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить название счёта'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Введите название'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              context.read<AccountCubit>().changeAccount(newName);
              Navigator.of(context).pop();
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<CurrencyCubit>().state.symbol;
    return Scaffold(
      appBar: Appbar(
        title: _account?.name ?? 'Счёт',
        actions: [
          IconButton(
            icon: Icon(
              _hidden ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: () => setState(() => _hidden = !_hidden),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 24, color: Colors.black),
            onPressed: _showRenameDialog,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _AccountListItem(hidden: _hidden, account: _account),
                const Divider(height: 0),
                const _BalanceListItem(),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: AccountChart(
                    values: _days,
                    labels: _labels,
                    currency: currency,
                  ),
                ),
              ],
            ),
    );
  }
}

class _AccountListItem extends StatelessWidget {
  final bool hidden;
  final BankAccount? account;
  const _AccountListItem({required this.hidden, required this.account});

  @override
  Widget build(BuildContext context) {
    final balance = account?.balance ?? '0.00';
    final currency = context.watch<CurrencyCubit>().state.symbol;
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Text('💰', style: TextStyle(fontSize: 20)),
      ),
      title: const Text("Баланс", style: TextStyle(fontSize: 20)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: hidden
                ? Container(
                    key: const ValueKey('hidden'),
                    width: 80,
                    height: 24,
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 60,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '•••••',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                : Text(
                    '$balance $currency',
                    key: const ValueKey('visible'),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
      tileColor: const Color(0xFFE8F5E9),
    );
  }
}

class _BalanceListItem extends StatelessWidget {
  const _BalanceListItem();

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<CurrencyCubit>().state;
    return ListTile(
      title: const Text("Валюта", style: TextStyle(fontSize: 20)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(currency.icon, size: 24, color: Colors.black),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
      tileColor: const Color(0xFFE8F5E9),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        builder: (_) => BlocProvider.value(
          value: context.read<CurrencyCubit>(),
          child: const CurrencyPickerBottomSheet(),
        ),
      ),
    );
  }
}

class CurrencyPickerBottomSheet extends StatelessWidget {
  const CurrencyPickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CurrencyTile(currency: CurrencyField.ruble),
        const Divider(height: 0),
        const CurrencyTile(currency: CurrencyField.dollar),
        const Divider(height: 0),
        const CurrencyTile(currency: CurrencyField.euro),
        const Divider(height: 0),
        ListTile(
          tileColor: Colors.red,
          contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
          leading: const Icon(Icons.cancel_outlined, color: Colors.white, size: 20),
          title: Text("Отмена", style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white)),
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class CurrencyTile extends StatelessWidget {
  final CurrencyField currency;
  const CurrencyTile({super.key, required this.currency});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
      leading: Icon(currency.icon, size: 24, color: Colors.black),
      title: Text(currency.name),
      onTap: () {
        context.read<CurrencyCubit>().changeCurrency(currency);
        Navigator.of(context).pop();
      },
    );
  }
}
