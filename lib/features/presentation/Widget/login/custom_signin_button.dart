// import 'package:e_commerce_shoes/domain/model/user_model.dart';
// import 'package:e_commerce_shoes/presentation/bloc/auth_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// final formkey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passWordController = TextEditingController();
  
// void SigninButton(BuildContext context) {
//     if (formkey.currentState!.validate()) {
//       UserModel user = UserModel(
//         email: emailController.text.trim(),
//         password: passWordController.text.trim(),
//       );
//       context.read<AuthBloc>().add(SignInEvent(
//           email: emailController.text,
//           password: passWordController.text));
//     }
//   }