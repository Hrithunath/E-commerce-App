import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/features/presentation/bloc/auth_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// class SplashWrapper extends StatelessWidget {
//   const SplashWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AuthBloc()..add(CheckLoginStatusEvent()),
//       child: const SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) {
//         if (state is AuthenticatedState) {
//           Navigator.pushReplacementNamed(context, "/HomeBottom");
//         } else if (state is UnAuthenticatedState) {
//           Navigator.pushReplacementNamed(context, "/Login");
//         }
//       },
//       child: Scaffold(
//         body: SafeArea(
//           child: Center(
//             child: AspectRatio(
//               aspectRatio: 16 / 33,
//               child: Image.asset(
//                 "assets/images/SmartStride.png",
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    User? user = FirebaseAuth.instance.currentUser;

    await Future.delayed(const Duration(milliseconds: 500)); // tiny delay

    if (!mounted) return;

    // Remove native splash before navigation
    FlutterNativeSplash.remove();

    if (user == null) {
      Navigator.pushReplacementNamed(context, "/Login");
    } else {
      Navigator.pushReplacementNamed(context, "/HomeBottom");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nothing visible here, native splash is still covering
    return const SizedBox.shrink();
  }
}