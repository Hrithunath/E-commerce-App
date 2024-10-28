//  import 'package:e_commerce_app/domain/model/user_model.dart';
// import 'package:e_commerce_app/presentation/bloc/auth_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//  final formkey = GlobalKey<FormState>();
  
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final passwordAgainController = TextEditingController();
  
// void SignButton(BuildContext context) {
//     if (formkey.currentState!.validate()) {
//       UserModel user = UserModel(
//         name: nameController.text,
//         email: emailController.text,
//         password: passwordController.text,
//         passwordAgain: passwordAgainController.text,
//       );
//       context.read<AuthBloc>().add(SignUpEvent(user: user));
//     }
//   }
