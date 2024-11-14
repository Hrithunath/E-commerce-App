import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentFailed extends StatelessWidget {
  const PaymentFailed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
              'https://lottie.host/a11f2a21-7a04-40a8-8ed5-3211f2f0b0ec/O0Q0y1D2e0.json',
              height: 250,
              width: 350),
          const Center(
            child: TextCustom(
              text: "Payment Failed",
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Center(
            child: TextCustom(
              text: "Please try again",
              fontSize: 25,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(
            height: 55,
          ),
          Center(
            child: SizedBox(
                height: 50,
                width: 200,
                child: ButtonCustomized(
                    text: 'Try again',
                    color: AppColors.primarycolor,
                    onPressed: () {})),
          ),
        ],
      ),
    );
  }
}
