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
          // Background Logo (Watermark)
          Opacity(
            opacity: 0.1,
            child: Image.asset('assets/images/logo.png'),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SocialityActionButton(
                          text: 'Create',
                          icon: Icons.link,
                          onPressed: () {
                            debugPrint('Create pressed');
                            Navigator.pushNamed(context, '/host-name-entry');
                          },
                        ),
                        const SizedBox(height: 56),
                        SocialityActionButton(
                          text: 'Join',
                          icon: Icons.add,
                          onPressed: () {
                            debugPrint('Join pressed');
                            Navigator.pushNamed(context, '/name-entry');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Tweakeract Sociality 🦋',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}