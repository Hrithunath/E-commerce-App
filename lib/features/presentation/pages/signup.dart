import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_scaffold_messenger.dart';
import 'package:e_commerce_app/core/constant/constant.dart';
import 'package:e_commerce_app/core/utils/validator.dart';
import 'package:e_commerce_app/features/domain/model/user_model.dart';
import 'package:e_commerce_app/features/presentation/Widget/button.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_widget.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_text_field.dart';
import 'package:e_commerce_app/features/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/core/constants/app_strings.dart';

class RegisterWrapper extends StatelessWidget {
  const RegisterWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return Register();
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordAgainController = TextEditingController();
  bool isObscure = true;
  bool isObscureAgain = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordAgainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          context.showSuccessSnackBar(AppStrings.accountCreated);
          Navigator.pushNamedAndRemoveUntil(
              context, "/HomeBottom", (route) => false);
        } else if (state is AuthErrorState) {
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            SafeArea(
              child: Scaffold(
                backgroundColor: AppColors.bgColor,
                body: Form(
                  key: formkey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
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
                          SizedBox(height: screenHeight * 0.03),

                          // 2. Title & Subtitle
                          TextCustom(
                            text: signupTitle,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8),
                          TextCustom(
                            text: signupSubTitle,
                            fontSize: 16,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // 3. Google Sign-up Button
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
                                  text: "Sign up with Google",
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

                          // 5. Input Fields
                          CustomTextField(
                            keyboardType: TextInputType.name,
                            controller: nameController,
                            hint: "Full Name",
                            prefix: Icon(Icons.person_outline,
                                color: Colors.grey.shade400),
                            validator: (value) =>
                                Validator.validateUsername(value),
                            fillColor: const Color(0xFFF8F9FA),
                            borderColor: Colors.transparent,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            hint: "Your Email",
                            prefix: Icon(Icons.email_outlined,
                                color: Colors.grey.shade400),
                            validator: (value) =>
                                Validator.validateEmail(value),
                            fillColor: const Color(0xFFF8F9FA),
                            borderColor: Colors.transparent,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: passwordController,
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
                            fillColor: const Color(0xFFF8F9FA),
                            borderColor: Colors.transparent,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: passwordAgainController,
                            hint: "Password Again",
                            prefix: Icon(Icons.lock_outline,
                                color: Colors.grey.shade400),
                            obscure: isObscureAgain,
                            suffix: IconButton(
                              icon: Icon(
                                isObscureAgain
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey.shade400,
                              ),
                              onPressed: () {
                                setState(() {
                                  isObscureAgain = !isObscureAgain;
                                });
                              },
                            ),
                            validator: (value) =>
                                Validator.validateAgainPassword(
                                    value, passwordController.text),
                            fillColor: const Color(0xFFF8F9FA),
                            borderColor: Colors.transparent,
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // 6. Sign Up Button
                          ButtonCustomized(
                            text: "Sign Up",
                            color: AppColors.primarycolor,
                            width: double.infinity,
                            height: 55,
                            borderRadius: 30,
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                UserModel user = UserModel(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  passwordAgain:
                                      passwordAgainController.text.trim(),
                                );
                                context
                                    .read<AuthBloc>()
                                    .add(SignUpEvent(user: user));
                              }
                            },
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          // 7. Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextCustom(
                                text: "Do you have an account? ",
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                              GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, "/Login"),
                                child: const TextCustom(
                                  text: "Sign in",
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
