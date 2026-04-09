import 'package:flutter/material.dart';
import '../theme/app_themeRyan.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreenv2 extends StatelessWidget {
  const HomeScreenv2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      // 1. Custom Top Navigation Bar
      appBar: const CustomAppBar(showBackButton: false),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 2. Background Logo (Watermark)
          Opacity(
            opacity: 0.1,
            child: Image.asset('assets/images/logo.png'),
          ),

          // 3. Main Menu Buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/create-join');
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play'),
                style: AppTheme.primaryButton,
              ),
              const SizedBox(height: 16),

              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan'),
                style: AppTheme.primaryButton,
              ),
              const SizedBox(height: 16),

              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/settings'),
                icon: const Icon(Icons.settings),
                label: const Text('Settings'),
                style: AppTheme.primaryButton,
              ),
            ],
          ),

          // 4. Footer Logo
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
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