import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      onPressed: () {},
      backgroundColor: const Color(0xFF2ECC71),
      shape: const CircleBorder(),
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      child: SvgPicture.asset(
        'assets/icons/plus.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}
