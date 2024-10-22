
import 'package:e_commerce_app/core/Theme/appcolors.dart';
import 'package:e_commerce_app/presentation/Widget/text.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({
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
        SizedBox(width: screenHeight * 0.075),
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
