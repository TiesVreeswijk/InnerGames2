import 'package:flutter/material.dart';
import '../theme/app_themeRyan.dart';

class WelcomeScreenv2 extends StatelessWidget {
  const WelcomeScreenv2({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        // Scaffold background color is now handled by the theme
        body: Column(
          children: [
            // 1. Top Section
            Expanded(
              flex: 4,
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 250,
                ),
              ),
            ),

            // 2. Bottom Section
            Expanded(
              flex:
                  4, // 10/10 flex is entire screen, so 4/10 for bottom section
              child: Container(
                width: double.infinity,
                decoration: AppTheme.bottomSheetDecoration, // Themed Decoration
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  children: [
                    const Text(
                      'Welkom!',
                      style: AppTheme.welcomeTitle, // Themed Style
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Verken sociale werksituaties en ontdek wat je kunt doen.',
                      textAlign: TextAlign.center,
                      style: AppTheme.welcomeBody, // Themed Style
                    ),
                    const SizedBox(height: 30),
                    FilledButton.icon(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      ),
                      style: AppTheme.primaryButton,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Volgende'),
                    ),
                    const Spacer(),
                    Image.asset(
                      'assets/images/innergames logo.png',
                      width: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
