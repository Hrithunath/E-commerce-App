// ignore_for_file: use_build_context_synchronously
import 'package:e_commerce_app/core/Theme/appcolors.dart';
import 'package:e_commerce_app/core/constant/constant.dart';
import 'package:e_commerce_app/core/utils/validator.dart';
import 'package:e_commerce_app/presentation/Widget/button.dart';
import 'package:e_commerce_app/presentation/Widget/text.dart';
import 'package:e_commerce_app/presentation/Widget/textFormFeild.dart';
import 'package:e_commerce_app/presentation/bloc/ForgotPassword/forgot_password_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Recovery extends StatelessWidget {
  Recovery({super.key});
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSend) {
         
          Navigator.pushReplacementNamed(context,"/Login");
        }else if(state is ResetLinkFailed){
           print("resend Link failed");
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextCustom(
                    text:fogotPasswordTitle,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 25),
                  TextCustom(
                    text:
                        forgotPasswordSubTitle,
                    fontSize: 17,
                  ),
                  const SizedBox(height: 25),
                  Textformfeildcustom(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    label: "Your Email",
                    prefixIcon: Icons.email,
                  validator: (value) =>
                  Validator.validateEmail(value),
                  ),
                  const SizedBox(height: 30),
                  ButtonCustomized(
                    text: "Continue",
                      color: AppColors.primarycolor,
                    width: 300,
                    height: 50,
                    borderRadius: 10,
                    onPressed: () {
                     context.read <ForgotPasswordBloc>().add(SendResetLink(emailController.text.trim()));
                     
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
            content:
               Text('$passwordFailedToSend ${e.toString()}'),

            backgroundColor: AppColors.kred
          ),
        );
      }
    }
  }
}
