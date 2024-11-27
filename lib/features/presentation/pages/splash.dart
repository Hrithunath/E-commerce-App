import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/features/presentation/bloc/auth_bloc.dart';

class SplashWrapper extends StatelessWidget {
  const SplashWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(CheckLoginStatusEvent()),
      child: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          Navigator.pushReplacementNamed(context, "/HomeBottom");
        } else if (state is UnAuthenticatedState) {
          Navigator.pushReplacementNamed(context, "/Login");
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: AspectRatio(
              aspectRatio: 16 / 33,
              child: Image.asset(
                "assets/images/SmartStride.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
