import 'package:flutter/material.dart';
import 'package:finance_app/data/repositories/mock_bank_account_repository.dart';

class AccountListItem extends StatefulWidget {
  final VoidCallback? onTap;

  const AccountListItem({super.key, this.onTap});

  @override
  State<AccountListItem> createState() => _AccountListItemState();
}

class _AccountListItemState extends State<AccountListItem> {
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
          Text(
            _wholeBalance(),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
      tileColor: Color(0xFFE8F5E9),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 1),
      ),
    );
  }
}

String _wholeBalance() {
  // TODO
  return '600000 \$';
}
