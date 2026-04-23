import 'package:flutter/material.dart';
import '../widgets/sociality_action_button.dart';
import '../widgets/custom_app_bar.dart';

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
          // 1. Background Logo (Watermark)
          Opacity(
            opacity: 0.1,
            child: Image.asset('assets/images/logo.png'),
          ),
          
          // 2. Main Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SocialityActionButton(
                    text: 'Create',
                    icon: Icons.link,
                    onPressed: () => Navigator.pushNamed(context, '/host-name-entry'),
                  ),
                  const SizedBox(height: 56),
                  SocialityActionButton(
                    text: 'Join',
                    icon: Icons.add,
                    onPressed: () => Navigator.pushNamed(context, '/name-entry'),
                  ),
                ],
              ),
            ),
          ),

          // 3. Static Footer Logo
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