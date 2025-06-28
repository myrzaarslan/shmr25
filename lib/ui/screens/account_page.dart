import 'package:flutter/material.dart';
import 'package:finance_app/ui/widgets/app_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:finance_app/ui/screens/account_edit_page.dart';
import 'package:finance_app/constants/assets.dart';
import 'package:finance_app/constants/currency_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_app/cubit/currency/currency_cubit.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => CurrencyCubit(), child: _AccountView());
  }
}

class _AccountView extends StatefulWidget {
  @override
  State<_AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<_AccountView> {
  bool _hidden = false;
  StreamSubscription? _sub;
  static const double shakeThreshold = 18.0;
  List<double> _lastAccel = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    _sub = accelerometerEvents.listen(_onAccel);
  }

  void _onAccel(AccelerometerEvent event) {
    // Shake detection
    final dx = event.x - _lastAccel[0];
    final dy = event.y - _lastAccel[1];
    final dz = event.z - _lastAccel[2];
    final delta = sqrt(dx * dx + dy * dy + dz * dz);
    _lastAccel = [event.x, event.y, event.z];
    if (delta > shakeThreshold) {
      setState(() => _hidden = !_hidden);
    }
    // Переворот экраном вниз (z < -8)
    if (event.x < -4) {
      if (!_hidden) setState(() => _hidden = true);
    }
    // Переворот экраном вверх (z > 8)
    if (event.x > 4) {
      if (_hidden) setState(() => _hidden = false);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Мой счет',
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppAssets.editIcon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountEditScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _AccountListItem(hidden: _hidden),
          Divider(),
          _BalanceListItem(),
        ],
      ),
    );
  }
}

class _AccountListItem extends StatelessWidget {
  final bool hidden;
  const _AccountListItem({this.hidden = false});
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.white;
    final avatar = "💰";
    final accountName = "Баланс";
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: backgroundColor,
        child: Text(avatar, style: const TextStyle(fontSize: 20)),
      ),
      title: Text(accountName, style: const TextStyle(fontSize: 20)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
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
                        child: Text('••••••', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ),
                    ),
                  )
                : Container(
                    key: const ValueKey('visible'),
                    child: Text(
                      _wholeBalance(),
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
      tileColor: Color(0xFFE8F5E9),
    );
  }
}

class _BalanceListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currency = context.watch<CurrencyCubit>().state;
    return ListTile(
      title: Text("Валюта", style: const TextStyle(fontSize: 20)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCurrencyIcon(currency),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
      tileColor: Color(0xFFE8F5E9),
      onTap: () async {
        await showModalBottomSheet<void>(
          context: context,
          builder: (bottomSheetContext) {
            return BlocProvider.value(
              value: context.read<CurrencyCubit>(),
              child: const CurrencyPickerBottomSheet(),
            );
          },
        );
      },
    );
  }
}

Widget _buildCurrencyIcon(CurrencyField currency) {
  switch (currency) {
    case CurrencyField.ruble:
      return const Icon(Icons.currency_ruble, size: 24, color: Colors.black);
    case CurrencyField.dollar:
      return const Icon(Icons.attach_money, size: 24, color: Colors.black);
    case CurrencyField.euro:
      return const Icon(Icons.euro, size: 24, color: Colors.black);
  }
}

String _wholeBalance() {
  // TODO
  return '600000 \$';
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
        const Divider(),
        const CurrencyTile(currency: CurrencyField.dollar),
        const Divider(),
        const CurrencyTile(currency: CurrencyField.euro),
        const Divider(),
        ListTile(
          tileColor: Colors.red,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 14,
          ),
          leading: const Icon(
            Icons.cancel_outlined,
            color: Colors.white,
            size: 20,
          ),
          title: Text(
            "Отмена",
            style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class CurrencyTile extends StatelessWidget {
  const CurrencyTile({super.key, required this.currency});

  final CurrencyField currency;

  @override
  Widget build(BuildContext context) {
    final currencyIcon = switch (currency) {
      CurrencyField.ruble => const Icon(
        Icons.currency_ruble,
        size: 24,
        color: Colors.black,
      ),
      CurrencyField.dollar => const Icon(
        Icons.attach_money,
        size: 24,
        color: Colors.black,
      ),
      CurrencyField.euro => const Icon(
        Icons.euro,
        size: 24,
        color: Colors.black,
      ),
    };

    final currencyDescription = switch (currency) {
      CurrencyField.ruble => "Российский рубль ₽",
      CurrencyField.dollar => "Американский доллар \$",
      CurrencyField.euro => "Евро",
    };

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
      leading: currencyIcon,
      title: Text(currencyDescription),
      onTap: () {
        context.read<CurrencyCubit>().changeCurrency(currency);
        Navigator.of(context).pop();
      },
    );
  }
}
