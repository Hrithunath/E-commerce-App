import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';

class Registered extends StatelessWidget {
  const Registered({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: screenHeight * 0.08),
        TextCustom(
          text: "Don’t have an account? ",
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.w300,
        ),
        TextCustom(
          onTap: () => Navigator.pushNamed(context, "/Register"),
          text: "Register",
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.bold,
          color: AppColors.primarycolor,
        ),
      ],
    );
  }
}
