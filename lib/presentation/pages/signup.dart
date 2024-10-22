import 'package:e_commerce_app/core/Theme/appcolors.dart';
import 'package:e_commerce_app/core/constant/constant.dart';
import 'package:e_commerce_app/core/utils/validator.dart';
import 'package:e_commerce_app/presentation/Widget/Register/signup_button.dart';
import 'package:e_commerce_app/presentation/Widget/button.dart';
import 'package:e_commerce_app/presentation/Widget/text.dart';
import 'package:e_commerce_app/presentation/Widget/textFormFeild.dart';
import 'package:e_commerce_app/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterWrapper extends StatelessWidget {
  const RegisterWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Register(),
    );
  }
}

class Register extends StatelessWidget {
  Register({super.key,});
  final formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordAgainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is Authenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(context,  "/HomeBottom", (route) => false);
    });
      }

      return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.02),
            child: SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.2),
                    TextCustom(
                      text: signupTitle,
                      fontSize: screenHeight * 0.03,
                    ),
                    TextCustom(
                      text: signupSubTitle,
                      fontSize: screenHeight * 0.02,
                    ),
                    Textformfeildcustom(
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      label: "Full Name",
                      hintText: "Enter your Full Name",
                      prefixIcon: Icons.person,
                      validator: (value) => Validator.validateUsername(value),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Textformfeildcustom(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      label: "Your Email",
                      hintText: "Enter your Email",
                      prefixIcon: Icons.email,
                      validator: (value) => Validator.validateEmail(value),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Textformfeildcustom(
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      label: "Password",
                      hintText: "Enter your password",
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: (value) => Validator.validatePassword(value),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Textformfeildcustom(
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordAgainController,
                      label: "Password Again",
                      hintText: "Re-enter your password",
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: (value) => Validator.validateAgainPassword(
                          value, passwordController.text),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    ButtonCustomized(
                      text: "Sign Up",
                      color: AppColors.primarycolor,
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.07,
                      borderRadius: 10,
                      onPressed: () async {
                        SignButton(context);
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    SizedBox(width: screenWidth * 0.3),
                    TextCustom(
                      text: "Do you have an account? ",
                      fontSize: screenHeight * 0.018,
                      fontWeight: FontWeight.w300,
                    ),
                    TextCustom(
                      onTap: () => Navigator.pushNamed(context, "/Login"),
                      text: "Sign in",
                      fontSize: screenHeight * 0.018,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primarycolor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }


}