import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/welcome');
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 200,
        ),
      ),
    );
  }
}