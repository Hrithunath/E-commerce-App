import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAfterDelay();
  }

  Future<void> _checkAuthAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    final user = FirebaseAuth.instance.currentUser;
    // Add a short fade-out for smoothness
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    if (user == null) {
      Navigator.pushReplacementNamed(context, "/Login");
    } else {
      Navigator.pushReplacementNamed(context, "/HomeBottom");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Lottie.asset(
              'assets/animation/splash.anime.json',
              fit: BoxFit.cover,
              repeat: false,
            ),
          ),
          const Center(child: AnimatedLogo()),
        ],
      ),
    );
  }
}

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..forward();

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart,
              size: 28,
              color: Colors.black,
            ),
            SizedBox(width: 16),
            Text(
              'Stride Smart',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
