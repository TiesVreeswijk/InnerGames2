import 'package:flutter/material.dart';
import '../widgets/sociality_action_button.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/animated_pop_button_effect.dart';
import '../theme/app_themeRyan.dart';

class CreateJoinScreen extends StatelessWidget {
  const CreateJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const CustomAppBar(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Logo (Watermark)
          Opacity(
            opacity: 0.1,
            child: Image.asset('assets/images/logo.png'),
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 2. Wrap the Create button
                  AnimatedPressButton( // create button with animation
                    onPressed: () {
                      Navigator.pushNamed(context, '/host-name-entry');
                    },
                    child: FilledButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.link),
                      label: const Text('Create'),
                      style: AppTheme.primaryButton.copyWith(
                        backgroundColor:
                            WidgetStateProperty.all(AppTheme.primaryMagenta),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 56),

                  AnimatedPressButton( // join button with animation
                    onPressed: () {
                      Navigator.pushNamed(context, '/name-entry');
                    },
                    child: FilledButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.add),
                      label: const Text('Join'),
                      style: AppTheme.primaryButton.copyWith(
                        backgroundColor:
                            WidgetStateProperty.all(AppTheme.primaryMagenta),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Static Footer Logo
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
