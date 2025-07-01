import 'package:flutter/material.dart';
import 'package:finance_app/ui/widgets/app_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:finance_app/ui/screens/account_edit_page.dart';
import 'package:finance_app/constants/assets.dart';
import 'package:finance_app/constants/currency_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_app/cubit/currency/currency_cubit.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shake_gesture/shake_gesture.dart';
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
  StreamSubscription? _accelSub;
  bool _down = false;
  List<double> _lastAccel = [0, 0, 0];
  static const double shakeThreshold = 15.0;

  @override
  void initState() {
    super.initState();
    _accelSub = accelerometerEvents.listen(_handleAccel);
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

  @override
  void dispose() {
    _accelSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Мой счет',
        actions: [
          IconButton(
            icon: Icon(_hidden ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() => _hidden = !_hidden);
            },
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, size: 24, color: Colors.black),
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
          _AccountListItem(
            hidden: _hidden,
            onShake: () => setState(() => _hidden = !_hidden),
          ),
          Divider(height: 0),
          _BalanceListItem(),
        ],
      ),
    );
  }
}

class _AccountListItem extends StatelessWidget {
  final bool hidden;
  final VoidCallback onShake;
  const _AccountListItem({this.hidden = false, required this.onShake});
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.white;
    final avatar = "💰";
    final accountName = "Баланс";
    return ShakeGesture(
      onShake: onShake,
      child: ListTile(
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
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
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
                            '••••••',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      key: const ValueKey('visible'),
                      child: Text(
                        _wholeBalance(context),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
        tileColor: Color(0xFFE8F5E9),
      ),
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
  return Icon(currency.icon, size: 24, color: Colors.black);
}

String _wholeBalance(BuildContext context) {
  // TODO
  final currency = context.watch<CurrencyCubit>().state;
  final balance = '60000 ${currency.symbol}';
  return balance;
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
