// ignore_for_file: use_build_context_synchronously
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_scaffold_messenger.dart';
import 'package:e_commerce_app/core/constant/constant.dart';
import 'package:e_commerce_app/core/utils/validator.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_field.dart';
import 'package:e_commerce_app/features/presentation/bloc/ForgotPassword/forgot_password_bloc.dart';
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

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSend) {
          context.showSuccessSnackBar(passwordResetTitle);
          Navigator.pushReplacementNamed(context, "/Login");
        } else if (state is ResetLinkFailed) {
          context.showErrorSnackBar(state.error);
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.bgColor,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
            child: Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.1),
                    // 1. App Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primarycolor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primarycolor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // 2. Title & Subtitle
                    TextCustom(
                      text: fogotPasswordTitle,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    TextCustom(
                      text: forgotPasswordSubTitle,
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.05),

                    // 3. Email Field
                    CustomTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      hint: "Enter your Email",
                      prefix: Icon(Icons.email_outlined,
                          color: Colors.grey.shade400),
                      validator: (value) => Validator.validateEmail(value),
                      fillColor: const Color(0xFFF8F9FA),
                      borderColor: Colors.transparent,
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // 4. Reset Button
                    ButtonCustomized(
                      text: "Continue",
                      color: AppColors.primarycolor,
                      width: double.infinity,
                      height: 55,
                      borderRadius: 30,
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          context
                              .read<ForgotPasswordBloc>()
                              .add(SendResetLink(emailController.text.trim()));
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // 5. Back to Login
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const TextCustom(
                        text: "Back to Login",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primarycolor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
