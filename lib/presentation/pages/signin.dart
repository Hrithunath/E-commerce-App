import 'package:e_commerce_app/core/Theme/appcolors.dart';
import 'package:e_commerce_app/core/constant/constant.dart';
import 'package:e_commerce_app/core/utils/validator.dart';
import 'package:e_commerce_app/domain/model/user_model.dart';
import 'package:e_commerce_app/presentation/Widget/button.dart';
import 'package:e_commerce_app/presentation/Widget/login/signin_options.dart';
import 'package:e_commerce_app/presentation/Widget/text.dart';
import 'package:e_commerce_app/presentation/Widget/textFormFeild.dart';
import 'package:e_commerce_app/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce_app/presentation/pages/signup.dart';
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
        if (state is Authenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User authenticated successfully!')),
          );
          Navigator.pushNamedAndRemoveUntil(
              context, "/HomeBottom", (route) => false);
        } else if (state is UnAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('User not authenticated. Please log in.')),
          );
        } else if (state is AuthenticatedError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication error: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
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
                          sufixIcon:
                              isObscure ? Icons.visibility_off : Icons.visibility,
                          validator: (value) =>
                              Validator.validatePassword(value)),
                      SizedBox(height: screenHeight * 0.025),
                      ButtonCustomized(
                        text: "Sign in",
                        color: AppColors.primarycolor,
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.07,
                        borderRadius: 10,
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                      UserModel user = UserModel(
                        email: emailController.text.trim(),
                        password: passWordController.text.trim(),
                      );
                      context.read<AuthBloc>().add(SignInEvent(
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
                            TextCustom(
                              onTap: () {
                                  context.read<AuthBloc>().add(GoogleSignInEvent());
                              },
                              text: "Login with Google",
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w500,
                              color: AppColors.kgreylight,
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
                           Registered(screenHeight: screenHeight, screenWidth: screenWidth),
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
