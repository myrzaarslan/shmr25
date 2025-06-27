import 'package:flutter/material.dart';
import 'package:finance_app/ui/widgets/app_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:finance_app/ui/screens/account_edit_page.dart';
import 'package:finance_app/constants/assets.dart';
import 'package:finance_app/ui/widgets/account_list_item.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
      body: Column(children: [AccountListItem()]),
    );
  }
}
