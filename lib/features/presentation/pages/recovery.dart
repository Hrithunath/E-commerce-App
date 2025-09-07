// ignore_for_file: use_build_context_synchronously
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/core/constant/constant.dart';
import 'package:e_commerce_app/core/utils/validator.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_Form_Feild.dart';
import 'package:e_commerce_app/features/presentation/bloc/ForgotPassword/forgot_password_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Recovery extends StatelessWidget {
  Recovery({super.key});
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.07; 
    final verticalSpacingSmall = screenHeight * 0.02;
    final verticalSpacingMedium = screenHeight * 0.03;
    final verticalSpacingLarge = screenHeight * 0.05;
    final buttonWidth = screenWidth * 0.8; 
    final buttonHeight = screenHeight * 0.065; 

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSend) {
          Navigator.pushReplacementNamed(context, "/Login");
        } else if (state is ResetLinkFailed) {
          print("resend Link failed");
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextCustom(
                    text: fogotPasswordTitle,
                    fontSize: screenWidth * 0.055, 
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: verticalSpacingLarge),
                  TextCustom(
                    text: forgotPasswordSubTitle,
                    fontSize: screenWidth * 0.045, 
                  ),
                  SizedBox(height: verticalSpacingLarge),
                  Textformfeildcustom(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    label: "Your Email",
                    prefixIcon: Icons.email,
                    validator: (value) => Validator.validateEmail(value),
                  ),
                  SizedBox(height: verticalSpacingMedium),
                  ButtonCustomized(
                    text: "Continue",
                    color: AppColors.primarycolor,
                    width: buttonWidth,
                    height: buttonHeight,
                    borderRadius: 10,
                    onPressed: () {
                      context
                          .read<ForgotPasswordBloc>()
                          .add(SendResetLink(emailController.text.trim()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword(BuildContext context) async {
    if (!formkey.currentState!.validate()) {
      return;
    }
    final email = emailController.text.trim();
    if (email.isNotEmpty) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(passwordResetTitle),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacementNamed(context, "/Login");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('$passwordFailedToSend ${e.toString()}'),
              backgroundColor: AppColors.kred),
        );
      }
    }
  }
}
