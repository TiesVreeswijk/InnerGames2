import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/splash2'); // navigation using main.dart routes
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Main Logo - Perfectly Centered
        Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 200,
          ),
        ),
        
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0), // Adjust distance from bottom
            child: Image.asset(
              'assets/images/innergames logo.png',
              width: 100,
            ),
          ),
        ),
      ],
    ),
  );
}
}