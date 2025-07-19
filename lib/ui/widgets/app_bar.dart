import 'package:flutter/material.dart';

class Appbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const Appbar({super.key, required this.title, this.actions, this.leading});

  @override
  State<Appbar> createState() => _FAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _FAppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: widget.leading,
      actions: widget.actions,
      title: Text(
        widget.title, 
        style: TextStyle(
          fontSize: 22,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }
}
