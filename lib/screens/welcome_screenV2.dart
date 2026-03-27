import 'package:flutter/material.dart';
import '../theme/app_themeRyan.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Temporary local theme usage for this screen only.
      // This should be moved to MaterialApp(theme: ...) in main.dart later.
      data: AppTheme.lightTheme, // Using the custom theme we defined in app_themeRyan.dart
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              Image.asset('assets/images/logo.png', width: 200),

              const SizedBox(height: 40),

              Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  // color: RyanTheme.lightBackgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Welkom!',
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Verken sociale werksituaties en ontdek wat je kunt doen.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    FilledButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: const Text('Volgende'),
                    )
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
  }
