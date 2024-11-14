import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar(
      {super.key, required this.title, this.action, required this.subtitle});
  final Widget title;
  final Widget subtitle;
  final List<Widget>? action;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          title,
          subtitle,
        ],
      ),
      actions: action,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
