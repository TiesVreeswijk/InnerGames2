import 'package:flutter/material.dart';
import '../widgets/sociality_action_button.dart';

class CreateJoinScreen extends StatelessWidget {
  const CreateJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Row(
          children: [
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/logo.png',
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'Sociality',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const _BackgroundLogo(),
            Column(
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
                            Navigator.pushNamed(context, '/join-game');
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
          ],
        ),
      ),
    );
  }
}

class _BackgroundLogo extends StatelessWidget {
  const _BackgroundLogo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.22,
        child: Image.asset(
          'assets/images/logo.png',
          width: 260,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}