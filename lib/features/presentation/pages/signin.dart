import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/core/constant/constant.dart';
import 'package:e_commerce_app/core/utils/validator.dart';
import 'package:e_commerce_app/features/domain/model/user_model.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/login/custom_signin_options.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_Form_Feild.dart';
import 'package:e_commerce_app/features/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWrapper extends StatelessWidget {
  const LoginWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Login(),
    );
  }
}

class Login extends StatelessWidget {
  Login({super.key});
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final isObscure = false;
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User authenticated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushNamedAndRemoveUntil(
              context, "/HomeBottom", (route) => false);
        } else if (state is UnAuthenticatedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('User not authenticated. Please log in.')),
          );
        } else if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Authentication error: ${state.errorMessage}')),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Padding(
              padding: EdgeInsets.all(screenWidth * 0.07),
              child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.2),
                      TextCustom(
                        text: loginTitle,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextCustom(
                          text: loginSubTitle,
                          fontSize: screenWidth * 0.045,
                          color: AppColors.kgrey),
                      Textformfeildcustom(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        label: "Email",
                        prefixIcon: Icons.email,
                        validator: (value) => Validator.validateEmail(value),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Textformfeildcustom(
                          keyboardType: TextInputType.visiblePassword,
                          controller: passWordController,
                          label: "Password",
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: isObscure,
                          sufixIcon: isObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          validator: (value) =>
                              Validator.validatePassword(value)),
                      SizedBox(height: screenHeight * 0.025),
                      ButtonCustomized(
                        text: "Sign in",
                        color: AppColors.primarycolor,
                        width: screenWidth * 0.6,
                        height: screenHeight * 0.06,
                        borderRadius: 50,
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            UserModel user = UserModel(
                              email: emailController.text.trim(),
                              password: passWordController.text.trim(),
                            );
                            context.read<AuthBloc>().add(LoginEvent(
                                email: emailController.text,
                                password: passWordController.text));
                          }
                        },
                      ),
                      TextCustom(
                        text: "OR",
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kgreylight,
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<AuthBloc>().add(GoogleSignInEvent());
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/google.png",
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 8),
                                TextCustom(
                                  text: "Login with Google",
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.kgreylight,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      TextCustom(
                        onTap: () => Navigator.pushNamed(context, "/Recovery"),
                        text: "Forgot Password",
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primarycolor,
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Registered(
                          screenHeight: screenHeight, screenWidth: screenWidth),
                      SizedBox(height: screenHeight * 0.025),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
