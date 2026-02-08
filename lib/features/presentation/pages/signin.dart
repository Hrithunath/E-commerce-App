import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_scaffold_messenger.dart';

import 'package:e_commerce_app/core/utils/validator.dart';

import 'package:e_commerce_app/features/presentation/Widget/button.dart';

import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_field.dart';
import 'package:e_commerce_app/features/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/core/constants/app_strings.dart';

class LoginWrapper extends StatelessWidget {
  const LoginWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const Login();
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  bool isObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          context.showSuccessSnackBar(AppStrings.userAuthenticated);
          Navigator.pushNamedAndRemoveUntil(
              context, "/HomeBottom", (route) => false);
        } else if (state is AuthErrorState) {
          context.showErrorSnackBar(
              '${AppStrings.authenticationError}${state.errorMessage}');
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: AppColors.bgColor,
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  child: Form(
                    key: formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.05),
                          // 1. App Icon
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primarycolor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primarycolor.withOpacity(0.3),
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
                          SizedBox(height: screenHeight * 0.02),

                          // 2. Title & Subtitle
                          const TextCustom(
                            text: "Welcome to StrideSmart",
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8),
                          TextCustom(
                            text: "Sign in to continue",
                            fontSize: 16,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          // 3. Google Login Button (Top)
                          ElevatedButton(
                            onPressed: state is AuthLoadingState
                                ? null
                                : () {
                                    context
                                        .read<AuthBloc>()
                                        .add(GoogleSignInEvent());
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 1,
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/google.png",
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 10),
                                const TextCustom(
                                  text: "Login with Google",
                                  fontSize: 16,
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // 4. Divider "OR"
                          Row(
                            children: [
                              Expanded(
                                  child: Divider(color: Colors.grey.shade200)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Divider(color: Colors.grey.shade200)),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // 5. Email Field
                          CustomTextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            hint: "Email",
                            prefix: Icon(Icons.email_outlined,
                                color: Colors.grey.shade400),
                            validator: (value) =>
                                Validator.validateEmail(value),
                            fillColor: const Color(0xFFF5F5F5),
                            borderColor: Colors.transparent,
                          ),
                          const SizedBox(height: 16),

                          // 6. Password Field
                          CustomTextField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: passWordController,
                            hint: "Password",
                            prefix: Icon(Icons.lock_outline,
                                color: Colors.grey.shade400),
                            obscure: isObscure,
                            suffix: IconButton(
                              icon: Icon(
                                isObscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey.shade400,
                              ),
                              onPressed: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                            ),
                            validator: (value) =>
                                Validator.validatePassword(value),
                            fillColor: const Color(0xFFF5F5F5),
                            borderColor: Colors.transparent,
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // 7. Sign In Button
                          ButtonCustomized(
                            text: "Sign in",
                            color: AppColors.primarycolor,
                            width: double.infinity,
                            height: 55,
                            borderRadius: 30,
                            onPressed: state is AuthLoadingState
                                ? () {}
                                : () {
                                    if (formkey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(LoginEvent(
                                          email: emailController.text.trim(),
                                          password:
                                              passWordController.text.trim()));
                                    }
                                  },
                          ),

                          const SizedBox(height: 20),

                          // 8. Forgot Password
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, "/Recovery"),
                            child: const TextCustom(
                              text: "Forgot Password",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primarycolor,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // 9. Register
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextCustom(
                                text: "Don't have an account? ",
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                              GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, "/Register"),
                                child: const TextCustom(
                                  text: "Register",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primarycolor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (state is AuthLoadingState)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primarycolor,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
