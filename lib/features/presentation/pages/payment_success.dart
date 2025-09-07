import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final lottieHeight = screenHeight * 0.3; 
    final lottieWidth = screenWidth * 0.8; 
    final fontSizeMain = screenWidth * 0.08; 
    final spacing = screenHeight * 0.03;
    final buttonHeight = screenHeight * 0.065;
    final buttonWidth = screenWidth * 0.6;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/5c09846e-0f86-4fd2-8e0f-df3e0d780015/bAGmD18dit.json',
              height: lottieHeight,
              width: lottieWidth,
            ),
            SizedBox(height: spacing),
            TextCustom(
              text: "Payment Done",
              fontSize: fontSizeMain,
              fontWeight: FontWeight.w900,
            ),
            SizedBox(height: spacing * 0.5),
            TextCustom(
              text: "Successfully",
              fontSize: fontSizeMain,
              fontWeight: FontWeight.w900,
            ),
            SizedBox(height: spacing * 2),
            SizedBox(
              height: buttonHeight,
              width: buttonWidth,
              child: ButtonCustomized(
                text: 'Continue',
                color: AppColors.primarycolor,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/HomeBottom");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
