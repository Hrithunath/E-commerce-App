import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';

class CustomTextRow extends StatelessWidget {
  const CustomTextRow(
      {super.key,
      required this.leading,
      required this.trailing,
      required this.onTap});
  final String leading;
  final String trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextCustom(
            text: leading,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
          TextCustom(
            text: trailing,
            fontSize: 17,
            fontWeight: FontWeight.w900,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
