import 'package:flutter/material.dart';
import '../theme/app_themeRyan.dart';

class HomeScreenv2 extends StatelessWidget {
  const HomeScreenv2({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Temporary local theme usage for this screen only.
      // This should be moved to MaterialApp(theme: ...) in main.dart later.
      data: AppTheme.lightTheme, // Using the custom theme we defined in app_themeRyan.dart
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            // Background logo
            Opacity(
              opacity: 0.1,
              child: Image.asset('assets/images/logo.png'),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play'),
                  style: AppTheme.primaryButton,
                ),
                const SizedBox(height: 16),

                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan'),
                ),
                const SizedBox(height: 16),

                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                  label: const Text('Settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}