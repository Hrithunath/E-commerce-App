import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
              'https://lottie.host/5c09846e-0f86-4fd2-8e0f-df3e0d780015/bAGmD18dit.json',
              height: 250,
              width: 350),
          Center(
            child: const TextCustom(
              text: "Payment Done",
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          Center(
            child: const TextCustom(
              text: "Successfully",
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(
            height: 55,
          ),
          Center(
            child: SizedBox(
                height: 50,
                width: 200,
                child: ButtonCustomized(
                    text: 'Continue',
                    color: AppColors.primarycolor,
                    onPressed: () {})),
          ),
        ],
      ),
    );
  }
}
